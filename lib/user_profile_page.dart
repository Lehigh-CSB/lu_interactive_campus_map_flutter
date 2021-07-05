import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lu_interactive_campus_map_flutter/auth.dart';
import 'package:lu_interactive_campus_map_flutter/home.dart';
import 'package:lu_interactive_campus_map_flutter/sign_in_screen.dart';

// main color pallete
var colorGryphonGold = "FBDE40";
var colorLehighBrown = "653818";
var colorPackerPatina = "6BBBAE";
var colorBetterThanMaroonRed = "F9423A";

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key key, UserCredential user})
      : _user = user,
        super(key: key);

  final UserCredential _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  UserCredential _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  Route _routeToHomePage() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Home(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(-1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: new Center(
            child: Text(
          'Profile Page',
          style: TextStyle(color: Colors.black),
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(_routeToHomePage());
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  if (_user.user.photoURL != null)
                    ClipOval(
                      child: Material(
                        color: Color(int.parse("0xFF$colorGryphonGold")),
                        child: Image.network(
                          _user.user.photoURL,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  else
                    ClipOval(
                      child: Material(
                        color: Color(int.parse("0xFF$colorGryphonGold")),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    'Hello',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _user.user.displayName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '( ${_user.user.email} )',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'You are now signed in using your Google account. To sign out of your account, click the "Sign Out" button below.',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 14, letterSpacing: 0.2),
                  ),
                  SizedBox(height: 16.0),
                  _isSigningOut
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color(int.parse("0xFF$colorLehighBrown")),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await Authentication.signOut(context: context);
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.of(context)
                                .pushReplacement(_routeToSignInScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                ],
              ))),
    );
  }
}
