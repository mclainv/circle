class User {
  final String id;
  final String username;
  final String email;

  User({this.id, this.username, this.email});

  getID() {
    return this.id;
  }

  getUsername() {
    return this.username;
  }
  getEmail() {
    return this.email;
  }

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        email = data['email'],
        username = data['username'];

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'username': username,
      'email' : email,
    };
  }
}