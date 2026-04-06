import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/att_bloc.dart';
import '../bloc/att_event.dart';
import '../bloc/att_state.dart';
import '../../../../shared/card_style.dart';
import '../../../../shared/theme_provider.dart';

final getIt = GetIt.instance;

class ATTWidget extends StatelessWidget {
  const ATTWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = getIt<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;

    return BlocProvider(
      create: (_) => getIt<ATTBloc>(),
      child: BlocConsumer<ATTBloc, ATTState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            decoration: CardStyle.decoration(isDarkMode: isDarkMode),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Аттенюаторы (ATT)',
                  style: CardStyle.titleStyle(isDarkMode: isDarkMode),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildATT1Selector(context, isDarkMode),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildATT2Selector(context, isDarkMode),
                    ),
                  ],
                ),
                if (state is ATTError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red[400], fontSize: 12),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildATT1Selector(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ATT1 (ПС)', style: CardStyle.labelStyle(isDarkMode: isDarkMode)),
        const SizedBox(height: 8),
        Container(
          decoration: CardStyle.containerDecoration(isDarkMode: isDarkMode),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _getCurrentATT1(context),
              items: const [
                DropdownMenuItem(value: 0, child: Text('0 dB')),
                DropdownMenuItem(value: 1, child: Text('-30 dB')),
                DropdownMenuItem(value: 2, child: Text('выкл.')),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<ATTBloc>().add(SetATT1Event(value));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildATT2Selector(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ATT2 (ПРМ)', style: CardStyle.labelStyle(isDarkMode: isDarkMode)),
        const SizedBox(height: 8),
        Container(
          decoration: CardStyle.containerDecoration(isDarkMode: isDarkMode),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _getCurrentATT2(context),
              items: const [
                DropdownMenuItem(value: 0, child: Text('0 dB')),
                DropdownMenuItem(value: 1, child: Text('-40 dB')),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<ATTBloc>().add(SetATT2Event(value));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  int _getCurrentATT1(BuildContext context) {
    final state = context.read<ATTBloc>().state;
    if (state is ATT1Updated) {
      return state.value;
    }
    return 0;
  }

  int _getCurrentATT2(BuildContext context) {
    final state = context.read<ATTBloc>().state;
    if (state is ATT2Updated) {
      return state.value;
    }
    return 0;
  }
}