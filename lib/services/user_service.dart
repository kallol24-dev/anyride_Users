import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/driver.dart';

import '../business/graph_client_provider.dart';

class UserService {
  // final GraphQLClient client;

  // ProfileService(this.client);

  Future<dynamic> getUserData(String? id) async {
    final client = await getGraphQLClient();
    const String query = """
    query getUsers(\$user_id: String!) {
      getUsers(user_id: \$user_id) {
        fullname
        phone_number
        isLoggedIn
        status
        walletAmt
      }
    }
  """;

    final options = QueryOptions(
      document: gql(query),
      variables: {
        "user_id": id, // ✅ Pass userId dynamically
      },
    );

    final result = await client.query(options);

    if (result.hasException) {
      print("GraphQL Error: ${result.exception.toString()}");
      return null;
    }

    final userData = result.data?["getUsers"];
    if (userData != null) {
      // print(userData)
      return userData;
      //; // Convert JSON to Driver model
    }
    return null;
  }
}
