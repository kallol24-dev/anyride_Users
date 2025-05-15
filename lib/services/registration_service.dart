import 'package:anyride_captain/business/driver_provider.dart';
import 'package:anyride_captain/models/user.dart';
import 'package:anyride_captain/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/driver.dart';
import '../business/graph_client_provider.dart';
import 'secure_storage_service.dart';

class RegistrationService {
  Future<Map<String, dynamic>?> registerCaptain(
    WidgetRef ref,
    Driver driver,
  ) async {
    final client = await getGraphQLClient();

    const String mutation = """
    mutation CreateUser(\$input: CreateUserDto!) {
      CreateUser(input: \$input) {
        fullname
        email
        phone_number
        isLoggedIn
        user_id
        status
      }
    }
  """;

    final options = MutationOptions(
      document: gql(mutation),
      variables: {"input": driver.toPersonalDetails()},
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      print("GraphQL Error: ${result.exception.toString()}");
      return null;
    }

    return result.data?["CreateUser"] as Map<String, dynamic>?;
  }

  Future<bool> verifyLogin(WidgetRef ref, User user) async {
    AuthService authService = AuthService();
    SecureStorage secureStorage = SecureStorage();
    final client = await getGraphQLClient();
    final token = await authService.getFirebaseIdToken();

    if (token == null) {
      print("Failed to retrieve Firebase token.");
    } else {
      const String mutation = """
    mutation firebaseLogin(\$firebaseToken: String!) {
      firebaseLogin(firebaseToken: \$firebaseToken) {
      token
      phone_number
      }
      
    }
    """;

      final options = MutationOptions(
        document: gql(mutation),
        variables: {
          "firebaseToken": token, // Convert driver model to JSON
        },
      );

      var result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (kDebugMode) {
        print(result.data);
      }
      if (result != null) {
        // ref.read(authTokenProvider.notifier).state =
        //     response["token"].toString();
        var loginresult = result.data!["firebaseLogin"];

        var d = await secureStorage.saveToken(
          result.data!["firebaseLogin"]["token"].toString(),
        );

        print("Token JWT: ${d}");

        ref
            .read(driverNotifierProvider.notifier)
            .updatePhoneNumber(loginresult["phone_number"].toString());
      }
      return true;

      // return result.data?["firebaseLogin"];
    }
    return false;
  }
}
