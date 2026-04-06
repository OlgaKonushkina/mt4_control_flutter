import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Widgets should not import services directly', () {
    final widgetFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.contains('widgets') && f.path.endsWith('.dart'));

    for (final file in widgetFiles) {
      final content = file.readAsStringSync();
      expect(
        content.contains('service') && !content.contains('generator_service'),
        false,
        reason: 'Widget ${file.path} imports a service',
      );
    }
  });

  test('Services should not import widgets', () {
    final serviceFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.contains('services') && f.path.endsWith('.dart'));

    for (final file in serviceFiles) {
      final content = file.readAsStringSync();
      expect(
        content.contains('widget'),
        false,
        reason: 'Service ${file.path} imports a widget',
      );
    }
  });

  test('Controllers should not import widgets directly', () {
    final controllerFiles = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.contains('controllers') && f.path.endsWith('.dart'));

    for (final file in controllerFiles) {
      final content = file.readAsStringSync();
      expect(
        content.contains('widget'),
        false,
        reason: 'Controller ${file.path} imports a widget',
      );
    }
  });
}