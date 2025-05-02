// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import '../../common/colorPalette.dart';
// import '../../common/Alert_box.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late GoogleMapController _mapController;

//   LatLng _initialCameraPosition = const LatLng(25.5679185, 91.8806332);
//   final Set<Marker> _markers = {};
//   final Set<Circle> _circles = {};
//   final LatLng _driverHub = LatLng(25.5767116, 91.8816341); //center
//   bool _isOnline = false;
//   LatLng? currentLatLng;

//   final List<Map<String, dynamic>> _staticUsers = [
//     {
//       'id': 'user1',
//       'name': 'Alice',
//       'lat': 25.567,
//       'lng': 91.880,
//       'color': BitmapDescriptor.hueBlue,
//     },
//     {
//       'id': 'user2',
//       'name': 'Bob',
//       'lat': 25.568,
//       'lng': 91.881,
//       'color': BitmapDescriptor.hueBlue,
//     },
//     {
//       'id': 'user3',
//       'name': 'Charlie',
//       'lat': 25.5665,
//       'lng': 91.879,
//       'color': BitmapDescriptor.hueBlue,
//     },
//   ];

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _setCurrentLocation();
//   }

//   Future<void> _setCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever)
//         return;
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     currentLatLng = LatLng(position.latitude, position.longitude);

//     setState(() {
//       _initialCameraPosition = currentLatLng!;
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('current_location'),
//           position: currentLatLng!,
//           infoWindow: const InfoWindow(title: 'You are here'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//       _circles.add(
//         Circle(
//           circleId: const CircleId('driver_radius'),
//           center: _driverHub,
//           radius: 5000, // Radius in meters (5 km)
//           fillColor: Colors.blue.withOpacity(0.1),
//           strokeColor: Colors.blueAccent,
//           strokeWidth: 2,
//         ),
//       );
//     });

//     _addUserMarkers();
//     _fitAllMarkers();
//   }

//   void _addUserMarkers() {
//     for (var user in _staticUsers) {
//       _markers.add(
//         Marker(
//           markerId: MarkerId(user['id']),
//           position: LatLng(user['lat'], user['lng']),
//           infoWindow: InfoWindow(title: user['name']),
//           icon: BitmapDescriptor.defaultMarkerWithHue(user['color']),
//         ),
//       );
//     }
//     setState(() {});
//   }

//   void _fitAllMarkers() {
//     if (_markers.isEmpty) return;

//     LatLngBounds bounds;
//     var positions = _markers.map((m) => m.position).toList();

//     double x0 = positions
//         .map((p) => p.latitude)
//         .reduce((a, b) => a < b ? a : b);
//     double x1 = positions
//         .map((p) => p.latitude)
//         .reduce((a, b) => a > b ? a : b);
//     double y0 = positions
//         .map((p) => p.longitude)
//         .reduce((a, b) => a < b ? a : b);
//     double y1 = positions
//         .map((p) => p.longitude)
//         .reduce((a, b) => a > b ? a : b);

//     bounds = LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));

//     _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
//   }

//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: _scaffoldKey,
//         resizeToAvoidBottomInset: false,
//         drawer: _buildProfileDrawer(),
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: CameraPosition(
//                   target: _initialCameraPosition,
//                   zoom: 1,
//                 ),
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//                 zoomControlsEnabled: true,
//                 markers: _markers,
//                 circles: _circles,
//               ),
//             ),
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: IconButton(
//                     iconSize: 40,
//                     icon: Icon(Icons.menu, size: 30, color: Colors.black),
//                     onPressed: () {
//                       _scaffoldKey.currentState!.openDrawer();
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Align(
//                   alignment: Alignment.topCenter,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Switch(
//                         value: _isOnline,
//                         onChanged: (value) async {
//                           if (value) {
//                             final confirmed = await showDialog<bool>(
//                               context: context,
//                               builder:
//                                   (context) => AlertDialog(
//                                     title: const Text('Start Earning?'),
//                                     content: const Text(
//                                       'Do you want to go online and start earning?',
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         onPressed:
//                                             () => Navigator.of(
//                                               context,
//                                             ).pop(false),
//                                         child: const Text('Cancel'),
//                                       ),
//                                       TextButton(
//                                         onPressed:
//                                             () =>
//                                                 Navigator.of(context).pop(true),
//                                         child: const Text('Yes'),
//                                       ),
//                                     ],
//                                   ),
//                             );

//                             if (confirmed == true) {
//                               setState(() {
//                                 _isOnline = true;
//                               });
//                               AlertBox.showSnackBar(
//                                 context,
//                                 'Online: ${currentLatLng?.latitude}, ${currentLatLng?.longitude}',
//                               );
//                             }
//                           } else {
//                             setState(() {
//                               _isOnline = false;
//                             });
//                             AlertBox.showSnackBar(context, 'Offline');
//                           }
//                         },
//                         activeColor: Colors.orangeAccent,
//                         inactiveThumbColor: Colors.red,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: selectedIndex,
//           onTap: (currentIndex) {},
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.car_rental),
//               label: 'Trip',
//             ),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colorpalette.bgPrimary,
//               image: DecorationImage(
//                 image: AssetImage('assets/images/background.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundImage: NetworkImage(
//                     'https://picsum.photos/seed/107/600',
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Kallol Dhar',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colorpalette.txtPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 RatingBar.builder(
//                   onRatingUpdate: (newValue) {},
//                   itemBuilder:
//                       (context, _) => Icon(
//                         Icons.star_rounded,
//                         color: Color.fromARGB(255, 229, 222, 202),
//                       ),
//                   direction: Axis.horizontal,
//                   initialRating: 3,
//                   itemCount: 5,
//                   itemSize: 30,
//                   glowColor: Colors.red,
//                 ),
//               ],
//             ),
//           ),
//           _buildDrawerItem(Icons.person, 'Personal Details', () {}),
//           _buildDrawerItem(Icons.directions_car, 'Vehicle Details', () {}),
//           _buildDrawerItem(Icons.info, 'About us', () {}),
//           _buildDrawerItem(Icons.settings, 'Settings', () {}),
//           _buildDrawerItem(
//             Icons.logout,
//             'Log out',
//             () {},
//             iconColor: Colors.red,
//             textColor: Colors.red,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     IconData icon,
//     String title,
//     VoidCallback onTap, {
//     Color iconColor = Colors.black,
//     Color textColor = Colors.black,
//   }) {
//     return Column(
//       children: [
//         ListTile(
//           leading: Icon(icon, color: iconColor),
//           title: Text(title, style: TextStyle(color: textColor)),
//           trailing: Icon(Icons.arrow_forward_ios, size: 16),
//           onTap: onTap,
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
