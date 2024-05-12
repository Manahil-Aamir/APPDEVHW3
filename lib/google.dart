import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hw3/home.dart';
import 'package:hw3/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

    bool _isLoggedIn = false;
    bool get isLoggedIn => _isLoggedIn;

  Future<void> googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credentials);

      _isLoggedIn = true;
      _saveLoginStatus();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );

      notifyListeners();
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }
  Future<void> googleSignOut(BuildContext context) async {
  try {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();

    _isLoggedIn = false;
     _saveLoginStatus();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
  } catch (error) {
    print('Error signing out: $error');
  }
}

Future<void> _saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print(_isLoggedIn);
    if (_isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }
}

