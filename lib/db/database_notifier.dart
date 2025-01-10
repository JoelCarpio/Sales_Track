import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
import 'database_helper.dart';  // Import your DatabaseHelper class

class DatabaseNotifier extends ChangeNotifier {
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> items = [];

  // Fetch all data and update the list
  Future<void> fetchAllData() async {
    var fetchedItems = await _dbHelper.fetchAllData();
    items = fetchedItems;
    notifyListeners(); // Notify listeners that the data has changed
  }

  // Insert data and refresh
  Future<void> insertData(String itemName, String categoryName, int price, String? imagePath) async {
    await _dbHelper.insertData(itemName, categoryName, price, imagePath);
    fetchAllData(); // Refresh the list after inserting data
  }
}
