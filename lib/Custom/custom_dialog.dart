import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_review/in_app_review.dart';
import 'constants.dart';
import 'package:provider/provider.dart';

import '../screens/workout_page.dart';
import '../providers/workouts.dart';

class CustomDialogBox extends StatefulWidget {
  final String title;
  final String description;
  final String img;
  final String dialogOrganizerId;
  final arguments;

  const CustomDialogBox(this.title, this.description, this.img,
      this.dialogOrganizerId, this.arguments);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  bool isLoading = false;
  final InAppReview inAppReview = InAppReview.instance;

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: isLoading
                      ? [
                          Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              backgroundColor: theme.shadowColor,
                              color: Colors.white,
                            ),
                          )
                        ]
                      : [
                          widget.dialogOrganizerId == 'photo-access'
                              ? SizedBox()
                              : TextButton(
                                  onPressed: () async {
                                    if (widget.dialogOrganizerId ==
                                        '/workout-page') {
                                      Navigator.of(context).popUntil(
                                          ModalRoute.withName(
                                              widget.dialogOrganizerId));

                                      if (await inAppReview.isAvailable()) {
                                        inAppReview.requestReview();
                                      }
                                    } else if (widget.dialogOrganizerId ==
                                        '/workout-page-first') {
                                      Navigator.of(context).popUntil(
                                          ModalRoute.withName(
                                              WorkoutPage.routeName));

                                      if (await inAppReview.isAvailable()) {
                                        inAppReview.requestReview();
                                      }
                                    } else if (widget.dialogOrganizerId ==
                                        'pop') {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await Provider.of<Workouts>(context,
                                                listen: false)
                                            .deleteWorkout(widget.arguments)
                                            .then((_) => Navigator.of(context)
                                                .popUntil(ModalRoute.withName(
                                                    WorkoutPage.routeName)));
                                      } catch (e) {
                                        _showToast(
                                            'Unable To Delete Workout Try Again Later');
                                      }
                                      if (this.mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    } else if (widget.dialogOrganizerId ==
                                        'delete-exercise') {
                                      Function delete =
                                          widget.arguments['delete'];
                                      String id = widget.arguments['id'];

                                      delete(id);
                                    } else if (widget.dialogOrganizerId ==
                                        'contact-us') {
                                      Navigator.of(context).pop();
                                    } else if (widget.dialogOrganizerId ==
                                        'pending') {
                                      Function submit = widget.arguments;
                                      submit();
                                      Navigator.of(context).pop();
                                    } else if (widget.dialogOrganizerId ==
                                        'accept-workout') {
                                      await Provider.of<Workouts>(context,
                                              listen: false)
                                          .acceptWorkout(widget.arguments);
                                      Navigator.of(context).pop();
                                    } else if (widget.dialogOrganizerId ==
                                        'fail-workout') {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await Provider.of<Workouts>(context,
                                                listen: false)
                                            .failWorkout(widget.arguments)
                                            .then((_) =>
                                                Navigator.of(context).pop());
                                      } catch (e) {
                                        _showToast(
                                            'Unable To Delete Workout Try Again Later');
                                      }
                                      if (this.mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    widget.dialogOrganizerId == 'contact-us'
                                        ? 'Back'
                                        : 'Yes',
                                    style: TextStyle(
                                        fontSize: 23, color: Colors.black),
                                  ),
                                ),
                          widget.dialogOrganizerId == 'contact-us'
                              ? SizedBox()
                              : TextButton(
                                  onPressed: () {
                                    if (widget.dialogOrganizerId ==
                                        '/workout-page-first') {
                                      Function goToFirst =
                                          widget.arguments['page1'];
                                      goToFirst();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    widget.dialogOrganizerId == 'photo-access'
                                        ? 'Okay'
                                        : 'No',
                                    style: TextStyle(
                                        fontSize: 23, color: Colors.black),
                                  ),
                                ),
                        ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset(widget.img)),
          ),
        ),
      ],
    );
  }
}
