import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool showlogo = false;

  String _username = '';

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email!;
      final index = email.indexOf('@');
      if (index != -1) {
        setState(() {
          _username = email.substring(0, index);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _currentUser = _auth.currentUser;
    // String useremail;
    // late String username;
    // _auth.authStateChanges().listen((user) {
    //   setState(() {
    //     _currentUser = user;
    //     useremail = _currentUser?.email ?? 'johndoe@gmail.com';
    //     username = useremail.substring(0, useremail.indexOf('@'));
    //   });
    // });
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            const Center(
              child: CircleAvatar(
                  radius: 72,
                  backgroundImage: AssetImage('assets/images/7309687.jpg')),
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "Name",
                textScaleFactor: 0.95,
              ),
              subtitle: Text(
                "${_username}",
                textScaleFactor: 1.1,
              ),
            ),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text(
                "City",
                textScaleFactor: 0.95,
              ),
              subtitle: Text(
                "Mumbai",
                textScaleFactor: 1.1,
              ),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                "Phone",
                textScaleFactor: 0.95,
              ),
              subtitle: Text(
                "8104951731",
                textScaleFactor: 1.1,
              ),
            ),
            ListTile(
                leading: const Icon(Icons.email),
                title: const Text(
                  "Email",
                  textScaleFactor: 0.95,
                ),
                subtitle: Text(_currentUser?.email ?? 'johndoe@gmail.com')),
            if (showlogo)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  "assets/builtwithflutter.png",
                ),
              ),
            const SizedBox(
              height: 72,
            )
          ],
        ),
      ),
    );
  }
}
