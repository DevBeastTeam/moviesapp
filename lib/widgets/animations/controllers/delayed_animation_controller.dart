// // ignore_for_file: prefer_final_fields

// part of delayed_animation;

// class DelayedAnimationController {
//   final bool autoStart;

//   List<VoidCallback> _startAnimations = [];

//   void startAnimation() => _c(_startAnimations);

//   List<VoidCallback> _forwardAnimations = [];

//   void forward() => _c(_forwardAnimations);

//   List<VoidCallback> _reverseAnimations = [];

//   void reverse() => _c(_reverseAnimations);

//   void _c(l) {
//     for (VoidCallback f in l) {
//       try {
//         f.call();
//       } catch (_) {
//         _reverseAnimations.remove(f);
//       }
//     }
//   }

//   VoidCallback? onFinished;

//   DelayedAnimationController({this.autoStart = true, this.onFinished});
// }
