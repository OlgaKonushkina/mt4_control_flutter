import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/di_container.dart' as di;
import 'shared/theme_provider.dart';
import 'features/generator/generator.dart';
import 'features/ps/ps.dart';

void main() {
  di.setupDependencies();
  
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
      body: const DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Управление'),
                Tab(text: 'Аналитика'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        GeneratorWidget(),
                        SizedBox(height: 16),
                        PSWidget(),
                      ],
                    ),
                  ),
                  Center(child: Text('Аналитика (в разработке)')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}