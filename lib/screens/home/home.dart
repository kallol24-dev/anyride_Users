import 'dart:async';

import 'package:anyride_captain/business/userProvider.dart';
import 'package:anyride_captain/models/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../business/driver_provider.dart';
import '../../business/locationState.dart';
import '../../services/auth_service.dart';
import '../../services/place_service.dart';
import '../../services/trip_service.dart';
import '../../socket/socket.dart';
import '../../wigets/searchDriverDialog.dart';
import '../drivers/search_drivers.dart';

class HomeScreen2 extends ConsumerStatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen2> {
  LatLng? _initialCameraPosition;
  late GoogleMapController _mapController;
  String? _mapStyle;
  final Set<Marker> _markers = {};
  LatLng? currentLatLng;
  SocketService socketService = SocketService();

  StreamSubscription<Position>? positionStream;

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();

  final PlacesService placesService = PlacesService(
    "AIzaSyBiliqjmbfaoeuu4w_pvKDtp-Gff_AUyiU",
  );

  void _showLocationInputSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter Your Trip Details',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildAutoCompleteField(
                  label: "Pickup Location",
                  controller: _pickupController,
                  onLocationSelected: (latLng, pincode) {
                    ref
                        .read(locationProvider.notifier)
                        .updatePickupLocation(latLng, pincode!);
                  },
                ),
                SizedBox(height: 10),
                _buildAutoCompleteField(
                  label: "Destination",
                  controller: _dropController,
                  onLocationSelected: (latLng, pincode) {
                    ref
                        .read(locationProvider.notifier)
                        .updateDropLocation(latLng, pincode!);
                  },
                ),
                const SizedBox(height: 24),
                greenButton('Confirm', () async {
                  final loc = ref.read(locationProvider);

                  print("Pickup: ${loc.pickupLatLng}, ${loc.pickupPincode}");
                  print("Drop: ${loc.dropLatLng}, ${loc.dropPincode}");
                  // Step 1: Show loader
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text("Searching for drivers..."),
                          ],
                        ),
                      );
                    },
                  );
                  int bookingId = await _initTripRequest();
                  late StreamSubscription tripSub;
                  socketService.connectAndSubscribe();
                  tripSub = socketService
                      .getLiveTripUpdates(bookingID: bookingId)
                      .listen((update) {
                        print("Trip update received: $update");

                        // Check if the driver has accepted the trip
                        if (update['status'] == 'ACCEPTED') {
                          // Close the loader
                          Navigator.of(context).pop();

                          // Stop listening
                          tripSub.cancel();

                          // Navigate or update map with driver info
                          _showTrip(socketService);
                        }
                      });
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _liveLocation();
  }

  Future<int> _initTripRequest() async {
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
        return response['bookingId'];

        // Close the dialog and notify parent that a driver was found
      } else {
        print("Trip request failed or returned null");
      }
    } catch (e) {
      print("Error during trip request: $e");
    }
    return 0;
  }

  Future<void> _showAvailableDrivers(SocketService socketService) async {
    BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/rider-marker.png',
    );
    socketService.connectAndSubscribe();
    socketService.getNearByDriversStream().listen((availableDrivers) {
      _markers.clear();
      for (var user in availableDrivers) {
        double lat =
            user['lat'] is String ? double.parse(user['lat']) : user['lat'];
        double lng =
            user['lng'] is String ? double.parse(user['lng']) : user['lng'];
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(user['id'].toString()),
              position: LatLng(lat, lng),
              icon: customIcon,
            ),
          );
        });
      }
    });
  }

  Future<void> _showTrip(SocketService socketService) async {
    BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/rider-marker.png',
    );
    socketService.connectAndSubscribe();
    socketService.getNearByDriversStream().listen((availableDrivers) {
      _markers.clear();
      for (var user in availableDrivers) {
        double lat =
            user['lat'] is String ? double.parse(user['lat']) : user['lat'];
        double lng =
            user['lng'] is String ? double.parse(user['lng']) : user['lng'];
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(user['id'].toString()),
              position: LatLng(lat, lng),
              icon: customIcon,
            ),
          );
        });
      }
    });
  }

  Future<void> _liveLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever)
        return;
    }

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    Position position = await Geolocator.getCurrentPosition();

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) async {
      LatLng currPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        currentLatLng = currPosition;
        _initialCameraPosition = currPosition;
      });

      Placemark place = await _getPlaceFromCoordinates();
      // _pickupController.text =
      //     "\${place.name}, \${place.locality}, \${place.postalCode}";

      socketService.connectAndSubscribe();
      final userNotifier = ref.watch(userNotifierProvider.notifier);
      final userState = ref.watch(userNotifierProvider);
      Coordinates coordinates = Coordinates(
        lat: currentLatLng!.latitude,
        lan: currentLatLng!.longitude,
      );
      userNotifier.updateCoordinates(coordinates);
      userNotifier.updateUserId(userState.id);
      socketService.sendUsersLocation(
        userID: userState.id,
        pincode: place.postalCode!,
        lat: currentLatLng!.latitude,
        lng: currentLatLng!.longitude,
      );
      _showAvailableDrivers(socketService);
    });
  }

  Future<Placemark> _getPlaceFromCoordinates() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      currentLatLng!.latitude,
      currentLatLng!.longitude,
    );
    return placemarks[0];
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _recenterMap() {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _initialCameraPosition!, zoom: 18),
      ),
    );
  }

  Widget _buildAutoCompleteField({
    required String label,
    required TextEditingController controller,
    required void Function(LatLng latLng, String? pincode) onLocationSelected,
  }) {
    return TypeAheadField<PlaceSuggestion>(
      suggestionsCallback: (pattern) async {
        return await placesService.getAutocomplete(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion.description));
      },
      onSelected: (suggestion) async {
        final details = await placesService.getPlaceDetails(suggestion.placeId);

        // if (label.toLowerCase().contains("pickup location")) {
        //   _pickupController.text = details['description'];
        // } else {
        //   _dropController.text = details['description'];
        // }
        controller.text = details['description'];
        onLocationSelected(
          LatLng(details['lat'], details['lng']),
          details['pincode'],
        );
      },
      builder: (context, fieldController, focusNode) {
        return TextField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.text = value;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCameraPosition == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialCameraPosition!,
                zoom: 18,
              ),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              markers: _markers,
              style: _mapStyle,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.9,
            left: 10,
            child: FloatingActionButton(
              mini: true,
              onPressed: _recenterMap,
              child: Icon(Icons.my_location),
            ),
          ),
          buildProfileTile(),
          textFieldWidget(),
        ],
      ),
    );
  }

  Widget textFieldWidget() {
    return Positioned(
      top: 170,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          readOnly: true,
          onTap: () => _showLocationInputSheet(context),
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xffA7A7A7),
          ),
          decoration: InputDecoration(
            hintText: "Enter destination",
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Icon(Icons.search, color: Colors.green),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

bool show = true;
Widget buildProfileTile() {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child:
        show == false
            ? Center(child: CircularProgressIndicator())
            : Container(
              width: Get.width,
              height: Get.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: Colors.white70),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Good Morning, ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: "Kallol Dhar",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Where are you going?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
  );
}

Widget greenButton(String title, Function onPressed) {
  return MaterialButton(
    minWidth: Get.width,
    height: 50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    color: Colors.green,
    onPressed: () => onPressed(),
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
