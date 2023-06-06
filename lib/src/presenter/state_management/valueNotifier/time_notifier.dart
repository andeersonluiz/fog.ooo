import 'package:flutter/foundation.dart';

class TimeNotifier {
  final _state = ValueNotifier<String>("");

  ValueListenable<String> get state => _state;

  String get value => _state.value;

  update(String value) {
    _state.value = value;
  }
}
