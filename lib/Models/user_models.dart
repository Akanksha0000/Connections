class UserModel {
  final String id;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phone_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
