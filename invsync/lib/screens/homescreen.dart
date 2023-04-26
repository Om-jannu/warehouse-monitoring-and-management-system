import 'package:firebase_auth/firebase_auth.dart';
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
  HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  final drawerItems = [
    DrawerItem("Dashboard", Icons.home),
    DrawerItem("Inventory", Icons.warehouse),
    DrawerItem("Profile", Icons.account_circle),
    DrawerItem("Logout", Icons.logout)
  ];

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const HomePage();
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
    var drawerOptions = drawerItems
        .map((d) => ListTile(
              leading: Icon(d.icon),
              title: Text(d.title),
              selected: drawerItems.indexOf(d) == _selectedDrawerIndex,
              onTap: () => _onSelectItem(drawerItems.indexOf(d)),
            ))
        .toList();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _currentUser = _auth.currentUser;

    _auth.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
    return Scaffold(
      appBar: AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: Text(drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: null,
                accountEmail: Text(_currentUser?.email ?? 'johndoe@gmail.com')),
            Expanded(
              child: ListView.builder(
                itemCount: drawerOptions.length,
                itemBuilder: (context, index) => drawerOptions[index],
              ),
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
