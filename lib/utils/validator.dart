

class ValidateField {
  ValidateField() : super();
  // ✅ Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email";
    return null;
  }

  // ✅ Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required";
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
  }

  static String? validatePan(String? value) {
    if (value == null || value.isEmpty) return "PAN number is required";
    return value.length == 10 ? null : "Enter a valid 10-digit PAN number";
  }

  static String? validateDLNumber(String? value) {
    if (value == null || value.isEmpty) return "Licence number is required";

    return value.length == 15 ? null : "Enter a valid 15-digit License number";
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return "Name is required";
    return null;
  }

  static String? validateImage(String? imagePath, String imageType) {
    if (imagePath == null || imagePath.isEmpty) {
      return "$imageType is required";
    }
    return null;
  }

  static String? validateVehicleModel(String? value) {
    if (value == null || value.isEmpty) return "Vehicle Model is required";
    return null;
  }

  static String? validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) return "Vehicle Number is required";
    return null;
  }

  static String? validateVehicleColor(String? value) {
    if (value == null || value.isEmpty) return "Vehicle Color is required";
    return null;
  }

  static String? validateVehicleType(String? value) {
    if (value == null || value.isEmpty) return "Vehicle Type is required";
    return null;
  }

  static String? validateIsEV(bool? value) {
    if (value == null) return "This Field is required";
    return null;
  }
}
