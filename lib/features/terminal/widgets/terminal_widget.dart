import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/interfaces/connection.dart';
import '../../../shared/card_style.dart';
import '../../../shared/event_bus.dart';
import '../../../shared/theme_provider.dart';
import '../../../shared/app_events.dart';
import '../../connection/domain/repositories/i_connection_repository.dart';

final getIt = GetIt.instance;

class TerminalWidget extends StatefulWidget {
  const TerminalWidget({super.key});

  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<TerminalEntry> _entries = [];
  late ThemeProvider themeProvider;
  late bool isDarkMode;
  late IEventBus _eventBus;

  @override
  void initState() {
    super.initState();
    themeProvider = getIt<ThemeProvider>();
    isDarkMode = themeProvider.isDarkMode;
    themeProvider.addListener(_onThemeChanged);
    _eventBus = getIt<IEventBus>();
    
    _eventBus.subscribe<CommandAcknowledgedEvent>(_onCommandAcknowledged);
  }

  void _onThemeChanged() {
    setState(() {
      isDarkMode = themeProvider.isDarkMode;
    });
  }

  void _onCommandAcknowledged(CommandAcknowledgedEvent event) {
    _addEntry(TerminalEntry(
      text: 'Ответ: ${event.command}',
      isCommand: false,
      isResponse: true,
      timestamp: DateTime.now(),
    ));
  }

  void _sendCommand() {
    final command = _commandController.text.trim();
    if (command.isEmpty) return;

    _addEntry(TerminalEntry(
      text: command,
      isCommand: true,
      timestamp: DateTime.now(),
    ));

    final connectionRepo = getIt<IConnectionRepository>();
    final currentConnection = connectionRepo.currentConnection;
    
    if (currentConnection != null && currentConnection.isConnected) {
      final parts = command.split(' ');
      if (parts.length >= 2) {
        final reg = parts[0];
        final value = parts[1];
        currentConnection.sendCommand(reg, value);
      } else {
        _addEntry(TerminalEntry(
          text: 'Ошибка: неверный формат команды (пример: GTR_F 350.0009)',
          isCommand: false,
          isError: true,
          timestamp: DateTime.now(),
        ));
      }
    } else {
      _addEntry(TerminalEntry(
        text: 'Ошибка: нет подключения',
        isCommand: false,
        isError: true,
        timestamp: DateTime.now(),
      ));
    }

    _commandController.clear();
  }

  void _addEntry(TerminalEntry entry) {
    setState(() {
      _entries.add(entry);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearHistory() {
    setState(() {
      _entries.clear();
    });
  }

  @override
  void dispose() {
    themeProvider.removeListener(_onThemeChanged);
    _eventBus.unsubscribe<CommandAcknowledgedEvent>(_onCommandAcknowledged);
    _commandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CardStyle.decoration(isDarkMode: isDarkMode),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Терминал',
                style: CardStyle.titleStyle(isDarkMode: isDarkMode),
              ),
              IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: _clearHistory,
                tooltip: 'Очистить историю',
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return _buildEntry(entry);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commandController,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                  decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode).copyWith(
                    hintText: 'Введите команду (например: GTR_F 350.0009)',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : Colors.grey[400]),
                  ),
                  onSubmitted: (_) => _sendCommand(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _sendCommand,
                child: const Text('Отправить'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(TerminalEntry entry) {
    Color textColor;
    if (entry.isCommand) {
      textColor = Colors.green;
    } else if (entry.isError) {
      textColor = Colors.red;
    } else if (entry.isResponse) {
      textColor = Colors.blue;
    } else {
      textColor = isDarkMode ? Colors.white : Colors.black87;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}:${entry.timestamp.second.toString().padLeft(2, '0')} ',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              entry.text,
              style: TextStyle(
                color: textColor,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TerminalEntry {
  final String text;
  final bool isCommand;
  final bool isResponse;
  final bool isError;
  final DateTime timestamp;

  TerminalEntry({
    required this.text,
    this.isCommand = false,
    this.isResponse = false,
    this.isError = false,
    required this.timestamp,
  });
}