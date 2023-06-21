import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/toast/toast.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

class FirestoreDataScreen extends StatefulWidget {
  const FirestoreDataScreen({super.key});

  @override
  State<FirestoreDataScreen> createState() => _FirestoreDataScreenState();
}

class _FirestoreDataScreenState extends State<FirestoreDataScreen> {
  //
  //

  bool loading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Firestore Data Screen',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 70),
              TextFormField(
                maxLines: 5,
                controller: postController,
                decoration: InputDecoration(
                  hintText: 'What\'s in your mind ?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.pink,
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              RoundButton(
                title: 'Add',
                loading: loading,
                myOnTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().microsecondsSinceEpoch.toString();

                  fireStore.doc(id).set({
                    'id': id,
                    'title': postController.text.toString(),
                  }).then((value) {
                    Toast().toastMessage('Post Added');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Post Added in Firestore Databse',
                        ),
                      ),
                    );

                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Toast().toastMessage(error.toString());

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Something went wrong!',
                        ),
                      ),
                    );

                    setState(() {
                      loading = false;
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
