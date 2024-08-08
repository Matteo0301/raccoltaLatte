import 'dart:collection';

import 'package:flutter/material.dart';

class Model<T> extends ChangeNotifier {
  final List<T> _items = [];
  final Set<int> _selected = {};

  UnmodifiableListView<T> get items => UnmodifiableListView(_items);
  UnmodifiableSetView<int> get selected => UnmodifiableSetView(_selected);

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

  void toggleSelected(int index) {
    if (!_selected.contains(index)) {
      _selected.add(index);
    } else {
      _selected.remove(index);
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
