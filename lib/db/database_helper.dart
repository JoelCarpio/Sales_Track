// import 'dart:convert'; // To encode image as base64
// import 'dart:io'; // For File handling
import 'package:get/get.dart'; // For GetX dependency
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'database_notifier.dart';

class DatabaseHelper extends GetxController {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

// Future<void> deleteWholeDatabase() async {
//   // Get the database path
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, 'POS_saleTrack.db');

//   // Check if the database file exists
//   if (await File(path).exists()) {
//     // Delete the database file
//     await deleteDatabase(path);
//     print('Database deleted successfully!');
//   } else {
//     print('Database does not exist at path: $path');
//   }
// }

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
            price INTEGER,
            image TEXT
          )
        ''');
      },
    );
  }

  // Insert data including image (base64)
  Future<void> insertData(String itemName, String categoryName, int price,
      String? imagePath) async {
    final db = await database;

    await db.insert(
      'items',
      {
        'item_name': itemName,
        'category_name': categoryName,
        'price': price,
        'image': imagePath // Store the image path directly
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all data
  Future<List<Map<String, dynamic>>> fetchAllData() async {
    final db = await database;
    return await db.query('items');
  }

  // Method to pick an image using GetX and ImagePicker
  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null; // No image selected
  }
}
