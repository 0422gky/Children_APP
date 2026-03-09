import 'package:flutter/material.dart';
import '../models/mock_parent_data.dart';
import '../models/approval_request.dart';

class ApprovalListPage extends StatefulWidget {
  const ApprovalListPage({Key? key}) : super(key: key);

  @override
  State<ApprovalListPage> createState() => _ApprovalListPageState();
}

class _ApprovalListPageState extends State<ApprovalListPage> {
  @override
  Widget build(BuildContext context) {
    final List<ApprovalRequest> pendingRequests = MockParentData
        .approvalRequests
        .where((r) => r.status == ApprovalStatus.pending)
        .toList();
    final List<ApprovalRequest> processedRequests = MockParentData
        .approvalRequests
        .where((r) => r.status != ApprovalStatus.pending)
        .toList();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          '活动审批',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.orange[400],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('待审批', Icons.pending_actions, Colors.orange[700]!),
          if (pendingRequests.isEmpty)
            _buildEmptyHint('当前没有待审批的活动申请')
          else
            ...pendingRequests.map((r) => _buildRequestCard(r, isPending: true)),
          const SizedBox(height: 24),
          _buildSectionTitle('已处理', Icons.check_circle, Colors.green[700]!),
          if (processedRequests.isEmpty)
            _buildEmptyHint('还没有已处理的申请')
          else
            ...processedRequests.map((r) => _buildRequestCard(r, isPending: false)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHint(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(ApprovalRequest request, {required bool isPending}) {
    final Color statusColor;
    switch (request.status) {
      case ApprovalStatus.pending:
        statusColor = Colors.orange[700]!;
        break;
      case ApprovalStatus.approved:
        statusColor = Colors.green[700]!;
        break;
      case ApprovalStatus.rejected:
        statusColor = Colors.red[700]!;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.targetTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '申请人：${request.childName}（演示儿童账号）',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    request.statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '申请时间：${request.createdAt}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (isPending) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        MockParentData.rejectRequest(request.id);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已拒绝该活动申请')),
                      );
                    },
                    child: const Text(
                      '拒绝',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        MockParentData.approveRequest(request.id);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已同意该活动申请')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('同意'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

