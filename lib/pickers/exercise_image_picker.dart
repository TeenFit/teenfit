import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teenfit/Custom/custom_dialog.dart';
import 'package:teenfit/widgets/video_player.dart';

class ExerciseImagePicker extends StatefulWidget {
  final String? imageLink;
  final File? imageFile;
  final Function pickFn;

  ExerciseImagePicker(this.pickFn, this.imageLink, this.imageFile);

  @override
  _ExerciseImagePickerState createState() => _ExerciseImagePickerState();
}

class _ExerciseImagePickerState extends State<ExerciseImagePicker> {
  File? _pickedImage;
  File? _pickedVideo;
  bool isLoading = false;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInit == false) {
      if (widget.imageFile != null) {
        setState(() {
          _pickedImage = widget.imageFile;
        });
      }

      if (this.mounted) {
        setState(() {
          isInit = true;
        });
      }
    }
  }

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
        setState(() {
          _pickedImage = File(result.files.single.path!);
          isLoading = false;
          _pickedVideo = null;
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

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(
      allowMultiple: false,
      type: FileType.video,
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
          _showToast('Video Must Be Shorter Than 5 Seconds');
        }
      },
    );

    if (result != null) {
      if (this.mounted) {
        setState(() {
          _pickedVideo = File(result.files.single.path!);
          isLoading = false;
          _pickedImage = null;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          _pickedVideo = _pickedVideo;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    Future showModal() {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: _mediaQuery.size.height * 0.2,
              color: Color(0xff73737),
              child: Container(
                decoration: BoxDecoration(
                    color: _theme.canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.camera_alt,
                        size: _mediaQuery.size.height * 0.04,
                      ),
                      title: Text(
                        'Pick a Photo',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: _mediaQuery.size.height * 0.025,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: isLoading == true
                          ? () {}
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              await _pickImage();
                              Navigator.of(context).pop();
                              await widget.pickFn(_pickedImage, _pickedVideo);
                              if (this.mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.play_arrow_rounded,
                        size: _mediaQuery.size.height * 0.04,
                      ),
                      title: Text(
                        'Pick A Video < 5 seconds',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: _mediaQuery.size.height * 0.025,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: isLoading == true
                          ? () {}
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              await _pickVideo();
                              Navigator.of(context).pop();
                              await widget.pickFn(_pickedImage, _pickedVideo);

                              if (this.mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    ),
                  ],
                ),
              ),
            );
          });
    }

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
                          ? _pickedVideo == null
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
                                      image: CachedNetworkImageProvider(
                                          widget.imageLink!),
                                      imageErrorBuilder: (image, _, __) =>
                                          Image.asset(
                                            'assets/images/ImageUploadError.png',
                                            fit: BoxFit.contain,
                                          ))
                              : VideoPlayerWidget(
                                  videofile: _pickedVideo,
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
                              image: FileImage(_pickedImage!),
                              imageErrorBuilder: (image, _, __) => Image.asset(
                                'assets/images/ImageUploadError.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                      onTap: () async {
                        await showModal();
                      }),
            ),
            Container(
              height: _mediaQuery.size.height * 0.06,
              child: TextButton.icon(
                onPressed: () async {
                  await showModal();
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
