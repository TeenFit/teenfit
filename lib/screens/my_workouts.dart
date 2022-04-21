import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/providers/userProv.dart';
import 'package:teenfit/screens/edit_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../Custom/my_flutter_app_icons.dart';
import '/providers/workout.dart';
import 'create_workout.dart';
import '/widgets/workout_tile.dart';

class CreateWorkout extends StatefulWidget {
  @override
  State<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  String? uid;
  bool isInit = false;
  var queryWorkout;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (isInit == false) {
      uid = Provider.of<Auth>(context, listen: false).userId!;

      setState(() {
        queryWorkout = FirebaseFirestore.instance
            .collection('/workouts')
            // .where('creatorId', isEqualTo: uid)
            .orderBy('date', descending: true)
            .withConverter<Workout>(
                fromFirestore: (snapshot, _) =>
                    Workout.fromJson(snapshot.data()!),
                toFirestore: (worKout, _) => worKout.toJson());
      });

      setState(() {
        isInit = true;
      });
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

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    var uuid = Uuid();

    User user = Provider.of<UserProv>(context, listen: false).getUser;

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_mediaQuery.size.height * 0.07),
        child: AppBar(
          elevation: 5,
          title: isInit == false
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    backgroundColor: _theme.shadowColor,
                    color: Colors.white,
                  ),
                )
              : Text(
                  '@' + user.name!,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: _appBarHeight * 0.2),
                ),
          backgroundColor: _theme.secondaryHeaderColor,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 15),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AddWorkoutScreen.routeName,
                    arguments: {
                      'workout': Workout(
                        views: 0,
                        searchTerms: [],
                        failed: false,
                        pending: true,
                        date: DateTime.now(),
                        creatorId: uid!,
                        workoutId: uuid.v4(),
                        workoutName: '',
                        bannerImage: null,
                        bannerImageLink: null,
                        exercises: [],
                      ),
                      'isEdit': false
                    },
                  );
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: _appBarHeight * 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
      body: isInit == false
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: _theme.shadowColor,
                color: Colors.white,
              ),
            )
          : Container(
              height: (_mediaQuery.size.height - _appBarHeight),
              width: _mediaQuery.size.width,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            height:
                                (_mediaQuery.size.height - _appBarHeight) * 0.2,
                            width: _mediaQuery.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: _mediaQuery.size.width * 0.05,
                                ),
                                Container(
                                    height: (_mediaQuery.size.height -
                                            _appBarHeight) *
                                        0.15,
                                    width: (_mediaQuery.size.height -
                                            _appBarHeight) *
                                        0.15,
                                    child: user.profilePic == null
                                        ? Image.asset(
                                            'assets/images/no_profile_pic.png',
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
                                                user.profilePic!),
                                            imageErrorBuilder: (image, _, __) =>
                                                Image.asset(
                                                  'assets/images/ImageUploadError.png',
                                                  fit: BoxFit.contain,
                                                ))),
                                SizedBox(
                                  width: _mediaQuery.size.width * 0.06,
                                ),
                                Container(
                                  height: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.15,
                                  width: _mediaQuery.size.width * 0.25,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.followersNum!.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: _appBarHeight * 0.27),
                                        ),
                                        Text(
                                          'followers',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: _appBarHeight * 0.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.15,
                                  width: _mediaQuery.size.width * 0.25,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.followingNum!.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: _appBarHeight * 0.27),
                                        ),
                                        Text(
                                          'following',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: _appBarHeight * 0.15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              width: _mediaQuery.size.width,
                              height:
                                  (_mediaQuery.size.height - _appBarHeight) *
                                      0.1,
                              child: Text(
                                user.bio == null ? '' : user.bio!,
                                textAlign: TextAlign.left,
                                maxLines: 5,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                    fontSize: _appBarHeight * 0.17),
                              ),
                            ),
                          ),
                          Container(
                            height: (_mediaQuery.size.height - _appBarHeight) *
                                0.07,
                            width: _mediaQuery.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: _mediaQuery.size.width * 0.5,
                                  height: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.07,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          side: BorderSide(
                                              width: 1,
                                              color: _theme.primaryColorLight),
                                          primary: _theme.primaryColor),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            EditProfile.routeName,
                                            arguments: user);
                                      },
                                      child: Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: _appBarHeight * 0.2),
                                      )),
                                ),
                                SizedBox(
                                  width: user.instagram != null
                                      ? _mediaQuery.size.width * 0.01
                                      : 0,
                                ),
                                user.instagram != null
                                    ? Container(
                                        width: (_mediaQuery.size.height -
                                                _appBarHeight) *
                                            0.07,
                                        height: (_mediaQuery.size.height -
                                                _appBarHeight) *
                                            0.07,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.center,
                                              elevation: 0,
                                              side: BorderSide(
                                                  width: 1,
                                                  color:
                                                      _theme.primaryColorLight),
                                              primary: _theme.primaryColor),
                                          onPressed: () {
                                            try {
                                              launch(user.instagram!)
                                                  .catchError((e) {
                                                _showToast(
                                                    'Link Not Available');
                                              });
                                            } catch (e) {
                                              _showToast('Link Not Available');
                                            }
                                          },
                                          child: Center(
                                            child: Icon(
                                              MyFlutterApp.instagram_1,
                                              size: _mediaQuery.size.height *
                                                  0.045,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  width: user.tiktok != null
                                      ? _mediaQuery.size.width * 0.01
                                      : 0,
                                ),
                                user.tiktok != null
                                    ? Container(
                                        width: (_mediaQuery.size.height -
                                                _appBarHeight) *
                                            0.07,
                                        height: (_mediaQuery.size.height -
                                                _appBarHeight) *
                                            0.07,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.center,
                                              elevation: 0,
                                              side: BorderSide(
                                                  width: 1,
                                                  color:
                                                      _theme.primaryColorLight),
                                              primary: _theme.primaryColor),
                                          onPressed: () {
                                            try {
                                              launch(user.tiktok!)
                                                  .catchError((e) {
                                                _showToast(
                                                    'Link Not Available');
                                              });
                                            } catch (e) {
                                              _showToast('Link Not Available');
                                            }
                                          },
                                          child: Center(
                                            child: Icon(
                                              MyFlutterApp.unknown,
                                              size: _mediaQuery.size.height *
                                                  0.045,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                          SizedBox(height: _mediaQuery.size.width * 0.05),
                        ],
                      ),
                    ),
                  ];
                },
                body: FirestoreQueryBuilder<Workout>(
                  query: queryWorkout,
                  pageSize: 6,
                  builder: (ctx, snapshot, _) {
                    if (snapshot.isFetching) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          backgroundColor: _theme.shadowColor,
                          color: Colors.white,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      _showToast('Unable To Load Workouts');
                      return Container();
                    } else {
                      return GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0),
                          itemCount: snapshot.docs.length,
                          itemBuilder: (context, index) {
                            final hasReachedEnd = snapshot.hasMore &&
                                index + 1 == snapshot.docs.length &&
                                !snapshot.isFetchingMore;

                            if (hasReachedEnd) {
                              snapshot.fetchMore();
                            }

                            final workout = snapshot.docs[index].data();
                            return snapshot.docs[index].exists
                                ? WorkoutTile(
                                    workout,
                                    true,
                                    false,
                                    true,
                                  )
                                : Container(
                                    height: (_mediaQuery.size.height -
                                        _appBarHeight),
                                    width: _mediaQuery.size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: (_mediaQuery.size.height -
                                                  _appBarHeight) *
                                              0.05,
                                        ),
                                        Container(
                                          height: (_mediaQuery.size.height -
                                                  _appBarHeight) *
                                              0.05,
                                          width: _mediaQuery.size.width * 0.8,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              'Create Your First Workout...',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    _mediaQuery.size.height *
                                                        0.025,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          });
                    }
                  },
                ),
              ),
            ),
    );
  }
}
