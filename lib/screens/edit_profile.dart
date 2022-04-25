import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/pickers/circle_image_picker.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/providers/userProv.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/editProfile';

  @override
  State<EditProfile> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfile> {
  final _formKey11 = GlobalKey<FormState>();
  User? user;
  bool _isLoading = false;
  bool isInit = false;

  @override
  void didChangeDependencies() async {
    if (isInit == false) {
      user = ModalRoute.of(context)!.settings.arguments as User;
      setState(() {
        isInit = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    void _pickImage(File? image) {
      setState(() {
        user = User(
          email: user!.email,
          name: user!.name,
          uid: user!.uid,
          date: user!.date,
          bio: user!.bio,
          profilePicFile: image,
          profilePic: user!.profilePic,
          followers: user!.followers,
          following: user!.following,
          searchTerms: user!.searchTerms,
          link: user!.link,
          tiktok: user!.tiktok,
          instagram: user!.instagram,
        );
      });
    }

    void _removeImage() {
      setState(() {
        user = User(
          email: user!.email,
          name: user!.name,
          uid: user!.uid,
          date: user!.date,
          bio: user!.bio,
          profilePicFile: null,
          profilePic: null,
          followers: user!.followers,
          following: user!.following,
          searchTerms: user!.searchTerms,
          link: user!.link,
          tiktok: user!.tiktok,
          instagram: user!.instagram,
        );
      });
    }

    void _showToast(String msg) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: msg,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        webShowClose: true,
        textColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
      );
    }

    Future<void> _submit() async {
      if (!_formKey11.currentState!.validate()) {
        _showToast('Failed Fields');
        return;
      }

      _formKey11.currentState!.save();

      user = User(
        email: user!.email,
        name: user!.name,
        uid: user!.uid,
        date: user!.date,
        bio: user!.bio,
        profilePicFile: user!.profilePicFile,
        profilePic: user!.profilePic,
        followers: user!.followers,
        following: user!.following,
        searchTerms: user!.searchTerms,
        link: user!.link,
        tiktok: user!.tiktok,
        instagram: user!.instagram,
      );

      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<UserProv>(context, listen: false)
            .updateUser(user, context);
        Navigator.pop(context, true);
      } catch (e) {
        _showToast('Unable To Add Workout Try Again Later');
      }

      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    Widget buildName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: user!.name,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return 'Name is Required';
              } else if (value.toString().trim().length > 30) {
                return 'Stay Under 30 Characters';
              } else if (value.toString().trim().contains(RegExp(r'[A-Z]'))) {
                return 'No Uppercase Letters';
              } else if (value.toString().trim().contains('-')) {
                return 'No dashes';
              } else if (value.toString().trim().contains(' ')) {
                return 'No Spaces';
              }
              // } else if (true) {
              //   return 'This Name Already Exists!';
              // }
              return null;
            },
            onSaved: (input) {
              user = User(
                email: user!.email,
                name: input.toString().trim(),
                uid: user!.uid,
                date: user!.date,
                bio: user!.bio,
                profilePicFile: user!.profilePicFile,
                profilePic: user!.profilePic,
                followers: user!.followers,
                following: user!.following,
                searchTerms: user!.searchTerms,
                link: user!.link,
                tiktok: user!.tiktok,
                instagram: user!.instagram,
              );
            },
          ),
        ),
      );
    }

    Widget buildInstagram() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: user!.instagram,
            decoration: InputDecoration(
              labelText: 'Instagram Profile Link',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return null;
              } else if (!value.toString().trim().contains('http') ||
                  !value.toString().trim().contains('https')) {
                return 'put a Link';
              }
              return null;
            },
            onSaved: (input) {
              user = User(
                email: user!.email,
                name: user!.name,
                uid: user!.uid,
                date: user!.date,
                bio: user!.bio,
                profilePicFile: user!.profilePicFile,
                profilePic: user!.profilePic,
                followers: user!.followers,
                following: user!.following,
                searchTerms: user!.searchTerms,
                link: user!.link,
                tiktok: user!.tiktok,
                instagram: input.toString().trim().isEmpty
                    ? null
                    : input.toString().trim(),
              );
            },
          ),
        ),
      );
    }

    Widget buildTikTok() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: user!.tiktok,
            decoration: InputDecoration(
              labelText: 'TikTok Profile Link',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return null;
              } else if (!value.toString().trim().contains('http') ||
                  !value.toString().trim().contains('https')) {
                return 'put a Link';
              }
              return null;
            },
            onSaved: (input) {
              user = User(
                email: user!.email,
                name: user!.name,
                uid: user!.uid,
                date: user!.date,
                bio: user!.bio,
                profilePicFile: user!.profilePicFile,
                profilePic: user!.profilePic,
                followers: user!.followers,
                following: user!.following,
                searchTerms: user!.searchTerms,
                link: user!.link,
                tiktok: input.toString().trim().isEmpty
                    ? null
                    : input.toString().trim(),
                instagram: user!.instagram,
              );
            },
          ),
        ),
      );
    }

    Widget buildBio() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.2,
          width: _mediaQuery.size.width,
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            initialValue: user!.bio,
            decoration: InputDecoration(
              labelText: 'Bio...',
              labelStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().length > 180) {
                return 'Stay Under 180 Characters';
              }
              return null;
            },
            onSaved: (input) {
              user = User(
                email: user!.email,
                name: user!.name,
                uid: user!.uid,
                date: user!.date,
                bio: input.toString().trim(),
                profilePicFile: user!.profilePicFile,
                profilePic: user!.profilePic,
                followers: user!.followers,
                following: user!.following,
                searchTerms: user!.searchTerms,
                link: user!.link,
                tiktok: user!.tiktok,
                instagram: user!.instagram,
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Edit Profile',
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
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
          key: _formKey11,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                ),
                CircleImagePicker(_pickImage, user!.profilePic,
                    user!.profilePicFile, _removeImage),
                buildName(),
                buildBio(),
                buildInstagram(),
                buildTikTok(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: _mediaQuery.size.width,
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _theme.secondaryHeaderColor,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              strokeWidth: 4,
                              backgroundColor: _theme.shadowColor,
                              color: Colors.white,
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w900,
                                fontSize: _mediaQuery.size.height * 0.03,
                              ),
                            ),
                      onPressed: _isLoading == true
                          ? () {}
                          : () {
                              _submit();
                            },
                    ),
                  ),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
