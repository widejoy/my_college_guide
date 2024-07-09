import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Viewpdf extends StatelessWidget {
  final String id;

  const Viewpdf({Key? key, required this.id}) : super(key: key);

  Future<String> _getPdfUrl() async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('$id.pdf');
    
    final String downloadURL = await storageReference.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: FutureBuilder<String>(
        future: _getPdfUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('PDF URL not found'),
            );
          } else {
            return const PDF(
              fitPolicy: FitPolicy.BOTH,
              fitEachPage: true,
              autoSpacing: true,
              enableSwipe: true,
            ).cachedFromUrl(snapshot.data!);
          }
        },
      ),
    );
  }
}
