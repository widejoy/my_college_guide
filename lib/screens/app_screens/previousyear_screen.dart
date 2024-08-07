import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_tile.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class PreviousYearScreen extends StatefulWidget {
  const PreviousYearScreen({super.key, required this.isquestionpaper});

  final bool isquestionpaper;

  @override
  State<PreviousYearScreen> createState() => _PreviousYearScreenState();
}

class _PreviousYearScreenState extends State<PreviousYearScreen> {
  String? selectedCollege;
  bool collegeDropdownEnabled = true;
  List<DocumentSnapshot> searchDatabase = [];
  TextEditingController search = TextEditingController();

  bool isloading = false;

  Future<List<DocumentSnapshot>> performFuzzySearch(String searchText) async {
    setState(() {
      isloading = true;
    });

    final querySnapshot = widget.isquestionpaper
        ? await FirebaseFirestore.instance.collection('QuestionPapers').get()
        : await FirebaseFirestore.instance.collection('Notes').get();

    final searchResults = querySnapshot.docs.where((doc) {
      final List<String> keywords = List<String>.from(doc["Keywords"] ?? []);

      final lowercaseSearchText = searchText.toLowerCase();

      for (String keyword in keywords) {
        final lowercaseKeyword = keyword.toLowerCase();

        final result = extractOne(
          query: lowercaseSearchText,
          choices: [lowercaseKeyword],
        );

        final score = result.score;

        if (score >= 50) {
          return true;
        }
      }
      return false;
    }).toList();

    searchResults.sort(
      (a, b) => b['Votes'].compareTo(a['Votes']),
    );

    setState(() {
      isloading = false;
    });

    return searchResults;
  }

  void updateSearchResults(String searchText) async {
    final results = await performFuzzySearch(searchText);
    setState(() {
      searchDatabase = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerCustom(),
      appBar: CustomAppBar(
          title: widget.isquestionpaper
              ? 'Previous Year Question Papers'
              : "Notes"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            SearchBar(
              onChanged: (value) {
                updateSearchResults(value);
              },
              controller: search,
              elevation: const WidgetStatePropertyAll(12),
              hintStyle: const WidgetStatePropertyAll(
                TextStyle(
                  overflow: TextOverflow.visible,
                  decorationColor: Colors.amber,
                ),
              ),
              hintText: 'Search by College/Subject/Year/Stream',
              backgroundColor: const WidgetStatePropertyAll(
                Color.fromARGB(255, 190, 216, 237),
              ),
            ),
            const SizedBox(height: 36),
            Expanded(
                child: !isloading
                    ? searchDatabase.isEmpty
                        ? const Center(
                            child: Text(
                              'No results found.',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : widget.isquestionpaper
                            ? ListView.builder(
                                itemCount: searchDatabase.length,
                                itemBuilder: (context, index) {
                                  final doc = searchDatabase[index].data() as Map<String, dynamic>;
                                  return CustomListTile(
                                    isQuestionpaper: true,
                                    isVerified: doc["Verified"],
                                    id: searchDatabase[index].id,
                                    collegeName: doc['CollegeName'],
                                    subjectName: doc['SubjectName'],
                                    userName: doc['UserId'],
                                    votes: doc['Votes'],
                                    year: doc['Year'],
                                    sem: doc['semester'],
                                    branch: doc['BranchName'],
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: searchDatabase.length,
                                itemBuilder: (context, index) {
                                  final doc = searchDatabase[index].data() as Map<String, dynamic>;
                                  return Column(
                                    children: [
                                      CustomListTile(
                                        sem: doc['semester'],
                                        branch: doc['BranchName'],
                                        isQuestionpaper: false,
                                        isVerified: doc["Verified"],
                                        id: searchDatabase[index].id,
                                        collegeName: doc['CollegeName'],
                                        subjectName: doc['SubjectName'],
                                        userName: doc['UserId'],
                                        votes: doc['Votes'],
                                        year: doc['TopicName'],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  );
                                },
                              )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
