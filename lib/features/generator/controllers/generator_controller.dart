import '../../../core/interfaces.dart';
import '../../../shared/app_events.dart';
import '../../../shared/base_controller.dart';
import '../services/generator_service.dart';

class GeneratorController extends BaseController {
  final GeneratorService _service;
  double _frequency = 349.9999;

  GeneratorController({
    required IEventBus eventBus,
    required GeneratorService service,
  }) : _service = service, super(eventBus) {
    eventBus.subscribe<GeneratorFrequencyChangedEvent>(_onFrequencyChanged);
  }

  double get frequency => _frequency;

  void setFrequency(double value) async {
    if ((value - _frequency).abs() > 0.0001) {
      savePrev('frequency', _frequency);
      _frequency = value;
      notifyListeners();
      final success = await _service.setFrequency(value);
      if (!success) {
        _frequency = getPrev('frequency') ?? _frequency;
        notifyListeners();
      }
    }
  }

  void _onFrequencyChanged(GeneratorFrequencyChangedEvent event) {
    if ((event.value - _frequency).abs() > 0.0001) {
      _frequency = event.value;
      notifyListeners();
    }
  }
}