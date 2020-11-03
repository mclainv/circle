import 'package:circle_app_alpha/Models/circle.dart';
import 'package:circle_app_alpha/Models/user.dart';
import 'package:circle_app_alpha/UI/Shared/app_colors.dart';
import 'package:circle_app_alpha/UI/Shared/ui_helpers.dart';
import 'package:circle_app_alpha/ui/widgets/circle_item.dart';
import 'package:circle_app_alpha/ViewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  bool isCollapsed = true;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> scaleAnimation;
  Animation<double> menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  //This might not be the best idea, because I'm not exactly sure which state is being initialized,
  //and it's odd that there's no @override present. But I suppose there would be nothing /to/ override if
  //there is no StatefulWidget present
  @override
  void initState() {
    super.initState();
      //_controller = AnimationController(vsync: , duration: duration);
      scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
      menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
      _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.listenToCircles(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child:
          !model.busy ? Icon(Icons.add) : CircularProgressIndicator(),
          onPressed: model.navigateToCreateView,
        ),
        body: Scaffold(
          body: Stack(
          children: <Widget>[
            menu(context, model.currentUser),
//            dashboard(context, model.circles, model.leaveCircle, model.editCircle),
            ],
          ),
        ),
      ),
    );
  }
  Widget dashboard(context, List<Circle> circles, Function leavecircle, Function editcircle) {
    return AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.6 * screenWidth(context),
        right: isCollapsed ? 0 : -0.4 * screenWidth(context),

        child: ScaleTransition(
          scale: scaleAnimation,

          child: Material(
            animationDuration: duration,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            elevation: 8,
            color: backgroundColor,

            child: Container(
              padding: const EdgeInsets.only(left:16, right: 16, top: 48),

              child: Column(

                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      InkWell(child: Icon(Icons.menu, color: Colors.blue), onTap: () {
                          if (isCollapsed)
                            _controller.forward();
                          else
                            _controller.reverse();
                          isCollapsed = !isCollapsed;
                      },),

                      horizontalSpaceLarge,

                      Text("My Dashboard", style: TextStyle(fontSize:26, color: Colors.black),),
                    ],
                  ),
                  verticalSpaceLarge,
                  Container(
                  height: 600,

                    child: PageView(
                      controller: PageController(viewportFraction: 0.8),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,

                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.redAccent,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                verticalSpace(35),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                      child: Image.asset('assets/images/title.png'),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: circles != null
                                        ? ListView.builder(
                                      itemCount: circles.length,
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                            onTap: () => editcircle(index),
                                            child: PostItem(
                                              post: circles[index],
                                              onDeleteItem: () => leavecircle(index),
                                            ),
                                          ),
                                    )
                                        : Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Theme.of(context).primaryColor),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.blueAccent,
                          width: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.greenAccent,
                          width: 100,
                        ),
                    ])
                  ),]
              ),
            )
          )
        )
    );
    }
  Widget menu(ctxt, User currentuser) {
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
                      SizedBox(width: 250)],
                  ),
                  InkWell(child: Text(currentuser.username,
                      style: TextStyle(color: Colors.white, fontSize: 20))),
                  SizedBox(height: 100),
                  InkWell(child: Text("Dashboard",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: () {},
                  ),
                  SizedBox(height: 20),
                  InkWell(child: Text("Circles",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {}
                      ),
                  SizedBox(height: 20),
                  InkWell(child: Text("Friends",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {}
                      ),
                  SizedBox(height: 20),
                  Text("Settings",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(height: 20),
                  InkWell(child: Text("Sign Out",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
 //
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