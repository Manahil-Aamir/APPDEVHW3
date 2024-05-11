import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hw3/first.dart';
import 'package:hw3/google.dart';
import 'package:hw3/login.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'AIzaSyAtrQTq3SXbWMFBVaDEkSgv6bZZoyUyWOM',
    appId: '1:644745555114:android:33ae95c60748b20685b4d3',
    messagingSenderId: '644745555114',
    projectId: 'appdevhw3',
  ),
);
  print('hello');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(), // Creating and providing an instance of GoogleSignInProvider
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: First(),
    ),
  );
 }
}

