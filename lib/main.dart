import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const ListaDeComprasApp());
}

class ListaDeComprasApp extends StatelessWidget {
  const ListaDeComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListaDeComprasPage(),
    );
  }
}

class ListaDeComprasPage extends StatefulWidget {
  const ListaDeComprasPage({super.key});

  @override
  State<ListaDeComprasPage> createState() => _ListaDeComprasPageState();
}

class _ListaDeComprasPageState extends State<ListaDeComprasPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  void _addItem(String item) {
    setState(() {
      _items.add({'title': item, 'checked': false});
      _saveList();
    });
    _controller.clear();
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index]['checked'] = !_items[index]['checked'];
      _saveList();
    });
  }

  void _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('shopping_list', jsonEncode(_items));
  }

  void _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? list = prefs.getString('shopping_list');
    if (list != null) {
      setState(() {
        _items = List<Map<String, dynamic>>.from(jsonDecode(list));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Novo item',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addItem(_controller.text);
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return CheckboxListTile(
                  title: Text(item['title']),
                  value: item['checked'],
                  onChanged: (bool? value) {
                    _toggleItem(index);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}