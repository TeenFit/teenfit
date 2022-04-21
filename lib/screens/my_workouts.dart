import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/providers/userProv.dart';
import 'package:uuid/uuid.dart';

import '/providers/workout.dart';
import 'create_workout.dart';
import '/widgets/workout_tile.dart';

class CreateWorkout extends StatefulWidget {
  @override
  State<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  User? user;
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

        user = Provider.of<UserProv>(context, listen: false).getUser;
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
                  user!.name!,
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
                        creatorName: '',
                        creatorId: uid!,
                        workoutId: uuid.v4(),
                        workoutName: '',
                        instagram: '',
                        facebook: '',
                        tiktokLink: '',
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                  child: user!.profilePic == null
                                      ? Image.asset(
                                          'assets/images/no_profile_pic.png',
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          user!.profilePic!,
                                          errorBuilder: (image, _, __) =>
                                              Image.asset(
                                            'assets/images/ImageUploadError.png',
                                            fit: BoxFit.contain,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                ),
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
                                          user!.followersNum!.toString(),
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
                                          user!.followingNum!.toString(),
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
                          Container(
                            height:
                                (_mediaQuery.size.height - _appBarHeight) * 0.2,
                            width: _mediaQuery.size.width,
                          )
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
