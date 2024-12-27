import 'package:flutter/material.dart';
import 'package:sales_track/about.dart';
import 'package:sales_track/add_new_item.dart';
import 'package:sales_track/analytics.dart';
import 'package:sales_track/inventory.dart';
import 'package:sales_track/order_history.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFFFF8E1),

      ///pale yellow
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFF8C00),
            ),
            child: Text(
              'Your Shop Name',
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.analytics_outlined,
              color: Colors.deepOrange[400],
            ),
            title: Text(
              'Analytics',
              style: TextStyle(color: Colors.grey[800]),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Analytics()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.deepOrange[400],
            ),
            title: Text(
              'Cashier dashboard',
              style: TextStyle(color: Colors.grey[800]),
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => Inventory()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.inventory_rounded,
              color: Colors.deepOrange[400],
            ),
            title: Text(
              'Inventory',
              style: TextStyle(color: Colors.grey[800]),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Inventory()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_box_outlined,
              color: Colors.deepOrange[400],
            ),
            title: Text(
              'Add New Item',
              style: TextStyle(color: Colors.grey[800]),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddNewItem()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history_toggle_off,
              color: Colors.deepOrange[400],
            ),
            title: Text(
              'Order History',
              style: TextStyle(color: Colors.grey[800]),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderHistory()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline_sharp,
              color: Colors.deepOrange[400],
            ),
            title: Text(
              'About',
              style: TextStyle(color: Colors.grey[800]),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()));
            },
          ),
        ],
      ),
    );
  }
}
