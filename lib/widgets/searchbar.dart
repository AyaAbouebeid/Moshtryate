import 'package:flutter/material.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/main.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/screens/NewItem.dart';
import 'package:moshtryate_new/screens/homepage.dart';
import 'package:provider/provider.dart';

class Searchbar extends SearchDelegate<Item> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    items = itemsBox.values.toList().cast<Item>();
    List<Item> mylist = items;
    final Item result = mylist.where((p) => p.title.contains(query)).first;
    final _formKey = GlobalKey<FormState>();
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Card(
                  child: ListTile(
                title: Text(result.title),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(result.itemIcon),
                  backgroundColor: Colors.transparent,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.blue,
                        onPressed: () {
                          result.incrementCounter();
                          cart.add(result);
                          result.keyShow = 1;
                          result.save();

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
                        }),
                    Text('${result.amount}'),
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.blue,
                        onPressed: () {
                          result.decrementCounter();
                          cart.remove(result);
                          result.save();
                        }),
                    Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints.tight(Size.fromWidth(32)),
                      child: Text(
                        '${result.quantity}',
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  print('clicked');
                },
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => NewItem()));
                },
                child: const Text('اضف جديد'),
              ),
            ],
          ));
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Item> mylist = itemsBox.values.toList().cast<Item>();

    mylist.sort((a, b) => a.title.compareTo(b.title));
    mylist = query.isEmpty
        ? mylist
        : mylist.where((p) => p.title.startsWith(query)).toList() +
            mylist.where((p) => p.title.contains(query)).toList();

    return mylist.isEmpty
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "هذا المنتج غير موجود",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => NewItem()));
                },
                child: const Text('اضف منتج جديد'),
              ),
            ],
          ))
        : Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: mylist.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                      onTap: () {
                        query = mylist[index].title;
                        return showResults(context);
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(mylist[index].itemIcon),
                      ),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mylist[index].title),
                            Text(mylist[index].category,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ])),
                );
              },
            ),
          );
  }
}
