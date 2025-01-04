import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// import 'package:sales_track/db/database_helper.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'POS_saleTrack.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_name TEXT NOT NULL,
            category_name TEXT NOT NULL,
            price INTEGER
          )
        ''');
      },
    );
  }

// pag insert ng data
  Future<void> insertData(
      String itemName, String categoryName, int price) async {
    final db = await database;
    await db.insert(
      'items',
      {'item_name': itemName, 'category_name': categoryName, 'price': price},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// pagfetch ng data
  Future<List<Map<String, dynamic>>> fetchAllData() async {
    final db = await database;
    return await db.query('items');
  }
}

// taas neto yung data base!! ^^^^^

// page part
class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemCategoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> _data = [];

  Future<void> _fetchData() async {
    final data = await _dbHelper.fetchAllData();
    setState(() {
      _data = data;
    });
  }

  Future<void> _insertData() async {
    final itemName = _itemNameController.text;
    final categoryName = _itemCategoryController.text;
    final price = int.tryParse(_priceController.text);

    if (itemName.isNotEmpty && categoryName.isNotEmpty && price != null) {
      await _dbHelper.insertData(itemName, categoryName, price);
      // _itemNameController.clear();
      // _itemNameController.clear();
      // _itemCategoryController.clear();
      _fetchData(); // Refresh the data list
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  File? _image;

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                labelText: 'Enter item name:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Price:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _itemCategoryController,
              decoration: InputDecoration(
                labelText: 'Category:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Upload image',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 255, 199, 32), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                child: Text(
                                  "No image selected.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 30),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        iconColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 255, 199, 32),
                      ),
                      onPressed: () => pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text(
                        "Gallery",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    iconColor: Colors.black87,
                    backgroundColor: Color.fromARGB(255, 255, 199, 32),
                  ),
                  onPressed: _insertData,
                  label: Text(
                    "Add Item",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.4, // 40% of screen height
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final item = _data[index];
                  return ListTile(
                    title: Text(item['item_name']),
                    subtitle: Text(
                        'Category: ${item['category_name']} - Price: ${item['price']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
