import 'dart:math';

import 'package:flutter/material.dart';

class LoadAnimation extends StatefulWidget {
  const LoadAnimation(
      {super.key, this.radiusToCenter, this.numberDot, this.sizeDot});

  final double? radiusToCenter;
  final int? numberDot;
  final double? sizeDot;

  @override
  State<LoadAnimation> createState() => _LoadAnimationState();
}

class _LoadAnimationState extends State<LoadAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> aRotation;
  late Animation<double> aRadiusIn;
  late Animation<double> aRadiusOut;

  late final int numberDot;
  late final double radiusToCenter;
  late final double sizeDot;

  double currentRadius = 0;

  List<Transform> dots = [];

  @override
  void initState() {
    super.initState();

    numberDot = widget.numberDot ?? 10;
    radiusToCenter = widget.radiusToCenter ?? 15;
    sizeDot = widget.sizeDot ?? 5;

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    aRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 1, curve: Curves.linear),
      ),
    );

    aRadiusIn = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 1, curve: Curves.elasticIn),
      ),
    );

    aRadiusOut = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          currentRadius = aRadiusIn.value * radiusToCenter;
        } else if (controller.value >= 0 && controller.value <= 0.25) {
          currentRadius = aRadiusOut.value * radiusToCenter;
        }
      });
    });

    controller.repeat();

    setDots();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setDots();

    return Container(
      width: 100,
      height: 100,
      child: Center(
        child: RotationTransition(
          turns: aRotation,
          child: Stack(
            children: [
              ...dots,
            ],
          ),
        ),
      ),
    );
  }

  void setDots() {
    dots = Iterable<int>.generate(numberDot).toList().map((number) {
      return Transform.translate(
        offset: Offset(currentRadius * cos(number * pi / (numberDot / 2)),
            currentRadius * sin(number * pi / (numberDot / 2))),
        child: Dot(
            radius: sizeDot, color: const Color.fromARGB(255, 255, 255, 255)),
      );
    }).toList();
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key, required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

// Class _LoadAnimationState extends State<LoadAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;

//   late Animation<double> aRotation;
//   late Animation<double> aRadiusIn;
//   late Animation<double> aRadiusOut;

//   final int numberDot = 10;
//   final double radiusToCenter = 30;

//   double currentRadius = 0;

//   List<Transform> dots = [];

//   @override
//   void initState() {
//     super.initState();

//     controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 5));

//     aRotation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: const Interval(0, 1, curve: Curves.linear),
//       ),
//     );

//     aRadiusIn = Tween<double>(begin: 1, end: 0).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: const Interval(0.75, 1, curve: Curves.elasticIn),
//       ),
//     );

//     aRadiusOut = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: const Interval(0, 0.25, curve: Curves.elasticOut),
//       ),
//     );

//     controller.addListener(() {
//       setState(() {
//         if (controller.value >= 0.75 && controller.value <= 1.0) {
//           currentRadius = aRadiusIn.value * radiusToCenter;
//         } else if (controller.value >= 0 && controller.value <= 0.25) {
//           currentRadius = aRadiusOut.value * radiusToCenter;
//         }
//       });
//     });

//     controller.repeat();

//     setDots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     setDots();

//     return Container(
//       width: 100,
//       height: 100,
//       child: Center(
//         child: RotationTransition(
//           turns: aRotation,
//           child: Stack(
//             children: [
//               const Dot(
//                 radius: 30,
//                 color: Colors.white,
//               ),
//               ...dots,
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void setDots() {
//     dots = Iterable<int>.generate(numberDot).toList().map((number) {
//       return Transform.translate(
//         offset: Offset(currentRadius * cos(number * pi / (numberDot / 2)),
//             currentRadius * sin(number * pi / (numberDot / 2))),
//         child: const Dot(radius: 10, color: Colors.red),
//       );
//     }).toList();
//   }
// }

// class Dot extends StatelessWidget {
//   const Dot({super.key, required this.radius, required this.color});

//   final double radius;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: radius,
//         height: radius,
//         decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//       ),
//     );
//   }
// }


