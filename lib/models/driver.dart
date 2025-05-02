enum VehicleType {
  TWOWHEELER,
  THREEWHEELER,
  FOURWHEELERNORMAL,
  FOURWHEELERMIDRANGE,
  FOURWHEELERSUV,
}

extension CarTypeExtension on VehicleType {
  String get name {
    switch (this) {
      case VehicleType.TWOWHEELER:
        return 'Two Wheeler';
      case VehicleType.THREEWHEELER:
        return 'Three Wheeler';
      case VehicleType.FOURWHEELERNORMAL:
        return 'Four Wheeler';
      case VehicleType.FOURWHEELERMIDRANGE:
        return 'Four Wheeler Midrange';
      case VehicleType.FOURWHEELERSUV:
        return 'Four Wheeler SUV';
    }
  }
}

class Driver {
  final String token;
  final String district;
  final String pan;
  final String panCard;
  final String fullName;
  final String email;
  final String phone;
  final String id;
  final String vehicleModel;
  final String vehicleColor;
  final String vehicleNumber;
  final VehicleType vehicleType;
  final String status;
  final String profile;
  final String gender;
  final String dlBack;
  final String dlFront;
  final String dlNumber;
  final String rcPhoto;
  final String driverStatus;
  final String permit;
  final String referralCode;
  final String referredBy;
  final String rideId;
  final bool isEv;

  Driver({
    required this.token,
    required this.district,
    required this.pan,
    required this.panCard,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.id,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.status,
    required this.profile,
    required this.gender,
    required this.dlBack,
    required this.dlFront,
    required this.dlNumber,
    required this.rcPhoto,
    required this.driverStatus,
    required this.permit,
    required this.referralCode,
    required this.referredBy,
    required this.rideId,
    required this.isEv,
  });

  // Default empty driver
  factory Driver.empty() {
    return Driver(
      token: '',
      district: '',
      pan: '',
      panCard: '',
      fullName: '',
      email: '',
      phone: '',
      id: '123',
      vehicleModel: '',
      vehicleColor: '',
      vehicleNumber: '',
      vehicleType: VehicleType.TWOWHEELER,
      status: 'Pending',
      profile: '',
      gender: '',
      dlBack: '',
      dlFront: '',
      dlNumber: '',
      rcPhoto: '',
      driverStatus: 'Pending Verification',
      permit: '',
      referralCode: '',
      referredBy: '',
      rideId: '',
      isEv: false,
    );
  }

  // Copy with method for updating driver info
  Driver copyWith({
    String? token,
    String? district,
    String? pan,
    String? panCard,
    String? fullName,
    String? email,
    String? phone,
    String? id,
    String? vehicleModel,
    String? vehicleColor,
    String? vehicleNumber,
    VehicleType? vehicleType,
    String? status,
    String? profile,
    String? gender,
    String? dlBack,
    String? dlFront,
    String? dlNumber,
    String? rcPhoto,
    String? driverStatus,
    String? permit,
    String? referralCode,
    String? referredBy,
    String? rideId,
    bool? isEv,
  }) {
    return Driver(
      token: token ?? this.token,
      district: district ?? this.district,
      pan: pan ?? this.pan,
      panCard: panCard ?? this.panCard,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      id: id ?? this.id,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      status: status ?? this.status,
      profile: profile ?? this.profile,
      gender: gender ?? this.gender,
      dlBack: dlBack ?? this.dlBack,
      dlFront: dlFront ?? this.dlFront,
      dlNumber: dlNumber ?? this.dlNumber,
      rcPhoto: rcPhoto ?? this.rcPhoto,
      driverStatus: driverStatus ?? this.driverStatus,
      permit: permit ?? this.permit,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      rideId: rideId ?? this.rideId,
      isEv: isEv ?? this.isEv,
    );
  }

  String authenticateUser() {
    return token;
  }

  Map<String, dynamic> toPersonalDetails() {
    return {
      "user_id": id,
      "fullname": fullName,
      "email": email,
      "phone_number": phone,
      "sos": [],
      "role": "DRIVER",
    };
  }

  Map<String, dynamic> toVehicleDetails() {
    return {
      "user_id": 1234.toString(),
      "fullname": fullName,
      "email": email,
      "phone_number": phone,
      "sos": [],
    };
  }
}
