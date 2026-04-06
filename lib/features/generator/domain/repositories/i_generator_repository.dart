abstract class IGeneratorRepository {
  Future<bool> setFrequency(double value);
  Future<bool> setStep(double value);
  Future<bool> setAmplitude(int value);
  Future<bool> setPll1(int value);
  Future<bool> setPll3(int value);
  Future<bool> setDoubler1(bool enabled);
}