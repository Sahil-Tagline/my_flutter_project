// import 'package:flutter/material.dart';
// import 'package:mobeguard_app/config/theme/app_theme.dart';
//
// class CustomSwitch extends StatefulWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   final Color activeColor;
//
//   const CustomSwitch({
//     Key key,
//     this.value,
//     this.onChanged,
//     this.activeColor,
//   }) : super(key: key);
//
//   @override
//   CustomSwitchState createState() => CustomSwitchState();
// }
//
// class _CustomSwitchState extends State<CustomSwitch>
//     with SingleTickerProviderStateMixin {
//   Animation _circleAnimation;
//   AnimationController _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 60));
//     _circleAnimation = AlignmentTween(
//             begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
//             end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
//         .animate(CurvedAnimation(
//             parent: _animationController, curve: Curves.easeInBack));
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return GestureDetector(
//           onTap: () {
//             if (_animationController.isCompleted) {
//               _animationController.reverse();
//             } else {
//               _animationController.forward();
//             }
//             widget.value == false
//                 ? widget.onChanged(true)
//                 : widget.onChanged(false);
//           },
//           child: Container(
//             width: 52.0,
//             height: 26.0,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(13.0),
//               color: _circleAnimation.value == Alignment.centerLeft
//                   ? AppTheme.switchOff
//                   : widget.activeColor,
//             ),
//             child: Padding(
//               padding:
//                   EdgeInsets.only(top: 4.0, bottom: 4.0, right: 4.0, left: 4.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   _circleAnimation.value == Alignment.centerRight
//                       ? Padding(
//                           padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                           child: Container(),
//                         )
//                       : Container(),
//                   Align(
//                     alignment: _circleAnimation.value,
//                     child: Container(
//                       width: 22.0,
//                       height: 22.0,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.white),
//                     ),
//                   ),
//                   _circleAnimation.value == Alignment.centerLeft
//                       ? Padding(
//                           padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                           child: Container(),
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
