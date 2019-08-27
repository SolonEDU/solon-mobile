import 'package:flutter/material.dart';
import 'dart:math';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;

  final double initialRadius = 70.0;
  double radius = 0.0;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    animationRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = animationRadiusOut.value * initialRadius;
        }
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animationRadiusIn.value * initialRadius;
        }
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    //return Text("Loading...");
    return Container(
      width: 100.0,
      height: 100.0,
      child: Stack(children: <Widget>[
        Image.asset('images/solon.png'),
        Center(
          child: RotationTransition(
            turns: animationRotation,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(
                      radius * cos(0 * pi / 4), radius * sin(0 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(1 * pi / 4), radius * sin(1 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                  child: Circle(
                    radius: 5.0,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class Circle extends StatelessWidget {
  final double radius;
  final Color color;

  Circle({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(color: this.color, shape: BoxShape.circle),
      ),
    );
  }
}
