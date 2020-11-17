import 'package:circle_app_alpha/Models/circle.dart';
import 'package:circle_app_alpha/UI/Shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class CircleItem extends StatelessWidget {
  final Circle circle;
  final Function onDeleteItem;
  const CircleItem({
    Key key,
    this.circle,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      width: 256,
      margin: const EdgeInsets.only(top: 5, left: 20, right: 15),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              child: Image(image: AssetImage('assets/circle_components/mandala.png'), width:256, height:256,
              )),
//          Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//                  MaterialButton(
//                    child: new Image(image: AssetImage('assets/icons/nonotif.png'), width:24, height:24, color: Colors.black),
//                    onPressed: () {
//                      if (onDeleteItem != null) {
//                        onDeleteItem();
//                      }
//                    },
//                  ),
//            ],
//          ),
        ],
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: (
              LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.33,
                    0.66
                  ],
                  colors: [
                    //Color.fromRGBO(142, 154, 175, 1),
                    Color.fromRGBO(239, 211, 215, 1),
                    Color.fromRGBO(254, 234, 250, 1)
                  ]
              ))
      ),
    );
  }
}