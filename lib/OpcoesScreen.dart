import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import "package:gallery_saver/gallery_saver.dart";
import 'package:path/path.dart' as path;

class CameraGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraGalleryScreen(),
    );
  }
}

class CameraGalleryScreen extends StatefulWidget {
  @override
  _CameraGalleryScreenState createState() => _CameraGalleryScreenState();
}

class _CameraGalleryScreenState extends State<CameraGalleryScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _takePicture() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final Directory? appDir = await getExternalStorageDirectory();
        if (appDir != null) {
          final String appPath = appDir.path;
          final String fileName = path.basename(pickedFile.path);
          final File localImage = await File(pickedFile.path).copy('$appPath/$fileName');

          setState(() {
            _image = localImage;
          });

          // Salvar na galeria
          await GallerySaver.saveImage(localImage.path);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Picture saved to gallery')),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take picture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Gallery App'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image taken.')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        tooltip: 'Take Picture',
        child: Icon(Icons.camera),
      ),
    );
  }
}