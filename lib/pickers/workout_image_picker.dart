import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkoutImagePicker extends StatefulWidget {
  const WorkoutImagePicker({Key? key}) : super(key: key);

  @override
  _WorkoutImagePickerState createState() => _WorkoutImagePickerState();
}

class _WorkoutImagePickerState extends State<WorkoutImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImageFile as File?;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: _mediaQuery.size.height * 0.28,
        width: _mediaQuery.size.width,
        child: InkWell(
          child: _pickedImage == null ? Image.asset(
            'assets/images/UploadImage.png',
            fit: BoxFit.contain,
          ) : FileImage(_pickedImage!) as Widget,
          onTap: () {
            _pickImage();
          },
        ),
      ),
    );
  }
}
