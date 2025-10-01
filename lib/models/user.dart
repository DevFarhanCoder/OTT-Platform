class User {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String? phone;
  final DateTime createdAt;
  final bool isVerified;
  final String subscriptionType;
  final DateTime? subscriptionExpiry;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    this.phone,
    required this.createdAt,
    this.isVerified = false,
    this.subscriptionType = 'free',
    this.subscriptionExpiry,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isVerified: json['is_verified'] ?? false,
      subscriptionType: json['subscription_type'] ?? 'free',
      subscriptionExpiry: json['subscription_expiry'] != null 
          ? DateTime.parse(json['subscription_expiry']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_image': profileImage,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'is_verified': isVerified,
      'subscription_type': subscriptionType,
      'subscription_expiry': subscriptionExpiry?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
    String? phone,
    DateTime? createdAt,
    bool? isVerified,
    String? subscriptionType,
    DateTime? subscriptionExpiry,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
    );
  }
}