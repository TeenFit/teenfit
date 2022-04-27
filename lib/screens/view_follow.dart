import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/screens/my_workouts.dart';

class ViewFollow extends StatefulWidget {
  static const routeName = '/view-follow';

  @override
  State<ViewFollow> createState() => _ViewFollowState();
}

class _ViewFollowState extends State<ViewFollow> {
  bool isInit = false;
  var followers;
  var following;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInit == false) {
      var prov = ModalRoute.of(context)!.settings.arguments as Map;

      var provFollowers = prov['followers'] == null ? [''] : prov['followers'];
      var provFollowing = prov['following'] == null ? [''] : prov['following'];

      followers = FirebaseFirestore.instance
          .collection('/users')
          .where('uid', whereIn: provFollowers)
          .withConverter<User>(
              fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
              toFirestore: (worKout, _) => worKout.toJson());

      following = FirebaseFirestore.instance
          .collection('/users')
          .where('uid', whereIn: provFollowing)
          .withConverter<User>(
              fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
              toFirestore: (worKout, _) => worKout.toJson());

      setState(() {
        isInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(_mediaQuery.size.height * 0.09),
          child: AppBar(
            elevation: 5,
            title: Text(
              'View Your Following',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: _appBarHeight * 0.2),
            ),
            backgroundColor: _theme.secondaryHeaderColor,
            automaticallyImplyLeading: true,
            bottom: TabBar(tabs: [
              Text(
                'Followers',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: _appBarHeight * 0.2),
              ),
              Text(
                'Following',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: _appBarHeight * 0.2),
              ),
            ]),
          ),
        ),
        body: TabBarView(
          children: [
            isInit == false
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      backgroundColor: _theme.shadowColor,
                      color: Colors.white,
                    ),
                  )
                : FirestoreListView<User>(
                    query: followers,
                    pageSize: 15,
                    itemBuilder: (ctx, snapshot) {
                      final user = snapshot.data();
                      return snapshot.exists
                          ? Container(
                              height: _mediaQuery.size.height * 0.09,
                              width: _mediaQuery.size.width,
                              child: ListTile(
                                leading: Container(
                                  height: _mediaQuery.size.height * 0.05,
                                  width: _mediaQuery.size.height * 0.05,
                                  child: user.profilePic == null
                                      ? Image.asset(
                                          'assets/images/no_profile_pic.png',
                                          fit: BoxFit.contain,
                                        )
                                      : AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: ClipOval(
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                  'assets/images/loading-gif.gif'),
                                              placeholderErrorBuilder:
                                                  (context, _, __) =>
                                                      Image.asset(
                                                'assets/images/loading-gif.gif',
                                                fit: BoxFit.contain,
                                              ),
                                              fit: BoxFit.cover,
                                              //change
                                              image: CachedNetworkImageProvider(
                                                  user.profilePic!),
                                              imageErrorBuilder:
                                                  (image, _, __) => Image.asset(
                                                'assets/images/ImageUploadError.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                title: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    '@' + user.name!,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w900,
                                      fontSize: _mediaQuery.size.height * 0.03,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CreateWorkout(true, user)));
                                },
                              ),
                            )
                          : Container(
                              height: (_mediaQuery.size.height - _appBarHeight),
                              width: _mediaQuery.size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              _mediaQuery.size.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
            isInit == false
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      backgroundColor: _theme.shadowColor,
                      color: Colors.white,
                    ),
                  )
                : FirestoreListView<User>(
                    query: following,
                    pageSize: 5,
                    itemBuilder: (ctx, snapshot) {
                      final user = snapshot.data();
                      return snapshot.exists
                          ? Container(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              width: _mediaQuery.size.width,
                              height: _mediaQuery.size.height * 0.09,
                              alignment: Alignment.center,
                              child: ListTile(
                                leading: Container(
                                  height: _mediaQuery.size.height * 0.05,
                                  width: _mediaQuery.size.height * 0.05,
                                  child: user.profilePic == null
                                      ? Image.asset(
                                          'assets/images/no_profile_pic.png',
                                          fit: BoxFit.contain,
                                        )
                                      : AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: ClipOval(
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                  'assets/images/loading-gif.gif'),
                                              placeholderErrorBuilder:
                                                  (context, _, __) =>
                                                      Image.asset(
                                                'assets/images/loading-gif.gif',
                                                fit: BoxFit.contain,
                                              ),
                                              fit: BoxFit.cover,
                                              //change
                                              image: CachedNetworkImageProvider(
                                                  user.profilePic!),
                                              imageErrorBuilder:
                                                  (image, _, __) => Image.asset(
                                                'assets/images/ImageUploadError.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                title: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    '@' + user.name!,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w900,
                                      fontSize: _mediaQuery.size.height * 0.03,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CreateWorkout(true, user)));
                                },
                              ),
                            )
                          : Container(
                              height: (_mediaQuery.size.height - _appBarHeight),
                              width: _mediaQuery.size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              _mediaQuery.size.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
