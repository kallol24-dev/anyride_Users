import 'package:anyride_captain/models/coordinates.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Profile profile;
  final Coordinates coordinates;
  final String sos;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profile,
    required this.coordinates,
    required this.sos,
  });

  factory User.empty() {
    return User(
      id: '',
      name: '',
      email: '',
      phone: '',
      sos: '',
      profile: Profile.empty(),
      coordinates: Coordinates.empty(),
    );
  }
  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    Coordinates? coordinates,
    Profile? profile,
    String? sos,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      coordinates: coordinates ?? this.coordinates,
      profile: profile ?? this.profile,
      sos: sos ?? this.sos,
    );
  }

  Map<String, dynamic> toProfileDetails() {
    return {
      "user_id": id,
      "fullname": name,
      "email": email,
      "phone_number": phone,
      "sos": [],
    };
  }
}

class Profile {
  final String profilePicture;

  Profile({required this.profilePicture});

  factory Profile.empty() {
    return Profile(profilePicture: '');
  }
}


