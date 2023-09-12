import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/viewpdf_screen.dart';

class CustomListTile extends StatefulWidget {
  final String collegeName;
  final String subjectName;
  final String userName;
  final int votes;
  final int year;
  final String stream;

  const CustomListTile({
    super.key,
    required this.collegeName,
    required this.subjectName,
    required this.userName,
    required this.votes,
    required this.year,
    required this.stream,
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

  void _upvote() {
    if (isUp) {
      setState(() {
        up = const Icon(Icons.thumb_up_alt_outlined);
        _voteCount--;
        isUp = false;
      });
    } else {
      setState(() {
        if (isDown) {
          // If it was previously downvoted, undo the downvote
          down = const Icon(Icons.thumb_down_alt_outlined);
          _voteCount++;
          isDown = false;
        }
        _voteCount++;
        up = const Icon(
          Icons.thumb_up,
          color: Colors.blue,
        );
        isUp = true;
      });
    }
  }

  void _downvote() {
    if (isDown) {
      setState(() {
        down = const Icon(Icons.thumb_down_alt_outlined);
        _voteCount++;
        isDown = false;
      });
    } else {
      setState(() {
        if (isUp) {
          up = const Icon(Icons.thumb_up_alt_outlined);
          _voteCount--;
          isUp = false;
        }
        _voteCount--;
        down = const Icon(
          Icons.thumb_down,
          color: Colors.red,
        );
        isDown = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.comfortable,
      leading: const Icon(Icons.sticky_note_2),
      title: Text('College: ${widget.collegeName}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subject: ${widget.subjectName}'),
          Text('Uploaded by: ${widget.userName}'),
          Text('Year: ${widget.year}'),
          Text('Stream: ${widget.stream}')
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
          Text('$_voteCount', style: const TextStyle(fontSize: 16)),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Viewpdf(),
          ),
        );
      },
    );
  }
}
