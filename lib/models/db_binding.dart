/// 绑定关系模型（用于存储到 SQLite）
class DbBinding {
  final String id;
  final String parentUserId;
  final String childUserId;
  final String bindCode;
  final String status; // 'pending' 或 'approved'

  DbBinding({
    required this.id,
    required this.parentUserId,
    required this.childUserId,
    required this.bindCode,
    required this.status,
  });

  /// 从 Map 创建（从数据库读取）
  factory DbBinding.fromMap(Map<String, dynamic> map) {
    return DbBinding(
      id: map['id'] as String,
      parentUserId: map['parent_user_id'] as String,
      childUserId: map['child_user_id'] as String,
      bindCode: map['bind_code'] as String,
      status: map['status'] as String,
    );
  }

  /// 转换为 Map（用于数据库写入）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent_user_id': parentUserId,
      'child_user_id': childUserId,
      'bind_code': bindCode,
      'status': status,
    };
  }
}
