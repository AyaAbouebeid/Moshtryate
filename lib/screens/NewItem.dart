import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:provider/provider.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/models/cart.dart';
import '../data/itemscat.dart';
import '../models/cart.dart';
import '../models/category.dart';
import 'drawer.dart';
import 'homepage.dart';

class NewItem extends StatefulWidget {
  final itemStorage storage;

  const NewItem({Key key, this.storage}) : super(key: key);
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final List<Item> itemsCats = items;

  final List<Item> itemsextra = [];

  final List<Category> _categories = categories;
  final List<String> _quantities = ['لتر   ', 'كيلو ', 'عبوه', 'وحده'];
  Category chooseItem;

  Item newitem;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, item, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('اضف جديد'),
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ],
          ),
          drawer: MyDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: FormBuilder(
              key: _formKey,
              child: Column(children: [
                Text(
                  'اضف جديد',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                FormBuilderTextField(
                  name: 'title',
                  decoration: InputDecoration(hintText: 'الاسم'),
                ),
                SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderDropdown(
                    name: 'category',
                    decoration: InputDecoration(
                        filled: true, icon: Icon(Icons.category)),
                    hint: Text('اختر القسم'),
                    isExpanded: true,
                    allowClear: true,
                    items: _categories.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem.category,
                          child: Text(valueItem.category));
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderDropdown(
                    name: 'quantity',
                    decoration: InputDecoration(
                        filled: true, icon: Icon(Icons.ad_units)),
                    hint: Text('اختر الوحده'),
                    allowClear: true,
                    items: _quantities.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderChoiceChip(
                    name: 'image',
                    decoration: InputDecoration(
                      labelText: 'اختر الصوره',
                    ),
                    options: [
                      FormBuilderFieldOption(
                        value: 'images/png/groceries.png',
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/png/groceries.png')),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/light-bulb.png',
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/png/light-bulb.png')),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/gingerbread.png',
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/png/gingerbread.png')),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/hazelnut.png',
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/png/hazelnut.png')),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/pasta.pn',
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/png/pasta.png')),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/pasta.pn',
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage('images/png/glass-3.png')),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                print(_formKey.currentState.value);
                newitem.title =
                    _formKey.currentState.fields['title'].toString();
                newitem.category =
                    _formKey.currentState.fields['category'].toString();
                newitem.itemIcon =
                    _formKey.currentState.fields['image'].toString();

                newitem.amount = 1;
                newitem.quantity =
                    _formKey.currentState.fields['quantity'].toString();

                widget.storage.writeCounter(newitem);
              } else {
                print('validation failed');
              }
            },
            tooltip: 'اضف الى القائمه',
            child: Icon(Icons.add),
          ),
        ),
      );
    });
  }
}

class itemStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data/itemscat.dart');
  }

  Future<File> writeCounter(Item newItem) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$newItem');
  }
}
