import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:circle_app_alpha/MainPages/dashboard.dart';
class SidebarMenu extends StatefulWidget {

  @override
  _SidebarMenuState createState() => _SidebarMenuState();

}

class _SidebarMenuState extends State<SidebarMenu> with SingleTickerProviderStateMixin{
  @override

  @override

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static bool isCollapsed = true;
  static double screenWidth, screenHeight;
  static final Duration duration = const Duration(milliseconds: 300);
  static AnimationController _controller;
  static Animation<double> _menuSlideAnimation;
  static Animation<double> scaleAnimation;
  static Animation<Offset> _slideAnimation;
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1,0), end: Offset(0,0)).animate(_controller);
    _menuSlideAnimation = Tween<double>(begin:0.5, end: 1).animate(_controller);
    _controller.forward();
  }
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Widget menu(ctxt) {
      return SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _menuSlideAnimation,
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
                    InkWell(child: Text("Dashboard",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        setState(() {
                          if (isCollapsed)
                            _controller.forward();
                          else
                            _controller.reverse();
                          isCollapsed = !isCollapsed;
                          //Navigator.of(ctxt).pushNamed('/circles');
                        });
                      },),
                    SizedBox(height: 20),
                    Text("Circles",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return menu(context);
  }
  }

