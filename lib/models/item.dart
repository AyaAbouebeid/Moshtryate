import 'package:flutter/widgets.dart';

class Item extends ChangeNotifier {
  String title;
  String itemIcon;
  String category;
  String quantity;
  int amount;

  List<Item> _items = [];

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void incrementCounter() {
    amount++;
    notifyListeners();
  }

  void delete(Item selectedItem) {
    _items.removeWhere((item) => selectedItem.title == item.title);
    notifyListeners();
  }

  void decrementCounter() {
    if (amount != 0) {
      amount--;
    }

    notifyListeners();
  }

  bool get check {
    return false;
  }

  Item({
    this.title,
    this.itemIcon,
    this.category,
    this.amount,
    this.quantity,
  });

  Item.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        itemIcon = json['itemIcon'],
        category = json['category'],
        amount = json['amount'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() => {
        title: 'title',
        itemIcon: 'itemIcon',
        category: 'category',
        amount.toString(): 'amount',
        quantity: 'quantity'
      };
}
