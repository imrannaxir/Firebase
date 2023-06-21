import 'package:firebase/posts/add_posts.dart';
import 'package:firebase/toast/toast.dart';
import 'package:firebase/ui/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  //
  //
  final searchController = TextEditingController();
  final editController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final _databaseRef = FirebaseDatabase.instance.ref().child('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
        title: const Text(
          'Post Screen',
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
      body: myPostScreen(),
      floatingActionButton: myFloatingActionButton(),
    );
  }

  Widget myPostScreen() {
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
        Expanded(
          child: StreamBuilder(
            stream: _databaseRef.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              print(snapshot.data);

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.pink,
                    strokeWidth: 3,
                  ),
                );
              } else {
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;

                List<dynamic> list = [];
                //list.clear();
                list = map.values.toList();
                print('~?????????????????????${list.length}');

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    /**
                     
                     */
                    String title = list[index]['title'];
                    String id = list[index]['rollNo'];
                    print('title@@@@@@@@@@@222$title');
                    print('rollno@@@@@@@@@@@@@@22$id');

                    if (searchController.text.isEmpty) {
                      return ListTile(
                        // title: Text('Imran Nazeer'),
                        title: Text(title),
                        subtitle: Text(id),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                showMyDialog(title, id);
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
                                Navigator.of(context).pop();
                                _databaseRef.child(id).remove();
                              },
                              child: const ListTile(
                                leading: Icon(Icons.delete_outline),
                                title: Text('Delete'),
                              ),
                            ),
                          ],
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
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget myFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const AddPostScreen();
            },
          ),
        );
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) {
    title = editController.text;
    return showDialog(
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
                Navigator.of(context).pop();

                _databaseRef.child(id).update({
                  'title': editController.text.toString(),
                }).then((value) {
                  Toast().toastMessage('Updated');
                }).onError((error, stackTrace) {
                  Toast().toastMessage(error.toString());
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

// child: FirebaseAnimatedList(
//   defaultChild: CircularProgressIndicator(),
//   scrollDirection: Axis.vertical,
//   query: _databaseRef,
//   itemBuilder: (context, snapshot, animation, index) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 50,
//         backgroundColor: Colors.pink,
//         child: Text(snapshot.child('id').value.toString()),
//       ),
//       title: Text(snapshot.child('name').value.toString()),
//     );
//   },
// ),
