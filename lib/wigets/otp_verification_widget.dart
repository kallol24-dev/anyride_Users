// import 'package:anyride_captain/wigets/textwidget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../utils/app_constants.dart';
// import 'pinput_widget.dart';

// Widget otpVerificationWidget(String? phoneNumber) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: textWidget(
//             text: "Welcome ${phoneNumber.toString()}",
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10),
//         textWidget(text: AppConstants.phoneVerification),
//         textWidget(
//           text: AppConstants.enterOtp,
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//         ),
//         const SizedBox(height: 40),

//         Container(width: Get.width, height: 50, child: RoundedWithShadow()),
//         const SizedBox(height: 40),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: RichText(
//             textAlign: TextAlign.start,
//             text: TextSpan(
//               style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
//               children: [
//                 TextSpan(text: AppConstants.resendCode + " "),
//                 TextSpan(
//                   text: "10 seconds",
//                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }


import 'package:anyride_captain/wigets/resend_otp_widget.dart';
import 'package:anyride_captain/wigets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../utils/app_constants.dart';
import 'pinput_widget.dart';

class otpVerificationWidget extends StatefulWidget {
  final String phoneNumber;
  const otpVerificationWidget(this.phoneNumber);

  @override
  State<otpVerificationWidget> createState() => _OTPVerificationWidgetState();
}

class _OTPVerificationWidgetState extends State<otpVerificationWidget> {
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Center(
  //           child: textWidget(
  //             text: "Welcome ${widget.phoneNumber}",
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         SizedBox(height: 10),
  //         textWidget(text: AppConstants.phoneVerification),
  //         textWidget(
  //           text: AppConstants.enterOtp,
  //           fontSize: 22,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         const SizedBox(height: 40),

  //         Container(width: Get.width, height: 50, child: RoundedWithShadow()),
  //         const SizedBox(height: 40),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           child: RichText(
  //             textAlign: TextAlign.start,
  //             text: TextSpan(
  //               style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
  //               children: [
  //                 TextSpan(text: AppConstants.resendCode + " "),
  //                 TextSpan(
  //                   text: formatTime(_secondsRemaining),
  //                   style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: textWidget(
              text: "Welcome ${widget.phoneNumber}",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          textWidget(text: AppConstants.phoneVerification),
          textWidget(
            text: AppConstants.enterOtp,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 40),

          // OTP Input
          SizedBox(width: Get.width, height: 50, child: RoundedWithShadow()),

          const SizedBox(height: 40),

          // Resend timer and button
          ResendOtpWidget(widget.phoneNumber),
        ],
      ),
    );
  }
}
