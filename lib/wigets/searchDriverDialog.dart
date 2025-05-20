import 'package:anyride_captain/business/userProvider.dart';
import 'package:anyride_captain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../business/locationState.dart';
import '../../models/user.dart';
import '../../services/trip_service.dart';
import '../../socket/socket.dart';
import '../services/secure_storage_service.dart';

class SearchingDriverDialog extends ConsumerStatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final VoidCallback onDriverFound;

  const SearchingDriverDialog({
    Key? key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.onDriverFound,
  }) : super(key: key);

  @override
  ConsumerState<SearchingDriverDialog> createState() =>
      _SearchingDriverDialogState();
}

class _SearchingDriverDialogState extends ConsumerState<SearchingDriverDialog> {
  @override
  void initState() {
    super.initState();
    _initTripRequest();
  }

  Future<void> _initTripRequest() async {
    final tripRequest = TripRequest();
    final loc = ref.read(locationProvider);
    AuthService authService = AuthService();
    String? id = await authService.getUserId();
    final userNotifier = ref.watch(userNotifierProvider.notifier);
    userNotifier.updateUserId(id!);
    final user = ref.read(userNotifierProvider);

    try {
      final response = await tripRequest.requestForTrip(loc, user);

      if (response != null) {
        print("Trip request successful: $response");

        final user = ref.read(userNotifierProvider);
        SocketService socketService = SocketService();
        socketService.connectAndSubscribe();
        socketService.validateTripDetails(
          userID: user.id,
          bookingID: response['bookingId'],
        );
        socketService
            .getLiveTripUpdates(bookingID: response['bookingId'])
            .listen((tripDetails) {
              print("The Trip Details: $tripDetails");
            });

        // Close the dialog and notify parent that a driver was found
        widget.onDriverFound();
        if (mounted) {
          Navigator.of(context).pop();
        }
        ; // dismiss dialog
      } else {
        print("Trip request failed or returned null");
        if (mounted) Navigator.of(context).pop(); // dismiss dialog
      }
    } catch (e) {
      print("Error during trip request: $e");
      if (mounted) Navigator.of(context).pop(); // dismiss dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            Text(
              'Looking for nearby drivers...',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
