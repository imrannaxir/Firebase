import 'dart:io';
import 'package:firebase/toast/toast.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  /*

  */
  bool loading = false;
  final _databaseRef = FirebaseDatabase.instance.ref().child('Post').push();

  firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;
  /*
    To fetch/pick image from gallery "dart:io" package is best
  */
  File? _image;

  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image Picked From Gallery');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Upload Image Screen',
        ),
        centerTitle: true,
      ),
      body: uploadImageScreen(),
    );
  }

  Widget uploadImageScreen() {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Center(
                child: Container(
                  height: size.height * 0.3,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : const Icon(Icons.image),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          RoundButton(
            loading: loading,
            title: 'Upload',
            myOnTap: () async {
              setState(() {
                loading = true;
              });

              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  //.ref('/Imran/' + DateTime.now().millisecondsSinceEpoch.toString());
                  .ref('/Imran/${DateTime.now().millisecondsSinceEpoch}');

              firebase_storage.UploadTask uploadTask =
                  ref.putFile(_image!.absolute);

              await Future.value(uploadTask);
              var newUrl = await ref.getDownloadURL();

              _databaseRef
                  .child(DateTime.now().millisecondsSinceEpoch.toString())
                  .set({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'title': newUrl.toString(),
              }).then((value) {
                Toast().toastMessage('Uploaded');
                setState(() {
                  loading = false;
                });
              }).onError((error, stackTrace) {
                Toast().toastMessage(error.toString());
                setState(() {
                  loading = false;
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
