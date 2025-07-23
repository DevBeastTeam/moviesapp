// part of delayed_animation;

// class _MultipleDelayedAnimationView extends State<MultipleDelayedAnimation> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.children.length > 1) {
//       var widgets = <Widget>[];
//       for (var i = 0; i < widget.children.length; i++) {
//         widgets.add(
//           DelayedAnimation(
//             duration: Duration(
//               microseconds:
//                   widget.firstDuration.inMilliseconds +
//                   (widget.intervalDuration.inMilliseconds * i),
//             ),
//             controller: widget.delayedAnimationController,
//             animationOffSet: widget.animationOffSet,
//             child: widget.children[i],
//           ),
//         );
//       }
//       return widget.axis == MultipleDelayedAnimationAxis.horizontal
//           ? Row(
//               mainAxisAlignment: widget.mainAxisAlignment,
//               mainAxisSize: widget.mainAxisSize,
//               crossAxisAlignment: widget.crossAxisAlignment,
//               children: widgets,
//             )
//           : Column(
//               mainAxisAlignment: widget.mainAxisAlignment,
//               mainAxisSize: widget.mainAxisSize,
//               crossAxisAlignment: widget.crossAxisAlignment,
//               children: widgets,
//             );
//     } else {
//       return DelayedAnimation(
//         duration: widget.firstDuration,
//         animationOffSet: widget.animationOffSet,
//         child: widget.children.first,
//       );
//     }
//   }
// }
