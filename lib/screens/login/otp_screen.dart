import 'package:anyride_captain/common/colorPalette.dart';
import 'package:anyride_captain/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../business/stateProviders.dart';
import '../../common/Alert_box.dart';
import '../../business/auth_provider.dart';
import '../../business/driver_provider.dart';
import '../../services/registration_service.dart';


class OtpScreen extends ConsumerWidget {
  final TextEditingController _otpController = TextEditingController();
  final RegistrationService _registrationservice = RegistrationService();

  OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? verificationId = ref.watch(verificationIdProvider);
    final isLoadingPage = ref.watch(isLoading);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                        ), // Adjust spacing
                        child: SizedBox(
                          height: 120, // Set height
                          width: 240, // Set width
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain, // Ensures proper scaling
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 30),
                            const Text(
                              "Enter OTP !",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // OTP Input Field
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Pinput(
                                length: 6,
                                controller: _otpController,
                                hapticFeedbackType:
                                    HapticFeedbackType.lightImpact,
                                defaultPinTheme: defaultPinTheme,
                                autofocus: true,
                                separatorBuilder:
                                    (index) => const SizedBox(width: 8),
                                cursor: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 9),
                                      width: 23,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Verify OTP Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 80,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed:
                                  isLoadingPage
                                      ? null
                                      : () async {
                                        ref.read(isLoading.notifier).state =
                                            true;
                                        await Future.delayed(
                                          const Duration(seconds: 3),
                                        );
                                        bool isOTPVerified = await ref
                                            .read(authServiceProvider)
                                            .verifyOTP(
                                              verificationId!,
                                              _otpController.text.trim(),
                                            );

                                        // bool isVerified = await ref
                                        //     .read(driverProvider.notifier)
                                        //     .firebaseVerificationOnVerifyOTP(
                                        //       ref,
                                        //     );
                                        var driver = ref.watch(
                                          driverNotifierProvider,
                                        );
                                        var isLoginVerified =
                                            await _registrationservice
                                                .verifyLogin(ref, driver);

                                        // var isRegisteredUser =
                                        //     await ref
                                        //         .read(authServiceProvider)
                                        //         .checkIsRegistered();

                                        if (isOTPVerified && isLoginVerified) {
                                          ref.read(isLoading.notifier).state =
                                              false;
                                          String? userid =
                                              await ref
                                                  .read(authServiceProvider)
                                                  .getUserId();

                                          if (userid != null) {
                                            ref
                                                .read(
                                                  driverNotifierProvider
                                                      .notifier,
                                                )
                                                .updateUserId(userid);
                                          }

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              AlertBox.ShowDialog(
                                                message: "Login Successful",
                                                contentType: "success",
                                              ),
                                            );

                                          ref
                                              .read(isLoggedinUser.notifier)
                                              .state = true;

                                          // // Navigate to Driver Registration
                                          // Navigator.pushReplacement(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder:
                                          //         (context) =>
                                          //             isRegisteredUser
                                          //                 ? Home()
                                          //                 : DriverRegistrationScreen(),
                                          //   ),
                                          // );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              AlertBox.ShowDialog(
                                                message: "Invalid OTP",
                                                contentType: "failure",
                                              ),
                                            );
                                        }
                                        ref
                                            .read(isLoggedinUser.notifier)
                                            .state = false;
                                      },
                              child:
                                  isLoadingPage
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text(
                                        "Verify OTP",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 45,
    textStyle: TextStyle(
      fontSize: 20,
      color: Colorpalette.txtPrimary,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colorpalette.bgPrimary),
      borderRadius: BorderRadius.circular(30),
    ),
  );
}
