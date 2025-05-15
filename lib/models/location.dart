// import 'package:anyride_captain/models/coordinates.dart';
// import 'package:anyride_captain/models/user.dart';

// class TripCoordinates {
//   final Coordinates coordinates;
//   final String postalCode;

//   TripCoordinates({required this.coordinates, required this.postalCode});

//   factory TripCoordinates.empty() {
//     return TripCoordinates(coordinates: Coordinates.empty(), postalCode: "");
//   }
// }

// class Trip {
//   final String id;
//   final User user;
//   final TripCoordinates source;
//   final TripCoordinates destination;

//   Trip({
//     required this.id,
//     required this.source,
//     required this.destination,
//     required this.user,
//   });

//   factory Trip.empty() {
//     return Trip(id: '', user: User.empty(), source: TripCoordinates.empty(), destination: TripCoordinates.empty());
//   }
//   Map<String, dynamic> toTripRequest() {
//     return {
//       "user_id": user.id,
//       "userCoordinates": user.coordinates,
//       "sourceCoordinates": source.coordinates,
//       "destinationCoordinates": destination.coordinates,
//     };
//   }
// }
import 'package:anyride_captain/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState {
  final LatLng? pickupLatLng;
  final String? pickupPincode;
  final LatLng? dropLatLng;
  final String? dropPincode;
  

  LocationState({
    this.pickupLatLng,
    this.pickupPincode,
    this.dropLatLng,
    this.dropPincode,
    
  });

  factory LocationState.empty() {
    return LocationState(
      
      pickupLatLng: null,
      dropLatLng: null,
    );
  }

  LocationState copyWith({
    LatLng? pickupLatLng,
    String? pickupPincode,
    LatLng? dropLatLng,
    String? dropPincode,
   
  }) {
    return LocationState(
      pickupLatLng: pickupLatLng ?? this.pickupLatLng,
      pickupPincode: pickupPincode ?? this.pickupPincode,
      dropLatLng: dropLatLng ?? this.dropLatLng,
      dropPincode: dropPincode ?? this.dropPincode,
      
    );
  }

 
}
