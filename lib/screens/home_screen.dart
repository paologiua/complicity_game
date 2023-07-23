
// import 'package:complicity_game/models/floating_button_model.dart';
// import 'package:complicity_game/models/step_model.dart';
// import 'package:flutter/material.dart';

// import '../widgets/list_item.dart';
// import '../widgets/player_selector_foreground.dart';
// import '../widgets/popup.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int stepIndex = 0;
//   List<String> players = [];
//   bool playerSelectorClosed = true;

//   StepModel getCurrentStep() {
//     return steps[stepIndex];
//   }

//   void prevStep() {
//     setState(() {
//       if (stepIndex > 0) {
//         stepIndex--;
//       }
//     });
//   }

//   void nextStep() {
//     setState(() {
//       if (stepIndex < steps.length - 1) {
//         stepIndex++;
//       }
//     });
//   }

//   void addPlayer(String playerName) {
//     setState(() {
//       players.add(playerName);
//     });
//   }

//   void openPlayerSelector() {
//     setState(() {
//       playerSelectorClosed = false;
//     });
//   }

//   void closePlayerSelector() {
//     setState(() {
//       playerSelectorClosed = true;
//     });
//   }

//   void Function() getAction(String action) {
//     switch (action) {
//       case "prevStep":
//         return () => prevStep();
//       case "nextStep":
//         return () => nextStep();
//       case "openPlayerSelector":
//         return () => openPlayerSelector();
//     }
//     return () {};
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF6D819A),
//       body: Container(
//         padding: const EdgeInsets.all(20.0),
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFF788AA3),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20.0),
//                   child: ListView(
//                     children: [
//                       const SizedBox(height: 212.0),
//                       ...players
//                           .map((playerName) => Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 15.0),
//                                 child: ListItem(
//                                     text: playerName,
//                                     color: const Color(0xFFB2C9AB),
//                                     borderColor: const Color(0xFFA6C19F),
//                                     onTap: openPlayerSelector),
//                               ))
//                           .toList(),
//                       const SizedBox(height: 96.0),
//                     ],
//                   ),
//                 ),
//                 Popup(
//                   color: getCurrentStep().color,
//                   borderColor: getCurrentStep().borderColor,
//                   icon: Icon(getCurrentStep().icon, size: 48.0),
//                   alignment: getCurrentStep().alignment,
//                   text: Text(
//                     getCurrentStep().text,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 18.0,
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF788AA3),
//                           Color(0xBB788AA3),
//                           Color(0x00788AA3),
//                         ],
//                         begin: FractionalOffset(0.0, 1.0),
//                         end: FractionalOffset(0.0, 0.0),
//                         stops: [0.0, 0.3, 1.0],
//                         tileMode: TileMode.clamp,
//                       ),
//                     ),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: getCurrentStep()
//                             .floatingButtons
//                             .map(
//                               (button) => Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: FloatingActionButton(
//                                   onPressed: getAction(button.action),
//                                   backgroundColor: button.backgroundColor,
//                                   elevation: 0,
//                                   highlightElevation: 0,
//                                   child: Icon(
//                                     button.icon,
//                                     color: button.color,
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .toList()),
//                   ),
//                 ),
//                 AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   switchInCurve: Curves.easeOutCirc,
//                   switchOutCurve: Curves.easeOutCirc,
//                   transitionBuilder:
//                       (Widget child, Animation<double> animation) =>
//                           FadeTransition(opacity: animation, child: child),
//                   child: !playerSelectorClosed
//                       ? PlayerSelectorForeground(
//                           onKeyboardChange: (visible) {
//                             if (!visible) {
//                               closePlayerSelector();
//                             }
//                           },
//                           onSubmitted: (text) => addPlayer(text),
//                           onCancel: () => closePlayerSelector(),
//                         )
//                       : null,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
