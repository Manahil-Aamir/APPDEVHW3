import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  String datecalc(Timestamp date) {
    DateTime now = new DateTime.now();
    DateTime posttime = date.toDate();
    Duration diff = now.difference(posttime);
    if (diff.inDays > 365) {
      int y = (diff.inDays / 365).floor();
      if(y==1) return '1 year ago';
      return '$y years ago';
    }
    if (diff.inDays > 30) {
      int m = (diff.inDays / 30).floor();
      if(m==1) return '1 month ago';
      return '$m months ago';
    }
    if (diff.inDays > 0) {
      int d = diff.inDays;
      print(d);
      if(d==1) return '1 day ago';
      return '$d days ago';
    }
    if (diff.inHours < 24 && diff.inHours>0) {
      int h = diff.inHours;
      if(h==1) return '1 hour ago';
      return '$h hours ago';
    }
    if (diff.inMinutes < 60 && diff.inMinutes>0) {
      int min = diff.inMinutes;
      if(min==1) return '1 minute ago';
      return '$min minutes ago';
    } else {
      return 'just now';
      
    }
  }

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
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleSignOut(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Hey ',
                  style: TextStyle(
                    color: Colors.grey[500],
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
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Start exploring resources',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
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
                          child: const Icon(
                            Icons.search,
                            color: Color(0xFFFF7B66),
                          ),
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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement filter logic
                  },
                  child: Icon(
                    Icons.filter_alt,
                    color: Color(0xFFFF7B66),
                    size: 30
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          'Latest Uploads',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 2.5,
                        ),
                        Icon(Icons.bolt, color: Colors.yellow, size: 30)
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (snapshot.data == null ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No data found'),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                color: Colors.grey[200],
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Add(
                                          name: data['uploaderName'],
                                          title: data['title'],
                                          description: data['description'],
                                          documentId:
                                              snapshot.data!.docs[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    data['profilePicture']
                                                        .toString()),
                                                radius: 18,
                                              ),
                                              const SizedBox(
                                                  width:
                                                      10), // Adjust spacing between the CircleAvatar and Text
                                              Text(
                                                data['uploaderName'],
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                datecalc(data['createdAt']),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                              height:
                                                  1), // Adjust spacing between the two rows
                                          Row(
                                            children: [
                                              Text(
                                                data['title'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 1),
                                          Row(
                                            children: [
                                              Text(
                                                data['description'],
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Container(
                                          height: 4,
                                          color: Colors.white,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 8, 5, 8),
                                              child: Text('0',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 8),
                                              child: Icon(
                                                Icons.favorite_border_outlined,
                                                color: Colors.grey[500],
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Container(
                                              height: 35,
                                              width: 3,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 8, 5, 8),
                                              child: Text('0',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 8),
                                              child: Icon(
                                                Icons.heart_broken,
                                                color: Colors.grey[500],
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Container(
                                              height: 35,
                                              width: 3,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 8, 0, 8),
                                              child: Icon(
                                                CupertinoIcons
                                                    .chat_bubble,
                                                color: Colors.grey[500],
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
