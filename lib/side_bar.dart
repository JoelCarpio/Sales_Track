import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        padding: EdgeInsets.all(4),
        children: [
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.analytics_outlined),
            title: Text('Analytics'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.inventory_rounded),
            title: Text('Inventory'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add_box_outlined),
            title: Text('Add New Item'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.history_toggle_off),
            title: Text('Order History'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help_outline_sharp),
            title: Text('About'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
