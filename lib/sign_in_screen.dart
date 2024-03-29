import 'package:flutter/material.dart';
import 'package:lu_interactive_campus_map_flutter/auth.dart';
import 'package:lu_interactive_campus_map_flutter/google_sign_in_button.dart';

// main color pallete
var colorGryphonGold = "FBDE40";
var colorLehighBrown = "653818";
var colorPackerPatina = "6BBBAE";
var colorBetterThanMaroonRed = "F9423A";

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse("0xFF$colorGryphonGold")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/lu_logo.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Lehigh',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Authentication',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}