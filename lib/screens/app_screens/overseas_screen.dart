import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';
import 'package:url_launcher/url_launcher.dart';

class OverseasScreen extends StatefulWidget {
  const OverseasScreen({super.key});

  @override
  State<OverseasScreen> createState() => _OverseasScreenState();
}

class _OverseasScreenState extends State<OverseasScreen> {
  bool isloading = false;
  List<Map<String, dynamic>> listdata = [];

  Future<void> getdata() async {
    setState(() {
      isloading = true;
    });

    final querySnapshot =
        await FirebaseFirestore.instance.collection('Notification').get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      listdata.add(data);
    }
    print(listdata);
    isloading = false;
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Overseas Help'),
      drawer: const DrawerCustom(),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listdata.length,
              itemBuilder: (context, index) {
                final item = listdata[index];
                return GestureDetector(
                  onTap: () {
                    _launchURL(Uri.parse(item['link']));
                  },
                  child: ListTile(
                    title: Text(item['data']),
                    subtitle: Text(item['link']),
                    tileColor: const Color.fromARGB(255, 253, 241, 255),
                  ),
                );
              },
            ),
    );
  }

  _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
