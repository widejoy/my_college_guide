import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_field.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController subname = TextEditingController();
  TextEditingController year = TextEditingController();
  String collegename = "CUSAT - Cochin University Of Science And Technology";
  TextEditingController stream = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Your Question Paper",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple,
                Colors.purpleAccent,
              ],
            ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Enter Details of Your Question Paper",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            customField(subname, "Subject Name"),
            const SizedBox(height: 16),
            customField(year, "Year"),
            const SizedBox(height: 16),
            customField(stream, "Stream"),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: collegename,
              items: const [
                DropdownMenuItem(
                  value: "CUSAT - Cochin University Of Science And Technology",
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      "CUSAT - Cochin University Of Science And Technology",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  collegename = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Select College",
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
            ),
            const SizedBox(height: 24),
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
                    "user id": user?.uid,
                    "Stream": stream.text
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
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $error"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
