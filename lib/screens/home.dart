import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  List<Item> items = <Item>[];

  HomeScreen({Key? key}) : super(key: key) {
    items = [];
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const prefsSelector = 'data';
  TextEditingController newTaskCtrl = TextEditingController();

  Future loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(prefsSelector);

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((it) => Item.fromJson(it)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  Future saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsSelector, jsonEncode(widget.items));
  }

  void addTask() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(
        title: newTaskCtrl.text,
        done: false,
      ));

      newTaskCtrl.clear();
      saveChanges();
    });
  }

  void removeTask(int index) {
    setState(() {
      widget.items.removeAt(index);
      saveChanges();
    });
  }

  // carrega a funcao loadTasks no constructor desta classe
  _HomeScreenState() {
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            labelText: 'Nova Tarefa',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: widget.items.isNotEmpty
          ? ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext cxt, int index) {
                final item = widget.items[index];

                return Dismissible(
                  child: CheckboxListTile(
                    title: Text(item.title!),
                    value: item.done,
                    onChanged: (val) {
                      setState(() {
                        item.done = val;
                        saveChanges();
                      });
                    },
                  ),
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red.withOpacity(0.2),
                  ),
                  onDismissed: (direction) {
                    removeTask(index);
                  },
                );
              },
            )
          : const Center(
              child: Text('Nenhuma tarefa cadastrada!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
