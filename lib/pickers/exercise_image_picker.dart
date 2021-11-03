import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExerciseImagePicker extends StatefulWidget {
  ExerciseImagePicker(this.imagePickFn);

  final Function(XFile pickedImage) imagePickFn;

  @override
  _ExerciseImagePickerState createState() => _ExerciseImagePickerState();
}

class _ExerciseImagePickerState extends State<ExerciseImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
        
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(XFile(_pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: _mediaQuery.size.height * 0.28,
        width: _mediaQuery.size.width,
        child: InkWell(
          child: _pickedImage == null
              ? Image.asset(
                  'assets/images/UploadImage.png',
                  fit: BoxFit.contain,
                )
              : Image.file(
                  File(_pickedImage!.path),
                  fit: BoxFit.contain,
                ),
          onTap: () {
            _pickImage();
          },
        ),
      ),
    );
  }
}
