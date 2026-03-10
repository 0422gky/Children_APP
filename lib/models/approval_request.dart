enum ApprovalRequestType {
  activity,
}

enum ApprovalStatus {
  pending,
  approved,
  rejected,
}

class ApprovalRequest {
  final String id;
  final ApprovalRequestType type;
  final String targetId;
  final String targetTitle;
  final String childName;
  ApprovalStatus status;
  final String createdAt;

  ApprovalRequest({
    required this.id,
    required this.type,
    required this.targetId,
    required this.targetTitle,
    required this.childName,
    required this.status,
    required this.createdAt,
  });

  String get statusLabel {
    switch (status) {
      case ApprovalStatus.pending:
        return '待审批';
      case ApprovalStatus.approved:
        return '已同意';
      case ApprovalStatus.rejected:
        return '已拒绝';
    }
  }
}

