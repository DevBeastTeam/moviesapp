// import 'package:edutainment/widgets/ui/default_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../providers/exercisesVm.dart';
// import '../../widgets/header_bar/custom_header_bar.dart';
// import '../../widgets/loaders/dotloader.dart';

// class ExcersiseLessonsPage extends ConsumerStatefulWidget {
//   final String labelTitle;
//   // final List<Tag> lableOptionsList;
//   const ExcersiseLessonsPage({
//     super.key,
//     this.labelTitle = '',
//     // this.lableOptionsList = const [],
//   });

//   @override
//   ConsumerState<ExcersiseLessonsPage> createState() =>
//       _ExcersiseLessonsPageState();
// }

// class _ExcersiseLessonsPageState extends ConsumerState<ExcersiseLessonsPage> {
//   @override
//   Widget build(BuildContext context) {
//     var p = ref.watch(excerVm);
//     var t = Theme.of(context).textTheme;
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;

//     return DefaultScaffold(
//       currentPage: '',
//       child: Column(
//         children: [
//           SizedBox(
//             // height: MediaQuery.of(context).size.height * 0.2,
//             child: Column(
//               children: [
//                 CustomHeaderBar(
//                   onBack: () async {
//                     // context.pop();
//                     // Get.back();
//                     Navigator.pop(context);
//                   },
//                   centerTitle: false,
//                   title: 'Excersises',
//                 ),
//                 ///////////////
//                 const Text(
//                   'EXCERSISES',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 50),
//                 Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(0)),
//                     gradient: LinearGradient(
//                       colors: [Colors.orangeAccent, Colors.deepOrange],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: Center(
//                       child: Text(
//                         widget.labelTitle,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//               ],
//             ),
//           ),
//           p.loadingFor == "get"
//               ? Padding(
//                   padding: EdgeInsets.only(top: h * 0.35),
//                   child: const Center(child: DotLoader()),
//                 )
//               : p.excersiseList.isEmpty
//               ? Padding(
//                   padding: EdgeInsets.only(top: h * 0.35),
//                   child: Center(
//                     child: Text(
//                       'Empty',
//                       style: t.titleMedium!.copyWith(
//                         color: Colors.orange,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ),
//                 )
//               : SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.7,
//                   child: SingleChildScrollView(
//                     controller: ScrollController(),
//                     child: FixedTimeline.tileBuilder(
//                       builder: TimelineTileBuilder.connectedFromStyle(
//                         contentsAlign: ContentsAlign.alternating,
//                         contentsBuilder: (context, index) {
//                           var data = widget.lableOptionsList[index];
//                           return Padding(
//                             padding: const EdgeInsets.all(10),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ExLessonQuestionPage(
//                                       labelTitle: widget.labelTitle,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 height: 70,
//                                 width: MediaQuery.of(context).size.width * 0.4,
//                                 decoration: BoxDecoration(
//                                   borderRadius: const BorderRadius.all(
//                                     Radius.circular(15),
//                                   ),
//                                   gradient: LinearGradient(
//                                     colors: index >= 3
//                                         ? [
//                                             const Color.fromARGB(
//                                               255,
//                                               255,
//                                               210,
//                                               206,
//                                             ),
//                                             const Color.fromARGB(
//                                               255,
//                                               255,
//                                               156,
//                                               156,
//                                             ),
//                                           ]
//                                         : [
//                                             Colors.lightGreen,
//                                             Colors.lightGreen.shade200,
//                                           ],
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Text(
//                                     data.label,
//                                     style: TextStyle(
//                                       color: index >= 3
//                                           ? Colors.red
//                                           : Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         connectorStyleBuilder: (context, index) =>
//                             ConnectorStyle.dashedLine,
//                         indicatorStyleBuilder: (context, index) =>
//                             IndicatorStyle.dot,
//                         itemCount: widget.lableOptionsList.length,
//                       ),
//                     ),
//                   ),
//                 ),
//         ],
     
     
//       ),
   
   
//     );
//   }
// }
