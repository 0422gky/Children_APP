import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/current_user.dart';

/// 身份选择页面（首次进入时选择家长/儿童身份）
class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({Key? key}) : super(key: key);

  void _selectRole(BuildContext context, UserRole role) {
    // 根据选择的角色初始化用户
    if (role == UserRole.parent) {
      CurrentUser.initDefaultParentUser();
    } else {
      CurrentUser.initDefaultChildUser();
    }

    // 跳转到登录页面
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/图标区域
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.purple[300],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple, width: 4),
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                // 标题
                Text(
                  '选择您的身份',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '请选择您的身份类型',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),
                // 家长身份卡片
                _buildRoleCard(
                  context,
                  title: '👨‍👩‍👧 我是家长',
                  description: '管理孩子的社交活动\n审批活动申请',
                  color: Colors.orange[400]!,
                  onTap: () => _selectRole(context, UserRole.parent),
                ),
                const SizedBox(height: 24),
                // 儿童身份卡片
                _buildRoleCard(
                  context,
                  title: '👶 我是小朋友',
                  description: '寻找小伙伴\n参加有趣的活动',
                  color: Colors.purple[400]!,
                  onTap: () => _selectRole(context, UserRole.child),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '选择',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
