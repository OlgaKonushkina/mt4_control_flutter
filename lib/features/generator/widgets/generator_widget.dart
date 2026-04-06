import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../controllers/generator_controller.dart';
import '../../../shared/card_style.dart';
import '../../../shared/theme_provider.dart';

final getIt = GetIt.instance;

class GeneratorWidget extends StatelessWidget {
  const GeneratorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = getIt<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;

    return ChangeNotifierProvider(
      create: (_) => getIt<GeneratorController>(),
      child: Consumer<GeneratorController>(
        builder: (context, controller, child) {
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
                    Expanded(
                      child: TextField(
                        decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text: controller.frequency.toStringAsFixed(4),
                        ),
                        onChanged: (value) {
                          final freq = double.tryParse(value);
                          if (freq != null) {
                            controller.setFrequency(freq);
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