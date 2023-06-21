import 'package:firebase/toast/toast.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  //
  //

  bool loading = false;
  final postController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref().child('Post').push();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Add Post',
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
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  _databaseRef.child(id).set({
                    'rollNo': id,
                    'title': postController.text.toString(),
                  }).then((value) {
                    Toast().toastMessage('Post Added');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Post Added in Realtime Databse',
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
                // myOnTap: () {
                //   try {
                //     FirebaseDatabase.instance.ref().child('talhaaa').push().set({
                //       'rollNo': 2,
                //       'title': 'Zooo',
                //     });
                //     print('Data Added');
                //   } catch (e) {
                //     print(e.toString());
                //     print('Error');
                //   }
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
