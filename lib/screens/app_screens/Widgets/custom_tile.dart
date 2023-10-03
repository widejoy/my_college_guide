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
  final String stream;
  final String id;
  final bool isVerified;
  final bool isQuestionpaper;

  const CustomListTile({
    super.key,
    required this.collegeName,
    required this.subjectName,
    required this.userName,
    required this.votes,
    required this.year,
    required this.stream,
    required this.id,
    required this.isVerified,
    required this.isQuestionpaper,
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

  @override
  void initState() {
    super.initState();
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
      });
    }
    if (isUp) {
      setState(() {
        up = const Icon(
          Icons.thumb_up,
          color: Colors.blue,
        );
      });
    } else {
      setState(() {
        up = const Icon(Icons.thumb_up_alt_outlined);
      });
    }
    if (isDown) {
      setState(() {
        down = const Icon(
          Icons.thumb_down,
          color: Colors.red,
        );
      });
    } else {
      setState(() {
        down = const Icon(Icons.thumb_down_alt_outlined);
      });
    }
  }

  void _updateVotes() {
    final collectionName = widget.isQuestionpaper ? 'Question Papers' : 'Notes';
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

    if (isUp) {
      setState(() {
        up = const Icon(Icons.thumb_up_alt_outlined);
        _voteCount--;
        isUp = false;
      });

      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);
      userReference
          .update({
            'upvoted': FieldValue.arrayRemove([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            print('Error removing upvote: $error');
          });
    } else {
      if (isDown) {
        setState(() {
          down = const Icon(Icons.thumb_down_alt_outlined);
          _voteCount++;
          isDown = false;
        });

        final userReference =
            FirebaseFirestore.instance.collection('users').doc(userid);
        userReference
            .update({
              'downvoted': FieldValue.arrayRemove([widget.id]),
            })
            .then((_) {})
            .catchError((error) {
              print('Error removing downvote: $error');
            });
      }

      setState(() {
        _voteCount++;
        up = const Icon(
          Icons.thumb_up,
          color: Colors.blue,
        );
        isUp = true;
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

    if (isDown) {
      setState(() {
        down = const Icon(Icons.thumb_down_alt_outlined);
        _voteCount++;
        isDown = false;
      });

      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);
      userReference
          .update({
            'downvoted': FieldValue.arrayRemove([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            print('Error removing downvote: $error');
          });
    } else {
      if (isUp) {
        setState(() {
          up = const Icon(Icons.thumb_up_alt_outlined);
          _voteCount--;
          isUp = false;
        });

        final userReference =
            FirebaseFirestore.instance.collection('users').doc(userid);
        userReference
            .update({
              'upvoted': FieldValue.arrayRemove([widget.id]),
            })
            .then((_) {})
            .catchError((error) {
              print('Error removing upvote: $error');
            });
      }

      setState(() {
        _voteCount--;
        down = const Icon(
          Icons.thumb_down,
          color: Colors.red,
        );
        isDown = true;
      });

      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userid);
      userReference
          .update({
            'downvoted': FieldValue.arrayUnion([widget.id]),
          })
          .then((_) {})
          .catchError((error) {
            print('Error adding downvote: $error');
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
          .catchError((error) {});
    } else {
      setState(() {
        isFavorited = true;
      });

      userReference
          .update({
            'favs': FieldValue.arrayUnion([widget.id]),
          })
          .then((_) {})
          .catchError((error) {});
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
          title: Text(
            'College: ${widget.collegeName}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject: ${widget.subjectName}'),
              Text('Uploaded by: ${widget.userName}'),
              widget.isQuestionpaper
                  ? Text('Year: ${widget.year}')
                  : Text('Topic: ${widget.year}'),
              Text('Stream: ${widget.stream}'),
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
