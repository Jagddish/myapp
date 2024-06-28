import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  Future<void> _refreshItems() async {
    final items = await dbHelper.getItems();
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem() async {
    final name = _textController.text;
    if (name.isNotEmpty) {
      await dbHelper.insertItem(name);
      _textController.clear();
      _refreshItems();
    }
  }

  Future<void> _deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter item name',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('Add Item'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_items.isNotEmpty) {
                      _deleteItem(_items.last['id']);
                    }
                  },
                  child: Text('Delete Last Item'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildItemsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    if (_items.isEmpty) {
      return Center(child: Text('No items available.'));
    }
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          title: Text(item['name']),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteItem(item['id']),
          ),
        );
      },
    );
  }
}
