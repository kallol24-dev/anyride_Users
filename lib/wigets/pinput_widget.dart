import 'package:anyride_captain/business/auth_provider.dart';
import 'package:anyride_captain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../business/driver_provider.dart';
import '../business/stateProviders.dart';
import '../main.dart';
import '../routes/navigator.dart';
import '../services/registration_service.dart';

// class RoundedWithShadow extends ConsumerWidget {
//   final controller = TextEditingController();
//   final focusNode = FocusNode();

//   AuthService _authService = AuthService();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     String? verificationId = ref.watch(verificationIdProvider);

//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 64,
//       textStyle: GoogleFonts.poppins(
//         fontSize: 20,
//         color: Color.fromRGBO(70, 69, 66, 1),
//       ),
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(232, 235, 241, 0.37),
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );

//     final cursor = Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: 21,
//         height: 1,
//         margin: EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(137, 146, 160, 1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );

//     return Pinput(
//       length: 6,
//       controller: controller,
//       // focusNode: focusNode,
//       onCompleted: (String input) async {
//         // authController.isDecided = false;
//         bool isverified = await ref
//             .read(authServiceProvider)
//             .verifyOTP(verificationId!, input);
//         if (isverified) {
//           Get.snackbar(
//             "Success",
//             "Login Successful!",
//             backgroundColor: Color.fromRGBO(226, 56, 14, 0.573),
//             colorText: Colors.white,
//             barBlur: 20,
//           );
//         } else {
//           Get.snackbar(
//             "Error",
//             "Invalid OTP!",
//             backgroundColor: Color.fromRGBO(14, 226, 78, 0.573),
//             colorText: Colors.white,
//             barBlur: 20,
//           );
//         }
//       },
//       defaultPinTheme: defaultPinTheme.copyWith(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Color.fromRGBO(0, 0, 0, 0.06),
//               offset: Offset(0, 3),
//               blurRadius: 16,
//             ),
//           ],
//         ),
//       ),
//       focusedPinTheme: defaultPinTheme.copyWith(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Color.fromRGBO(0, 0, 0, 0.06),
//               offset: Offset(0, 3),
//               blurRadius: 16,
//             ),
//           ],
//         ),
//       ),
//       showCursor: true,
//       cursor: cursor,

//       // This aligns and spaces the boxes
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     );
//   }
// }
// ===========================

class RoundedWithShadow extends ConsumerStatefulWidget {
  @override
  _RoundedWithShadowState createState() => _RoundedWithShadowState();
}

class _RoundedWithShadowState extends ConsumerState<RoundedWithShadow> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final RegistrationService _registrationservice = RegistrationService();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? verificationId = ref.watch(verificationIdProvider);

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: Color.fromRGBO(70, 69, 66, 1),
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(232, 235, 241, 0.37),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Pinput(
      length: 6,
      controller: controller,
      focusNode: focusNode,
      onCompleted: (String input) async {
        bool isverified = await ref
            .read(authServiceProvider)
            .verifyOTP(verificationId!, input);

        var driver = ref.watch(driverNotifierProvider);

        var isLoginVerified = await _registrationservice.verifyLogin(
          ref,
          driver,
        );

        if (!mounted) return; // <-- Important: check if widget is still in tree

        if (isverified) {
          Get.snackbar(
            "Success",
            "Login Successful!",
            backgroundColor: Color.fromRGBO(226, 56, 14, 0.573),
            colorText: Colors.white,
            barBlur: 20,
          );
          // Example: Navigate to home
          // Get.offAllNamed('/home');
          navigatorKey.currentState?.pushReplacementNamed('/home');
          ref.read(isLoggedinUser.notifier).state = true;
        } else {
          Get.snackbar(
            "Error",
            "Invalid OTP!",
            backgroundColor: Color.fromRGBO(14, 226, 78, 0.573),
            colorText: Colors.white,
            barBlur: 20,
          );
        }
      },
      defaultPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              offset: Offset(0, 3),
              blurRadius: 16,
            ),
          ],
        ),
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              offset: Offset(0, 3),
              blurRadius: 16,
            ),
          ],
        ),
      ),
      showCursor: true,
      cursor: cursor,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
