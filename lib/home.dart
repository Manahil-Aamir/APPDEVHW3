import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hw3/createpost.dart';
import 'package:hw3/google.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[200],
    appBar: AppBar(
      title: const Text(
        'Home',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.grey[200],
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleSignOut(context);
          },
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hey ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                user.displayName!,
                style: const TextStyle(
                  color: Color(0xFFFF7B66),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Start exploring resources',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white, // Remove this line
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.search,
                            color: const Color(0xFFFF7B66),),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 244, 196, 189),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {},
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement filter logic
                  },
                  child: const Icon(
                    Icons.file_download_done,
                    color: const Color(0xFFFF7B66),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                )
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
              
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No data found'),
                    );
                  }
              
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['profilePicture'].toString()), // Assuming profilePicUrl contains the URL of the profile picture
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['uploaderName'].toString()),
                        Text(
              data['createdAt'].toString(), // Assuming date is a DateTime or String field
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
              data['title'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
                        ),
                        Text(data['description'].toString()),
                      ],
                    ),
                  );
                },
              );
              
                },
              ),
            ),
          ),
        ],
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
                MaterialPageRoute(builder: (context) => Home()),
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
                MaterialPageRoute(builder: (context) => Add()),
              );
            },
          ),
        ],
      ),
    ),
  );
}
}
