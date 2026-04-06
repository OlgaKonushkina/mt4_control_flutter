import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/connection_factory.dart';
import 'features/generator/generator.dart';
import 'features/ps/ps.dart';
import 'shared/di_container.dart' as di;
import 'shared/theme_provider.dart';

void main() {
  di.setupDependencies(type: ConnectionType.mock);
  
  final themeProvider = di.getIt<ThemeProvider>();
  
  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  
  const MyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'МТ-4 Пульт',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = di.getIt<ThemeProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ПУЛЬТ МТ-4 АБ'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Управление'),
                Tab(text: 'Аналитика'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Вкладка "Управление" — здесь будут все виджеты
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const GeneratorWidget(),
                        const SizedBox(height: 16),
                        const PSWidget(),
                        const SizedBox(height: 16),
                        // TODO: ATTWidget
                        // TODO: ControlWidget
                        // TODO: StatusWidget
                        // TODO: MonitorWidget
                      ],
                    ),
                  ),
                  // Вкладка "Аналитика" — пока заглушка
                  const Center(child: Text('Аналитика (в разработке)')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}