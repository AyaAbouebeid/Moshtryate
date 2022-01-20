import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
import 'package:moshtryate_new/data/itemscat.dart';

class Cart extends ChangeNotifier {
  List<Item> _items = [];
  List<Item> _organizedItems = [];
  int counter = 0;
  List<Item> distinctIds = [];

  void add(Item item) {
    _items.add(item);
    FileController().writeCart();
    notifyListeners();
  }

  void addAll(List<Item> itemsbasket) {
    _items.addAll(itemsbasket);
  }

  void remove(Item item) {
    _items.remove(item);
    FileController().writeCart();
    notifyListeners();
  }

  void delete(Item selectedItem) {
    _items.removeWhere((item) => selectedItem.title == item.title);
    selectedItem.amount = 0;
    selectedItem.bought = 1;
    FileController().writeCart();
    notifyListeners();
  }

  int get count {
    distinctIds = _items.toSet().toList();
    return distinctIds.length;
  }

  List<Item> get basketItems {
    _organizedItems = _items.toSet().toList();
    _organizedItems.sort((a, b) => b.category.compareTo(a.category));
    FileController().writeCart();

    return _organizedItems;
  }
}
