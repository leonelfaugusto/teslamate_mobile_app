import 'package:flutter/material.dart';

class Loading with ChangeNotifier {
  bool _state = false;

  Loading();

  set state(bool state) {
    _state = state;
    notifyListeners();
  }

  bool get state => _state;
}
