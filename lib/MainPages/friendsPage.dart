import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
import 'package:circle_app_alpha/MainPages/dashboard.dart';
import 'package:circle_app_alpha/circle_components/inner_circle.dart';
import 'package:circle_app_alpha/models/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circle_app_alpha/models/user.dart';
import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class Friends extends StatefulWidget {
  Friends({this.auth, this.thisUser});
  final BaseAuth auth;
  final User thisUser;
  @override
  _FriendsState createState() => _FriendsState();

}
class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}
MyGlobals myGlobals = new MyGlobals();
class _FriendsState extends State<Friends> with SingleTickerProviderStateMixin {
  //String myUsername = widget.thisUser.getUsername();
  String otherUsername;
  String _errorMessage;
  QuerySnapshot friends;
  QuerySnapshot friendRequests;
  Color backgroundColor = Color.fromRGBO(72, 72, 74, 1.0);
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CrudMethods crudObj = new CrudMethods();
  double balance = 0;
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> scaleAnimation;
  Animation<double> menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  DatabaseService  DBS;

  //create user obj based on Firebase User
  String _userId = "";
  User thisUser;
  User _userFromFirebaseUsername(FirebaseUser user, String username) {
    return user != null ? User(id: user.uid, username: username) : null;
  }
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          thisUser = _userFromFirebaseUsername(user, user.uid);
          _userId = user?.uid;
        }
      }
      );
      crudObj.getFriends(_userId).then((results) {
        setState(() {
          friends = results;
        });
      }
      );
      crudObj.getFriendRequests(_userId).then((results) {
        setState(() {
          print(_userId);
          friendRequests = results;
        });
      }
      );
    });
    _controller = AnimationController(vsync: this, duration: duration);
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation =
        Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(
            _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> sendFriendRequest(BuildContext context) async {
    DatabaseService  DBS = new DatabaseService(uid: widget.thisUser.getID());
    return showDialog(
        //syncs context
        context: myGlobals.scaffoldKey.currentContext,
        //non-dismissible
        barrierDismissible: false,
        //
        builder: (BuildContext context) {
          //Builds the "showDialog" widget
          return AlertDialog(
            //returns an Alert-Dialog box
            //DONE: ENSURE USERNAME EXISTS BEFORE PUSHING REQUEST
            //TODO: TRY/CATCH ERRORS TO DISPLAY TO THE ERROR
            title: Text('Add Data', style: TextStyle(fontSize: 15.0)),
            //Bold header text
            content: Column(
              //new column
              children: <Widget>[
                //child of the Column
                TextField(
                  //new Text field
                  decoration: InputDecoration(hintText: 'Enter username'),
                  //Greyed out default text in the input box
                  onChanged: (value) {
                    //When it is changed, save the value as the username
                    this.otherUsername = value;
                  },
                ),
                SizedBox(height: 5.0),
                //Small box between text and line
              ],
            ),
            actions: <Widget>[
              //actions of the alert dialog
              FlatButton(
                //Creates the button without a box
                child: Text('Add'),
                //Adds the text
                textColor: Colors.blue,
                //Sets the color
                onPressed: ()  {
                  //Creates an async event when the button is pressed
                  _errorMessage = "";
                  //creates the empty error message string
                  //Pop the stack
                    //Try this method
//                    await crudObj.sendFriendRequest(_userId, username);
                    //Await a response from the CRUD method
                      //signals dialog trigger to run
                    Navigator.of(context).pop();
                    DBS.sendFriendRequest(widget.thisUser.getUsername(), otherUsername).then((result) {
                      dialogTrigger(context);
                      _errorMessage = "Friend Request sent to @$otherUsername";
                    }).catchError((e) {
                      _errorMessage = e.message;
                      print(e);
                      dialogTrigger(context);
                    });
                },
              )
            ],
          );

        });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: myGlobals.scaffoldKey.currentContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Queried...', style: TextStyle(fontSize: 15.0)),
            content: Text(_errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    screenHeight = size.height;
    screenWidth = size.width;
    return new Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          friendsViewNew(context),
        ],
      ),
      key: myGlobals.scaffoldKey,
    )
    ;
  }
  Widget friendsViewNew(ctxt) {
    return AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.6 * screenWidth,
        right: isCollapsed ? 0 : -0.4 * screenWidth,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Material(
            animationDuration: duration,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            elevation: 8,
            color: backgroundColor,
              child: new Scaffold(
                appBar: AppBar(
                  backgroundColor: backgroundColor,
                  title: Text('Friends'),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        if (isCollapsed)
                          _controller.forward();
                        else
                          _controller.reverse();
                        isCollapsed = !isCollapsed;
                      });
                    }
                  ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      sendFriendRequest(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      crudObj.getFriends(_userId).then((results) {
                        setState(() {
                          friends = results;
                        });
                      });
                    },),
                  IconButton(
                    icon: Icon(Icons.mail_outline),
                    onPressed: () {
                      _getFriendRequestList(ctxt);
                    },),
                ],),
                  body: _friendsList())
            )),
        );
  }

  Widget _friendsList() {
    if (friends != null) {
      return ListView.builder(
        itemCount: friends.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return ListTileTheme(
            selectedColor: backgroundColor,
            child: new ListTile(
              title: Text(friends.documents[i].data['carName']),
              subtitle: Text(friends.documents[i].data['color']),
            ),
          );
        },
      );
    } else {
      return Text('Loading, Please wait..');
    }
  }
  void _getFriendRequestList(ctxt) {
    //ensure friendRequests has data, i.e. check if the user has at least one friend request.
  // if(friendRequests != null) {
      //prevents the user from interacting with the rest of the app
      showModalBottomSheet(context: ctxt, builder: (BuildContext bc) {
        //returns a container widget
      return Container(
        //sets the height according to a mediaquery
        height: MediaQuery.of(ctxt).size.height * 0.60,
        //adds a padding object
        child: Padding(
          //sets the padding
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
              children: <Widget>[
                Padding(
                  //first object in column
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Incoming Friend Requests"),
                )
        ]
        ),
              //second object in column
              _friendRequestsList(),
        ]
        )
        )
      );
      }
      );
    }
 // }
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['from']),
      subtitle: Text(document['to']),
    );
  }
  Widget _friendRequestsList() {
      //return a card
      return new Card (
        //create a stream builder object
        child: new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('friendRequests').snapshots(),
            builder: (context, snapshot) {
              print(snapshot);
              if(!snapshot.hasData) {
                return Text("Loading... one minute", );
              }
                  return new Row(
                        children: <Widget> [ Expanded(

                              child: SizedBox(
                                height: 350,
                                child:
                                  ListView.builder(itemCount: 10, itemBuilder: (context, index) {
                                    return _buildList(context,
                                        (snapshot.data.documents[index])
                                      );
                                    }
                                  )
                              )
                        )]
                  );
            })
      );

  }
        //useless??
//  getFriendRequests(AsyncSnapshot<QuerySnapshot> snapshot) {
//    return snapshot.data.documents
//        .map((doc) => new ListTile(title: new Text(doc["to"]), subtitle: new Text(doc["from"].toString())));
//  }

  Widget menu(ctxt) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: menuScaleAnimation,
        child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            //Only pads the left side by 16 pixels
            child: Align(
              alignment: Alignment.centerLeft,
              //Aligns the text itself but not the text widgets
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image(
                        height: 50,
                        width: 50,
                        image: AssetImage('assets/profilePictureDefault.png'),
                      ),
                      SizedBox(width:250)],
                  ),
                  InkWell(child: Text(widget.thisUser.getUsername(),
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {}
                      ),
                  InkWell(child: Text("Dashboard",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              Dashboard(
                                auth: widget.auth,
                                thisUser: thisUser,
                                username: thisUser.username
                              )),
                        );
                      }),
                  SizedBox(height: 20),
                  InkWell(child: Text("Circles",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InnerCircle(
                                auth: widget.auth,
                              )),
                        );
                      }),
                  SizedBox(height: 20),
                  InkWell(child: Text("Friends",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        setState(() {
                          if (isCollapsed)
                            _controller.forward();
                          else
                            _controller.reverse();
                          isCollapsed = !isCollapsed;
                        });
                      },
                      ),
                  SizedBox(height: 20),
                  Text("Settings",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(height: 20),
                  InkWell(child: Text("Sign Out",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        _firebaseAuth.signOut();
                        Navigator.of(ctxt).pushNamedAndRemoveUntil(
                            '/', (Route<dynamic> route) => false);
                      })
                ],
              ),
            )
        ),
      ),
    );
  }
}
