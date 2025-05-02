import 'dart:async';

import 'package:anyride_captain/wigets/loginwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../business/auth_provider.dart';
import '../business/stateProviders.dart';
import '../utils/app_constants.dart';

class ResendOtpWidget extends ConsumerStatefulWidget {
  final String phoneNumber;
  const ResendOtpWidget(this.phoneNumber, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _reSendOtpScreenState createState() {
    return _reSendOtpScreenState();
  }
}

class _reSendOtpScreenState extends ConsumerState<ResendOtpWidget> {
  late Timer _timer;
  int _secondsRemaining = 30;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
          _secondsRemaining > 0
              ? Column(
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(text: AppConstants.resendCode + " "),
                        TextSpan(
                          text: formatTime(_secondsRemaining),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : TextButton(
                onPressed: () {
                  // TODO: Call resend OTP here
                  ref.read(isResentOtpLoading.notifier).state = true;
                  ref.read(authServiceProvider).sendOTP(widget.phoneNumber, (
                    newVerificationId,
                  ) {
                    ref.read(verificationIdProvider.notifier).state =
                        newVerificationId;
                  });

                  setState(() {
                    _secondsRemaining = 30; // restart timer
                  });
                  ref.read(isResentOtpLoading.notifier).state = false;
                  if (context.mounted) {
                    Get.snackbar(
                      "Success",
                      "Resend Otp Sent !",
                      backgroundColor: Color.fromRGBO(226, 56, 14, 0.573),
                      colorText: Colors.white,
                      barBlur: 20,
                    );
                  }
                  startTimer();
                },
                child: Text(
                  "Resend Code",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
    );
  }
}
