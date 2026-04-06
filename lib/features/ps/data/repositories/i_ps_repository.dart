abstract class IPSRepository {
  Future<bool> setFrequency(double value);
  Future<bool> setStep(double value);
  Future<bool> setAmplitude(int value);
  Future<bool> setPll2(int value);
  Future<bool> setDoubler2(bool enabled);
}