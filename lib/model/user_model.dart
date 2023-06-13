import 'date_model.dart';

class UserModel {
  String name;
  String email;
  String ? bio;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  String bloodGroup;
  DateModel ? dateModel;
  String ? location;
  String ? additionalPhoneNumber;
  int ? numOfBloodDonation;

  UserModel({
    required this.name,
    required this.email,
     this.bio,
    required this.profilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
     this.dateModel,
    required this.bloodGroup,
     this.location,
    this.additionalPhoneNumber,
    this.numOfBloodDonation


  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      profilePic: map['profilePic'] ?? '',
      dateModel: map['dateModel'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      location: map['additionalPhoneNumber'] ?? '',
      additionalPhoneNumber: map['additionalPhoneNumber'] ?? '',
      numOfBloodDonation: map['numOfBloodDonation'] ?? '',

    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "bio": bio,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "dateModel": dateModel,
      "bloodGroup":bloodGroup,
      "additionalPhoneNumber":additionalPhoneNumber,
      "numOfBloodDonation":numOfBloodDonation,

    };
  }
}
