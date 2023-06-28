import 'dart:convert';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  bool? is_active;
  bool? is_staff;
  bool? is_superuser;
  List<Permission>? list_permissions;
  String? phone;
  List<Permission>? user_permissions;
  String? username;
  String? token;
  String? refreshToken;
  String? renewalToken;
  List<Map<String,dynamic>> identities;

  User({this.id, this.firstName, this.lastName, this.email, this.image, this.is_active,
    this.is_staff, this.is_superuser, this.phone, this.list_permissions, this.user_permissions,
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
        is_active: responseData['is_active'],
        is_staff: responseData['is_staff'],
        is_superuser: responseData['is_superuser'],
        phone: responseData['phone'] ?? '',
        list_permissions: List<Permission>.from(responseData['list_permissions'].map((model)=> Permission.fromJson(model))),
        user_permissions: List<Permission>.from(responseData['user_permissions'].map((model)=> Permission.fromJson(model))),
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
      'is_active': is_active,
      'is_staff': is_staff,
      'is_superuser': is_superuser,
      'phone': phone,
      'list_permissions': list_permissions == null ? [] : List<String>.from(list_permissions!.map((model)=> model.toJson())),
      'user_permissions': user_permissions == null ? [] : List<String>.from(user_permissions!.map((model)=> model.toJson())),
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
