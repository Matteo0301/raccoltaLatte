import 'dart:collection';

import 'package:flutter/material.dart';

class Model<T> extends ChangeNotifier {
  final List<T> _items = [];
  final Set<String> _selected = {};

  UnmodifiableListView<T> get items => UnmodifiableListView(_items);
  UnmodifiableSetView<String> get selected => UnmodifiableSetView(_selected);

  void add(T item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    //notifyListeners();
  }

  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    //notifyListeners();
  }

  void toggleSelected(String elem) {
    if (!_selected.contains(elem)) {
      _selected.add(elem);
    } else {
      _selected.remove(elem);
    }
    notifyListeners();
  }

  void clearSelected() {
    _selected.clear();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
