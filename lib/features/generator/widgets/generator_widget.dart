import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../controllers/generator_controller.dart';
import '../../../shared/card_style.dart';
import '../../../shared/theme_provider.dart';

final getIt = GetIt.instance;

class GeneratorWidget extends StatefulWidget {
  const GeneratorWidget({super.key});

  @override
  State<GeneratorWidget> createState() => _GeneratorWidgetState();
}

class _GeneratorWidgetState extends State<GeneratorWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late GeneratorController _controller;
  bool _isUpdatingFromController = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = getIt<GeneratorController>();
    _focusNode = FocusNode();
    _textController = TextEditingController(
      text: _controller.frequency.toStringAsFixed(4),
    );
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_isUpdatingFromController) return;
    
    final text = _textController.text;
    if (text.isEmpty) return;
    
    final freq = double.tryParse(text);
    if (freq != null && freq >= 100.0 && freq <= 999.9999) {
      _controller.setFrequency(freq);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = getIt<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<GeneratorController>(
        builder: (context, controller, child) {
          final currentText = _textController.text;
          final expectedText = controller.frequency.toStringAsFixed(4);
          
          if (currentText != expectedText && !_focusNode.hasFocus) {
            _isUpdatingFromController = true;
            _textController.text = expectedText;
            _isUpdatingFromController = false;
          }
          
          return Container(
            decoration: CardStyle.decoration(isDarkMode: isDarkMode),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Генератор ГЕТ',
                  style: CardStyle.titleStyle(isDarkMode: isDarkMode),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Частота ГЕТ:'),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          double newValue = controller.frequency - 0.001;
                          if (newValue >= 100.0) {
                            controller.setFrequency(newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          double newValue = controller.frequency + 0.001;
                          if (newValue <= 999.9999) {
                            controller.setFrequency(newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('МГц'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}