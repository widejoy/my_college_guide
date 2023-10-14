import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_tile.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreen();
}

class _NotesScreen extends State<NotesScreen> {
  var searchDatabase = [];
  TextEditingController search = TextEditingController();
  var id = " ";
  bool isloading = false;

  Future<List<DocumentSnapshot>> performFuzzySearch(String searchText) async {
    setState(() {
      isloading = true;
    });

    final querySnapshot =
        await FirebaseFirestore.instance.collection('Notes').get();

    final searchResults = querySnapshot.docs.where((doc) {
      final List<String> keywords = List<String>.from(doc["Keywords"] ?? []);
      id = doc.id;

      final lowercaseSearchText = searchText.toLowerCase();

      double totalScore = 0.0;

      for (String keyword in keywords) {
        final lowercaseKeyword = keyword.toLowerCase();

        final result = extractOne(
          query: lowercaseSearchText,
          choices: [lowercaseKeyword],
        );

        final score = result.score;
        final votes = doc['Votes'] ?? 0;

        final double weightedScore = score + (votes * 0.1) as double;
        totalScore = weightedScore;

        if (totalScore >= 0.5) {
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
      appBar: const CustomAppBar(
        title: 'Notes',
      ),
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
              elevation: const MaterialStatePropertyAll(12),
              hintStyle: const MaterialStatePropertyAll(
                TextStyle(
                  overflow: TextOverflow.visible,
                  decorationColor: Colors.amber,
                ),
              ),
              hintText: 'Search by College/Subject/Topic/Stream',
              backgroundColor: const MaterialStatePropertyAll(
                Color.fromARGB(255, 190, 216, 237),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: !isloading
                    ? searchDatabase.isEmpty
                        ? const Center(
                            child: Text(
                              'No results found.',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: searchDatabase.length,
                            itemBuilder: (context, index) {
                              final doc = searchDatabase[index].data();
                              return Column(
                                children: [
                                  CustomListTile(
                                    isQuestionpaper: false,
                                    isVerified: doc["Verified"],
                                    id: id,
                                    collegeName: doc['CollegeName'],
                                    subjectName: doc['SubjectName'],
                                    userName: doc['UserId'],
                                    votes: doc['Votes'],
                                    year: doc['TopicName'],
                                    stream: doc['Stream'],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  )
                                ],
                              );
                            },
                          )
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )),
          ],
        ),
      ),
    );
  }
}
