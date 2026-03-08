import 'approval_request.dart';

/// 简单的本地 mock 数据仓库，仅在内存中维护家长相关状态
class MockParentData {
  /// 是否已完成家长绑定（仅用于演示）
  static bool isBound = true;

  /// 定位共享开关（仅演示，不做真实定位）
  static bool locationSharingEnabled = true;

  /// 审批请求列表（仅实现 activity 类型）
  static final List<ApprovalRequest> approvalRequests = [];

  /// 创建活动加入审批请求（如果已存在同一活动的请求，则不重复创建）
  static ApprovalRequest? createActivityRequest({
    required String activityId,
    required String activityTitle,
    String childName = '我',
  }) {
    final existing = approvalRequests.where((r) {
      return r.type == ApprovalRequestType.activity && r.targetId == activityId;
    }).toList();

    if (existing.isNotEmpty) {
      return existing.first;
    }

    final now = DateTime.now();
    final request = ApprovalRequest(
      id: 'req_${now.millisecondsSinceEpoch}',
      type: ApprovalRequestType.activity,
      targetId: activityId,
      targetTitle: activityTitle,
      childName: childName,
      status: ApprovalStatus.pending,
      createdAt: now.toString().substring(0, 16),
    );
    approvalRequests.add(request);
    return request;
  }

  /// 通过请求 ID 同意请求
  static void approveRequest(String requestId) {
    final request =
        approvalRequests.firstWhere((r) => r.id == requestId, orElse: () => _emptyRequest());
    if (request.id.isEmpty) return;
    request.status = ApprovalStatus.approved;
  }

  /// 通过请求 ID 拒绝请求
  static void rejectRequest(String requestId) {
    final request =
        approvalRequests.firstWhere((r) => r.id == requestId, orElse: () => _emptyRequest());
    if (request.id.isEmpty) return;
    request.status = ApprovalStatus.rejected;
  }

  /// 获取某个活动当前的审批状态（如果没有记录，返回 null）
  static ApprovalStatus? getStatusByActivityId(String activityId) {
    for (final r in approvalRequests) {
      if (r.type == ApprovalRequestType.activity && r.targetId == activityId) {
        return r.status;
      }
    }
    return null;
  }

  /// 获取待审批请求数量
  static int get pendingCount {
    return approvalRequests
        .where((r) => r.status == ApprovalStatus.pending)
        .length;
  }

  /// 用于安全处理 firstWhere 的占位空对象（外部不应直接使用）
  static ApprovalRequest _emptyRequest() {
    return ApprovalRequest(
      id: '',
      type: ApprovalRequestType.activity,
      targetId: '',
      targetTitle: '',
      childName: '',
      status: ApprovalStatus.pending,
      createdAt: '',
    );
  }
}

