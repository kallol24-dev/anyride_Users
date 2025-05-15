import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// class PlaceSuggestion {
//   final String description;
//   final String placeId;

//   PlaceSuggestion({required this.description, required this.placeId});
// }

// class PlacesService {
//   final String apiKey;

//   PlacesService(this.apiKey);

//   Future<List<String>> getAutocomplete(String input) async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final predictions = data['predictions'] as List;
//       return predictions.map((p) => p['description'] as String).toList();
//     } else {
//       throw Exception('Failed to fetch suggestions');
//     }
//   }
// }

class PlaceSuggestion {
  final String description;
  final String placeId;

  PlaceSuggestion({required this.description, required this.placeId});
}

class PlacesService {
  final String apiKey;

  PlacesService(this.apiKey);

  Future<List<PlaceSuggestion>> getAutocomplete(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return (data['predictions'] as List)
          .map(
            (e) => PlaceSuggestion(
              description: e['description'],
              placeId: e['place_id'],
            ),
          )
          .toList();
    }

    return [];
  }

  Future<String?> _getPostalCodeFromCoordinates(
    double? lat,
    double? lan,
  ) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lan!);

    Placemark place = placemarks[0];
    // print(
    //   "${place.name}, ${place.locality}, ${place.country}, ${place.postalCode}",
    // );
    return place.postalCode;
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final result = data['result'];
      final location = result['geometry']['location'];
      final addressComponents = result['address_components'];

      // final postalCodeComponent = addressComponents.firstWhere(
      //   (comp) =>
      //       comp['types'] != null &&
      //       (comp['types'] as List).contains('postal_code'),
      //   orElse: () => null,
      // );
      final postalCode = await _getPostalCodeFromCoordinates(
        location['lat'],
        location['lng'],
      );

      // final lat = location['lat'];
      // final lng = location['lng'];
      // final postalCode =
      //     postalCodeComponent != null ? postalCodeComponent['long_name'] : '';

      return {
        'description': result['formatted_address'],
        'lat': location['lat'],
        'lng': location['lng'],
        'pincode': postalCode ?? '', // fallback empty
      };
    }

    return {};
  }
}
