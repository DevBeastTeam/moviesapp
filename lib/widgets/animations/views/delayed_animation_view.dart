// part of delayed_animation;

// class _DelayedAnimationView extends State<DelayedAnimation>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animationController;
//   late final CurvedAnimation _curvedAnimation;
//   late final Animation<Offset> _animationOffSet;

//   @override
//   void initState() {
//     _animationController =
//         AnimationController(vsync: this, duration: widget.duration);
//     _animationController.addListener(() => setState(() {}));
//     _curvedAnimation =
//         CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
//     _animationOffSet =
//         Tween<Offset>(begin: widget.animationOffSet.offset, end: Offset.zero)
//             .animate(_curvedAnimation);
//     if (widget.controller?.autoStart ?? true) {
//       _animationController.forward();
//     }
//     if (widget.controller != null) {
//       widget.controller!._startAnimations
//           .add(() => _animationController.forward());
//       widget.controller!._forwardAnimations
//           .add(() => _animationController.forward());
//       widget.controller!._reverseAnimations
//           .add(() => _animationController.reverse());
//       _animationController.addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           widget.controller!.onFinished?.call();
//         }
//       });
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _curvedAnimation.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//         opacity: _animationController,
//         child:
//             SlideTransition(position: _animationOffSet, child: widget.child));
//   }
// }
