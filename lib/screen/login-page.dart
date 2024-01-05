import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kimiafarma/component/rounded_button.dart';
import 'package:kimiafarma/component/theme.dart';
import 'package:kimiafarma/screen/forgot-page.dart';
import 'package:kimiafarma/screen/home-page.dart';

const kTextFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorBlueBase, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorBlueBase, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
    ));

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final _auth = FirebaseAuth.instance;

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;

  String errorMessage = '';
  bool _isobsecured = true;

  // late Future<FirebaseApp> _firebaseInitialization;

  // @override
  // void initState() {
  //   super.initState();
  //   _firebaseInitialization = _initializeFirebase();
  // }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('admin')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        String email = userData['email'];
        String nama = userData['nama'];

        print('Email: $email');
        print('nama: $nama');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
    return firebaseApp;
  }

  bool isPasswordValid(String password) {
    // Regex for at least 6 characters
    RegExp regex = RegExp(r'^.{6,}$');
    return regex.hasMatch(password);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/undraw_medicine_b-1-ol.svg',
                    height: 300,
                    width: 250,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        email = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      )),
                  SizedBox(height: 20.0),
                  TextField(
                      obscureText: _isobsecured,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password.',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isobsecured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isobsecured = !_isobsecured;
                              });
                            },
                          ))),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                  RoundedButton(
                      colour: colorBlueBase,
                      title: 'Log In',
                      onPressed: () async {
                        setState(() {});
                        try {
                          if (!isPasswordValid(password)) {
                            setState(() {
                              errorMessage =
                                  'Password must be at least 6 characters long.';
                            });
                            return;
                          }
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          // if (user != null) {
                          //   Navigator.popAndPushNamed(context, 'home_page');
                          // }
                        } catch (e) {
                          setState(() {
                            // untuk menampilkan pesan kesalahan
                            errorMessage =
                                'Login Failed check your email and password';
                          });
                          print(e);
                        }
                        setState(() {});
                      }),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPage()),
                      );
                    },
                    child: Text(
                      'Forget your password ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorBlueBase,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
