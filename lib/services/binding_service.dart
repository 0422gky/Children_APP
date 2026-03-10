import '../database/database_helper.dart';
import '../models/db_child_profile.dart';
import '../models/db_binding.dart';

/// 绑定服务
/// 负责家长绑定码生成、儿童绑定等操作
class BindingService {
  static final BindingService instance = BindingService._init();
  BindingService._init();

  final DatabaseHelper _db = DatabaseHelper.instance;

  /// 生成6位绑定码
  String _generateBindCode() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final code = (random % 1000000).toString().padLeft(6, '0');
    return code;
  }

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 为家长生成绑定码
  /// 
  /// 参数：
  /// - parentUserId: 家长用户ID
  /// 
  /// 返回：生成的6位绑定码
  Future<String> generateBindCode(String parentUserId) async {
    // 检查家长资料是否存在
    final profileMap = await _db.getParentProfileByUserId(parentUserId);
    if (profileMap == null) {
      throw Exception('家长资料不存在');
    }

    // 生成绑定码
    String bindCode = '';
    bool codeExists = true;
    
    // 确保绑定码唯一
    while (codeExists) {
      bindCode = _generateBindCode();
      final existing = await _db.getParentProfileByBindCode(bindCode);
      codeExists = existing != null;
    }

    // 更新家长资料
    await _db.updateParentProfile(parentUserId, {'bind_code': bindCode});

    return bindCode;
  }

  /// 获取家长的绑定码
  /// 
  /// 参数：
  /// - parentUserId: 家长用户ID
  /// 
  /// 返回：绑定码，如果不存在则生成新的
  Future<String> getOrGenerateBindCode(String parentUserId) async {
    final profileMap = await _db.getParentProfileByUserId(parentUserId);
    if (profileMap == null) {
      throw Exception('家长资料不存在');
    }

    final bindCode = profileMap['bind_code'] as String?;
    if (bindCode != null && bindCode.isNotEmpty) {
      return bindCode;
    }

    // 如果没有绑定码，生成一个新的
    return await generateBindCode(parentUserId);
  }

  /// 儿童绑定家长
  /// 
  /// 参数：
  /// - childUserId: 儿童用户ID
  /// - bindCode: 绑定码
  /// 
  /// 返回：绑定是否成功
  Future<bool> bindChildToParent(String childUserId, String bindCode) async {
    // 根据绑定码查找家长
    final parentProfileMap = await _db.getParentProfileByBindCode(bindCode);
    if (parentProfileMap == null) {
      return false; // 绑定码无效
    }

    final parentUserId = parentProfileMap['user_id'] as String;

    // 检查是否已经绑定
    final existingBinding = await _db.getBindingByChildId(childUserId);
    if (existingBinding != null) {
      return false; // 已经绑定过
    }

    // 创建绑定关系
    final bindingId = _generateId();
    final binding = DbBinding(
      id: bindingId,
      parentUserId: parentUserId,
      childUserId: childUserId,
      bindCode: bindCode,
      status: 'approved', // 直接批准
    );

    await _db.insertBinding(binding.toMap());

    // 更新儿童资料
    await _db.updateChildProfile(childUserId, {
      'parent_user_id': parentUserId,
    });

    return true;
  }

  /// 获取家长绑定的所有儿童
  /// 
  /// 参数：
  /// - parentUserId: 家长用户ID
  /// 
  /// 返回：绑定的儿童资料列表
  Future<List<DbChildProfile>> getChildrenByParent(String parentUserId) async {
    final childrenMaps = await _db.getChildrenByParentId(parentUserId);
    return childrenMaps.map((map) => DbChildProfile.fromMap(map)).toList();
  }

  /// 获取儿童绑定的家长ID
  /// 
  /// 参数：
  /// - childUserId: 儿童用户ID
  /// 
  /// 返回：家长用户ID，如果未绑定返回 null
  Future<String?> getParentByChild(String childUserId) async {
    final childProfileMap = await _db.getChildProfileByUserId(childUserId);
    if (childProfileMap == null) return null;
    return childProfileMap['parent_user_id'] as String?;
  }
}
