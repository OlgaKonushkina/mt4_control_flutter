import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/connection_bloc.dart';
import '../bloc/connection_event.dart';
import '../bloc/connection_state.dart';
import '../../domain/entities/connection_config.dart';
import '../../../../shared/card_style.dart';
import '../../../../shared/theme_provider.dart';

final getIt = GetIt.instance;

class ConnectionWidget extends StatefulWidget {
  const ConnectionWidget({super.key});

  @override
  State<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  ConnectionType _selectedType = ConnectionType.emulator;
  String _wifiHost = '192.168.1.100';
  int _wifiPort = 10001;

  @override
  Widget build(BuildContext context) {
    final themeProvider = getIt<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;

    return BlocConsumer<ConnectionBloc, ConnState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          decoration: CardStyle.decoration(isDarkMode: isDarkMode),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Подключение',
                style: CardStyle.titleStyle(isDarkMode: isDarkMode),
              ),
              const SizedBox(height: 16),
              _buildTypeSelector(context, isDarkMode),
              const SizedBox(height: 16),
              _buildConfigFields(context, isDarkMode),
              const SizedBox(height: 16),
              _buildConnectButton(context, state),
              const SizedBox(height: 8),
              _buildStatus(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeSelector(BuildContext context, bool isDarkMode) {
    return DropdownButtonFormField<ConnectionType>(
      decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode),
      value: _selectedType,
      items: const [
        DropdownMenuItem(value: ConnectionType.emulator, child: Text('Эмулятор')),
        DropdownMenuItem(value: ConnectionType.wifi, child: Text('Wi-Fi')),
        DropdownMenuItem(value: ConnectionType.bluetooth, child: Text('Bluetooth')),
        DropdownMenuItem(value: ConnectionType.serial, child: Text('Serial (USB)')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedType = value;
          });
          context.read<ConnectionBloc>().add(ChangeConnectionTypeEvent(value));
        }
      },
    );
  }

  Widget _buildConfigFields(BuildContext context, bool isDarkMode) {
    if (_selectedType == ConnectionType.wifi) {
      return Column(
        children: [
          TextField(
            decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode),
            onChanged: (value) => _wifiHost = value,
            controller: TextEditingController(text: _wifiHost),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode),
            onChanged: (value) => _wifiPort = int.tryParse(value) ?? 10001,
            controller: TextEditingController(text: _wifiPort.toString()),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildConnectButton(BuildContext context, ConnState state) {
    final isConnecting = state is ConnConnecting;
    final isConnected = state is ConnConnected;

    return ElevatedButton(
      onPressed: isConnecting
          ? null
          : () {
              if (isConnected) {
                context.read<ConnectionBloc>().add(DisconnectEvent());
              } else {
                final config = ConnectionConfig(
                  type: _selectedType,
                  host: _selectedType == ConnectionType.wifi ? _wifiHost : null,
                  port: _selectedType == ConnectionType.wifi ? _wifiPort : null,
                );
                context.read<ConnectionBloc>().add(ConnectEvent(config));
              }
            },
      child: Text(isConnecting ? 'Подключение...' : (isConnected ? 'Отключить' : 'Подключить')),
    );
  }

  Widget _buildStatus(ConnState state) {
    if (state is ConnConnected) {
      return Text(
        '✅ Подключено: ${state.config.type.name}',
        style: const TextStyle(color: Colors.green, fontSize: 12),
      );
    } else if (state is ConnConnecting) {
      return Text(
        '🟡 Подключение...',
        style: const TextStyle(color: Colors.orange, fontSize: 12),
      );
    } else if (state is ConnError) {
      return Text(
        '❌ Ошибка: ${state.message}',
        style: const TextStyle(color: Colors.red, fontSize: 12),
      );
    }
    return const Text(
      '⏸ Отключено',
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }
}