import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/user.dart';

import 'auth.dart';

class UserProv with ChangeNotifier {
  User? _user;

  User get getUser {
    return _user!;
  }

  Future<Map> authAccount() async {
    var idAndKey = '004b2d9d74e33f20000000003:K004vzBfb9w+bLUXQqtlb9O7B6n7I0A';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    var basicAuthString = 'Basic' + stringToBase64.encode(idAndKey);
    var headers = {'Authorization': basicAuthString};

    var request = await http.get(
        Uri.parse('https://api.backblazeb2.com/b2api/v2/b2_authorize_account'),
        headers: headers);

    Map<String, dynamic> response =
        await json.decode(request.body) as Map<String, dynamic>;

    return response;
  }

  Future<Map> getUploadUrl() async {
    Map authResponse = await authAccount();

    var apiUrl = authResponse['apiUrl'];
    var authorizationToken = authResponse['authorizationToken'];
    var bucketId = authResponse['allowed']['bucketId'];

    var request = await http.post(
      Uri.parse('$apiUrl/b2api/v2/b2_get_upload_url'),
      body: json.encode({'bucketId': bucketId}),
      headers: {'Authorization': authorizationToken},
    );

    Map<String, dynamic> response =
        await json.decode(request.body) as Map<String, dynamic>;

    return response;
  }

  Future<void> fetchAndSetUser(context) async {
    final uid = Provider.of<Auth>(context, listen: false).userId!;
    final userDoc =
        await FirebaseFirestore.instance.collection('/users').doc(uid).get();

    // final List<Map> usersList = [
    //   {
    //     'email': 'teenfitness.fit@gmail.com',
    //     'uid': 'fu9uLdEgQCX3jsVrOMcU4KFmNCr1',
    //   },
    //   {
    //     'email': 'admin@teenfit.com',
    //     'uid': '68SoGmjDUaXpEPP4VfbCB2j9lr32',
    //   },
    //   {
    //     'email': 'obauer@gmx.at',
    //     'uid': 'buo95FXvCsStcN676cyicrz2R753',
    //   },
    //   {
    //     'email': 'msd270405@gmail.com',
    //     'uid': 'XHXpYDEPthhmZ9sZ48cZSCbqUB22',
    //   },
    //   {
    //     'email': 'landonscroggins09@icloud.com',
    //     'uid': '5i8Cb8kmicdf8mMHv2liiRLfhui1',
    //   },
    //   {
    //     'email': 'jaygup2.0@gmail.com',
    //     'uid': 'nPTmLWbUn9OuJryTCmI6l03TIj82',
    //   },
    //   {
    //     'email': 'jaxontrower@gmail.com',
    //     'uid': 'G6sSPkVrtwMNRTVy69j4dY8wYjC2',
    //   },
    //   {
    //     'email': 'muqeeth082005@gmail.com',
    //     'uid': 'oHTw5MuxYLghIBd5tbex2fpcNv72',
    //   },
    //   {
    //     'email': 'isaiahsteitz1234@gmail.com',
    //     'uid': 'zuCqcWWYX3PDFpEYuv0ROmo2Tsj2',
    //   },
    //   {
    //     'email': 'hannahgeiger11@icloud.com',
    //     'uid': 'ASN35cB97kbfZ9CcHRMpXYS8wb23',
    //   },
    //   {
    //     'email': 'jackloyd1080@gmail.com',
    //     'uid': 'Y5DsMEfyUaezViWWBzW7yeyx4mt2',
    //   },
    //   {
    //     'email': 'cappsjl14@att.net',
    //     'uid': 'XcU6KyYvCLUXYGFWnIIEWx22GOd2',
    //   },
    //   {
    //     'email': 'addyson130@gmail.com',
    //     'uid': 'sMPRYdLe43S3rfZ06FCIrtlyZya2',
    //   },
    //   {
    //     'email': 'hfisherman05@gmail.com',
    //     'uid': 'jKrqaWMWAIMAinM23b4VzBYlHTj2',
    //   },
    //   {
    //     'email': 'jc0rdellb2007@icloud.com',
    //     'uid': 'cz9TsOE5mER9I6GkjNc1fWv4zP03',
    //   },
    //   {
    //     'email': 'robbieellison0121@icloud.com',
    //     'uid': 'SevXXiN73oSX4kfLm5Piw1CvSQf2',
    //   },
    //   {
    //     'email': 'ethanwells2007@yahoo.com',
    //     'uid': 'aBp8bCbidvcpme0CiKRY1PTrFF93',
    //   },
    //   {
    //     'email': 'granberrykelly3@gmail.com',
    //     'uid': 'uB0IyCsWjzRoqKB7OcgbL85H9Ut1',
    //   },
    //   {
    //     'email': 'viannyperez30@gmail.com',
    //     'uid': 'sbuX5TsL6DhZttG294GHE3mM8Jp2',
    //   },
    //   {
    //     'email': 'etinacci2008@gmail.com',
    //     'uid': 'oJWsHbjjjhQADNrx8745whE69OE2',
    //   },
    //   {
    //     'email': 'ethan901@gmail.com',
    //     'uid': 'glHylzM19cVyYImdPt42shNr9CL2',
    //   },
    //   {
    //     'email': 'sangheranirmaljit700@gmail.com',
    //     'uid': '85bfIfzdMCWNShl4s7ZArSpuFj22',
    //   },
    //   {
    //     'email': 'ceash09@gmail.com',
    //     'uid': 'x8YmZM8K8Wh3mMWl0hGrwuqNgan2',
    //   },
    //   {
    //     'email': 'lanicaroline06@gmail.com',
    //     'uid': 'C2a35eAJfkhhayOm6FMtbUVQISl2',
    //   },
    //   {
    //     'email': 'chasememie@gmail.com',
    //     'uid': 'KtIliGeAkHObYqVCevOf7A3bLXp1',
    //   },
    //   {
    //     'email': 'familysar277@gmail.com',
    //     'uid': '63DqapmzLhZebAmOIstfhTq1IJv2',
    //   },
    //   {
    //     'email': 'manvirsingh402@yahoo.ca',
    //     'uid': '2KUlZ89dEjaeOPckWDRtaqPipYc2',
    //   },
    //   {
    //     'email': 'tim_verbeek@icloud.com',
    //     'uid': 'w7J5AmRIK7bWSaArwKWi0nhojg82',
    //   },
    //   {
    //     'email': 'hzrichards@icloud.com',
    //     'uid': '0BJCNd4rhQfwtgy90tcQVRYADjk1',
    //   },
    //   {
    //     'email': 'bryanjrbrandon@gmail.com',
    //     'uid': '44vnN7eLRseNOL5CVQh3ddz8Nxy2',
    //   },
    //   {
    //     'email': 'emmabug316@icloud.com',
    //     'uid': 'MWpL2NN23sPL14nELHDD4UeT6GT2',
    //   },
    //   {
    //     'email': 'zainoul19@gmail.com',
    //     'uid': 'IPgM3Vnr6CQfKIijDm98KoucqLm2',
    //   },
    //   {
    //     'email': 'jacksons0614@gmail.com',
    //     'uid': 'DFl6kJX7hXhvNxFMeboXqOQgYsl2',
    //   },
    //   {
    //     'email': 'miriro0320@gmail.com',
    //     'uid': 'xLQlCM2uZXOT1T6aPT3Dc3Smsmr2',
    //   },
    //   {
    //     'email': 'cnothnaglez@gmail.com',
    //     'uid': 'xwsX5AhnBsXEOtA2K4XOLDmWDGf1',
    //   },
    //   {
    //     'email': 'bellafraczek@gmail.com',
    //     'uid': 'FnvR57bNvUUrZ405aAKKmH0CJvs2',
    //   },
    //   {
    //     'email': 'ianhurter@icloud.com',
    //     'uid': '3uAXCvYCHcbpggNpBMYqlAq7y592',
    //   },
    //   {
    //     'email': 'lipnfract@gmail.com',
    //     'uid': 'Dmn5fusOoyfU0TrNSvDiRgvdWGn1',
    //   },
    //   {
    //     'email': 'enzo.miroudot@icloud.com',
    //     'uid': '3xtZdks77Ta0d7KZeYY8dTqQh1m1',
    //   },
    //   {
    //     'email': 'hhailey0429@gmail.com',
    //     'uid': 'qUb4hpV7NJhYpYsNGnxeVDmOwx52',
    //   },
    //   {
    //     'email': 'oliviaherron12@gmail.com',
    //     'uid': 'PQSTwsh2MtStgjp995rX26ilAih1',
    //   },
    //   {
    //     'email': 'seren_sutton2008@icloud.com',
    //     'uid': 'UmMhiQRuKSRalVvUnN2def8asxX2',
    //   },
    //   {
    //     'email': 'eknoor2005@gmail.com',
    //     'uid': 'kIJ3Pvr360eaeDyZVw79sXphA0v1',
    //   },
    //   {
    //     'email': 'ajbilinski8@icloud.com',
    //     'uid': 'M5dAmPoqrmfXtXQGhc9dhPI48ag2',
    //   },
    //   {
    //     'email': 'ryanlawdeem@gmail.com',
    //     'uid': 'npwetKsPdZdleBgGzLjDYZaKpOx2',
    //   },
    //   {
    //     'email': 'kaseanburton346@gmail.com',
    //     'uid': 'npwetKsPdZdleBgGzLjDYZaKpOx2',
    //   },
    //   {
    //     'email': 'kaseanburton346@gmail.com',
    //     'uid': 'go7OAecpn8hM4FUALFwhr4IRNRu1',
    //   },
    //   {
    //     'email': 'emmargreatrex94@gmail.com',
    //     'uid': '6YpbjnhytcOLSM7AGuqSUia8YSk2',
    //   },
    //   {
    //     'email': 'marjanhasana12@gmail.com',
    //     'uid': 'hTYr9vCSebc11DkoaZHCUuCM1NL2',
    //   },
    //   {
    //     'email': 'zoe08292008@gmail.com',
    //     'uid': 'XouNUNEPjBMfQcicej5G8Bz6y6f1',
    //   },
    //   {
    //     'email': 'kader_1@yahoo.com',
    //     'uid': 'a14j9wySLSWneLzhemEpUcs8r3u1',
    //   },
    //   {
    //     'email': 'triordan0709@gmail.com',
    //     'uid': 'Lzv5AgaUP4afZhW4qGfznPmMbbs2',
    //   },
    //   {
    //     'email': 'caden.porter@me.com',
    //     'uid': 'iou5iRslrNQ03zPUJdO6E3Ylkxq1',
    //   },
    //   {
    //     'email': 'westineckhart@gmail.com',
    //     'uid': 'CkJzagkTzwTNnc2c9vOIXEIaNkt2',
    //   },
    //   {
    //     'email': 'audreyupton3@gmail.com',
    //     'uid': 'gLXS8srbdjYNigNKZEBNfw5qtJh1',
    //   },
    //   {
    //     'email': 'cocoloco08@icloud.com',
    //     'uid': 'WBcGfZRKicXOEOJCw8xqMlEtUNh2',
    //   },
    //   {
    //     'email': '769888@pdsb.net',
    //     'uid': 'XezFFLGISmTp0zuTFr6674VemO43',
    //   },
    //   {
    //     'email': 'sammyk378@icloud.com',
    //     'uid': 'vH2slwy8LEZUl1Gyly6RGLqJoK52',
    //   },
    // ];

    // usersList.forEach((element) async {
    //   await FirebaseFirestore.instance
    //       .collection('/users')
    //       .doc(element['uid'])
    //       .set({
    //     'email': element['email'],
    //     'name':
    //         'user_${element['uid']} ${element['email'].substring(0, element['email'].indexOf('@')).toLowerCase()}'
    //             .substring(0, 30),
    //     'bio': null,
    //     'profilePic': null,
    //     'following': null,
    //     'followers': null,
    //     'uid': '${element['uid']}',
    //     'date': DateTime.now().toString(),
    //     'searchTerms': [
    //       'user_${element['uid']} ${element['email'].substring(0, element['email'].indexOf('@')).toLowerCase()}'
    //           .substring(0, 30),
    //       '${element['uid']} ${element['email'].substring(0, element['email'].indexOf('@')).toLowerCase()}'
    //           .substring(0, 30)
    //     ],
    //     'link': null,
    //     'instagram': null,
    //     'tiktok': null,
    //   });
    // });

    _user = User(
      email: userDoc.data()!['email'],
      name: userDoc.data()!['name'],
      uid: userDoc.data()!['uid'],
      date: userDoc.data()!['date'],
      bio: userDoc.data()!['bio'],
      profilePic: userDoc.data()!['profilePic'],
      followers: userDoc.data()!['followers'],
      following: userDoc.data()!['following'],
      searchTerms: userDoc.data()!['searchTerms'],
      link: userDoc.data()!['link'],
      instagram: userDoc.data()!['instagram'],
      tiktok: userDoc.data()!['tiktok'],
    );
    notifyListeners();
  }

  Future<User> fetchAUser(context, uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('/users').doc(uid).get();

    return User(
      email: userDoc.data()!['email'],
      name: userDoc.data()!['name'],
      uid: userDoc.data()!['uid'],
      date: userDoc.data()!['date'],
      bio: userDoc.data()!['bio'],
      profilePic: userDoc.data()!['profilePic'],
      followers: userDoc.data()!['followers'],
      following: userDoc.data()!['following'],
      searchTerms: userDoc.data()!['searchTerms'],
      link: userDoc.data()!['link'],
      instagram: userDoc.data()!['instagram'],
      tiktok: userDoc.data()!['tiktok'],
    );
  }

  Future<void> updateUser(User? useR, context) async {
    List<String> searchTermsList = [];

    Future<void> addSearchTerms(String workoutName) async {
      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i).toLowerCase());
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i).toUpperCase());
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 2 < 0 ? 0 : i - 2, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 3 < 0 ? 0 : i - 3, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 4 < 0 ? 0 : i - 4, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 5 < 0 ? 0 : i - 5, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 6 < 0 ? 0 : i - 6, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 7 < 0 ? 0 : i - 7, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 8 < 0 ? 0 : i - 8, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 9 < 0 ? 0 : i - 9, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 10 < 0 ? 0 : i - 10, i));
      }

      searchTermsList = searchTermsList.toSet().toList();
    }

    try {
      addSearchTerms(useR!.name!);
      var uploadResponse = await getUploadUrl();
      var uploadUrl = uploadResponse['uploadUrl'];
      var uploadAuthToken = uploadResponse['authorizationToken'];
      var contentType = 'b2/x-auto';
      var sha1 = 'do_not_verify';

      if (useR.profilePicFile != null) {
        File file = useR.profilePicFile!;
        Uint8List fileData = await file.readAsBytes();
        String fileName = useR.uid!;

        await http.post(
          Uri.parse(uploadUrl),
          body: fileData,
          headers: {
            'Authorization': uploadAuthToken,
            'X-Bz-File-Name': fileName,
            'Content-Type': contentType,
            'X-Bz-Content-Sha1': sha1,
            'X-Bz-Info-Author': 'unknown',
            'X-Bz-Server-Side-Encryption': 'AES256'
          },
        );
      }

      await FirebaseFirestore.instance
          .collection('/users')
          .doc(useR.uid)
          .update({
        'profilePic': useR.profilePicFile != null
            ? 'https://f004.backblazeb2.com/file/profilePics/${useR.uid}'
            : useR.profilePic,
        'name': useR.name,
        'bio': useR.bio,
        'instagram': useR.instagram,
        'tiktok': useR.tiktok,
        'searchTerms': searchTermsList,
        'date': DateTime.now().toString(),
      });

      await fetchAndSetUser(context);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void addFollower(String uid) {
    FirebaseFirestore.instance.collection('/users').doc(uid.toString()).update({
      'followers': FieldValue.arrayUnion([_user!.uid.toString()])
    });

    FirebaseFirestore.instance
        .collection('/users')
        .doc(_user!.uid.toString())
        .update({
      'following': FieldValue.arrayUnion([uid.toString()])
    });

    notifyListeners();
  }

  void removeFollower(String uid) {
    FirebaseFirestore.instance.collection('/users').doc(uid.toString()).update({
      'followers': FieldValue.arrayRemove([_user!.uid.toString()])
    });

    FirebaseFirestore.instance
        .collection('/users')
        .doc(_user!.uid.toString())
        .update({
      'following': FieldValue.arrayRemove([uid.toString()])
    });

    notifyListeners();
  }

  
}
