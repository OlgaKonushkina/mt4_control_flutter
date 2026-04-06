import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/ps_bloc.dart';
import '../bloc/ps_event.dart';
import '../bloc/ps_state.dart';

final getIt = GetIt.instance;

class PSWidget extends StatefulWidget {
  const PSWidget({super.key});

  @override
  State<PSWidget> createState() => _PSWidgetState();
}

class _PSWidgetState extends State<PSWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  double _currentFrequency = 749.9999;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _currentFrequency.toStringAsFixed(4));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PSBloc>(),
      child: BlocConsumer<PSBloc, PSState>(
        listener: (context, state) {
          if (state is PSFrequencyUpdated) {
            _currentFrequency = state.frequency;
            if (!_focusNode.hasFocus) {
              _textController.text = _currentFrequency.toStringAsFixed(4);
            }
          }
        },
        builder: (context, state) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Генератор ПС'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Частота ПС:'),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          double newValue = _currentFrequency - 0.001;
                          if (newValue >= 100.0) {
                            context.read<PSBloc>().add(SetPSFrequencyEvent(newValue));
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixText: 'МГц',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final freq = double.tryParse(value);
                            if (freq != null && freq >= 100.0 && freq <= 999.9999) {
                              context.read<PSBloc>().add(SetPSFrequencyEvent(freq));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          double newValue = _currentFrequency + 0.001;
                          if (newValue <= 999.9999) {
                            context.read<PSBloc>().add(SetPSFrequencyEvent(newValue));
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text('МГц'),
                    ],
                  ),
                  if (state is PSLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  if (state is PSError)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}