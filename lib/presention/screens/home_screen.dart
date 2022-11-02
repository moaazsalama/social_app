import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/presention/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: Container(
        child: Center(
          child: Column(
            children: [ContainerPost(), Posts()],
          ),
        ),
      ),
      appBar: AppBar(
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
  ContainerPost({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();
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
  Future<QuerySnapshot<Map<String, dynamic>>> getPosts() async {
    return await FirebaseFirestore.instance.collection('posts').get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        else if (snapshot.hasData) {
          var querySnapshot = snapshot.data;
          var docs = querySnapshot!.docs;
          return Expanded(
              child: ListView.builder(
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
                      Text(
                        docs[index].data()['content'],
                      ),
                      SizedBox(width: 40, child: Text(docs[index].data()['date'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,))
                    ],
                  ),
                ),
              ],
            ),
            itemCount: docs.length,
          ));
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
    return Container();
  }
}
