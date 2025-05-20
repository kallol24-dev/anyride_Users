// import 'package:anyride_captain/business/userProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../business/locationState.dart';
// import '../../models/user.dart';
// import '../../services/trip_service.dart';
// import '../../socket/socket.dart';

// class SearchingDriverScreen extends ConsumerStatefulWidget {
//   final String pickupAddress;
//   final String dropAddress;
//   final User user;

//   const SearchingDriverScreen({
//     Key? key,
//     required this.pickupAddress,
//     required this.dropAddress,
//     required this.user,
//   }) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return _SearchingDriverScreenState();
//   }
// }

// class _SearchingDriverScreenState extends ConsumerState<SearchingDriverScreen> {
//   bool isBookingId = false;
//   @override
//   void initState() {
//     final tripRequest = TripRequest();
//     final loc = ref.read(locationProvider);

//     _initTripRequest();
//   }

//   Future<void> _initTripRequest() async {
//     final tripRequest = TripRequest();
//     final loc = ref.read(locationProvider);

//     try {
//       final Map<String, dynamic>? response = await tripRequest.requestForTrip(
//         loc,
//         widget.user,
//       );

//       if (response != null) {
//         isBookingId = true;
//         print("Trip request successful: $response");
//         SocketService socketService = SocketService();
//         final user = ref.read(userNotifierProvider);
//         socketService.validateTripDetails(
//           userID: user.id,
//           bookingID: response['bookingId'],
//         );

//         // Do something with the response
//       } else {
//         print("Trip request failed or returned null");
//       }
//     } catch (e) {
//       print("Error during trip request: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(color: Colors.green),
//               const SizedBox(height: 24),
//               Text(
//                 'Please wait while we connect you to nearby drivers...',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(Icons.my_location, color: Colors.green),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             widget.pickupAddress,
//                             style: GoogleFonts.poppins(fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             widget.dropAddress,
//                             style: GoogleFonts.poppins(fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),
//               Text(
//                 'Looking for nearby drivers...',
//                 style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:anyride_captain/business/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../business/locationState.dart';
import '../../models/user.dart';
import '../../services/trip_service.dart';
import '../../socket/socket.dart';

class SearchingDriverScreen extends ConsumerStatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final User user;

  const SearchingDriverScreen({
    Key? key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.user,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SearchingDriverScreenState();
  }
}

class _SearchingDriverScreenState extends ConsumerState<SearchingDriverScreen> {
  bool hasValidBooking = false;

  @override
  void initState() {
    super.initState();
    _initTripRequest(); // Call in initState safely
  }

  Future<void> _initTripRequest() async {
    final tripRequest = TripRequest();
    final loc = ref.read(locationProvider);

    try {
      final Map<String, dynamic>? response = await tripRequest.requestForTrip(
        loc,
        widget.user,
      );

      if (response != null) {
        setState(() {
          hasValidBooking = true;
        });

        print("Trip request successful: $response");

        final user = ref.read(userNotifierProvider);
        SocketService().validateTripDetails(
          userID: user.id,
          bookingID: response['bookingId'],
        );
      } else {
        print("Trip request failed or returned null");
      }
    } catch (e) {
      print("Error during trip request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          hasValidBooking
              ? _buildDriverFoundScreen() // Show map or driver details
              : _buildSearchingScreen(), // Show waiting spinner
    );
  }

  Widget _buildSearchingScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.green),
            const SizedBox(height: 24),
            Text(
              'Please wait while we connect you to nearby drivers...',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.pickupAddress,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.dropAddress,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Looking for nearby drivers...',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverFoundScreen() {
    return const Center(
      child: Text(
        "Driver found! Displaying map or driver info...",
        style: TextStyle(fontSize: 18),
      ),
    );

    // TODO: Replace this with actual map widget and driver info
  }
}
