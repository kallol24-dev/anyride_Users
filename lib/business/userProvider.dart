import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/coordinates.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class Userprovider extends Notifier<User> {
  //  final RegistrationService _registrationservice = RegistrationService();
  final AuthService _authService = AuthService();
  // final ProfileService _profileService = ProfileService();

  //late final AuthService _service;
  @override
  User build() {
    return User.empty(); // Return an empty driver instance
  }

  void updateUserName(String name) {
    state = state.copyWith(name: name);
  }

  void updateUserPhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updateUserEmail(String email) {
    state = state.copyWith(phone: email);
  }

  void updateUserSos(String sos) {
    state = state.copyWith(sos: sos);
  }

  void updateCoordinates(Coordinates coordinates) {
    state = state.copyWith(coordinates: coordinates);
  }

  void updateUserId(String userId) {
    state = state.copyWith(id: userId);
  }

  void updateProfilePicrure(Profile profile) {
    state = state.copyWith(profile: profile);
  }
}

final userNotifierProvider = NotifierProvider<Userprovider, User>(() {
  return Userprovider();
});
