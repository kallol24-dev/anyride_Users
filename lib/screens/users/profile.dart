// import 'package:anyride_captain/business/auth_provider.dart';
// import 'package:anyride_captain/business/driver_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// final vehicleSectionExpandedProvider = StateProvider<bool>((ref) => false);

// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final driver = ref.watch(driverProvider);

   
//     Future.microtask(() {
//       ref.read(driverProvider.notifier).loadProfile(ref);
//     });

//     final vehicleSectionExpanded = ref.watch(vehicleSectionExpandedProvider);
//     return Scaffold(
//       body: Stack(
//         children: [
//           ClipPath(
//             clipper: ArcClipper(),
//             child: Container(
//               height: 340,
//               color: Color.fromRGBO(230, 17, 45, 0.8),
//             ),
//           ),
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 45),
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage: AssetImage(driver.profile),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   // driver.fullName,
//                   "Kallol Dhar",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 RatingBar.builder(
//                   initialRating: 4.5,
//                   minRating: 1,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   itemSize: 28,
//                   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
//                   itemBuilder:
//                       (context, _) => Icon(Icons.star, color: Colors.amber),
//                   onRatingUpdate: (rating) {},
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   driver.email,
//                   style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                 ),
//                 SizedBox(height: 16),
//                 _buildEditableField(ref, "phone", driver.phone, "Phone"),
//                 SizedBox(height: 16),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ExpansionTile(
//                     title: Text(
//                       "Vehicle Information",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurpleAccent,
//                       ),
//                     ),
//                     initiallyExpanded: vehicleSectionExpanded,
//                     tilePadding: EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     collapsedBackgroundColor: Colors.purple.shade50,
//                     backgroundColor: Colors.white,
//                     onExpansionChanged: (expanded) {
//                       ref.read(vehicleSectionExpandedProvider.notifier).state =
//                           expanded;
//                     },
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             _buildEditableField(
//                               ref,
//                               "vehicleModel",
//                               driver.vehicleModel,
//                               "Vehicle Model",
//                             ),
//                             SizedBox(height: 12),
//                             _buildEditableField(
//                               ref,
//                               "vehicleNumber",
//                               driver.vehicleNumber,
//                               "Vehicle Number",
//                             ),
//                             SizedBox(height: 12),
//                             _buildEditableField(
//                               ref,
//                               "vehicleColor",
//                               driver.vehicleColor,
//                               "Color",
//                             ),
//                             SizedBox(height: 12),
//                             _buildEditableField(
//                               ref,
//                               "dlNumber",
//                               driver.dlNumber,
//                               "License Number",
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 _buildEditableField(ref, "status", driver.status, "Status"),
//                 _buildEditableField(
//                   ref,
//                   "driverStatus",
//                   driver.driverStatus,
//                   "Driver Status",
//                 ),
//                 _buildEditableField(
//                   ref,
//                   "referralCode",
//                   driver.referralCode,
//                   "Referral Code",
//                 ),
//                 SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
//                   ),
//                   child: Text(
//                     "Logout",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     "Deactivate Account",
//                     style: TextStyle(
//                       color: Colors.purple,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditableField(
//     WidgetRef ref,
//     String field,
//     String value,
//     String label,
//   ) {
//     TextEditingController controller = TextEditingController(text: value);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.purple,
//           ),
//         ),
//         SizedBox(height: 4),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//           onSubmitted: (newValue) {
//             ref.read(driverProvider.notifier).updateField(field, newValue);
//           },
//         ),
//         SizedBox(height: 16),
//       ],
//     );
//   }
// }

// class ArcClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height - 70);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
