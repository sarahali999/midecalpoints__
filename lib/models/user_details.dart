class UserDetails {
  final String? message;
  final Data? data;
  final bool? error;

  UserDetails({this.message, this.data, this.error});
  UserDetails.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        data = json['data'] != null ? Data.fromJson(json['data']) : null,
        error = json['error'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data!.toJson();
    }
    jsonData['error'] = error;
    return jsonData;
  }
}

class Data {
  final int? gender;
  final String? address;
  final String? country;
  final String? province;
  final String? district;
  final String? alley;
  final String? house;
  final int? bloodType;
  final String? chronicDiseases;
  final String? allergies;
  final String? birthYear;
  final String? emergencyContactFullName;
  final String? emergencyContactAddress;
  final String? emergencyContactCountry;
  final String? emergencyContactProvince;
  final String? emergencyContactDistrict;
  final String? emergencyContactAlley;
  final String? emergencyContactHouse;
  final String? emergencyContactPhoneNumber;
  final int? emergencyContactRelationship;
  final String? randomCode;
  final String? userId;
  final User? user;
  final dynamic createdBy;
  final dynamic createdById;
  final dynamic modifiedBy;
  final dynamic modifiedById;
  final dynamic deletedBy;
  final dynamic deletedById;
  final String? createdAt;
  final String? modifiedAt;
  final dynamic deletedAt;
  final bool? isDeleted;
  final String? id;

  Data({
    this.gender,
    this.address,
    this.country,
    this.province,
    this.district,
    this.alley,
    this.house,
    this.bloodType,
    this.chronicDiseases,
    this.allergies,
    this.birthYear,
    this.emergencyContactFullName,
    this.emergencyContactAddress,
    this.emergencyContactCountry,
    this.emergencyContactProvince,
    this.emergencyContactDistrict,
    this.emergencyContactAlley,
    this.emergencyContactHouse,
    this.emergencyContactPhoneNumber,
    this.emergencyContactRelationship,
    this.randomCode,
    this.userId,
    this.user,
    this.createdBy,
    this.createdById,
    this.modifiedBy,
    this.modifiedById,
    this.deletedBy,
    this.deletedById,
    this.createdAt,
    this.modifiedAt,
    this.deletedAt,
    this.isDeleted,
    this.id,
  });

  Data.fromJson(Map<String, dynamic> json)
      : gender = json['gender'],
        address = json['address'],
        country = json['country'],
        province = json['province'],
        district = json['district'],
        alley = json['alley'],
        house = json['house'],
        bloodType = json['bloodType'],
        chronicDiseases = json['chronicDiseases'],
        allergies = json['allergies'],
        birthYear = json['birthYear'],
        emergencyContactFullName = json['emergencyContactFullName'],
        emergencyContactAddress = json['emergencyContactAddress'],
        emergencyContactCountry = json['emergencyContactCountry'],
        emergencyContactProvince = json['emergencyContactProvince'],
        emergencyContactDistrict = json['emergencyContactDistrict'],
        emergencyContactAlley = json['emergencyContactAlley'],
        emergencyContactHouse = json['emergencyContactHouse'],
        emergencyContactPhoneNumber = json['emergencyContactPhoneNumber'],
        emergencyContactRelationship = json['emergencyContactRelationship'],
        randomCode = json['randomCode'],
        userId = json['userId'],
        user = json['user'] != null ? User.fromJson(json['user']) : null,
        createdBy = json['createdBy'],
        createdById = json['createdById'],
        modifiedBy = json['modifiedBy'],
        modifiedById = json['modifiedById'],
        deletedBy = json['deletedBy'],
        deletedById = json['deletedById'],
        createdAt = json['createdAt'],
        modifiedAt = json['modifiedAt'],
        deletedAt = json['deletedAt'],
        isDeleted = json['isDeleted'],
        id = json['id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['gender'] = gender;
    jsonData['address'] = address;
    jsonData['country'] = country;
    jsonData['province'] = province;
    jsonData['district'] = district;
    jsonData['alley'] = alley;
    jsonData['house'] = house;
    jsonData['bloodType'] = bloodType;
    jsonData['chronicDiseases'] = chronicDiseases;
    jsonData['allergies'] = allergies;
    jsonData['birthYear'] = birthYear;
    jsonData['emergencyContactFullName'] = emergencyContactFullName;
    jsonData['emergencyContactAddress'] = emergencyContactAddress;
    jsonData['emergencyContactCountry'] = emergencyContactCountry;
    jsonData['emergencyContactProvince'] = emergencyContactProvince;
    jsonData['emergencyContactDistrict'] = emergencyContactDistrict;
    jsonData['emergencyContactAlley'] = emergencyContactAlley;
    jsonData['emergencyContactHouse'] = emergencyContactHouse;
    jsonData['emergencyContactPhoneNumber'] = emergencyContactPhoneNumber;
    jsonData['emergencyContactRelationship'] = emergencyContactRelationship;
    jsonData['randomCode'] = randomCode;
    jsonData['userId'] = userId;
    if (user != null) {
      jsonData['user'] = user!.toJson();
    }
    jsonData['createdBy'] = createdBy;
    jsonData['createdById'] = createdById;
    jsonData['modifiedBy'] = modifiedBy;
    jsonData['modifiedById'] = modifiedById;
    jsonData['deletedBy'] = deletedBy;
    jsonData['deletedById'] = deletedById;
    jsonData['createdAt'] = createdAt;
    jsonData['modifiedAt'] = modifiedAt;
    jsonData['deletedAt'] = deletedAt;
    jsonData['isDeleted'] = isDeleted;
    jsonData['id'] = id;
    return jsonData;
  }
}

class User {
  final String? username;
  final String? password;
  final int? role;
  final String? phoneNumber;
  final String? email;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? createdAt;
  final String? modifiedAt;
  final dynamic deletedAt;
  final bool? isDeleted;
  final String? id;

  User({
    this.username,
    this.password,
    this.role,
    this.phoneNumber,
    this.email,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.createdAt,
    this.modifiedAt,
    this.deletedAt,
    this.isDeleted,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        role = json['role'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        firstName = json['firstName'],
        secondName = json['secondName'],
        thirdName = json['thirdName'],
        createdAt = json['createdAt'],
        modifiedAt = json['modifiedAt'],
        deletedAt = json['deletedAt'],
        isDeleted = json['isDeleted'],
        id = json['id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['username'] = username;
    jsonData['password'] = password;
    jsonData['role'] = role;
    jsonData['phoneNumber'] = phoneNumber;
    jsonData['email'] = email;
    jsonData['firstName'] = firstName;
    jsonData['secondName'] = secondName;
    jsonData['thirdName'] = thirdName;
    jsonData['createdAt'] = createdAt;
    jsonData['modifiedAt'] = modifiedAt;
    jsonData['deletedAt'] = deletedAt;
    jsonData['isDeleted'] = isDeleted;
    jsonData['id'] = id;
    return jsonData;
  }
}