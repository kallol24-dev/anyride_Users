import 'package:anyride_captain/business/graph_client_provider.dart';
import 'package:anyride_captain/models/location.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/user.dart';

class TripRequest {
  Future<Map<String, dynamic>?> requestForTrip(
    LocationState location,
    User user,
  ) async {
    final client = await getGraphQLClient();

    const String mutation = """
    mutation tripRequest(\$input: BookingDto!) {
      tripRequest(input: \$input) {
      bookingId
      bookingStatus
      broadcastToDriver
      }
    }
  """;

    final payload = {
      "userId": user.id,
      "userCoordinates": [user.coordinates.lat, user.coordinates.lan],
      "sourceCoordinates": [
        location.pickupLatLng?.latitude,
        location.pickupLatLng?.longitude,
      ],
      "destinationCoordinates": [
        location.dropLatLng?.latitude,
        location.dropLatLng?.longitude,
      ],
    };

    final options = MutationOptions(
      document: gql(mutation),
      variables: {"input": payload},
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      print("GraphQL Error: ${result.exception.toString()}");
      return null;
    }

    return result.data?["tripRequest"] as Map<String, dynamic>?;
  }
}
