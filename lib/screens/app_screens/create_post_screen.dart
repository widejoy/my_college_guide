import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_field.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController subname = TextEditingController();
  TextEditingController year = TextEditingController();
  String collegename =
      "CUSAT - Cochin University Of Science And Technology"; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Post your question paper'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notes_rounded,
            size: 75,
            weight: 12,
            color: Colors.purple,
          ),
          const Text(
            "Question Paper",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purple),
          ),
          const Text(
            "Enter Details of your qp",
            style: TextStyle(
              color: Color.fromARGB(255, 160, 78, 174),
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          customField(subname, "Subject Name"),
          const SizedBox(
            height: 20,
          ),
          customField(year, "Year"),
          const SizedBox(
            height: 20,
          ),
          DropdownButton(
            value: collegename,
            items: const [
              DropdownMenuItem(
                value: "CUSAT - Cochin University Of Science And Technology",
                child: SizedBox(
                  width: 200,
                  child: Tooltip(
                    message:
                        "CUSAT - Cochin University Of Science And Technology",
                    child: Text(
                      "CUSAT - Cochin University Of Science And Technology",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                collegename = value as String;
              });
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: OutlinedButton(
              style: const ButtonStyle(
                fixedSize: MaterialStatePropertyAll(
                  Size(400, 12),
                ),
              ),
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;

                Map<String, dynamic> dataToAdd = {
                  "Subject name": subname.text,
                  "year": year.text,
                  "College Name": collegename,
                  "votes": 0,
                  "user id": user?.uid
                };

                FirebaseFirestore.instance
                    .collection("Question Papers")
                    .add(dataToAdd)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Succesfully added data"),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error:$error"),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              child: const Text("Submit"),
            ),
          )
        ],
      ),
    );
  }
}
