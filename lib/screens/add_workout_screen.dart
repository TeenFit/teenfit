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

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    String imageUrl = '';

    Workout? workout = ModalRoute.of(context)?.settings.arguments as Workout?;

    Future<void> _submit() async {
      if (!_formKey3.currentState!.validate()) {
        return;
      }

      _formKey3.currentState!.save();
      print(_imageUrlController.text);

      Navigator.of(context).pop();
    }

    Widget buildAddImage() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.25,
          width: _mediaQuery.size.width,
          child: Row(
            children: [
              Container(
                height: _mediaQuery.size.height * 0.25,
                width: _mediaQuery.size.height * 0.25,
                child: _imageUrlController.text.isEmpty
                    ? Image.asset('assets/images/UploadImage.png')
                    : FadeInImage(
                        image: AssetImage(_imageUrlController.text),
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
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    labelStyle:
                        TextStyle(fontSize: _mediaQuery.size.height * 0.03),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey3,
            child: Column(
              children: [
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.05,
                ),
                buildAddImage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
