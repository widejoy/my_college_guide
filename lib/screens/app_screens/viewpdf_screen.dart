import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class Viewpdf extends StatelessWidget {
  const Viewpdf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: const PDF(
        fitPolicy: FitPolicy.BOTH,
        fitEachPage: true,
        autoSpacing: true,
        enableSwipe: true, // Enable swipe gestures
      ).cachedFromUrl(
          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
    );
  }
}
