class User {
  final String uid;
  final String username;
  final String email;

  User({this.uid, this.username, this.email});

  getUID() {
    return this.uid;
  }

  getUsername() {
    return this.username;
  }
  getEmail() {
    return this.email;
  }

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        username = data['username'],
        email = data['email'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email' : email,
    };
  }
}