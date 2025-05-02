class AppUser {
  final String id;
  final String email;
  final String? nickname;
  final String? fullName;
  final String? company;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final String? phone;
  final String? address;
  final String? role;
  final String? profile_pic_url;

  AppUser({
    required this.id,
    required this.email,
    this.nickname,
    this.fullName,
    this.company,
    this.profileImageUrl,
    this.createdAt,
    this.phone,
    this.address,
    this.role,
    this.profile_pic_url,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] as String,
      nickname: map['nickname'] as String?,
      fullName: map['full_name'] as String?,
      company: map['company'] as String?,
      profileImageUrl: map['profile_image_url'] as String?,
      createdAt:
          map['created_at'] != null
              ? DateTime.tryParse(map['created_at'])
              : null,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      role: map['role'] as String?,
      profile_pic_url: map['profile_pic_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'full_name': fullName,
      'company': company,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt?.toIso8601String(),
      'phone': phone,
      'address': address,
      'role': role,
      'profile_pic_url': profile_pic_url,
    };
  }
}
