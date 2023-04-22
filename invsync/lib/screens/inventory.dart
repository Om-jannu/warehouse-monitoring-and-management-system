
// import 'package:flutter/material.dart';
// import 'package:invsync/models/inventoryItem.dart';

// class InventoryScreen extends StatefulWidget {
//   @override
//   _InventoryScreenState createState() => _InventoryScreenState();
// }

// class _InventoryScreenState extends State<InventoryScreen> {
//   List<InventoryItem> items = [
//       InventoryItem(id: "1", itemName: "Bananas", lastUpdated: "01/01/2022", quantity: 50),
//       InventoryItem(id: "2", itemName: "Apples", lastUpdated: "01/01/2022", quantity: 100),
//       InventoryItem(id: "3", itemName: "Grapes", lastUpdated: "01/01/2022", quantity: 75),  
//     ];

//   void _showAddItemDialog() {
//     TextEditingController _quantityController = TextEditingController();
//     // String selectedItem;
//     String selectedItem = '';
//     // String? selectedItem;



//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.6,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Add Item',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: items.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(items[index].itemName),
//                           onTap: () {
//                             setState(() {
//                               selectedItem = items[index].itemName;
//                             });
//                           },
//                           trailing: selectedItem == items[index].itemName
//                               ? Icon(Icons.check)
//                               : null,
//                         );
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _quantityController,
//                       decoration: InputDecoration(
//                         hintText: 'Enter quantity',
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (selectedItem != null &&
//                           _quantityController.text.isNotEmpty) {
//                         setState(() {
//                           InventoryItem newItem = InventoryItem(
//                             id: DateTime.now().toString(),
//                             itemName: selectedItem,
//                             lastUpdated: DateTime.now().toString(),
//                             quantity: int.parse(_quantityController.text),
//                           );
//                           items.add(newItem);
//                           selectedItem = '';
//                           _quantityController.clear();
//                         });
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text('Add'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inventory'),
//       ),
//       body: ListView.builder(
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(items[index].itemName),
//             subtitle: Text(
//                 'Last Updated: ${items[index].lastUpdated} Quantity: ${items[index].quantity}'),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddItemDialog,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:invsync/models/inventoryItem.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<InventoryItem> items = [
    InventoryItem(
        id: "asifialshvsf", itemName: "Wheat", lastUpdated: "kjewifwife", quantity: 350),
    InventoryItem(
        id: "asifialshvsf", itemName: "Bananas", lastUpdated: "kjewifwife", quantity: 100),
    InventoryItem(id: "asifialshvsf", itemName: "Apples", lastUpdated: "kjewifwife", quantity: 50),
    InventoryItem(id: "asifialshvsf", itemName: "Grapes", lastUpdated: "kjewifwife", quantity: 75),
    InventoryItem(
        id: "asifialshvsf", itemName: "Oranges", lastUpdated: "kjewifwife", quantity: 25),
  ];

  InventoryItem? selectedItem;
  int totalSpace = 1000;
  int usedSpace = 0;

  void addItem(String itemName, int quantity) {
    setState(() {
      items.add(InventoryItem(
          id: "newid",
          itemName: itemName,
          lastUpdated: DateTime.now().toString(),
          quantity: quantity));
      usedSpace += quantity;
    });
    Navigator.pop(context);
  }

  void _showAddItemDialog() {
    TextEditingController itemNameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Add Item',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(hintText: 'Enter item name'),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(hintText: 'Enter quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (itemNameController.text.isNotEmpty &&
                        quantityController.text.isNotEmpty) {
                      addItem(itemNameController.text, int.parse(quantityController.text));
                      itemNameController.clear();
                      quantityController.clear();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    int availableSpace = totalSpace - usedSpace;
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: usedSpace / totalSpace,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].itemName),
            subtitle: Text(
                'Last Updated: ${items[index].lastUpdated} Quantity: ${items[index].quantity}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
       
