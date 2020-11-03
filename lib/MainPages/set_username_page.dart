//import 'package:circle_app_alpha/Models/user.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
//import 'package:circle_app_alpha/DatabaseAndAuth/sign_in.dart';
//import 'package:circle_app_alpha/MainPages/dashboard.dart';
//import 'package:flutter/widgets.dart';
//import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
//class SetUsernamePage extends StatefulWidget {
//  SetUsernamePage({this.auth, this.loginCallback, this.user});
//  final User user;
//  final BaseAuth auth;
//  final VoidCallback loginCallback;
//  Color c = const Color(0xFF42A5F5);
//  @override
//  State<StatefulWidget> createState() => new _SetUsernamePageState();
//}
//
//class _SetUsernamePageState extends State<SetUsernamePage> {
//  final _formKey = new GlobalKey<FormState>();
//
//  String _username;
//  String _errorMessage;
//  int amountOfNames;
//  bool _isLoginForm;
//  bool _isLoading;
//  User user;
//  String username;
//  bool validateAndSave() {
//    final form = _formKey.currentState;
//    if (form.validate()) {
//      form.save();
//      return true;
//    }
//    return false;
//  }
//  void validateAndSubmit() async {
//    setState(() {
//      _errorMessage = "";
//      _isLoading = true;
//    });
//    if (validateAndSave()) {
//      try {
//          amountOfNames = await DatabaseService.checkUsername(_username);
//          if (amountOfNames != 0) {
//            throw Exception("That username is already in use.");
//          }
//        setState(() {
//          _isLoading = false;
//        });
//        if (amountOfNames == 0) {
//          FirebaseUser fbUser = await widget.auth.getCurrentUser();
//          await DatabaseService.addUsername(_username, widget.user.getID());
//            // ignore: unnecessary_statements
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (context) {
//                  return Dashboard(
//                    auth: widget.auth,
//                    user: widget.user
//                  );
//                },
//              ),
//            );
//        }
//      } catch (e) {
//        print('Error: $e');
//        setState(() {
//          _isLoading = false;
//          _errorMessage = e.message;
//          if(Auth().getUserTaken())
//            _errorMessage = "That username is already in use.";
//          _formKey.currentState.reset();
//        });
//      }
//    }
//  }
//  // Check if form is valid before perform login or signup
//  @override
//  void initState() {
//    _errorMessage = "";
//    _isLoading = false;
//    _isLoginForm = true;
//    super.initState();
//  }
//
//  void resetForm() {
//    _formKey.currentState.reset();
//    _errorMessage = "";
//  }
//
//  void toggleFormMode() {
//    resetForm();
//    setState(() {
//      _isLoginForm = !_isLoginForm;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//        child: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              // Where the linear gradient begins and ends
//              begin: Alignment.topRight,
//              end: Alignment.bottomLeft,
//              stops: [0, 0.7],
//              colors: [
//                Color.fromRGBO(0, 0, 0, 1),
//                Color.fromRGBO(53,92,125,1),
////                Colors.indigo[600],
////                Colors.indigo[400],
//              ],
//            ),
//          ),
//          child: Stack(
//            children: <Widget>[
//              _showForm(),
//              _showCircularProgress(),
//            ],
//          ),
//        ));
//  }
//
//  Widget _showCircularProgress() {
//    if (_isLoading) {
//      return Center(child: CircularProgressIndicator());
//    }
//    return Container(
//      height: 0.0,
//      width: 0.0,
//    );
//  }
//
//  Widget _showForm() {
//    return new Container(
//        padding: EdgeInsets.all(16.0),
//        child: new Form(
//          key: _formKey,
//          child: new ListView(
//            shrinkWrap: true,
//            children: <Widget>[
//              //showLogo(),
//              SizedBox(height: 20),
//              showUsernameInput(),
//              showErrorMessage(),
//              showPrimaryButton(),
//            ],
//          ),
//        ));
//  }
//
//  Widget showErrorMessage() {
//
//    if (_errorMessage.length > 0 && _errorMessage != null) {
//      return Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: new Text(
//          _errorMessage,
//          style: TextStyle(
//              fontSize: 13.0,
//              color: Color(0xFF42A5F5),
//              height: 1.0,
//              fontWeight: FontWeight.w300),
//        ),
//      );
//    } else {
//      return new Container(
//        height: 0.0,
//      );
//    }
//  }
//
//  Widget showLogo() {
//    return new Hero(
//      tag: 'hero',
//      child: Padding(
//        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
//        child: CircleAvatar(
//          backgroundColor: Colors.transparent,
//          radius: 48.0,
//          child: Image.asset('assets/flutter-icon.png'),
//        ),
//      ),
//    );
//  }
//
//  Widget showUsernameInput() {
//    return Opacity(
//      opacity: 1.0,
//      child: Padding(
//        padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
//        child: new TextFormField(
//          maxLines: 1,
//          maxLength: 16,
//          keyboardType: TextInputType.text,
//          autofocus: false,
//          decoration: new InputDecoration(
//              hintText: 'Username',
//              icon: new Icon(
//                Icons.person,
//                color: Colors.grey,
//              )),
//          validator: (value) {
//            if (!_isLoginForm)
//              if (value.isEmpty) {
//                return 'Username must exist';
//              }
//            return null;
//          },
//          onSaved: (value) => _username = value.trim(),
//        ),
//      ),
//    );
//  }
//
//  Widget showPrimaryButton() {
//    return new Padding(
//        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
//        child: SizedBox(
//          height: 40.0,
//          child: new RaisedButton(
//            elevation: 5.0,
//            shape: new RoundedRectangleBorder(
//                borderRadius: new BorderRadius.circular(30.0)),
//            color: Colors.blue,
//            child: new Text( 'SetUsername',
//                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
//            onPressed: validateAndSubmit,
//          ),
//        ));
//  }
//
//}
//
