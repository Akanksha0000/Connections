class UserModel {
  final String id;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;
  final bool? userDetails;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    this.userDetails,
  });

  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phone_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userDetails: json['user_details'],
    );
  }
}
