import 'package:flutter/material.dart';

import '../providers/workout.dart';

class AddWorkoutScreen extends StatefulWidget {
  static const routeName = '/add-workout-screen';

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey3 = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    String imageUrl = '';
    String workoutName = '';
    String creatorName = '';
    String instagramLink = '';
    String tumblrLink = '';
    String facebookLink = '';

    Workout? workout = ModalRoute.of(context)?.settings.arguments as Workout?;

    Future<void> _submit() async {
      if (!_formKey3.currentState!.validate()) {
        return;
      }

      _formKey3.currentState!.save();
      print(imageUrl);

      Navigator.of(context).pop();
    }

    Widget buildAddImage() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.4,
          width: _mediaQuery.size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: _mediaQuery.size.height * 0.28,
                width: _mediaQuery.size.width,
                child: _imageUrlController.text.isEmpty
                    ? Image.asset('assets/images/UploadImage.png')
                    : FadeInImage(
                        image: AssetImage(_imageUrlController.text),
                        placeholderErrorBuilder: (context, _, __) =>
                            Image.asset('assets/images/loading-gif.gif'),
                        imageErrorBuilder: (context, image, stackTrace) =>
                            Image.asset('assets/images/ImageUploadError.png'),
                        placeholder:
                            AssetImage('assets/images/loading-gif.gif'),
                        fit: BoxFit.contain,
                      ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    labelStyle:
                        TextStyle(fontSize: _mediaQuery.size.height * 0.02),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'URL is Required';
                    } else if (value.toString().contains(' ')) {
                      return 'Please Remove Spaces';
                    }
                    return null;
                  },
                  onSaved: (input) {
                    imageUrl = input.toString();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildCreatorName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Creator Name',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'Name is Required';
              }
              return null;
            },
            onSaved: (input) {
              creatorName = input.toString();
            },
          ),
        ),
      );
    }

    Widget buildWorkoutName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Workout Name',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'Name is Required';
              }
              return null;
            },
            onSaved: (input) {
              workoutName = input.toString();
            },
          ),
        ),
      );
    }

    Widget buildInstagramLink() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Optional',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
              labelText: 'Instagram Link',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              } else if (Uri.parse(value.toString()).isAbsolute) {
                return 'Not a Valid Link';
              }
              return null;
            },
            onSaved: (input) {
              instagramLink = input.toString();
            },
          ),
        ),
      );
    }

    Widget buildTumblrLink() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Optional',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
              labelText: 'Tumblr Link',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              } else if (Uri.parse(value.toString()).isAbsolute) {
                return 'Not a Valid Link';
              }
              return null;
            },
            onSaved: (input) {
              tumblrLink = input.toString();
            },
          ),
        ),
      );
    }

    Widget buildFacebookLink() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Optional',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
              labelText: 'Facebook Link',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              } else if (Uri.parse(value.toString()).isAbsolute) {
                return 'Not a Valid Link';
              }
              return null;
            },
            onSaved: (input) {
              facebookLink = input.toString();
            },
          ),
        ),
      );
    }

    //add exercises button

    return Scaffold(
      backgroundColor: _theme.highlightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          workout == null ? 'Add A Workout' : 'Edit Your Workout',
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: _mediaQuery.size.height * 0.03,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        height: _mediaQuery.size.height - _appBarHeight,
        width: _mediaQuery.size.width,
        child: Form(
          key: _formKey3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                ),
                buildAddImage(),
                buildCreatorName(),
                buildWorkoutName(),
                buildInstagramLink(),
                buildTumblrLink(),
                buildFacebookLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
