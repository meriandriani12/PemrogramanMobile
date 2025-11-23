import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list_app/add_item_page.dart';
import 'package:shopping_list_app/shopping_item.dart';

enum SortOption { name, date }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ShoppingItem> _shoppingItems = [];
  String _searchQuery = '';
  // Default sort dinonaktifkan agar tidak konflik dengan GroupedList
  final Color _primaryColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    _loadShoppingItems();
  }

  Future<void> _loadShoppingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('shopping_items');

    if (dataString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(dataString);
        setState(() {
          _shoppingItems = jsonList
              .map((json) => ShoppingItem.fromJson(json))
              .toList();
        });
      } catch (e) {
        await prefs.clear();
        setState(() => _shoppingItems = []);
      }
    }
  }

  Future<void> _saveShoppingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String shoppingItemsString = jsonEncode(
      _shoppingItems.map((item) => item.toJson()).toList(),
    );
    await prefs.setString('shopping_items', shoppingItemsString);
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<ShoppingItem>(
      MaterialPageRoute(builder: (context) => const AddItemPage()),
    );

    if (newItem != null) {
      // FIX CRASH: Pastikan item punya kategori. Jika null, lempar error/assign default
      // Kita asumsikan ShoppingItem.category adalah Enum dan tidak boleh null.

      setState(() {
        _shoppingItems.add(newItem);
      });
      _saveShoppingItems();
    }
  }

  void _editItem(ShoppingItem item) async {
    final updatedItem = await Navigator.of(context).push<ShoppingItem>(
      MaterialPageRoute(builder: (context) => AddItemPage(item: item)),
    );
    if (updatedItem != null) {
      setState(() {
        final index = _shoppingItems.indexOf(item);
        _shoppingItems[index] = updatedItem;
      });
      _saveShoppingItems();
    }
  }

  void _deleteItem(ShoppingItem item) {
    setState(() {
      _shoppingItems.remove(item);
    });
    _saveShoppingItems();
  }

  void _onItemTapped(ShoppingItem item) {
    setState(() {
      item.isPurchased = !item.isPurchased;
    });
    _saveShoppingItems();
  }

  void _shareShoppingList() {
    final String text = _shoppingItems
        .map((item) => '- ${item.name} (Qty: ${item.quantity})')
        .join('\n');
    Share.share(text, subject: 'Daftar Belanja');
  }

  // --- UI UTAMA YANG LEBIH STABIL ---
  @override
  Widget build(BuildContext context) {
    // 1. Filter Pencarian Saja (JANGAN DISORT MANUAL DI SINI)
    List<ShoppingItem> filteredItems = _searchQuery.isEmpty
        ? _shoppingItems
        : _shoppingItems
              .where(
                (item) => item.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareShoppingList,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ShoppingSearchDelegate(_shoppingItems),
              );
            },
          ),
          // Tombol Reset (Hanya dipakai jika error parah)
          IconButton(
            icon: const Icon(Icons.restore_from_trash),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              setState(() => _shoppingItems = []);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: _primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  "Dibeli",
                  filteredItems.where((i) => i.isPurchased).length,
                ),
                _buildStat(
                  "Belum",
                  filteredItems.where((i) => !i.isPurchased).length,
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text("Belum ada data"))
                : GroupedListView<ShoppingItem, String>(
                    // UBAH KE STRING AGAR STABIL
                    elements: filteredItems,

                    // PENTING: Group by String (nama kategori) bukan Enum Object
                    // Ini mencegah crash saat sorting Enum yang berbeda index
                    groupBy: (item) => item.category.toString(),

                    // Sorting otomatis oleh library
                    order: GroupedListOrder.ASC,
                    useStickyGroupSeparators: true,

                    // Tampilan Header Grup
                    groupSeparatorBuilder: (String categoryValue) {
                      // Bersihkan string "ShoppingCategory.sayur" jadi "SAYUR"
                      var display = categoryValue.split('.').last.toUpperCase();
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.grey[200],
                        child: Text(
                          display,
                          style: TextStyle(
                            color: _primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },

                    // Tampilan Item
                    itemBuilder: (context, item) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            activeColor: _primaryColor,
                            value: item.isPurchased,
                            onChanged: (val) => _onItemTapped(item),
                          ),
                          title: Text(item.name),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(item),
                          ),
                          onTap: () => _editItem(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class ShoppingSearchDelegate extends SearchDelegate<ShoppingItem> {
  final List<ShoppingItem> items;
  ShoppingSearchDelegate(this.items);

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, items.first),
  ); // Dummy safe return
  @override
  Widget buildResults(BuildContext context) => Container();
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = items
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) =>
          ListTile(title: Text(suggestions[index].name)),
    );
  }
}
