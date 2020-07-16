class User {
  final String uid;
  final String username;
  var friendRequests = new Map();
  var friends = new Map();

  User( {this.uid, this.username} );

  getUID() {
    return this.uid;
  }
  getUsername() {
    return this.username;
  }
//  getFriends() {
//    return friends;
//  }
//  getFriendRequests() {
//    return friendRequests;
//  }
//  setFriends(Map friendsToAdd) {
//    for(int i = 0; i < friendsToAdd.length; i++) {
//      friends[friends.length+i+1] = friendsToAdd[i];
//    }
//  }
//  setFriendRequests(Map friendRequestsToAdd) {
//    for(int i = 0; i < friendRequests.length; i++) {
//      friendRequests[friendRequests.length+i+1] = friendRequestsToAdd[i];
//    }
//  }
}