import 'package:anyride_captain/business/stateProviders.dart';
import 'package:anyride_captain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/navigator.dart';
import '../utils/app_constants.dart';
import 'textwidget.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

Widget bannerWidget() {
  return Container(
    width: Get.width,

    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/login-background.png'),
        fit: BoxFit.cover,
      ),
    ),
    height: Get.height * 0.6,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Image.asset("assets/images/logo.png")],
    ),
  );
}

TextEditingController phoneController = TextEditingController();

Widget loginWidget(
  CountryCode countryCode,
  Function onCountryChange,
  void Function(String mobileNumber, CountryCode code) onSubmit,
  //Function onSubmit, // Function signature for onSubmit
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.helloNiceToMeetYou),
        textWidget(
          text: AppConstants.getMovingWithGreenTaxi,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => onCountryChange(),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          child: countryCode.flagImage(
                            width: 10,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      textWidget(text: countryCode.dialCode),
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10), // Max 10 digits
                    ],
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: AppConstants.enterMobileNumber,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.green),
                        onPressed: () {
                          final input = phoneController.text.trim();
                          if (input.isNotEmpty && input.length == 10) {
                            // Call onSubmit here and pass the mobile number
                            onSubmit(input, countryCode);
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please enter a valid 10-digit mobile number",
                              backgroundColor: Color.fromRGBO(
                                226,
                                56,
                                14,
                                0.573,
                              ),
                              colorText: Colors.white,
                              barBlur: 20,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
              children: [
                TextSpan(text: AppConstants.byCreating + " "),
                TextSpan(
                  text: AppConstants.termsOfService + " ",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "and "),
                TextSpan(
                  text: AppConstants.privacyPolicy + " ",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

void onSubmit(WidgetRef ref, String mobileNumber, CountryCode countryCode) {
  // Combine country code and mobile number
  String fullPhoneNumber = countryCode.dialCode + mobileNumber;
  print(fullPhoneNumber);

  AuthService _authService = AuthService();

  ;

  _authService.sendOTP(fullPhoneNumber, (verificationId) {
    ref.read(verificationIdProvider.notifier).state = verificationId;
    ref.read(otpSentProvider.notifier).state = true;
    ref.read(isLoading.notifier).state = false;

    navigatorKey.currentState?.pushReplacementNamed(
      '/otp',
      arguments: fullPhoneNumber,
    );
  });
}
