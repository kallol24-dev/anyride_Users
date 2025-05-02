import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../business/driver_provider.dart';
import '../../socket/socket.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  LatLng? _initialCameraPosition;
  late GoogleMapController _mapController;
  String? _mapStyle;
  final Set<Marker> _markers = {};
  // final LatLng _driverHub = LatLng(25.5767116, 91.8816341); //center
  LatLng? currentLatLng;
  SocketService socketService = SocketService();

  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    // Load map style from asset
    // rootBundle.loadString('assets/map_style.txt').then((string) {
    //   _mapStyle = string;
    // });
    _liveLocation();

    //socketService.getNearByDrivers();
  }

  Future<void> _showAvailableDrivers(SocketService socketService) async {
    BitmapDescriptor customIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/rider-marker.png',
    );
    socketService.connectAndSubscribe();
    //final  availableDrivers = await socketService.getNearByDriversStream();
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
              markerId: MarkerId(user['driverId'].toString()),
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

    // Inside your method:
    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) async {
      LatLng currPosition = LatLng(position.latitude, position.longitude);
      print("Current Position ...........................${currPosition}");

      setState(() {
        currentLatLng = currPosition;
        _initialCameraPosition = LatLng(position.latitude, position.longitude);
      });
      print("Current Latlang ...........................${currPosition}");
      Placemark place = await _getPlaceFromCoordinates();

      socketService.connectAndSubscribe();
      var driver = ref.watch(driverNotifierProvider);
      socketService.sendUsersLocation(
        userID: driver.id,
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

    Placemark place = placemarks[0];
    // print(
    //   "${place.name}, ${place.locality}, ${place.country}, ${place.postalCode}",
    // );
    return place;
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
                  //
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

Widget textFieldWidget() {
  return Positioned(
    top: 170,
    left: 20,
    right: 20,
    child: Container(
      width: Get.width,
      // height: 50,
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
        onTap: () => (),
        // validator: (input)=> validator(input),
        // controller: controller,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xffA7A7A7),
        ),
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(Icons.search, color: Colors.green),
          ),
          border: InputBorder.none,
        ),
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
