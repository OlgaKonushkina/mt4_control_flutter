import 'package:flutter/material.dart';
import '../core/interfaces.dart';

abstract class BaseController extends ChangeNotifier {
  final IEventBus eventBus;
  final Map<String, dynamic> _prevValues = {};

  BaseController(this.eventBus);

  void savePrev(String key, dynamic value) {
    _prevValues[key] = value;
  }

  dynamic getPrev(String key) {
    return _prevValues[key];
  }

  void clearPrev() {
    _prevValues.clear();
  }

  @override
  void dispose() {
    clearPrev();
    super.dispose();
  }
}