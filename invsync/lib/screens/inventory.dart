import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Item {
  final String id;
  final String name;
  final int quantity;
  final Timestamp lastUpdated;

  Item(this.id, this.name, this.quantity, this.lastUpdated);

  String get formattedDate {
    return DateFormat('MMM d, h:mm a').format(lastUpdated.toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'lastUpdated': lastUpdated,
    };
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final CollectionReference itemsRef =
      FirebaseFirestore.instance.collection('wareHouseItem');

  void _showAddItemDialog() {
    String? name;
    int? quantity;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    quantity = int.tryParse(value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (name != null && quantity != null) {
                  // Check if an item with the same name already exists
                  var query =
                      await itemsRef.where('name', isEqualTo: name).get();
                  if (query.docs.isNotEmpty) {
                    // Update the quantity of the existing item
                    var item = query.docs.first;
                    var existingQuantity = item.get('quantity');
                    var newQuantity = existingQuantity + quantity!;
                    await itemsRef
                        .doc(item.id)
                        .update({'quantity': newQuantity});
                  } else {
                    // Add a new item to the database
                    final newItem = Item(DateTime.now().toString(), name!,
                        quantity!, Timestamp.now());
                    await itemsRef.doc(newItem.id).set(newItem.toMap());
                  }
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditItemDialog(Item item) async {
    final TextEditingController nameController =
        TextEditingController(text: item.name);
    final TextEditingController quantityController =
        TextEditingController(text: item.quantity.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name'),
              TextFormField(
                controller: nameController,
              ),
              SizedBox(height: 10),
              Text('Quantity'),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                final String name = nameController.text.trim();
                final int quantity =
                    int.tryParse(quantityController.text.trim()) ?? 0;

                if (name.isNotEmpty && quantity > 0) {
                  await FirebaseFirestore.instance
                      .collection('wareHouseItem')
                      .doc(item.id)
                      .update({
                    'name': name,
                    'quantity': quantity,
                    'lastUpdated': Timestamp.now(),
                  });
                  Navigator.of(context).pop(); // close the dialog box
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _showEditItemDialog(Item item) async {
  //   final TextEditingController nameController =
  //       TextEditingController(text: item.name);
  //   final TextEditingController quantityController =
  //       TextEditingController(text: item.quantity.toString());

  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Edit Item'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Name'),
  //             TextFormField(
  //               controller: nameController,
  //             ),
  //             SizedBox(height: 10),
  //             Text('Quantity'),
  //             TextFormField(
  //               controller: quantityController,
  //               keyboardType: TextInputType.number,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //           TextButton(
  //             child: Text('Update'),
  //             onPressed: () async {
  //               final String name = nameController.text.trim();
  //               final int quantity =
  //                   int.tryParse(quantityController.text.trim()) ?? 0;

  //               if (name.isNotEmpty && quantity > 0) {
  //                 await FirebaseFirestore.instance
  //                     .collection('wareHouseItem')
  //                     .doc(item.id)
  //                     .update({
  //                   'name': name,
  //                   'quantity': quantity,
  //                   'lastUpdated': Timestamp.now(),
  //                 });
  //               }
  //               Navigator.of(context)
  //                   .pop(); // add this line to close the dialog
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showExportItemDialog(item) {
    final CollectionReference itemsRef =
        FirebaseFirestore.instance.collection('wareHouseItem');

    final TextEditingController nameController =
        TextEditingController(text: item.name);
    final TextEditingController quantityController =
        TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name'),
              TextFormField(
                controller: nameController,
              ),
              SizedBox(height: 10),
              Text('Quantity'),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                final quantity = int.tryParse(quantityController.text);

                if (name != null && quantity != null) {
                  // Update the quantity of the existing item
                  final query =
                      await itemsRef.where('name', isEqualTo: name).get();
                  if (query.docs.isNotEmpty) {
                    final item = query.docs.first;
                    final existingQuantity = item.get('quantity');
                    final newQuantity = existingQuantity - quantity;
                    await itemsRef
                        .doc(item.id)
                        .update({'quantity': newQuantity});
                  } else {
                    // No item with this name exists in the database
                    // Show an error message or add a new item as desired
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteItemDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                itemsRef.doc(id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: itemsRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final List<Item> items = snapshot.data!.docs
              .map((doc) => Item(
                    doc['id'],
                    doc['name'],
                    doc['quantity'],
                    doc['lastUpdated'],
                  ))
              .toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final Item item = items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Slidable(
                  key: Key(item.id),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.5,
                    children: [
                      SlidableAction(
                        label: 'Update',
                        backgroundColor: Colors.blue.shade100,
                        icon: Icons.edit,
                        onPressed: (context) => _showEditItemDialog(item),
                      ),
                      SlidableAction(
                        label: 'Export',
                        backgroundColor: Colors.blue.shade300,
                        icon: Icons.more_vert,
                        onPressed: (context) => _showExportItemDialog(item),
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        label: 'Delete',
                        backgroundColor: Colors.red.shade900,
                        icon: Icons.delete,
                        onPressed: (context) => _showDeleteItemDialog(item.id),
                      ),
                    ],
                  ),
                  child: Card(
                    key: Key(item.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(item.name),
                        trailing: Text('Qty : ${item.quantity} tons'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text('Last Updated : ${item.formattedDate}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
