import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invsync/screens/homepage.dart';
import 'package:invsync/screens/inventory.dart';
import 'package:invsync/screens/loginPage.dart';
import 'package:invsync/screens/profile.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Dashboard", Icons.home),
    DrawerItem("Inventory", Icons.warehouse),
    DrawerItem("Profile", Icons.account_circle),
    DrawerItem("Logout", Icons.logout)
  ];

  HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomePage();
      case 1:
        return const InventoryScreen();
      case 2:
        return const MyProfilePage();
      case 3:
        return FutureBuilder(
          future: logOut(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Return a loading indicator while logging out
              return CircularProgressIndicator();
            } else {
              // Navigate to LoginPage once logged out
              return LoginPage();
            }
          },
        );
      default:
        return const Text("Error");
    }
  }

  logOut() async {
    await Hive.box('userBox').put('isLoggedIn', false);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const UserAccountsDrawerHeader(
                accountName: Text("John Doe"), accountEmail: null),
            Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
