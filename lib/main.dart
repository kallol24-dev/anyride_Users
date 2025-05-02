import 'package:anyride_captain/business/stateProviders.dart';
import 'package:anyride_captain/screens/home/home2.dart';
import 'package:anyride_captain/screens/login/login_screen2.dart';
import 'package:anyride_captain/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'models/driver.dart';
import 'business/auth_provider.dart';
import 'business/driver_provider.dart';
import 'routes/navigator.dart';
import 'screens/login/otp_screen2.dart';
import 'services/auth_service.dart';
import 'services/secure_storage_service.dart';
import 'services/user_service.dart';
import 'screens/users/profile.dart';
import 'screens/home/home.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/otp_screen.dart';
import 'common/splashScreen.dart';
import 'common/error.dart';

// ✅ FutureProvider to check if JWT token exists (user is logged in)
final isLoggedinProvider = FutureProvider<bool>((ref) async {
  ref.keepAlive();
  final storage = SecureStorage();
  final jwtToken = await storage.getToken();
  return jwtToken != null;
});

// ✅ Main entry
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

// ✅ MainApp Widget
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedinAsync = ref.watch(isLoggedinProvider);
    final isLoggedInUser = ref.watch(isLoggedinUser);

    // Combine both FutureProviders
    return isLoggedinAsync.when(
      data: (isLoggedin) {
        String initialRoute;
        if (isLoggedin) {
          initialRoute = "/home";
        } else {
          initialRoute = "/welcome";
        }

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          //initialRoute: initialRoute,
          // home: OtpVerificationScreen("1234567890"),
          // home: initialRoute == "/welcome" ? WelcomeScreen() : LoginScreen2(),
          navigatorKey: navigatorKey,
          initialRoute: initialRoute,
          routes: {
            "/login": (context) => LoginScreen2(),
            "/otp": (context) => OtpVerificationScreen(),
            // "/registration": (context) => DriverRegistrationScreen(),
            "/home": (context) => HomeScreen(),
            "/welcome": (context) => WelcomeScreen(),
          },
        );
      },
      loading: () => const MaterialApp(home: SplashScreen()),
      error: (err, _) => MaterialApp(home: ErrorScreen(error: err.toString())),
    );
  }
}
