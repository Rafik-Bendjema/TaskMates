import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CoTaskRow extends StatefulWidget {
  dynamic Function(String, String) onChoosed;
  CoTaskRow({super.key, required this.onChoosed});

  @override
  State<CoTaskRow> createState() => _CoTaskRowState();
}

class _CoTaskRowState extends State<CoTaskRow> {
  String? friendId;
  String? friendsUid;
  Future<DocumentSnapshot<Map<String, dynamic>>> friendsFuture() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<List<DocumentSnapshot>> fetchFriends(List<dynamic> friends) async {
    List<DocumentSnapshot> docs = [];
    for (String friendId in friends) {
      DocumentSnapshot friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .get();
      if (friendDoc.exists) {
        docs.add(friendDoc);
      }
    }

    return docs;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Co-Task'),
        if (friendId != null) Text(friendId!),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA6FF94),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: FutureBuilder(
                      future: friendsFuture(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("error fetching friends list"),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          var friendlist = snapshot.data;
                          var data = friendlist?.data();
                          if (data != null) {
                            List<dynamic> friendids = data["friends"];
                            return FutureBuilder(
                              future: fetchFriends(friendids),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return const Text("error getting friends");
                                }
                                if (snapshot.hasData && snapshot.data != null) {
                                  List<DocumentSnapshot<Object?>> friendDocs =
                                      snapshot.data!;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: friendDocs.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text((friendDocs[index].data()
                                            as Map<String, dynamic>)["id"]),
                                        trailing: ElevatedButton(
                                            onPressed: () {
                                              widget.onChoosed(
                                                  friendDocs[index].id,
                                                  (friendDocs[index].data()
                                                      as Map<String,
                                                          dynamic>)["id"]);
                                              setState(() {
                                                friendId =
                                                    (friendDocs[index].data()
                                                        as Map<String,
                                                            dynamic>)["id"];
                                              });
                                            },
                                            child: const Text("choose")),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox();
                              },
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  );
                });
          },
          child: const Text(
            "Change",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
