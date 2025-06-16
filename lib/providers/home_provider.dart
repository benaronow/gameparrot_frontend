import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String? _selectedId;

  String? get selectedId => _selectedId;

  void setSelectedId(String? id) {
    _selectedId = id;
    notifyListeners();
  }
}
