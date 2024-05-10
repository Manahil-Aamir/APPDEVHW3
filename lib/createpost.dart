import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:hw3/home.dart';

class Add extends StatefulWidget {
  const Add({super.key});
  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String detail = '';
  String title = '';

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> _addData(String name, String title, String detail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
       String? imageUrl;
      if (user != null) {
        imageUrl = user.photoURL;
      }
      DateTime now = DateTime.now();
      // Add a new document with a generated ID to a collection
      await _firestore.collection('posts').add({
        'uploaderName': name,
        'title': title,
        'description': detail,
        'profilePicture': imageUrl,
        'createdAt': now
      });
      print('Data added to Firestore');
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }
 

Future<void> initialize() async {
    _firestore = FirebaseFirestore.instance;
    final CollectionReference posts = _firestore.collection('posts');
}

void init(){
  initialize();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('CREATE'),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 140),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'NAME',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7B66),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TITLE',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7B66),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DETAIL',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7B66),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  detail = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF7B66)),
              ),
              onPressed: () {
                _addData(name, title, detail);
              },
              child: const Text(
                'ADD',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF7B66)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: const Text(
                'VIEW DETAILS',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}