import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:hw3/home.dart';

class Add extends StatefulWidget {
  final String name;
  final String title;
  final String description;

  var documentId;

  Add({
    Key? key,
    required this.name,
    required this.title,
    required this.description,
    this.documentId,
  }) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool b = false;

  @override
  void initState() {
    if (widget.documentId == null) {
      b = true;
    }
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = widget.name;
    if (widget.title == '') {
      _titleController.text = user!.displayName.toString();
    } else {
      _titleController.text = widget.title;
    }
    _detailController.text = widget.description;
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateData(String documentId) async {
    try {
      await _firestore.doc('posts/$documentId').update({
        'uploaderName': _nameController.text,
        'title': _titleController.text,
        'description': _detailController.text,
      });
      print('Data updated in Firestore');
    } catch (error) {
      print('Error updating data in Firestore: $error');
    }
  }

  Future<void> _addData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      String? imageUrl;
      if (user != null) {
        imageUrl = user.photoURL;
      }
      DateTime now = DateTime.now();
      // Add a new document with a generated ID to a collection
      await _firestore.collection('posts').add({
        'uploaderName': _nameController.text,
        'title': _titleController.text,
        'description': _detailController.text,
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

  void init() {
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
                  )),
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
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFFF7B66)),
                ),
                onPressed: () {
                  if (!b) {
                    _updateData(widget.documentId);
                  } else {
                    _addData();
                  }
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  !b ? 'UPDATE' : 'ADD',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFFF7B66)),
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
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFFF7B66),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.create,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Add(
                      name: '',
                      title: '',
                      description: '',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
