import 'package:flutter/material.dart';
import 'package:hw3/google.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});



  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFF7B66),
    body: Center(
      child: ElevatedButton.icon(
       onPressed: () {
        print("hi");
        // Handle Google sign-in logic here
        final provider = Provider.of<GoogleSignInProvider>(context, listen:false);
        provider.googleLogin(context);
      },
      icon: Image.asset(

        'assets/google.png',
        width: 35.0,
        height: 35.0,
      ),
      label: const Text(
        'Continue with Google',
        style: TextStyle(
          color: Color(0xFF716562),
          fontSize: 25,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF716562),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),
);
  }
}