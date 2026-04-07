import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/ble_scan.dart';
import '../../../../shared/card_style.dart';
import '../../../../shared/theme_provider.dart';
import '../bloc/connection_bloc.dart';
import '../bloc/connection_event.dart';
import '../bloc/connection_state.dart';
import '../../domain/entities/connection_config.dart';

final getIt = GetIt.instance;

class ConnectionWidget extends StatefulWidget {
  const ConnectionWidget({super.key});

  @override
  State<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  late ThemeProvider themeProvider;
  late bool isDarkMode;
  
  ConnectionType _selectedType = ConnectionType.emulator;
  String _wifiHost = '';
  int _wifiPort = 10001;
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  bool _ipError = false;
  
  List<BleScanResult> _bleDevices = [];
  bool _isScanning = false;
  BleScanResult? _selectedBleDevice;

  @override
  void initState() {
    super.initState();
    themeProvider = getIt<ThemeProvider>();
    isDarkMode = themeProvider.isDarkMode;
    _hostController.text = _wifiHost;
    _portController.text = _wifiPort.toString();
    themeProvider.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    setState(() {
      isDarkMode = themeProvider.isDarkMode;
    });
  }

  @override
  void dispose() {
    themeProvider.removeListener(_onThemeChanged);
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  bool _isValidIp(String ip) {
    if (ip.isEmpty) return true;
    final regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!regex.hasMatch(ip)) return false;
    final parts = ip.split('.');
    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
    }
    return true;
  }

  Future<void> _scanDevices() async {
    setState(() {
      _isScanning = true;
      _bleDevices = [];
    });
    
    final devices = await scanForDevices();
    
    setState(() {
      _bleDevices = devices;
      _isScanning = false;
    });
    
    if (devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Устройства не найдены')),
      );
    }
  }

  void _showDevicePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите устройство'),
        content: _isScanning
            ? const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              )
            : SizedBox(
                width: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _bleDevices.length,
                  itemBuilder: (context, index) {
                    final device = _bleDevices[index];
                    return ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.id),
                      onTap: () {
                        setState(() {
                          _selectedBleDevice = device;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: _isScanning ? null : () {
              _scanDevices();
              Navigator.pop(context);
              _showDevicePicker();
            },
            child: const Text('Обновить'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _buildTypeSelector(),
              const SizedBox(height: 16),
              _buildConfigFields(),
              const SizedBox(height: 16),
              _buildConnectButton(state),
              const SizedBox(height: 8),
              _buildStatus(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeSelector() {
    return DropdownButtonFormField<ConnectionType>(
      key: ValueKey('type_$isDarkMode'),
      dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
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
            if (value == ConnectionType.bluetooth) {
              _scanDevices();
            }
          });
          context.read<ConnectionBloc>().add(ChangeConnectionTypeEvent(value));
        }
      },
    );
  }

  Widget _buildConfigFields() {
    if (_selectedType == ConnectionType.wifi) {
      return Column(
        children: [
          TextField(
            key: ValueKey('host_$isDarkMode'),
            controller: _hostController,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode).copyWith(
              hintText: '192.168.1.100',
              hintStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : Colors.grey[400]),
              errorText: _ipError && !_isValidIp(_hostController.text) ? 'Неверный IP-адрес' : null,
            ),
            onChanged: (value) {
              setState(() {
                _wifiHost = value;
                _ipError = false;
              });
            },
            onSubmitted: (_) {
              setState(() {
                _ipError = !_isValidIp(_hostController.text);
              });
            },
          ),
          const SizedBox(height: 8),
          TextField(
            key: ValueKey('port_$isDarkMode'),
            controller: _portController,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            decoration: CardStyle.inputDecoration(isDarkMode: isDarkMode).copyWith(
              hintText: '10001',
              hintStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : Colors.grey[400]),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            onChanged: (value) {
              setState(() {
                _wifiPort = int.tryParse(value) ?? 10001;
              });
            },
          ),
        ],
      );
    }
    
    if (_selectedType == ConnectionType.bluetooth) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: _isScanning ? null : () => _showDevicePicker(),
            child: Text(_selectedBleDevice == null ? 'Выбрать устройство' : 'Устройство: ${_selectedBleDevice!.name}'),
          ),
          if (_isScanning) const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildConnectButton(ConnState state) {
    final isConnecting = state is ConnConnecting;
    final isConnected = state is ConnConnected;
    final isWifiInvalid = _selectedType == ConnectionType.wifi && !_isValidIp(_hostController.text);
    final isBleInvalid = _selectedType == ConnectionType.bluetooth && _selectedBleDevice == null;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
        foregroundColor: Colors.white,
      ),
      onPressed: (isConnecting || (isWifiInvalid && _selectedType == ConnectionType.wifi) || (isBleInvalid && _selectedType == ConnectionType.bluetooth))
          ? null
          : () {
              if (isConnected) {
                context.read<ConnectionBloc>().add(DisconnectEvent());
              } else {
                ConnectionConfig config;
                if (_selectedType == ConnectionType.bluetooth && _selectedBleDevice != null) {
                  config = ConnectionConfig(
                    type: _selectedType,
                    deviceName: _selectedBleDevice!.name,
                    deviceId: _selectedBleDevice!.id,
                  );
                } else {
                  config = ConnectionConfig(
                    type: _selectedType,
                    host: _selectedType == ConnectionType.wifi ? _hostController.text : null,
                    port: _selectedType == ConnectionType.wifi ? _wifiPort : null,
                  );
                }
                context.read<ConnectionBloc>().add(ConnectEvent(config));
              }
            },
      child: Text(isConnecting ? 'Подключение...' : (isConnected ? 'Отключить' : 'Подключить')),
    );
  }

  Widget _buildStatus(ConnState state) {
    if (state is ConnConnected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ Подключено: ${state.config.type.name}${state.config.deviceName != null ? ' (${state.config.deviceName})' : ''}',
            style: const TextStyle(color: Colors.green, fontSize: 12),
          ),
          if (state.serviceUuid != null)
            Text(
              'Service: ${state.serviceUuid}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          if (state.characteristicUuid != null)
            Text(
              'Characteristic: ${state.characteristicUuid}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
        ],
      );
    } else if (state is ConnConnecting) {
      return const Text(
        '🟡 Подключение...',
        style: TextStyle(color: Colors.orange, fontSize: 12),
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