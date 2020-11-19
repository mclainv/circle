//import 'package:circle_app_alpha/DatabaseAndAuth/authentication.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/physics.dart';
//import 'dart:math';
//
//class InnerCircle extends StatelessWidget {
//  InnerCircle({this.auth});
//  final BaseAuth auth;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(),
//      body: DraggableCircle(
//        child:
//        CircleGraphWidget(context),
//      ),
//    );
//  }
//}
//
//Widget CircleGraphWidget(BuildContext context) {
//  @override
//  void paint(Canvas canvas, Size size) {
//    final double radius = 1000.0;
//    final Paint paint = new Paint()
//      ..isAntiAlias = true
//      ..strokeWidth = 1.0
//      ..color = Colors.blue[500]
//      ..style = PaintingStyle.stroke;
//    return canvas.drawArc(new Rect.fromLTWH(0.0, 0.0, size.width/2, size.height/2),
//        0.175, 0.349, false, paint);
//  }
//}
//
//class DraggableCircle extends StatefulWidget {
//  final Widget child;
//  DraggableCircle({this.child});
//
//  @override
//  _DraggableCircleState createState() => _DraggableCircleState();
//}
//
//class _DraggableCircleState extends State<DraggableCircle>
//    with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//
//  /// The alignment of the card as it is dragged or being animated.
//  ///
//  /// While the card is being dragged, this value is set to the values computed
//  /// in the GestureDetector onPanUpdate callback. If the animation is running,
//  /// this value is set to the value of the [_animation].
//  Alignment _dragAlignment = Alignment.center;
//
//  Animation<Alignment> _animation;
//
//  /// Calculates and runs a [SpringSimulation].
//  void _runAnimation(Offset pixelsPerSecond, Size size) {
//    _animation = _controller.drive(
//      AlignmentTween(
//        begin: _dragAlignment,
//        end: Alignment.center,
//      ),
//    );
//    // Calculate the velocity relative to the unit interval, [0,1],
//    // used by the animation controller.
//    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
//    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
//    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
//    final unitVelocity = unitsPerSecond.distance;
//
//    const spring = SpringDescription(
//      mass: 30,
//      stiffness: 1,
//      damping: 1,
//    );
//
//    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
//
//    _controller.animateWith(simulation);
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = AnimationController(vsync: this);
//
//    _controller.addListener(() {
//      setState(() {
//        _dragAlignment = _animation.value;
//      });
//    });
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final size = MediaQuery.of(context).size;
//    return GestureDetector(
//      onPanDown: (details) {
//        _controller.stop();
//      },
//      onPanUpdate: (details) {
//        setState(() {
//          _dragAlignment += Alignment(
//            details.delta.dx / (size.width / 2),
//            details.delta.dy / (size.height / 2),
//          );
//        });
//      },
//      onPanEnd: (details) {
//        _runAnimation(details.velocity.pixelsPerSecond, size);
//      },
//      child: Align(
//        alignment: _dragAlignment,
//        child: Card(
//          child: widget.child,
//        ),
//      ),
//    );
//  }
//}