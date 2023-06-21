import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/firestore_data_screen.dart';
import 'package:firebase/toast/toast.dart';
import 'package:firebase/ui/authentication/login_screen.dart';
import 'package:firebase/upload_image_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  //
  //

  final searchController = TextEditingController();
  final editController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('post').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
        title: const Text(
          'Firestore List Screen',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then(
                (value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ),
                  );
                },
              ).onError((error, stackTrace) {
                Toast().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: myFirestoreListScreen(),
      floatingActionButton: myFloatingActionButton(),
    );
  }

  Widget myFirestoreListScreen() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              }),
        ),
        StreamBuilder(
          stream: fireStore,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                  strokeWidth: 3,
                ),
              );
            }
            if (snapshot.hasError) {
              Toast().toastMessage('Something went wrong!');
            }
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final title = snapshot.data!.docs[index]['title'].toString();
                  final id = snapshot.data!.docs[index]['id'].toString();

                  if (searchController.text.isEmpty) {
                    return Card(
                      elevation: 10,
                      color: Colors.grey[200],
                      child: ListTile(
                        leading: CircleAvatar(
                          child: FittedBox(
                              child: Text(
                                  snapshot.data!.docs[index]['id'].toString())),
                        ),
                        title: Text(
                            snapshot.data!.docs[index]['title'].toString()),
                        subtitle:
                            Text(snapshot.data!.docs[index]['id'].toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Update'),
                                      content: TextFormField(
                                        controller: editController,
                                        decoration: const InputDecoration(
                                          hintText: 'Edit',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ref
                                                .doc(snapshot.data!.docs[index]
                                                    ['id'])
                                                .update({
                                              'title': editController.text,
                                              // 'title': 'I\'m Available',
                                            });
                                            Navigator.of(context).pop();
                                            editController.clear();
                                          },
                                          child: const Text('Update'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              value: 1,
                              child: const ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {
                                ref
                                    .doc(snapshot.data!.docs[index]['id'])
                                    .delete();
                                // Navigator.of(context).pop();
                              },
                              child: const ListTile(
                                leading: Icon(Icons.delete_outline),
                                title: Text('Delete'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (title.toLowerCase().contains(
                      searchController.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(title),
                      subtitle: Text(id),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget myFloatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'FirestoreDataScreen',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const FirestoreDataScreen();
                },
              ),
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        FloatingActionButton(
          heroTag: 'UploadImageScreen',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const UploadImageScreen();
                },
              ),
            );
          },
          child: const Icon(
            Icons.remove,
          ),
        ),
      ],
    );
  }
}
