import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kimiafarma/component/rounded_button.dart';
import 'package:kimiafarma/component/theme.dart';
import 'package:kimiafarma/screen/forgot-page.dart';

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

  bool isPasswordValid(String password) {
    // Regex for at least 6 characters
    RegExp regex = RegExp(r'^.{6,}$');
    return regex.hasMatch(password);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                        _isobsecured ? Icons.visibility : Icons.visibility_off,
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
                    if (user != null) {
                      Navigator.popAndPushNamed(context, 'home_page');
                    }
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
      ),
    );
  }
}
