import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/cat.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;

  @override
  void initState() {
    super.initState();

    boxController = AnimationController(vsync: this,
      duration: Duration(milliseconds: 200)
    );
    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
      CurvedAnimation(parent: boxController, curve: Curves.easeInOut)
    );
    boxAnimation.addStatusListener((status) {
      if (status.isCompleted) {
        boxController.reverse();
      } else if (status.isDismissed) {
        boxController.forward();
      }
    });
    boxController.forward();

    catController = AnimationController(vsync: this,
        duration: Duration(milliseconds: 200)
    );
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
        CurvedAnimation(parent: catController, curve: Curves.easeIn)
    );
  }

  onTap() {
    if (catController.isCompleted) {
      catController.reverse();
      boxController.forward();
    } else {
      catController.forward();
      boxController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap()
            ],
          ),
        )
      )
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
            top: catAnimation.value,
            right: 0,
            left: 0,
            child: child!
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
        left: 3,
        child: AnimatedBuilder(animation: boxAnimation,
            builder: (context, child) {
              return Transform.rotate(
                  alignment: Alignment.topLeft,
                  angle: boxAnimation.value,
                  child: child
              );
            },
            child: Container(
                height: 10,
                width: 125,
                color: Colors.brown
            )
        ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3,
      child: AnimatedBuilder(animation: boxAnimation,
          builder: (context, child) {
            return Transform.rotate(
                alignment: Alignment.topRight,
                angle: - boxAnimation.value,
                child: child
            );
          },
          child: Container(
              height: 10,
              width: 125,
              color: Colors.brown
          )
      ),
    );
  }
}