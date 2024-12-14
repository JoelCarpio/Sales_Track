import 'package:flutter/material.dart';
import 'package:sales_track/side_bar.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedValue = 'Category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the Scaffold
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
          style: TextStyle(fontWeight: FontWeight.bold),
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
                          hintText: 'Search here...',
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
                            icon: Icon(Icons.search),
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
      bottomNavigationBar: CheckOrders(),
    );
  }
}

class OrderScreenBody extends StatefulWidget {
  const OrderScreenBody({super.key});

  @override
  State<OrderScreenBody> createState() => _OrderScreenBodyState();
}

class _OrderScreenBodyState extends State<OrderScreenBody> {
  final List<int> _itemCounts = List<int>.generate(12, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _itemCounts.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.2),
            //     spreadRadius: 1,
            //     blurRadius: 5,
            //     offset: Offset(0, 3),
            //   ),
            // ],
            border: Border.all(color: Colors.grey, width: .1),
            // borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(0),
          child: ListTile(
            leading: Image.asset('assets/item.png'),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 100,
                  padding: EdgeInsets.all(0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Item Chicken burger (Extra Large) $index',
                      softWrap: true,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[200],
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_itemCounts[index] > 0) {
                              _itemCounts[index]--;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(_itemCounts[index].toString()),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[200],
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _itemCounts[index]++;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CheckOrders extends StatefulWidget {
  const CheckOrders({super.key});

  @override
  State<CheckOrders> createState() => _CheckOrdersState();
}

class _CheckOrdersState extends State<CheckOrders> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1 Item added',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                Text(
                  'Total: 100Php',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'Check orders',
                    style: TextStyle(fontSize: 16,),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Icon(Icons.arrow_circle_right_outlined),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


