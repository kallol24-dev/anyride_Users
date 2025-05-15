// Global Providers

import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoading = StateProvider<bool>((ref) => false);
final verificationIdProvider = StateProvider<String?>((ref) => null);
final registrationStepProvider = StateProvider<int>((ref) => 0);
final otpSentProvider = StateProvider<bool>((ref) => false);
final isLoggedinUser = StateProvider<bool>((ref) => false);
final isLoggedOutUser = StateProvider<bool>((ref) => false);
final isResentOtpLoading = StateProvider<bool>((ref) => false);


