import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_tile.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class PreviousYearScreen extends StatefulWidget {
  const PreviousYearScreen({super.key});

  @override
  State<PreviousYearScreen> createState() => _PreviousYearScreenState();
}

class _PreviousYearScreenState extends State<PreviousYearScreen> {
  String? selectedCollege;
  bool collegeDropdownEnabled = true;
  var searchDatabase = [];
  TextEditingController search = TextEditingController();
  var id = " ";

  String _truncateFileName(String fileName) {
    const maxFileNameLength = 35;
    if (fileName.length <= maxFileNameLength) {
      return fileName;
    } else {
      return '${fileName.substring(0, maxFileNameLength - 3)}...';
    }
  }

  Future<List<DocumentSnapshot>> performFuzzySearch(String searchText) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Question Papers').get();

    final searchResults = querySnapshot.docs.where((doc) {
      final List<String> keywords = List<String>.from(doc["Keywords"] ?? []);
      id = doc.id;
      final result = extractOne(
        query: searchText,
        choices: keywords,
        cutoff: 10,
      );
      if (result.score >= 95) {
        return true;
      }
      return false;
    }).toList();

    searchResults.sort(
      (a, b) => b['Votes'].compareTo(
        a['Votes'],
      ),
    );

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
        title: 'Previous Year Question Papers',
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
              hintText: 'Search by College/Subject/Year/Stream',
              backgroundColor: const MaterialStatePropertyAll(
                Color.fromARGB(255, 190, 216, 237),
              ),
            ),
            const SizedBox(height: 36),
            Expanded(
              child: searchDatabase.isEmpty
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
                        return CustomListTile(
                          isQuestionpaper: true,
                          isVerified: doc["Verified"],
                          id: id,
                          collegeName: doc['College Name'],
                          subjectName: doc['Subject Name'],
                          userName: doc['User Id'],
                          votes: doc['Votes'],
                          year: doc['Year'],
                          stream: doc['Stream'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
