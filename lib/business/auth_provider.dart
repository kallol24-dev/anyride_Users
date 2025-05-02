// import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:anyride_captain/services/registration_service.dart';

import '../services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = StateProvider((ref) {
  return AuthService();
});

final registrationServiceProvider = StateProvider((ref) {
  return RegistrationService();
});

// final isLoading = StateProvider<bool>((ref) => false);
// final isLoggedinUser = StateProvider<bool>((ref) => false);
// final otpSentProvider = StateProvider<bool>((ref) => false);
// final verificationIdProvider = StateProvider<String?>((ref) => null);
// final validationField = StateProvider<bool>((ref) => false);
// final phoneNumberField = StateProvider<String?>((ref) => '+91 1111111111');
// final isRegisteredDriver = StateProvider<bool>((ref) => false);
// class AuthNotifier extends StateNotifier<bool> {
//   AuthNotifier() : super(false) {
//     _loadLoginState();
//   }

//   Future<void> _loadLoginState() async {
//     final prefs = await SharedPreferences.getInstance();
//     state = prefs.getBool('isLoggedIn') ?? false;
//   }

//   Future<void> setLogin(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', value);
//     state = value;
//   }
// }

// //Verification Id
// class AuthVerification extends StateNotifier<String?> {
//   AuthVerification() : super(null);

//   void setverificationId(String id) {
//     state = id;
//   }
// }

// //otp Sent
// class AuthOtpSent extends StateNotifier<bool> {
//   AuthOtpSent() : super(false);

//   void setOtpSentState(bool value) async {
//     state = value;
//   }
// }
