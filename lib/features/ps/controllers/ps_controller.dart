import '../../../shared/event_bus.dart';
import '../../../shared/base_controller.dart';
import '../../../shared/app_events.dart';
import '../services/ps_service.dart';

class PSController extends BaseController {
  final PSService _service;
  double _frequency = 749.9999;

  PSController({
    required IEventBus eventBus,
    required PSService service,
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
    // ПС реагирует на события ГЕТ (для теста)
    if ((event.value - _frequency).abs() > 0.0001) {
      _frequency = event.value;
      notifyListeners();
    }
  }
}