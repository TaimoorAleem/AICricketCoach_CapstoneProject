// import 'package:flutter/material.dart';
// import 'package:ai_cricket_coach/features/video_upload/presentation/pages/upload_video.dart';
// import 'package:ai_cricket_coach/resources/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SessionsManagerPage extends StatefulWidget {
//   const SessionsManagerPage({Key? key}) : super(key: key);
//
//   @override
//   State<SessionsManagerPage> createState() => _SessionsManagerPageState();
// }
//
// class _SessionsManagerPageState extends State<SessionsManagerPage> {
//   String? sessionId;
//   List deliveries = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadActiveSession();
//   }
//
//   Future<void> _loadActiveSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     sessionId = prefs.getString('active_session_id');
//     if (sessionId != null) {
//       final session = SessionCache().getSessionById(sessionId!);
//       setState(() {
//         deliveries = session?.deliveries ?? [];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Session Manager"),
//         backgroundColor: AppColors.secondary,
//       ),
//       body: sessionId == null
//           ? const Center(child: Text("No active session."))
//           : Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text("Active Session ID: $sessionId"),
//           ),
//           Expanded(
//             child: deliveries.isEmpty
//                 ? const Center(child: Text("No deliveries yet."))
//                 : ListView.builder(
//               itemCount: deliveries.length,
//               itemBuilder: (context, index) {
//                 final delivery = deliveries[index];
//                 return ListTile(
//                   title: Text("Delivery ${index + 1}"),
//                   subtitle: Text(
//                       "Ball Speed: ${delivery.ballSpeed} km/h, Line: ${delivery.ballLine}, Length: ${delivery.ballLength}"),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => DeliveryDetailsPage(
//                           deliveryId: delivery.deliveryId,
//                           sessionId: sessionId!,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const UploadVideoPage(),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.add),
//               label: const Text("Add New Delivery"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }