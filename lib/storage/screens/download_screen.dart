import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadScreen extends StatelessWidget {
  final String downloadUrl;

  DownloadScreen({required this.downloadUrl});

  Future<void> _downloadImage(BuildContext context) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    final dir = await getExternalStorageDirectory();
    final filePath = "${dir!.path}/mascot.jpg";

    try {
      await Dio().download(downloadUrl, filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mascot downloaded to gallery!')),
      );
    } catch (e) {
      print('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mascot Uploaded')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Download URL:"),
            SelectableText(downloadUrl),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _downloadImage(context),
              icon: Icon(Icons.download),
              label: Text("Download Mascot Photo"),
            ),
          ],
        ),
      ),
    );
  }
}
