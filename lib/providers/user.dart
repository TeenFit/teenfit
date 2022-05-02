import 'dart:io';

class User {
  final String? bio;
  final String? email;
  final String? name;
  final String? uid;
  final String? date;
  final String? link;
  final String? profilePic;
  final List? followers;
  final List? following;
  final List? searchTerms;
  final String? instagram;
  final String? tiktok;
  final File? profilePicFile;

  const User({
    required this.email,
    required this.name,
    required this.uid,
    this.date,
    this.bio,
    this.profilePic,
    this.profilePicFile,
    this.followers,
    this.following,
    this.searchTerms,
    this.link,
    this.instagram,
    this.tiktok,
  });

  User.fromJson(Map<String, dynamic> e)
      : this(
          email: e['email'],
          name: e['name'],
          uid: e['uid'],
          date: e['date'],
          bio: e['bio'],
          profilePic: e['profilePic'],
          followers: e['followers'],
          following: e['following'],
          searchTerms: e['searchTerms'],
          link: e['link'],
          tiktok: e['tiktok'],
          instagram: e['instagram'],
          profilePicFile: null,
        );

  Map<String, Object?> toJson() => {
        'email': email,
        'name': name,
        'uid': uid,
        'date': date,
        'bio': bio,
        'profilePic': profilePic,
        'followers': followers == null || followers == [] ? ['a'] : followers,
        'following': following == null || following == [] ? ['a'] : following,
        'searchTerms': searchTerms,
        'link': link,
        'instagram': instagram,
        'tiktok': tiktok,
      };
}
