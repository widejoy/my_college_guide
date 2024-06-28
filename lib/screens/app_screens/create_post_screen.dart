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
  TextEditingController year = TextEditingController();
  TextEditingController branchnameController = TextEditingController();
  TextEditingController semnameController = TextEditingController();
  TextEditingController subnameController = TextEditingController();
  TextEditingController topic = TextEditingController();
  String? subnameError;
  String? yearError;
  String? fileError;

  String? topicError;
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
            !_isSubmitting ? Navigator.of(context).pop() : null;
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              widget.isquestionpaper
                  ? customField(year, "Year", isNumeric: true)
                  : customField(topic, "Topic", isNumeric: false),
              const SizedBox(height: 16),
              customField(branchnameController, "Branch Name", isNumeric: false),
              const SizedBox(height: 16),
              customField(semnameController, "Semester", isNumeric: true),
              const SizedBox(height: 16),
              customField(subnameController, "Subject Name", isNumeric: false),
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
                      elevation: WidgetStatePropertyAll(24),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.grey),
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
                          backgroundColor: WidgetStatePropertyAll(
                              Colors.purple.withOpacity(0.1)),
                          fixedSize:
                              const WidgetStatePropertyAll(Size(400, 12)),
                        ),
                        onPressed: _isSubmitting
                            ? null
                            : () async {
                                setState(() {
                                  _isSubmitting = true;
                                });
                                yearError = widget.isquestionpaper
                                    ? _validateField(year.text, "Year")
                                    : null;
                                topicError = !widget.isquestionpaper
                                    ? _validateField(topic.text, "Topic")
                                    : null;

                                if (subnameError == null &&
                                    yearError == null &&
                                    topicError == null) {
                                  if (file != null) {
                                    keywords.addAll(subnameController.text
                                            .toLowerCase()
                                            .split(' ') +
                                        branchnameController.text
                                            .toLowerCase()
                                            .split(' ') +
                                        semnameController.text.split(' '));
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
                                          "SubjectName":
                                              subnameController.text,
                                          "Year": year.text,
                                          "CollegeName":
                                              "CUSAT - Cochin University Of Science And Technology",
                                          "BranchName":
                                              branchnameController.text,
                                          "semester": semnameController.text,
                                          "Votes": 0,
                                          "UserId": (userDoc.data() as Map<
                                              String, dynamic>)['username'],
                                          "Keywords": keywords,
                                          "Verified": false
                                        };

                                        final addedDocRef =
                                            await FirebaseFirestore.instance
                                                .collection("QuestionPapers")
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
                                          'QpPosts': FieldValue.arrayUnion(
                                              [documentId]),
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
                                          "CollegeName":
                                              "CUSAT - Cochin University Of Science And Technology",
                                          "BranchName":
                                              branchnameController.text,
                                          "semester": semnameController.text,
                                          "Votes": 0,
                                          "SubjectName":
                                              subnameController.text,
                                          "UserId": (userDoc.data() as Map<
                                              String, dynamic>)['username'],
                                          "TopicName": topic.text,
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
                                          'NotePosts': FieldValue.arrayUnion(
                                              [documentId]),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                }
                              },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return "$fieldName cannot be empty";
    }
    return null;
  }

  String _truncateFileName(String fileName) {
    int maxLength = 30;
    if (fileName.length <= maxLength) return fileName;
    int lastDotIndex = fileName.lastIndexOf('.');
    String extension = lastDotIndex != -1 ? fileName.substring(lastDotIndex) : '';
    String truncatedFileName = '${fileName.substring(0, maxLength - extension.length)}...$extension';
    return truncatedFileName;
  }
}
