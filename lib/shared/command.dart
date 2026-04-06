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
  bool validate() {
    return _value >= 100.0 && _value <= 999.9999;
  }

  @override
  int get retries => 3;

  @override
  Duration get timeout => const Duration(seconds: 2);
}