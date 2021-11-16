import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExerciseImagePicker extends StatefulWidget {
  final String? imageLink;

  ExerciseImagePicker(this.imagePickFn, this.imageLink);

  final void Function(
    File? pickedImage,
  ) imagePickFn;

  @override
  _ExerciseImagePickerState createState() => _ExerciseImagePickerState();
}

class _ExerciseImagePickerState extends State<ExerciseImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxHeight: 600,
      maxWidth: 337.50,
    );

    setState(() {
      _pickedImage =
          pickedImageFile == null ? null : File(pickedImageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: _mediaQuery.size.height * 0.35,
        width: _mediaQuery.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: _mediaQuery.size.height * 0.28,
              width: _mediaQuery.size.width,
              child: InkWell(
                child: _pickedImage == null
                    ? widget.imageLink == null
                        ? Image.asset(
                            'assets/images/UploadImage.png',
                            fit: BoxFit.contain,
                          )
                        : FadeInImage(
                            placeholder:
                                AssetImage('assets/images/loading-gif.gif'),
                            placeholderErrorBuilder: (context, _, __) =>
                                Image.asset(
                                  'assets/images/loading-gif.gif',
                                  fit: BoxFit.contain,
                                ),
                            fit: BoxFit.cover,
                            //change
                            image: NetworkImage(widget.imageLink!),
                            imageErrorBuilder: (image, _, __) => Image.asset(
                                  'assets/images/ImageUploadError.png',
                                  fit: BoxFit.contain,
                                ))
                    : FadeInImage(
                        placeholder:
                            AssetImage('assets/images/loading-gif.gif'),
                        placeholderErrorBuilder: (context, _, __) =>
                            Image.asset(
                          'assets/images/loading-gif.gif',
                          fit: BoxFit.contain,
                        ),
                        fit: BoxFit.cover,
                        //change
                        image: FileImage(_pickedImage!),
                        imageErrorBuilder: (image, _, __) => Image.asset(
                          'assets/images/ImageUploadError.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                onTap: () async {
                  await _pickImage()
                      .then((_) => widget.imagePickFn(_pickedImage));
                },
              ),
            ),
            Container(
              height: _mediaQuery.size.height * 0.06,
              child: TextButton.icon(
                onPressed: () async {
                  await _pickImage()
                      .then((_) => widget.imagePickFn(_pickedImage));
                },
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: Text(
                  'Add Image',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _mediaQuery.size.height * 0.025),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
