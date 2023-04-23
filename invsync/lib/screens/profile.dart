import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool showlogo = false;

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/88235295?v=4"),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "Name",
                textScaleFactor: 0.95,
              ),
              subtitle: Text(
                "Tushar Padhy",
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
            const ListTile(
              leading: Icon(Icons.email),
              title: Text(
                "Email",
                textScaleFactor: 0.95,
              ),
              subtitle: Text(
                "padhytushar4303@gmail.com",
                textScaleFactor: 1.1,
              ),
            ),
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
