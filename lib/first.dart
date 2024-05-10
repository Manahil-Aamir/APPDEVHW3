import 'package:flutter/material.dart';
import 'package:hw3/google.dart';

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = GoogleSignInProvider();
    googleSignInProvider.checkLoginStatus(context);
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}