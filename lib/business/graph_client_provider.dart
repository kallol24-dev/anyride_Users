import 'package:graphql_flutter/graphql_flutter.dart';

import '../services/secure_storage_service.dart';

Future<GraphQLClient> getGraphQLClient() async {
  final storage = SecureStorage();
  final jwtToken = await storage.getToken();

  print("Fetched JWT Token: $jwtToken");

  final HttpLink httpLink = HttpLink(
    // "http://192.168.29.142/anyride-backend/graphql",
    "http://192.168.29.2:8003/graphql",
    defaultHeaders: {
      if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      'Content-Type': 'application/json',
    },
  );

  return GraphQLClient(link: httpLink, cache: GraphQLCache());
}
