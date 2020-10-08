import 'package:circle_app_alpha/models/user.dart';
import 'package:flutter/material.dart';
import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
import 'package:circle_app_alpha/DatabaseAndAuth/sign_in.dart';
import 'package:circle_app_alpha/MainPages/dashboard.dart';
import 'package:flutter/widgets.dart';
import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  Color c = const Color(0xFF42A5F5);
  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _username;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      User user;
      try {
        if (_isLoginForm) {
          user = await widget.auth.signIn(_email, _password);
          print('Signed in: ${user.getUID()}, ${user.getUsername()}');
        } else {
          user = await widget.auth.signUp(_email, _password, _username);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: ${user.getUID()}');
        }
        setState(() {
          _isLoading = false;
        });
        if (user.getUID().length > 0 && user.getUID() != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          if(Auth().getUserTaken())
            _errorMessage = "That username is already in use.";
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
    _isLoading = false;
  }

  void toggleFormMode() {
    resetForm();
    _isLoading = false;
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
      children: <Widget>[
        _showForm(),
        _showCircularProgress(),
        ],
      ),
    );
  }




  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.2, 0.9],
            colors: [
              const Color(0xfff4acb7),
              const Color(0xffd8e2dc),
            ],
          ),
        ),
        child:
       new Scaffold(
       backgroundColor: Colors.transparent,
         body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: _formKey,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  showLogo(),
                  showUsernameInput(),
                  showEmailInput(),
                  showPasswordInput(),
                  showErrorMessage(),
                  showPrimaryButton(),
                  showSecondaryButton(),
                  SizedBox(height: 20),
                  _signInButton(),
                ],
              ),
          )
         )
         )
      );
  }

  Widget showErrorMessage() {
    _isLoading = false;
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Color(0xFF42A5F5),
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/flutter-icon.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }
  Widget showUsernameInput() {
    if(_isLoginForm) {
      return Opacity(
        opacity: 0.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
          child: new TextFormField(
            maxLines: 1,
            maxLength: 16,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
                hintText: 'Username',
                icon: new Icon(
                  Icons.person,
                  color: Colors.grey,
                )),
            validator: (value) {
              if (!_isLoginForm)
                if (value.isEmpty) {
                  return 'Username must exist';
                }
              return null;
            },
            onSaved: (value) => _username = value.trim(),
          ),
        ),
      );
    }
    else {
      return Opacity(
        opacity: 1.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
          child: new TextFormField(
            maxLines: 1,
            maxLength: 16,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
                hintText: 'Username',
                icon: new Icon(
                  Icons.person,
                  color: Colors.grey,
                )),
            validator: (value) {
              if (!_isLoginForm)
                if (value.isEmpty) {
                  return 'Username must exist';
                }
              return null;
            },
            onSaved: (value) => _username = value.trim(),
          ),
        ),
      );
    }
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        //validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        validator: (value) {
          if(value.isEmpty)
            return 'Password can\'t be empty';
          else if(value.toString().length < 6)
            return 'Password must be at least six characters';

          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Color(0xff627264),
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          widget.loginCallback();
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) {
//                return Dashboard(
//                  auth: widget.auth,
//                  thisUser: ,
//                );
//              },
//            ),
//          );
        });
      },
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Colors.grey),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/google_logo.png"), height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
  }
}
//class LoginPageWidget extends StatefulWidget {
//  LoginPageWidget({Key key}) : super(key: key);
//
//  @override
//  _LoginPageWidgetState createState() => _LoginPageWidgetState();
//}
//class _LoginPageWidgetState extends State<LoginPageWidget> {
//  Widget build(BuildContext buildContext) {
//
//  }
//}
