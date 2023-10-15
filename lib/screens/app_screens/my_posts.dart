import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_tile.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key, required this.isfav});

  @override
  State<MyPosts> createState() => _MyPostsState();
  final bool isfav;
}

class _MyPostsState extends State<MyPosts> {
  String col = "QpPosts";
  var id = "";

  Future<Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _findposts();
  }

  Future<Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _findposts() async {
    final user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();

    if (col == "QpPosts") {
      final refdoc =
          await FirebaseFirestore.instance.collection('QuestionPapers').get();
      return refdoc.docs.where(
        (element) {
          id = element.id;

          List user = widget.isfav ? userDoc["favs"] : userDoc["QpPosts"];
          return user.contains(id);
        },
      );
    } else {
      final refdoc = await FirebaseFirestore.instance.collection('Notes').get();
      return refdoc.docs.where(
        (element) {
          id = element.id;
          List user = widget.isfav ? userDoc["favs"] : userDoc["NotePosts"];
          return user.contains(id);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          !widget.isfav ? "Your Posts" : "Your Favorites",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 136, 255),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  !widget.isfav ? "Your Contributions" : "Favorited Material",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: col,
                  onChanged: (value) {
                    setState(
                      () {
                        col = value!;
                        _future = _findposts();
                      },
                    );
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "QpPosts",
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          "Question Papers",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "NotePosts",
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          "Notes",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: "Select Post Type",
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<
                Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final ref = snapshot.data ?? [];
                  if (ref.isEmpty) {
                    // Handle case when there are no posts available
                    return Center(
                      child: Text(
                        widget.isfav
                            ? "You haven't favorited any posts yet."
                            : "You haven't made any posts yet.",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: ref.length,
                      itemBuilder: (context, index) {
                        final doc = ref.elementAt(index).data();
                        return col == "QpPosts"
                            ? CustomListTile(
                                sem: doc['semester'],
                                branch: doc['BranchName'],
                                isQuestionpaper: true,
                                isVerified: doc["Verified"],
                                id: id,
                                collegeName: doc['CollegeName'],
                                subjectName: doc['SubjectName'],
                                userName: doc['User Id'],
                                votes: doc['Votes'],
                                year: doc['Year'],
                              )
                            : CustomListTile(
                                sem: doc['semester'],
                                branch: doc['BranchName'],
                                isQuestionpaper: false,
                                isVerified: doc["Verified"],
                                id: id,
                                collegeName: doc['CollegeName'],
                                subjectName: doc['SubjectName'],
                                userName: doc['UserId'],
                                votes: doc['Votes'],
                                year: doc['TopicName'],
                              );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
