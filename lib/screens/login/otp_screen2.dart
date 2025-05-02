import 'package:anyride_captain/wigets/loginwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../wigets/otp_verification_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  // String phoneNumber;
  // OtpVerificationScreen(this.phoneNumber);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                bannerWidget(),

                // Positioned(
                // top: 60,
                // left: 30,
                // child: InkWell(
                //   onTap: () {
                //     Get.back();
                //   },
                //   child: Container(
                //     width: 45,
                //     height: 45,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Colors.white,
                //     ),
                //     child: Icon(Icons.arrow_back),
                //   ),
                // ),
                // ),
              ],
            ),

            SizedBox(height: 50),

            otpVerificationWidget( phoneNumber),
          ],
        ),
      ),
    );
  }
}
