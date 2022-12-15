import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/presention/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "home-screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  Future<Map<String, dynamic>> getUserData() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var data = documentSnapshot.data();
    return data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Uint8List?>(
          future: FirebaseStorage.instance
              .ref("users/${FirebaseAuth.instance.currentUser?.uid}")
              .getData(),
          builder: (context, snapshot) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: snapshot.data == null
                      ? null
                      : DecorationImage(
                        fit: BoxFit.fill,
                          image: MemoryImage(snapshot.data!),
                        )),
              child: Center(
                child: Column(
                  children: [
                    ContainerPost(setState),
                    Expanded(
                      child: Posts(),
                    ),
                  ],
                ),
              ),
            );
          }),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
        title: FutureBuilder<Map<String, dynamic>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasData) {
              return Text("Welcome Mr. " + snapshot.data!['name']);
            } else {
              return Text('Empty');
            }
          },
        ),
      ),
    );
  }
}

class ContainerPost extends StatelessWidget {
  ContainerPost(this.sett, {Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();
  void Function(VoidCallback fn) sett;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: controller,
              minLines: 3,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('posts').add({
                  'content': controller.text,
                  'user': FirebaseAuth.instance.currentUser!.uid,
                  'date': DateTime.now().toString(),
                });
                controller.clear();

                //show Snack Bar
                // sett(() {

                // });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Post Added")));
              },
              child: Text("Post"))
        ],
      ),
    );
  }
}

class Posts extends StatelessWidget {
  const Posts({Key? key}) : super(key: key);
  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    return FirebaseFirestore.instance.collection('posts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var count = 0;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getPosts(),
      builder: (context, snapshot) {
        // print(++count);
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        else if (snapshot.hasData) {
          var querySnapshot = snapshot.data;
          var docs = querySnapshot!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) => Column(
              children: [
                UserName(),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(docs[index].data()['user'])
                              .get(),
                          builder: (context, snapshot) {
                            return Text(
                                snapshot.data?.data()?['name'] ?? 'Loading');
                          }),
                      Text(
                        docs[index].data()['content'],
                      ),
                      SizedBox(
                          width: 40,
                          child: InkWell(
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(docs[index].id)
                                  .update({"content": "Ahmed"});
                            },
                            child: Text(
                              docs[index].data()['date'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
            itemCount: docs.length,
          );
        }
        return Text('data');
      },
    );
  }
}

class UserName extends StatelessWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String Function(double, int) f = (a, b) {
      return "$a $b";
    };
    String s = f.call(1, 2);
    Future Function() function = () {
      return Future.delayed(Duration(seconds: 2), () => "Hello");
    };
    return Container();
  }
}
