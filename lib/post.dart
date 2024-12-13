class Post 
{

  final String phone_number;
  final String otp;
   
   Post({

    required this.phone_number,
    required this.otp,
   });

   factory Post.fromJson(Map<String, dynamic> json) => Post(phone_number: json['phone_number'],
    otp: json['otp'],);  
}