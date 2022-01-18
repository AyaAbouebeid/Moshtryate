import 'package:flutter/widgets.dart';
import 'package:moshtryate_new/controller/file_controller.dart';

class Category extends ChangeNotifier {
  String category;
  int keyShow = 1;

  List<Category> _categorys = [];

  void add(Category category) {
    _categorys.add(category);
    this.keyShow = 1;
    FileController().writeCategory();
    notifyListeners();
  }

  void remove() {
    //_categorys.remove(category);
    keyShow = 0;
    FileController().writeCategory();
    notifyListeners();
  }

  Category({this.category, this.keyShow = 1});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(category: json["category"], keyShow: json["keyShow"]);
  }
  Map<String, dynamic> toJson() => {"category": category, "keyShow": keyShow};
}
