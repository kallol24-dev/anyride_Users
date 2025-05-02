import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

class MapUser with ClusterItem {
  final String id;
  final String name;
  final LatLng latLng;
  final double hue;

  MapUser({
    required this.id,
    required this.name,
    required this.latLng,
    required this.hue,
  });

  @override
  LatLng get location => latLng;
}


