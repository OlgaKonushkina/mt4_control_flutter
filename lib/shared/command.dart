abstract class Command {
  String get name;
  dynamic get value;
  bool validate();
  int get retries => 3;
  Duration get timeout => const Duration(seconds: 2);
}

class SetFrequencyCommand implements Command {
  final String target;
  final double _value;

  SetFrequencyCommand(this.target, this._value);

  @override
  String get name => target == 'GTR' ? 'GTR_F' : 'PS_F';

  @override
  dynamic get value => _value.toStringAsFixed(4);

  @override
  bool validate() => _value >= 100.0 && _value <= 999.9999;

  @override
  int get retries => 3;

  @override
  Duration get timeout => const Duration(seconds: 2);
}

class SetStepCommand implements Command {
  final String target;
  final double _value;

  SetStepCommand(this.target, this._value);

  @override
  String get name => target == 'GTR' ? 'GTR_STEP' : 'PS_STEP';

  @override
  dynamic get value => _value.toStringAsFixed(4);

  @override
  bool validate() => _value >= 0.0001 && _value <= 1.0;

  @override
  int get retries => 3;

  @override
  Duration get timeout => const Duration(seconds: 2);
}

class SetAmplitudeCommand implements Command {
  final String dds;
  final int _value;

  SetAmplitudeCommand(this.dds, this._value);

  @override
  String get name => dds == '0' ? 'DDS0_A' : 'DDS1_A';

  @override
  dynamic get value => _value;

  @override
  bool validate() => _value >= 0 && _value <= 1023;

  @override
  int get retries => 3;

  @override
  Duration get timeout => const Duration(seconds: 2);
}

class SetPLLCommand implements Command {
  final String pll;
  final int _value;

  SetPLLCommand(this.pll, this._value);

  @override
  String get name => 'PLL${pll}_N';

  @override
  dynamic get value => _value;

  @override
  bool validate() {
    if (pll == '3') {
      return _value == 4 || _value == 7 || _value == 8;
    }
    return _value >= 17 && _value <= 68;
  }

  @override
  int get retries => 3;

  @override
  Duration get timeout => const Duration(seconds: 2);
}

class SetDoublerCommand implements Command {
  final String pll;
  final int _value;

  SetDoublerCommand(this.pll, bool enabled) : _value = enabled ? 1 : 0;

  @override
  String get name => 'DB${pll}_EN';

  @override
  dynamic get value => _value;

  @override
  bool validate() => _value == 0 || _value == 1;

  @override
  int get retries => 3;

  @override
  Duration get timeout => const Duration(seconds: 2);
}