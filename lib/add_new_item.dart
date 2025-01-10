import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sales_track/db/database_helper.dart';
import 'package:get/get.dart';
import 'package:sales_track/image_controller.dart';

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
  final ImageController _imageController =
      Get.put(ImageController()); // Use GetX controller

  List<Map<String, dynamic>> _itemsList = []; // List to hold added items

  // Method to fetch items from the database
  Future<void> _fetchItems() async {
    final data = await _dbHelper.fetchAllData();
    setState(() {
      _itemsList = data;
    });
  }

  // Method to insert data into the database
  Future<void> _insertData() async {
    final itemName = _itemNameController.text;
    final categoryName = _itemCategoryController.text;
    final price = int.tryParse(_priceController.text);

    if (itemName.isNotEmpty && categoryName.isNotEmpty && price != null) {
      await _dbHelper.insertData(
          itemName, categoryName, price, _imageController.imagePath.value);
      _itemNameController.clear();
      _itemCategoryController.clear();
      _priceController.clear();
      _imageController.clearImage();
      await _fetchItems();
    }
  }

  // Method to pick an image from the gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        _imageController
            .setImage(pickedFile.path); // Update image path in controller
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchItems();
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
                      child: Obx(() => _imageController.imagePath.value != null
                          ? Image.file(
                              File(_imageController.imagePath.value!),
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
                            )),
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
                  onPressed: () {
                    _insertData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Item added successfully!",
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 2), // Snackbar duration
                        behavior: SnackBarBehavior
                            .floating, // Makes the Snackbar float
                        backgroundColor: Colors.grey,
                      ),
                    );
                  },
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
          ],
        ),
      ),
    );
  }
}
