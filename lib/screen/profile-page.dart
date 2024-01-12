import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kimiafarma/component/botBar.dart';
import 'package:kimiafarma/component/rounded_button.dart';
import 'package:kimiafarma/component/theme.dart';
import 'package:kimiafarma/screen/login-page.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  //profile page
  int _selectedIndex = 0;

  void _onHomePressed() {
    print('Home button pressed');
  }

  void _onInventoryPressed() {
    print('Inventory button pressed');
  }

  void _onProfilePressed() {
    print('Profile button pressed');
  }

  void _onFabPressed() {
    print('FAB pressed');
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  User? user = FirebaseAuth.instance.currentUser;

  String userName = '';
  String userEmail = '';

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance
                .collection('admin')
                .doc(user!.uid)
                .get();

        if (userData.exists) {
          String nama = userData['nama'];
          String email = userData['email'];

          setState(() {
            userName = nama;
            userEmail = email;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: colorBlueBase,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: colorBlueBase,
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.80,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xfff2f1f1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$userName',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$userEmail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: RoundedButton(
                  colour: colorBlueBase,
                  title: 'Log Out',
                  onPressed: _handleLogout,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _onFabPressed,
              tooltip: 'Create',
              child: Icon(Icons.add),
              backgroundColor: Colors.orangeAccent,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: DemoBottomAppBar(onFabPressed: _onFabPressed),
    );
  }

  void _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print("Error during logout: $e");
    }
    setState(() {});
  }
}
