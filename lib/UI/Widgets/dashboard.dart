import 'package:flutter/material.dart';
import 'package:circle_app_alpha/Models/circle.dart';
import 'package:circle_app_alpha/UI/Shared/ui_helpers.dart';
import 'package:circle_app_alpha/UI/Widgets/circle_item.dart';

Widget dashboard(context, List<Circle> circles, Function leavecircle, Function editcircle) {
  return Padding(
    padding: const EdgeInsets.only(left:16, right: 16, top: 48, bottom:10),

    child: Column(

        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,

            children: [
              Text("My Dashboard", style: TextStyle(fontSize:26, color: Colors.black),),
            ],
          ),
          verticalSpaceLarge,
          Container(
              height: 515,

              child: PageView(
                  controller: PageController(viewportFraction: 0.8),
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,

                  children: <Widget>[
                    Container( //RED
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.redAccent,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            titleText("Circles", 24),
                            verticalSpace(35),
                            Expanded(
                                child: circles != null
                                    ? ListView.builder(
                                  itemCount: circles.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () => editcircle(index),
                                        child: CircleItem(
                                          circle: circles[index],
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
  );
}