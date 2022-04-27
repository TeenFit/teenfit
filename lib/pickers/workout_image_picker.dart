import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:teenfit/Custom/custom_dialog.dart';

class WorkoutImagePicker extends StatefulWidget {
  final String? imageLink;
  final File? imageFile;
  final Function imagePickFn;

  WorkoutImagePicker(this.imagePickFn, this.imageLink, this.imageFile);

  @override
  _WorkoutImagePickerState createState() => _WorkoutImagePickerState();
}

class _WorkoutImagePickerState extends State<WorkoutImagePicker> {
  File? _pickedImage;
  bool isLoading = false;

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 10,
      webShowClose: true,
      textColor: Colors.white,
      backgroundColor: Colors.grey.shade700,
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(
      allowMultiple: false,
      type: FileType.image,
      allowCompression: true,
    )
        .catchError(
      (e) async {
        var status = await Permission.photos.isDenied;

        if (status) {
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
          _showToast('Unable To Pick Image');
        }
      },
    );

    if (result != null) {
      if (this.mounted) {
        var croppedImage = await ImageCropper().cropImage(
          sourcePath: result.files.single.path!,
          compressQuality: 80,
          aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
          compressFormat: ImageCompressFormat.png,
          iosUiSettings: IOSUiSettings(
            resetAspectRatioEnabled: true,
            cancelButtonTitle: 'cancel',
            doneButtonTitle: 'done',
            resetButtonHidden: false,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            showCancelConfirmationDialog: true,
            title: 'Crop Your Image',
          ),
        );

        var image = await FlutterNativeImage.compressImage(
          croppedImage!.path,
          quality: 40,
          percentage: 100,
        );

        setState(() {
          _pickedImage = image;
          isLoading = false;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          _pickedImage = _pickedImage;
          isLoading = false;
        });
      }
    }
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
              child: isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 4,
                      backgroundColor: _theme.shadowColor,
                      color: Colors.white,
                    )
                  : InkWell(
                      child: _pickedImage == null
                          ? widget.imageLink == null
                              ? Image.asset(
                                  'assets/images/UploadImage.png',
                                  fit: BoxFit.contain,
                                )
                              : FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/loading-gif.gif'),
                                  placeholderErrorBuilder: (context, _, __) =>
                                      Image.asset(
                                        'assets/images/loading-gif.gif',
                                        fit: BoxFit.contain,
                                      ),
                                  fit: BoxFit.cover,
                                  //change
                                  image: CachedNetworkImageProvider(
                                      widget.imageLink!),
                                  imageErrorBuilder: (image, _, __) =>
                                      Image.asset(
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
                        await _pickImage();
                        await widget.imagePickFn(_pickedImage);
                      },
                    ),
            ),
            Container(
              height: _mediaQuery.size.height * 0.06,
              child: TextButton.icon(
                onPressed: isLoading == true
                    ? () {}
                    : () async {
                        await _pickImage();
                        await widget.imagePickFn(_pickedImage);
                      },
                icon: Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                label: Text(
                  'Add Image',
                  style: TextStyle(
                      color: Colors.black,
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
