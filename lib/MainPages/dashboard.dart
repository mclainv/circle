//import 'package:circle_app_alpha/DatabaseAndAuth/database.dart';
//import 'package:circle_app_alpha/MainPages/friendsPage.dart';
//import 'package:circle_app_alpha/circle_components/inner_circle.dart';
//import 'package:circle_app_alpha/Models/user.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
//import 'package:firebase_database/firebase_database.dart';
//
//class Dashboard extends StatefulWidget {
//  Dashboard({this.auth, this.user});
//  final BaseAuth auth;
//  final User user;
//  @override
//  _DashboardState createState() => _DashboardState();
//}
//
//class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
//  double screenWidth, screenHeight;
//  bool isCollapsed = true;
//  final Duration duration = const Duration(milliseconds: 300);
//  AnimationController _controller;
//  Animation<double> scaleAnimation;
//  Animation<double> menuScaleAnimation;
//  Animation<Offset> _slideAnimation;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = AnimationController(vsync: this, duration: duration);
//    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
//    menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
//    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
//      }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//    screenHeight = size.height;
//    screenWidth = size.width;
//
//    return Scaffold(
//      backgroundColor: Colors.white,
//      body: Stack(
//        children: <Widget>[
//          menu(context),
//          dashboard(context),
//        ],
//      ),
//    );
//  }
//  Widget dashboard(ctxt) {
//    return AnimatedPositioned(
//      duration: duration,
//      top: 0,
//      bottom: 0,
//      left: isCollapsed ? 0 : 0.6 * screenWidth,
//      right: isCollapsed ? 0 : -0.4 * screenWidth,
//
//      child: ScaleTransition(
//        scale: scaleAnimation,
//        child: Material(
//          animationDuration: duration,
//          borderRadius: BorderRadius.all(Radius.circular(40)),
//          elevation: 8,
//          color: Colors.white,
//          child: Container(
//            padding: const EdgeInsets.only(left:16, right: 16, top: 48),
//            child: Column(
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.max,
//                  children: [
//                  InkWell(child: Icon(Icons.menu, color: Colors.blue), onTap: () {
//                    setState(() {
//                      if (isCollapsed)
//                        _controller.forward();
//                      else
//                        _controller.reverse();
//                      isCollapsed = !isCollapsed;
//                    });
//                    },),
//                  SizedBox(width: 90),
//                  Text("My Dashboard", style: TextStyle(fontSize:26, color: Colors.black),),
//                  ],
//                ),
//                SizedBox(height: 50),
//                Container(
//                  height: 600,
//                  child: PageView(
//                    controller: PageController(viewportFraction: 0.8),
//                    scrollDirection: Axis.horizontal,
//                    pageSnapping: true,
//                    children: <Widget>[
//                      Container(
//                        margin: const EdgeInsets.symmetric(horizontal: 8),
//                        color: Colors.redAccent,
//                        width: 100,
//                      ),
//                      Container(
//                        margin: const EdgeInsets.symmetric(horizontal: 8),
//                        color: Colors.blueAccent,
//                        width: 100,
//                      ),
//                      Container(
//                        margin: const EdgeInsets.symmetric(horizontal: 8),
//                        color: Colors.greenAccent,
//                        width: 100,
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          )
//        ),
//      ),
//    );
//  }
//  Widget menu(ctxt) {
//    return SlideTransition(
//      position: _slideAnimation,
//      child: ScaleTransition(
//        scale: menuScaleAnimation,
//        child: Padding(
//            padding: const EdgeInsets.only(left: 16.0),
//            //Only pads the left side by 16 pixels
//            child: Align(
//              alignment: Alignment.centerLeft,
//              //Aligns the text itself but not the text widgets
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: <Widget>[
//                      Image(
//                        height: 50,
//                        width: 50,
//                        image: AssetImage('assets/profilePictureDefault.png'),
//                      ),
//                    SizedBox(width:250)],
//                  ),
//                  InkWell(child: Text(widget.user.getUsername(),
//                      style: TextStyle(color: Colors.white, fontSize: 20))),
//                  SizedBox(height:100),
//                  InkWell(child: Text("Dashboard",
//                      style: TextStyle(color: Colors.white, fontSize: 20)),
//                    onTap: () {
//                      setState(() {
//                        if (isCollapsed)
//                          _controller.forward();
//                        else
//                          _controller.reverse();
//                        isCollapsed = !isCollapsed;
//                      });
//                    },),
//                  SizedBox(height: 20),
//                  InkWell(child: Text("Circles",
//                      style: TextStyle(color: Colors.white, fontSize: 20)),
//                      onTap: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => InnerCircle()),
//                        );
//                      }),
//                  SizedBox(height: 20),
//                  InkWell(child: Text("Friends",
//                  style: TextStyle(color: Colors.white, fontSize: 20)),
//                  onTap: () {}),
//                  SizedBox(height: 20),
//                  Text("Settings",
//                      style: TextStyle(color: Colors.white, fontSize: 20)),
//                  SizedBox(height: 20),
//                  InkWell(child: Text("Sign Out",
//                      style: TextStyle(color: Colors.white, fontSize: 20)),
//                      onTap: () {})
//                ],
//              ),
//            )
//        ),
//      ),
//    );
//  }
//}
