import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teenfit/Custom/custom_dialog.dart';

class WorkoutImagePicker extends StatefulWidget {
  final String? imageLink;

  WorkoutImagePicker(this.imagePickFn, this.imageLink);

  final void Function(
    File? pickedImage,
  ) imagePickFn;

  @override
  _WorkoutImagePickerState createState() => _WorkoutImagePickerState();
}

class _WorkoutImagePickerState extends State<WorkoutImagePicker> {
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
                  var status = await Permission.photos.status;

                  if (status.isDenied) {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialogBox(
                        'Denied Access',
                        'Unable to access photo Library please Allow Access in Settings',
                        'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                        'photo-access',
                        {},
                      ),
                    );
                  } else {
                    await _pickImage()
                        .then((_) => widget.imagePickFn(_pickedImage));
                  }
                },
              ),
            ),
            Container(
              height: _mediaQuery.size.height * 0.06,
              child: TextButton.icon(
                onPressed: () async {
                  var status = await Permission.photos.status;

                  if (status.isDenied) {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialogBox(
                        'Denied Access',
                        'Unable to access photo Library please Allow Access in Settings',
                        'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                        'photo-access',
                        {},
                      ),
                    );
                  } else {
                    await _pickImage()
                        .then((_) => widget.imagePickFn(_pickedImage));
                  }
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
