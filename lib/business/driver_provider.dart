// import 'dart:io';

import 'dart:io';

import 'package:anyride_captain/services/auth_service.dart';
import 'package:anyride_captain/services/user_service.dart';
import 'package:anyride_captain/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/driver.dart';
import '../services/registration_service.dart';
import '../utils/validator.dart';
import 'auth_provider.dart';

// class DriverProvider extends Notifier<Driver> {
//   @override
//   Driver build() {
//     return Driver.empty();
//   }

//   final Map<String, String?> _errors = {};

//   Map<String, String?> get errors => _errors;

//   void updatePhoneNumber(String phoneNumber) {
//     state = state.copyWith(phone: phoneNumber);
//   }

//   void updateDLFront(File file) {
//     state = state.copyWith(dlFront: file.path);
//   }

//   void updateDLBack(File file) {
//     state = state.copyWith(dlBack: file.path);
//   }

//   void updateUserId(String userId) {
//     state = state.copyWith(id: userId);
//   }

//   void updateProfilePicture(File image) {
//     state = state.copyWith(profile: image.path);
//   }

//   //bool validateForm(int step) {
//   //     // if (step == 0) {
//   //     //   fieldsValidation("fullName", state.fullName);
//   //     //   fieldsValidation("email", state.email);
//   //     //   fieldsValidation("phone", state.phone);
//   //     //   fieldsValidation("panCard", state.panCard);
//   //     //   fieldsValidation("licence", state.dlNumber);
//   //     //   fieldsValidation("dlfront", state.dlFront);
//   //     //   fieldsValidation("dlback", state.dlBack);
//   //     // } else if (step == 1) {
//   //     //   fieldsValidation("vehicleModel", state.vehicleModel);
//   //     //   fieldsValidation("vehicleNumber", state.vehicleNumber);
//   //     //   fieldsValidation("vehicleColor", state.vehicleColor);
//   //     //   fieldsValidation("vehicleType", state.vehicleType.name.toString());
//   //     // }

//   //     // validateField("licenceback", state.dlBack);

//   //     return _errors.values.every((error) => error == null);
//   //   }

//   Future<bool> submitRegistration(WidgetRef ref) async {
//     try {
//       final RegistrationService registrationservice = RegistrationService();
//       final response = await registrationservice.registerCaptain(
//         ref,
//         state,
//       ); // API call

//       if (response != null) {
//         print(response);
//       }
//       return true;
//     } catch (e) {
//       print("Error: $e");
//       return false;
//     }
//   }
// }

final driverNotifierProvider = NotifierProvider<DriverProvider, Driver>(() {
  return DriverProvider();
});

class DriverProvider extends Notifier<Driver> {
  //  final RegistrationService _registrationservice = RegistrationService();
  final AuthService _authService = AuthService();
  // final ProfileService _profileService = ProfileService();

  //late final AuthService _service;
  @override
  Driver build() {
    //final client = ref.read(graphQLClientProvider); // Inject GraphQL client
    // _registrationservice = RegistrationService(
    //   client,
    // ); // Pass client to the service
    // _profileService = ProfileService(client); // Pass client to the service
    return Driver.empty(); // Return an empty driver instance
  }

  final Map<String, String?> _errors = {};

  Map<String, String?> get errors => _errors;

  /// **Provider for DriverNotifier**

  void updateField(String key, dynamic value) {
    state = state.copyWith(
      district: key == 'district' ? value : null,
      // pan: key == 'pan' ? value : null,
      panCard: key == 'panCard' ? value : null,
      fullName: key == 'fullName' ? value : null,
      email: key == 'email' ? value : null,
      phone: key == 'phone' ? value : null,

      vehicleModel: key == 'vehicleModel' ? value : null,
      vehicleColor: key == 'vehicleColor' ? value : null,
      vehicleNumber: key == 'vehicleNumber' ? value : null,
      vehicleType:
          key == 'vehicleType' ? value as VehicleType : state.vehicleType,
      isEv: key == 'ev' ? value : false,

      dlNumber: key == 'dlNumber' ? value : null,
      referralCode: key == 'referralCode' ? value : null,
    );
    // validateField(key, value);
  }

  void fieldsValidation(String key, String value) {
    String? error;
    switch (key) {
      case "fullName":
        error = ValidateField.validateName(value);
        break;
      case "email":
        error = ValidateField.validateEmail(value);

        break;
      case "phone":
        error = ValidateField.validatePhone(value);
        break;
      case "panCard":
        error = ValidateField.validatePan(value);
        break;
      case "dlNumber":
        error = ValidateField.validateDLNumber(value);
        break;
      case "dlfront":
        error = ValidateField.validateImage(value, "Driving License (Front)");
        break;
      case "dlback":
        error = ValidateField.validateImage(value, "Driving License (Back)");
        break;
      case "vehicleModel":
        error = ValidateField.validateVehicleModel(value);
        break;
      case "vehicleNumber":
        error = ValidateField.validateVehicleNumber(value);
        break;
      case "vehicleColor":
        error = ValidateField.validateVehicleColor(value);
        break;

      case "vehicleType":
        error = ValidateField.validateVehicleType(value);

        break;
    }
    _errors[key] = error; // Update error map

    state = state.copyWith(); // **Trigger UI rebuild**
  }

  bool validateForm(int step) {
    // if (step == 0) {
    //   fieldsValidation("fullName", state.fullName);
    //   fieldsValidation("email", state.email);
    //   fieldsValidation("phone", state.phone);
    //   fieldsValidation("panCard", state.panCard);
    //   fieldsValidation("licence", state.dlNumber);
    //   fieldsValidation("dlfront", state.dlFront);
    //   fieldsValidation("dlback", state.dlBack);
    // } else if (step == 1) {
    //   fieldsValidation("vehicleModel", state.vehicleModel);
    //   fieldsValidation("vehicleNumber", state.vehicleNumber);
    //   fieldsValidation("vehicleColor", state.vehicleColor);
    //   fieldsValidation("vehicleType", state.vehicleType.name.toString());
    // }

    // validateField("licenceback", state.dlBack);

    return _errors.values.every((error) => error == null);
  }

  void updateVehicleType(VehicleType type) {
    state = state.copyWith(vehicleType: type);
  }

  void updateProfilePicture(File image) {
    state = state.copyWith(profile: image.path);
  }

  void updateDLFront(File file) {
    state = state.copyWith(dlFront: file.path);
  }

  void updateDLBack(File file) {
    state = state.copyWith(dlBack: file.path);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phone: phoneNumber);
  }

  void updateUserId(String userId) {
    state = state.copyWith(id: userId);
  }

  // Future<void> loadProfile(WidgetRef ref) async {
  //   String? userId = await _authService.getUserId();
  //   if (userId != null) {
  //     Driver? driver = await _profileService.getUserData(ref, userId);
  //     if (driver != null) {
  //       state = driver; // Update state with fetched profile
  //     }
  //   }
  // }

  // Future<bool> firebaseVerificationOnVerifyOTP(WidgetRef ref) async {
  //   try {
  //     // final checkToken =
  //     final response = await _registrationservice.verifyCaptain(
  //       ref,
  //       state,
  //     ); // API call
  //     //final response = await ref.read(driverProvider.notifier)._service.verifyCaptain(ref.read(driverProvider));

  //     if (response != null) {
  //       // ref.read(authTokenProvider.notifier).state =
  //       //     response["token"].toString();
  //       var d = await ref
  //           .read(secureStorageProvider)
  //           .saveToken(response["token"].toString());
  //       print("Token JWT: ${d}");

  //       ref
  //           .read(driverProvider.notifier)
  //           .updatePhoneNumber(response["phone_number"].toString());
  //     }
  //     return true;
  //   } catch (e) {
  //     print("Error: $e");
  //     return false;
  //   }
  // }

  // Future<bool> submitRegistration(WidgetRef ref) async {
  //   try {
  //     final response = await _registrationservice.registerCaptain(
  //       ref,
  //       state,
  //     ); // API call

  //     if (response != null) {
  //       print(response);
  //     }
  //     return true;
  //   } catch (e) {
  //     print("Error: $e");
  //     return false;
  //   }
  // }
}





// bool validateForm(int step) {
//   final errors = <String, String?>{};

//   if (step == 0) { // Personal Details Validation
//     errors['fullName'] = ValidateField.validateName(state.);
//     errors['email'] = Validator.validateEmail(state.email);
//     errors['phone'] = Validator.validatePhone(state.phone);
//     errors['pan'] = Validator.validateText(state.pan, "Pan Card");
//     errors['licence'] = Validator.validateText(state.licence, "Driving Licence");
//     errors['profile'] = Validator.validateImage(state.profile, "Profile Picture");
//     errors['dlFront'] = Validator.validateImage(state.dlFront, "Driving License Front");
//     errors['dlBack'] = Validator.validateImage(state.dlBack, "Driving License Back");
//   }

//   if (step == 1) { // Vehicle Details Validation
//     errors['carModel'] = Validator.validateText(state.carModel, "Vehicle Model");
//     errors['vehicleNumber'] = Validator.validateText(state.vehicleNumber, "Vehicle Number");
//     errors['vehicleColor'] = Validator.validateText(state.vehicleColor, "Vehicle Color");
//     if (state.carType == null) {
//       errors['carType'] = "Car Type is required";
//     }
//   }

//   state = state.copyWith(errors: errors); // Update errors in state

//   return errors.values.every((error) => error == null); // If all are null, validation passed
// }

// import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/driver.dart';

// // Validation State Model
// class DriverValidationState {
//   final String? fullNameError;
//   final String? emailError;
//   final String? phoneError;
//   final String? vehicleNumberError;

//   const DriverValidationState({
//     this.fullNameError,
//     this.emailError,
//     this.phoneError,
//     this.vehicleNumberError,
//   });

//   bool get isValid =>
//       fullNameError == null &&
//       emailError == null &&
//       phoneError == null &&
//       vehicleNumberError == null;
// }

// // Driver State Notifier
// class DriverNotifier extends StateNotifier<Driver> {
//   DriverNotifier() : super(Driver.empty());

//   // Validate and Update the Driver State
//   DriverValidationState validateAndUpdate({
//     String? fullName,
//     String? email,
//     String? phone,
//     String? vehicleNumber,
//     CarType? carType,
//   }) {
//     String? fullNameError =
//         (fullName == null || fullName.isEmpty) ? "Full Name is required" : null;

//     String? emailError = (email == null || email.isEmpty)
//         ? "Email is required"
//         : (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
//                 .hasMatch(email)
//             ? "Enter a valid email"
//             : null);

//     String? phoneError = (phone == null || phone.isEmpty)
//         ? "Phone number is required"
//         : (!RegExp(r"^[0-9]{10}$").hasMatch(phone)
//             ? "Enter a valid 10-digit phone number"
//             : null);

//     String? vehicleNumberError =
//         (vehicleNumber == null || vehicleNumber.isEmpty)
//             ? "Vehicle Number is required"
//             : null;

//     // If all fields are valid, update the driver state
//     if (fullNameError == null &&
//         emailError == null &&
//         phoneError == null &&
//         vehicleNumberError == null) {
//       state = state.copyWith(
//         fullName: fullName,
//         email: email,
//         phone: phone,
//         vehicleNumber: vehicleNumber,
//         carType: carType,
//       );
//     }

//     return DriverValidationState(
//       fullNameError: fullNameError,
//       emailError: emailError,
//       phoneError: phoneError,
//       vehicleNumberError: vehicleNumberError,
//     );
//   }

//   void updateProfilePicture(File image) {

//     state = state.copyWith(profile: image.path);
//   }
// }

// // Riverpod Provider
// final driverProvider = StateNotifierProvider<DriverNotifier, Driver>((ref) {
//   return DriverNotifier();
// });

// // Validation State Provider
// final driverValidationProvider =
//     StateProvider<DriverValidationState>((ref) => const DriverValidationState());



