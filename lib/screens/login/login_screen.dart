// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // import '../../common/Alert_box.dart';
// // import '../../providers/auth_provider.dart';
// // import 'otp_screen.dart';

// // class LoginScreen extends ConsumerWidget {
// //   final TextEditingController _phoneController = TextEditingController();

// //   LoginScreen({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final isLoadingPage = ref.watch(isLoading);
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Login with OTP")),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // TextField(
// //             //   controller: _phoneController,
// //             //   decoration: InputDecoration(labelText: "Phone Number"),
// //             //   keyboardType: TextInputType.phone,
// //             // ),
// //             TextField(
// //               controller: _phoneController,
// //               decoration: InputDecoration(
// //                 labelText: 'Enter Phone Number',
// //                 border: const OutlineInputBorder(),
// //                 prefixIcon: const Icon(Icons.phone),
// //                 prefixText: "+91 ",
// //               ),
// //               maxLength: 10,

// //               keyboardType: TextInputType.phone,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed:
// //                   isLoadingPage
// //                       ? null
// //                       : () {
// //                         checkLogin(ref, context);
// //                       },
// //               child:
// //                   isLoadingPage
// //                       ? SizedBox(
// //                         height: 20,
// //                         width: 20,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           color: Colors.white,
// //                         ),
// //                       )
// //                       : Text("Send OTP"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> checkLogin(WidgetRef ref, BuildContext context) async {
// //     ref.read(isLoading.notifier).state = true;
// //     //await Future.delayed(Duration(seconds: 3));
// //     if (_phoneController.text.isEmpty ||
// //         _phoneController.text != "1234567890") {
// //       ScaffoldMessenger.of(context)
// //         ..hideCurrentSnackBar()
// //         ..showSnackBar(
// //           AlertBox.ShowDialog(
// //             message: "Please Provide a valid Number",
// //             contentType: "failure",
// //           ),
// //         );
// //       ref.read(isLoading.notifier).state = false;
// //     } else {
// //       final phoneNumber = getFullPhoneNumber(_phoneController.text.trim());
// //       ref.read(authProvider).sendOTP(phoneNumber, (verificationId) {
// //         ref.read(verificationIdProvider.notifier).state = verificationId;
// //         ref.read(otpSentProvider.notifier).state = true;

// //         ref.read(isLoading.notifier).state = false;
// //         ref.read(phoneNumberField.notifier).state = phoneNumber;

// //         // ref.read(driverProvider.notifier).updateToken(ref.read(authProvider).getToken().toString());

// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => OtpScreen()),
// //         );
// //       });
// //     }
// //   }

// //   String getFullPhoneNumber(String phoneNumber) {
// //     String countryCode = "+91 ";
// //     phoneNumber = phoneNumber.trim();
// //     if (!phoneNumber.startsWith(countryCode)) {
// //       return countryCode + phoneNumber;
// //     }
// //     return phoneNumber;
// //   }
// // }
// import '../../providers/auth_provider.dart';
// import 'otp_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../common/Alert_box.dart';

// class LoginScreen extends ConsumerWidget {
//   final TextEditingController _phoneController = TextEditingController();

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isLoadingPage = ref.watch(isLoading);
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/background.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Expanded(
//                 flex: 4,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage('assets/images/logo.png'),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 6,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     keyboardDismissBehavior:
//                         ScrollViewKeyboardDismissBehavior.onDrag,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const SizedBox(height: 30),
//                         const Text(
//                           "Login with OTP",
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orangeAccent,
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         TextField(
//                           controller: _phoneController,
//                           decoration: InputDecoration(
//                             labelText: 'Enter Phone Number',
//                             border: const OutlineInputBorder(),
//                             prefixIcon: const Icon(Icons.phone),
//                             prefixText: "+91 ",
//                           ),
//                           maxLength: 10,
//                           keyboardType: TextInputType.phone,
//                         ),
//                         const SizedBox(height: 40),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orange,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 80,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                           ),
//                           onPressed:
//                               isLoadingPage
//                                   ? null
//                                   : () {
//                                     checkLogin(ref, context);
//                                   },
//                           child:
//                               isLoadingPage
//                                   ? const SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                   : const Text(
//                                     "Send OTP",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> checkLogin(WidgetRef ref, BuildContext context) async {
//     ref.read(isLoading.notifier).state = true;
//     if (_phoneController.text.isEmpty ||
//         _phoneController.text != "1234567890") {
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           AlertBox.ShowDialog(
//             message: "Please Provide a valid Number",
//             contentType: "failure",
//           ),
//         );
//       ref.read(isLoading.notifier).state = false;
//     } else {
//       final phoneNumber = getFullPhoneNumber(_phoneController.text.trim());
//       ref.read(authProvider).sendOTP(phoneNumber, (verificationId) {
//         ref.read(verificationIdProvider.notifier).state = verificationId;
//         ref.read(otpSentProvider.notifier).state = true;
//         ref.read(isLoading.notifier).state = false;
//         ref.read(phoneNumberField.notifier).state = phoneNumber;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => OtpScreen()),
//         );
//       });
//     }
//   }

//   String getFullPhoneNumber(String phoneNumber) {
//     String countryCode = "+91 ";
//     phoneNumber = phoneNumber.trim();
//     if (!phoneNumber.startsWith(countryCode)) {
//       return countryCode + phoneNumber;
//     }
//     return phoneNumber;
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../business/stateProviders.dart';
import '../../common/Alert_box.dart';
import '../../business/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController _phoneController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      // Logo Positioned at the Top
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
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
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          "Login with OTP",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Phone Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                            prefixText: "+91 ",
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 40),
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
                                  : () {
                                    checkLogin(ref, context);
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
                                    "Send OTP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> checkLogin(WidgetRef ref, BuildContext context) async {
    ref.read(isLoading.notifier).state = true;
    if (_phoneController.text.isEmpty ||
        _phoneController.text != "1234567890") {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          AlertBox.ShowDialog(
            message: "Please Provide a valid Number",
            contentType: "failure",
          ),
        );
      ref.read(isLoading.notifier).state = false;
    } else {
      final phoneNumber = getFullPhoneNumber(_phoneController.text.trim());
      ref.read(authServiceProvider).sendOTP(phoneNumber, (verificationId) {
        ref.read(verificationIdProvider.notifier).state = verificationId;
        ref.read(otpSentProvider.notifier).state = true;
        ref.read(isLoading.notifier).state = false;
        //ref.read(phoneNumberField.notifier).state = phoneNumber;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen()),
        );
      });
    }
  }

  String getFullPhoneNumber(String phoneNumber) {
    String countryCode = "+91 ";
    phoneNumber = phoneNumber.trim();
    if (!phoneNumber.startsWith(countryCode)) {
      return countryCode + phoneNumber;
    }
    return phoneNumber;
  }
}
