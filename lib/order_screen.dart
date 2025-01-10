import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
// import 'dart:convert';
import 'package:sales_track/side_bar.dart';
import 'package:sales_track/db/database_helper.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  ///yawa

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedValue = 'Category';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        title: Text(
          'Cashier',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Column(
            children: [
              Divider(
                height: 1,
                thickness: 0.1,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedValue),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_drop_down_rounded),
                        ],
                      ),
                      onSelected: (String value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 'Category',
                            child: Text('Category'),
                          ),
                          PopupMenuItem(
                            value: 'Category 1',
                            child: Text('Category 1'),
                          ),
                          PopupMenuItem(
                            value: 'Category 2',
                            child: Text('Category 2'),
                          ),
                          PopupMenuItem(
                            value: 'Category 3',
                            child: Text('Category 3'),
                          )
                        ];
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search item...',
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 204, 204, 204),
                              width: 0.2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0.3,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Color(0xFFFF8C00),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: SideBar(),
      body: const OrderScreenBody(),
      // bottomNavigationBar: CheckOrders(),
    );
  }
}

double totalPrice = 0.0;
num totalQuantity = 0;

class OrderScreenBody extends StatefulWidget {
  const OrderScreenBody({super.key});

  @override
  State<OrderScreenBody> createState() => _OrderScreenBodyState();
}

class _OrderScreenBodyState extends State<OrderScreenBody> {
  late Future<List<Map<String, dynamic>>> items;
  List<Map<String, dynamic>> mutableItemList = [];

  @override
  void initState() {
    super.initState();
    items = DatabaseHelper().fetchAllData();
  }

  void _incrementQuantity(int index) {
    setState(() {
      mutableItemList[index]['quantity'] =
          (mutableItemList[index]['quantity'] ?? 0) + 1;
      mutableItemList[index]['totalPrice'] =
          mutableItemList[index]['quantity'] * mutableItemList[index]['price'];
      _updateTotal();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (mutableItemList[index]['quantity'] > 0) {
        mutableItemList[index]['quantity'] =
            mutableItemList[index]['quantity'] - 1;
        mutableItemList[index]['totalPrice'] = mutableItemList[index]
                ['quantity'] *
            mutableItemList[index]['price'];
        _updateTotal();
      }
    });
  }

  void _updateTotal() {
    totalPrice = 0.0;
    totalQuantity = 0;

    for (var item in mutableItemList) {
      totalPrice += item['totalPrice'] ?? 0;
      totalQuantity += (item['quantity'] ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No items available'));
        } else {
          if (mutableItemList.isEmpty) {
            mutableItemList = List<Map<String, dynamic>>.from(
              snapshot.data!.map((item) {
                var newItem = Map<String, dynamic>.from(item);
                newItem['quantity'] = 0;
                newItem['totalPrice'] = 0;
                return newItem;
              }),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: mutableItemList.length,
                  itemBuilder: (context, index) {
                    if (mutableItemList[index]['quantity'] == null) {
                      mutableItemList[index]['quantity'] = 0;
                    }

                    if (mutableItemList[index]['totalPrice'] == null) {
                      mutableItemList[index]['totalPrice'] = 0;
                    }

                    return ListTile(
                      title: Text(mutableItemList[index]['item_name']),
                      subtitle: Text('Php: ${mutableItemList[index]['price']}'),
                      leading: mutableItemList[index]['image'] != null
                          ? Image.file(
                              File(mutableItemList[index]['image']),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _decrementQuantity(index),
                          ),
                          Text('${mutableItemList[index]['quantity']}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _incrementQuantity(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.black87,
                      padding: EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total: Php $totalPrice',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Quantity: $totalQuantity',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 255, 191, 0),
                      padding: EdgeInsets.all(18),
                      child: InkWell(
                        onTap: () {
                          _ordersListDialog(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              'Check Orders',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // SizedBox(
                            //   width: 4,
                            // ),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              size: 32,
                              color: Colors.grey[700],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  // dialogg for check orders
  void _ordersListDialog(BuildContext context) {
    // Filter the mutableItemList to include only items with a quantity > 0
    List<Map<String, dynamic>> orderedItems =
        mutableItemList.where((item) => (item['quantity'] ?? 0) > 0).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.center,
            child: Text('Check Order'),
          ),
          content: orderedItems.isEmpty
              ? Center(
                  child: Text('No items ordered yet'),
                )
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderedItems.length,
                    itemBuilder: (context, index) {
                      var item = orderedItems[index];
                      return ListTile(
                        title: Text(item['item_name']),
                        subtitle: Text('Quantity: ${item['quantity']}x'),
                        trailing: Text(
                          'Php ${item['totalPrice']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          actions: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Amount: ₱ $totalPrice',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Add your payment logic here
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Pay',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 255, 191, 0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}





// class CheckOrders extends StatefulWidget {
//   const CheckOrders({super.key});

//   @override
//   State<CheckOrders> createState() => _CheckOrdersState();
// }

// class _CheckOrdersState extends State<CheckOrders> {
//   //sa pagcheck ng orders duh dialog____________________________________________
  // void _ordersListDialog(BuildContext context) {
  //   List<String> items = [
  //     'Item Name',
  //     'QTY',
  //     'Price',
  //   ];
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: Align(
  //           alignment: Alignment.center,
  //           child: Text('Check Order'),
  //         ),
  //         content: ListView.builder(
  //           itemCount: items.length,
  //           itemBuilder: (context, index) {
  //             return ListTile(
  //               leading: Icon(Icons.place),
  //               title: Text(items[index]),
  //             );
  //           },
  //         ),
  //         actions: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Colors.blue,
  //                 ),
  //                 child: TextButton(
  //                   onPressed: () {},
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       'Pay',
  //                       style: TextStyle(color: Colors.black87),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 20,
  //               ),
  //               Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: const Color.fromARGB(255, 255, 191, 0),
  //                 ),
  //                 child: TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       'Add',
  //                       style: TextStyle(color: Colors.black87),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

// //bottom nav barrr______________________________________________________________
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.black87,
//       padding: EdgeInsets.all(0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('$totalQuantity Item added',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       )),
//                   Text(
//                     'Total: $totalPrice Php',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             color: const Color.fromARGB(255, 255, 191, 0),
//             padding: EdgeInsets.all(10),
//             child: InkWell(
//               onTap: () {
//                 _ordersListDialog(context);
//               },
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Row(
//                   children: [
//                     Text(
//                       'Check orders',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 16,
//                     ),
//                     Icon(
//                       Icons.arrow_circle_right_outlined,
//                       size: 32,
//                       color: Colors.grey[700],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OrderScreenBody extends StatefulWidget {
//   const OrderScreenBody({super.key});

//   @override
//   State<OrderScreenBody> createState() => _OrderScreenBodyState();
// }

// class _OrderScreenBodyState extends State<OrderScreenBody> {
//   // final List<int> _itemCounts = List<int>.generate(100, (index) => 0);
//   // int count = 0;

//   final DatabaseHelper _dbHelper = DatabaseHelper();

//   List<Map<String, dynamic>> _data = [];

//   Future<void> _fetchData() async {
//     final data = await _dbHelper.fetchAllData();
//     setState(() {
//       _data = data;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   //recycle view list___________________________________________________________
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: _data.length,
//       itemBuilder: (context, index) {
//         final item = _data[index];
//         return Container(
//           decoration: BoxDecoration(
//             color: const Color.fromRGBO(255, 255, 255, 1),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//             border: Border.all(color: Colors.grey, width: .1),
//             // borderRadius: BorderRadius.all(Radius.circular(8)),
//           ),
//           padding: const EdgeInsets.all(4),
//           margin: const EdgeInsets.all(0),
//           child: ListTile(
//             leading: Image.asset('assets/item.png'),
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 120,
//                   height: 100,
//                   padding: EdgeInsets.all(0),
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       item['item_name'],
//                       softWrap: true,
//                       overflow: TextOverflow.clip,
//                       style: TextStyle(
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       width: 28,
//                       height: 28,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 255, 199, 32),
//                         // shape: BoxShape.circle,
//                         borderRadius: BorderRadius.all(Radius.circular(9)),
//                       ),
//                       child: IconButton(
//                         padding: EdgeInsets.all(0),
//                         icon: Icon(
//                           Icons.remove,
//                           size: 14,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             // if (_itemCounts[index] > 0) {
//                             //   _itemCounts[index]--;
//                             // }
//                           });
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     // Text(
//                     //   _itemCounts[index].toString(),
//                     //   style: TextStyle(fontSize: 12),
//                     // ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Container(
//                       width: 28,
//                       height: 28,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 255, 199, 32),
//                         // shape: BoxShape.circle,
//                         borderRadius: BorderRadius.all(Radius.circular(9)),
//                       ),
//                       child: IconButton(
//                         padding: EdgeInsets.all(0),
//                         icon: Icon(
//                           Icons.add,
//                           size: 14,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             // _itemCounts[index]++;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
