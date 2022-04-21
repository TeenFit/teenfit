import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:teenfit/Custom/custom_dialog.dart';

class CircleImagePicker extends StatefulWidget {
  final String? imageLink;
  final File? imageFile;
  final Function imagePickFn;
  final Function removeImage;

  CircleImagePicker(
      this.imagePickFn, this.imageLink, this.imageFile, this.removeImage);

  @override
  _CircleImagePickerState createState() => _CircleImagePickerState();
}

class _CircleImagePickerState extends State<CircleImagePicker> {
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
        var image = await ImageCropper().cropImage(
          sourcePath: result.files.single.path!,
          compressQuality: 70,
          cropStyle: CropStyle.circle,
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
        height: _mediaQuery.size.height * 0.4,
        width: _mediaQuery.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: _mediaQuery.size.height * 0.035,
              child: Text(
                'Optional*',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: _mediaQuery.size.height * 0.02),
              ),
            ),
            Container(
              height: _mediaQuery.size.height * 0.28,
              width: _mediaQuery.size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  isLoading
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
                                      placeholderErrorBuilder:
                                          (context, _, __) => Image.asset(
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
                                  placeholder: AssetImage(
                                      'assets/images/loading-gif.gif'),
                                  placeholderErrorBuilder: (context, _, __) =>
                                      Image.asset(
                                    'assets/images/loading-gif.gif',
                                    fit: BoxFit.contain,
                                  ),
                                  fit: BoxFit.cover,
                                  //change
                                  image: FileImage(_pickedImage!),
                                  imageErrorBuilder: (image, _, __) =>
                                      Image.asset(
                                    'assets/images/ImageUploadError.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          onTap: () async {
                            await _pickImage();
                            await widget.imagePickFn(_pickedImage);
                          },
                        ),
                  _pickedImage != null || widget.imageLink != null
                      ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            color: Color.fromARGB(255, 223, 93, 84),
                            onPressed: () {
                              widget.removeImage();

                              setState(() {
                                _pickedImage = null;
                              });
                            },
                            iconSize: _mediaQuery.size.height * 0.04,
                            splashRadius: _mediaQuery.size.height * 0.02,
                          ),
                        )
                      : SizedBox()
                ],
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
