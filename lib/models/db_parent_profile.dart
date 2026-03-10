/// 家长资料模型（用于存储到 SQLite）
class DbParentProfile {
  final String userId;
  final String parentName;
  final String? phone;
  final String? bindCode; // 6位绑定码

  DbParentProfile({
    required this.userId,
    required this.parentName,
    this.phone,
    this.bindCode,
  });

  /// 从 Map 创建（从数据库读取）
  factory DbParentProfile.fromMap(Map<String, dynamic> map) {
    return DbParentProfile(
      userId: map['user_id'] as String,
      parentName: map['parent_name'] as String,
      phone: map['phone'] as String?,
      bindCode: map['bind_code'] as String?,
    );
  }

  /// 转换为 Map（用于数据库写入）
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'parent_name': parentName,
      'phone': phone,
      'bind_code': bindCode,
    };
  }
}
