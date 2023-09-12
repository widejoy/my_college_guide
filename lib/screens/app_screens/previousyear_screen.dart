import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_tile.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';

class PreviousYearScreen extends StatefulWidget {
  const PreviousYearScreen({super.key});

  @override
  State<PreviousYearScreen> createState() => _PreviousYearScreenState();
}

class _PreviousYearScreenState extends State<PreviousYearScreen> {
  String? selectedCollege;
  bool isselected(String txt) {
    if (txt == 'Select College') {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerCustom(),
      appBar: const CustomAppBar(
        title: 'Previous Year Question Papers',
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          const SearchBar(
            elevation: MaterialStatePropertyAll(12),
            hintStyle: MaterialStatePropertyAll(
              TextStyle(
                overflow: TextOverflow.visible,
                decorationColor: Colors.amber,
              ),
            ),
            hintText: 'College name/subject name/year',
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 190, 216, 237),
            ),
          ),
          DropdownButton<String>(
            hint: const Text('Select College'),
            value: selectedCollege,
            onChanged: (newValue) {
              setState(() {
                selectedCollege = newValue;
              });
            },
            items: const [
              DropdownMenuItem(
                enabled: false,
                value: '',
                child: Text(
                  'Select College',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              DropdownMenuItem(
                value: 'College1',
                child: Text('College 1'),
              ),
              DropdownMenuItem(
                value: 'College2',
                child: Text('College 2'),
              ),
              DropdownMenuItem(
                value: 'College3',
                child: Text('College 3'),
              ),
            ],
          ),
          const CustomListTile(
            collegeName: "CUSAT - Cochin University Of Science And Technology",
            subjectName: "dsa",
            userName: "rogerantony",
            votes: 2,
            year: 2012,
            stream: "btech cs",
          )
        ],
      ),
    );
  }
}
