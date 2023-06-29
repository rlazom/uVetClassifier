import 'dart:convert';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  bool? isActive;
  bool? isStaff;
  bool? isSuperuser;
  List<Permission>? listPermissions;
  String? phone;
  List<Permission>? userPermissions;
  String? username;
  String? token;
  String? refreshToken;
  String? renewalToken;
  List<Map<String,dynamic>> identities;

  User({this.id, this.firstName, this.lastName, this.email, this.image, this.isActive,
    this.isStaff, this.isSuperuser, this.phone, this.listPermissions, this.userPermissions,
    this.username, this.token, this.refreshToken, this.renewalToken, this.identities = const []});

  String? get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> responseData) {
    List identities = responseData['identities'] ?? [];
    return User(
        id: responseData['id'],
        firstName: responseData['first_name'],
        lastName: responseData['last_name'],
        email: responseData['email'],
        image: responseData['image'] ?? '',
        isActive: responseData['is_active'],
        isStaff: responseData['is_staff'],
        isSuperuser: responseData['is_superuser'],
        phone: responseData['phone'] ?? '',
        listPermissions: List<Permission>.from(responseData['list_permissions'].map((model)=> Permission.fromJson(model))),
        userPermissions: List<Permission>.from(responseData['user_permissions'].map((model)=> Permission.fromJson(model))),
        username: responseData['username'],
        token: responseData['token'],
        refreshToken: responseData['refresh_token'],
        renewalToken: responseData['renewal_token'],
        identities: List.from(identities),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'image': image,
      'is_active': isActive,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'phone': phone,
      'list_permissions': listPermissions == null ? [] : List<String>.from(listPermissions!.map((model)=> model.toJson())),
      'user_permissions': userPermissions == null ? [] : List<String>.from(userPermissions!.map((model)=> model.toJson())),
      'username': username,
      'token': token,
      'refresh_token': refreshToken,
      'renewalToken': renewalToken,
      'identities': identities,
    };
  }
}

class Permission {
  int? id;
  dynamic contentType;
  String? name;

  Permission({this.id, this.contentType, this.name});

  factory Permission.fromJson(Map<String, dynamic> responseData) {
    return Permission(
      id: responseData['id'],
      contentType: responseData['content_type'],
      name: responseData['name']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_type': json.encode(contentType),
      'name': name
    };
  }
}
