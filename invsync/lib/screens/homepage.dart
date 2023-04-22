import 'package:flutter/material.dart';
import 'package:invsync/widgets/myDrawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Title(color: Colors.black, child: const Text("InvSync")),
    //   ),
    //   drawer: MyDrawer(),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text('This is the inventory screen'),
      ),
    );
  }
}
