import 'package:anyride_captain/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/location.dart';
import '../models/user.dart';

class LocationProvider extends Notifier<LocationState> {
  @override
  LocationState build() {
    return LocationState.empty(); // Return an empty driver instance
  }

  void updatePickupLocation(LatLng latLng, String pincode) {
    state = state.copyWith(pickupLatLng: latLng, pickupPincode: pincode);
  }

  void updateDropLocation(LatLng latLng, String pincode) {
    state = state.copyWith(dropLatLng: latLng, dropPincode: pincode);
  }
}

final locationProvider = NotifierProvider<LocationProvider, LocationState>(() {
  return LocationProvider();
});
