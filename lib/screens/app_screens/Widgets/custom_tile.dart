import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/viewpdf_screen.dart';

class CustomListTile extends StatefulWidget {
  final String collegeName;
  final String subjectName;
  final String userName;
  final int votes;
  final String year;
  final String id;
  final bool isVerified;
  final bool isQuestionpaper;
  final String sem;
  final String branch;

  const CustomListTile({
    super.key,
    required this.collegeName,
    required this.subjectName,
    required this.userName,
    required this.votes,
    required this.year,
    required this.id,
    required this.isVerified,
    required this.isQuestionpaper,
    required this.sem,
    required this.branch,
  });

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  Widget up = const Icon(Icons.thumb_up_alt_outlined);
  Widget down = const Icon(Icons.thumb_down_alt_outlined);
  bool isUp = false;
  bool isDown = false;
  int _voteCount = 0;
  bool isFavorited = false;

  bool hasUpvoted = false;
  bool hasDownvoted = false;

  @override
  void initState() {
    super.initState();
    print(widget.id);
    _checkUserVotesAndFavorites();
  }

  void _checkUserVotesAndFavorites() {
    final user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid;

    if (userid != null) {
      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);

      userReference.get().then((doc) {
        final upvotedPosts = doc['upvoted'] ?? [];
        final downvotedPosts = doc['downvoted'] ?? [];
        final favoritedPosts = doc['favs'] ?? [];

        setState(() {
          isUp = upvotedPosts.contains(widget.id);
          isDown = downvotedPosts.contains(widget.id);
          isFavorited = favoritedPosts.contains(widget.id);
        });

        // Update the hasUpvoted and hasDownvoted variables
        hasUpvoted = isUp;
        hasDownvoted = isDown;

        // Set the upvote and downvote icon colors based on the variables
        if (hasUpvoted) {
          setState(() {
            up = const Icon(
              Icons.thumb_up,
              color: Colors.blue,
            );
          });
        }

        if (hasDownvoted) {
          setState(() {
            down = const Icon(
              Icons.thumb_down,
              color: Colors.red,
            );
          });
        }
      });
    }

    final collectionName = widget.isQuestionpaper ? 'QuestionPapers' : 'Notes';
    final docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(widget.id);

    docRef.get().then((doc) {
      setState(() {
        _voteCount = doc['Votes'];
      });
    });
  }

  void _updateVotes() {
    final collectionName = widget.isQuestionpaper ? 'QuestionPapers' : 'Notes';
    final docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(widget.id);

    docRef
        .update({
          'Votes': _voteCount,
        })
        .then((_) {})
        .catchError(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error :$error"),
              ),
            );
          },
        );
  }

  void _upvote() {
    final user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid;

    if (hasUpvoted) {
      setState(() {
        up = const Icon(Icons.thumb_up_alt_outlined);
        _voteCount--;
        hasUpvoted = false;
      });

      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);
      userReference
          .update({
            'upvoted': FieldValue.arrayRemove([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(' $error'),
              ),
            );
          });
    } else {
      if (hasDownvoted) {
        setState(() {
          down = const Icon(Icons.thumb_down_alt_outlined);
          _voteCount++;
          hasDownvoted = false;
        });

        final userReference =
            FirebaseFirestore.instance.collection('users').doc(userid);
        userReference
            .update({
              'downvoted': FieldValue.arrayRemove([widget.id]),
            })
            .then((_) {})
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(' $error'),
                ),
              );
            });
      }

      setState(() {
        _voteCount++;
        up = const Icon(
          Icons.thumb_up,
          color: Colors.blue,
        );
        hasUpvoted = true;
      });

      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);
      userReference
          .update({
            'upvoted': FieldValue.arrayUnion([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            print('Error adding upvote: $error');
          });
    }

    _updateVotes();
  }

  void _downvote() {
    final user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid;

    if (hasDownvoted) {
      setState(() {
        down = const Icon(Icons.thumb_down_alt_outlined);
        _voteCount++;
        hasDownvoted = false;
      });

      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);
      userReference
          .update({
            'downvoted': FieldValue.arrayRemove([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(' $error'),
              ),
            );
          });
    } else {
      if (hasUpvoted) {
        setState(() {
          up = const Icon(Icons.thumb_up_alt_outlined);
          _voteCount--;
          hasUpvoted = false;
        });

        final userReference =
            FirebaseFirestore.instance.collection('users').doc(userid);
        userReference
            .update({
              'upvoted': FieldValue.arrayRemove([widget.id]),
            })
            .then((_) {})
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(' $error'),
                ),
              );
            });
      }

      setState(() {
        _voteCount--;
        down = const Icon(
          Icons.thumb_down,
          color: Colors.red,
        );
        hasDownvoted = true;
      });

      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);
      userReference
          .update({
            'downvoted': FieldValue.arrayUnion([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$error'),
              ),
            );
          });
    }

    _updateVotes();
  }

  void _toggleFavorite() {
    final user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid;

    final userReference =
        FirebaseFirestore.instance.collection('users').doc(userid);

    if (isFavorited) {
      setState(() {
        isFavorited = false;
      });

      userReference
          .update({
            'favs': FieldValue.arrayRemove([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$error'),
              ),
            );
          });
    } else {
      setState(() {
        isFavorited = true;
      });

      userReference
          .update({
            'favs': FieldValue.arrayUnion([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$error'),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListTile(
          tileColor: const Color.fromARGB(255, 253, 241, 255),
          visualDensity: VisualDensity.comfortable,
          leading: const Icon(Icons.sticky_note_2),
          title: widget.isQuestionpaper
              ? Text(
                  'Subject: ${widget.subjectName} \n Year: ${widget.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : Text(
                  'Subject: ${widget.subjectName} \n Topic: ${widget.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Text('semester: ${widget.sem}'),
              Text('branch: ${widget.branch}'),
              Text('Uploaded by: ${widget.userName}'),
            ],
          ),
          trailing: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: up,
                      onPressed: _upvote,
                    ),
                    IconButton(
                      icon: down,
                      onPressed: _downvote,
                    ),
                  ],
                ),
              ),
              Text(
                '$_voteCount',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Viewpdf(id: widget.id),
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: isFavorited
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ),
        if (widget.isVerified)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
}
