// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePostScreen extends StatefulWidget {
  final bool isquestionpaper;

  const CreatePostScreen({super.key, required this.isquestionpaper});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController subname = TextEditingController();
  TextEditingController year = TextEditingController();
  String collegename = "CUSAT - Cochin University Of Science And Technology";
  TextEditingController topic = TextEditingController();
  TextEditingController stream = TextEditingController();
  String? subnameError;
  String? yearError;
  String? fileError;

  String? topicError;
  String? streamError;
  bool _isSubmitting = false;

  PlatformFile? file;
  bool pdf = false;
  List<String> keywords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isquestionpaper
              ? "Upload Your Question Paper"
              : "Upload Your Notes",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              widget.isquestionpaper
                  ? "Enter Details of Your Question Paper"
                  : "Enter Details of Your Notes",
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            customField(subname, "Subject Name"),
            const SizedBox(height: 16),
            widget.isquestionpaper
                ? customField(year, "Year", isnum: true)
                : customField(topic, "Topic"),
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
                      style: TextStyle(fontSize: 14, color: Colors.purple),
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "Others",
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      "Others",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14, color: Colors.purple),
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  collegename = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 253, 241, 255),
                labelText: "Select College",
                labelStyle: const TextStyle(
                  color: Colors.purple,
                  fontSize: 16.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.purple, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purple.withOpacity(0.7), width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      dialogTitle: 'Pick Your File',
                      type: FileType.custom,
                      allowedExtensions: ["pdf"],
                    );

                    if (result != null) {
                      setState(() {
                        file = result.files.first;
                        pdf = true;
                      });
                    }
                  },
                  icon: pdf
                      ? const Icon(
                          Icons.picture_as_pdf,
                          size: 48,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.upload,
                          size: 48,
                        ),
                  style: const ButtonStyle(
                    enableFeedback: true,
                    elevation: MaterialStatePropertyAll(24),
                    surfaceTintColor: MaterialStatePropertyAll(Colors.grey),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: pdf
                      ? Text(
                          ' ${_truncateFileName(file!.name)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                            fontFamily: 'Montserrat',
                            letterSpacing: 0.5,
                          ),
                        )
                      : const Text(
                          'Upload Your File',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            letterSpacing: 0.5,
                          ),
                        ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : OutlinedButton(
                      style: ButtonStyle(
                        enableFeedback: true,
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.purple.withOpacity(0.1)),
                        fixedSize:
                            const MaterialStatePropertyAll(Size(400, 12)),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              setState(() {
                                _isSubmitting = true;
                              });
                              subnameError =
                                  _validateField(subname.text, "Subject Name");
                              yearError = widget.isquestionpaper
                                  ? _validateField(year.text, "Year")
                                  : null;
                              topicError = !widget.isquestionpaper
                                  ? _validateField(topic.text, "Topic")
                                  : null;
                              streamError =
                                  _validateField(stream.text, "Stream");

                              if (subnameError == null &&
                                  yearError == null &&
                                  topicError == null &&
                                  streamError == null) {
                                if (file != null) {
                                  keywords.addAll(
                                    subname.text.toLowerCase().split(' ') +
                                        stream.text.toLowerCase().split(' ') +
                                        collegename.toLowerCase().split(' '),
                                  );
                                  if (widget.isquestionpaper) {
                                    keywords.add(year.text);
                                  } else {
                                    keywords.addAll(
                                      topic.text.toLowerCase().split(' '),
                                    );
                                  }

                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  DocumentSnapshot userDoc =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user?.uid)
                                          .get();

                                  try {
                                    if (widget.isquestionpaper) {
                                      Map<String, dynamic> dataToAdd = {
                                        "Subject Name": subname.text,
                                        "Year": year.text,
                                        "College Name": collegename,
                                        "Votes": 0,
                                        "User Id": (userDoc.data() as Map<
                                            String, dynamic>)['username'],
                                        "Stream": stream.text,
                                        "Keywords": keywords,
                                        "Verified": false
                                      };

                                      final addedDocRef =
                                          await FirebaseFirestore.instance
                                              .collection("Question Papers")
                                              .add(dataToAdd);
                                      String documentId = addedDocRef.id;
                                      final filePath = '/$documentId.pdf';
                                      await FirebaseStorage.instance
                                          .ref()
                                          .child(filePath)
                                          .putFile(
                                            File(file!.path!),
                                          );

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user?.uid)
                                          .update({
                                        'QpPosts':
                                            FieldValue.arrayUnion([documentId]),
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Successfully added data"),
                                        ),
                                      );
                                    } else {
                                      Map<String, dynamic> dataToAdd = {
                                        "College Name": collegename,
                                        "Votes": 0,
                                        "Subject Name": subname.text,
                                        "User Id": (userDoc.data() as Map<
                                            String, dynamic>)['username'],
                                        "Stream": stream.text,
                                        "Topic Name": topic.text,
                                        "Keywords": keywords,
                                        "Verified": false
                                      };

                                      final addedDocRef =
                                          await FirebaseFirestore.instance
                                              .collection("Notes")
                                              .add(dataToAdd);
                                      String documentId = addedDocRef.id;
                                      final filePath = '/$documentId.pdf';
                                      await FirebaseStorage.instance
                                          .ref()
                                          .child(filePath)
                                          .putFile(
                                            File(file!.path!),
                                          );

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user?.uid)
                                          .update({
                                        'NotePosts':
                                            FieldValue.arrayUnion([documentId]),
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Successfully added data"),
                                        ),
                                      );
                                    }

                                    Navigator.of(context).pop();
                                  } catch (error) {
                                    setState(() {
                                      _isSubmitting = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error: $error"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    _isSubmitting = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please upload a file"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                setState(() {
                                  _isSubmitting = false;
                                });

                                if (subnameError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${subnameError!}"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                if (yearError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${yearError!}"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                if (topicError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${topicError!}"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                if (streamError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${streamError!}"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return "$fieldName is required";
    }

    return null;
  }

  String _truncateFileName(String fileName) {
    const maxFileNameLength = 30;
    if (fileName.length <= maxFileNameLength) {
      return fileName;
    } else {
      return '${fileName.substring(0, maxFileNameLength - 3)}...';
    }
  }
}
