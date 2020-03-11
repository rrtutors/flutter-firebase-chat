import 'package:flutter/material.dart';
import 'package:flutter_firbase/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore.dart';
import 'loginpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Application',
      theme: ThemeData(

        primarySwatch: Colors.pink,
      ),
      home: Informationdevelopper(),
    );
  }
}
/*
class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage>
{

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isSignedIn();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Chat Application"),),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              child: Text("Login With Google "),
              onPressed: () async {

                GoogleSignInAccount googleUser = await googleSignIn.signIn();
                GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                final AuthCredential credential = GoogleAuthProvider.getCredential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );
                FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
                if (firebaseUser != null) {
                  // Check is already sign up

                  currentUser = firebaseUser;
                  await prefs.setString('id', currentUser.uid);
                  await prefs.setString('nickname', currentUser.displayName);
                  await prefs.setString('photoUrl', currentUser.photoUrl);

                 Fluttertoast.showToast(msg: "Sign in success");
                  this.setState(() {
                    isLoading = false;
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                } else {
                  Fluttertoast.showToast(msg: "Sign in fail");
                  this.setState(() {
                    isLoading = false;
                  });
                }
              },
            ),

          ]),
    );
  }




  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }
}*/
