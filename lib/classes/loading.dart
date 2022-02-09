import 'package:flutter/material.dart';

class Loading with ChangeNotifier {
  bool isLoading = false;

  set loading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}
