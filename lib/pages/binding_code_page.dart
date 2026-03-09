import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/current_user.dart';
import '../models/binding.dart';

/// 绑定码生成/输入页面
class BindingCodePage extends StatefulWidget {
  final bool isParent; // true: 家长生成绑定码, false: 儿童输入绑定码

  const BindingCodePage({
    Key? key,
    required this.isParent,
  }) : super(key: key);

  @override
  State<BindingCodePage> createState() => _BindingCodePageState();
}

class _BindingCodePageState extends State<BindingCodePage> {
  String? _generatedCode;
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// 生成绑定码（家长端）
  void _generateCode() {
    final currentUser = CurrentUser.user;
    if (currentUser == null || !currentUser.isParent) return;

    final bindingCode = BindingCodeManager.createBindingCode(currentUser.id);
    setState(() {
      _generatedCode = bindingCode.code;
    });
  }

  /// 输入绑定码并绑定（儿童端）
  void _bindWithCode() {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入6位绑定码'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 模拟网络延迟
    Future.delayed(const Duration(milliseconds: 500), () {
      final currentUser = CurrentUser.user;
      if (currentUser == null || !currentUser.isChild) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final binding = BindingCodeManager.bind(code, currentUser.id);
      
      setState(() {
        _isLoading = false;
      });

      if (binding != null) {
        // 绑定成功
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('绑定成功！'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        // 绑定失败
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('绑定码无效或已过期，请重新输入'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  /// 复制绑定码
  void _copyCode() {
    if (_generatedCode != null) {
      Clipboard.setData(ClipboardData(text: _generatedCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已复制到剪贴板'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isParent ? Colors.orange[50] : Colors.purple[50],
      appBar: AppBar(
        title: Text(
          widget.isParent ? '生成绑定码' : '输入绑定码',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: widget.isParent ? Colors.orange[400] : Colors.purple[400],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 说明文字
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.isParent ? Icons.info_outline : Icons.qr_code,
                      color: widget.isParent ? Colors.orange[700] : Colors.purple[700],
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.isParent
                            ? '生成绑定码后，让您的孩子输入此码即可完成绑定'
                            : '请输入家长提供的6位绑定码',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (widget.isParent) ...[
                // 家长端：生成绑定码
                if (_generatedCode == null)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _generateCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        '生成绑定码',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else ...[
                  // 显示生成的绑定码
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '您的绑定码',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.orange[400]!,
                              width: 3,
                            ),
                          ),
                          child: Text(
                            _generatedCode!,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[900],
                              letterSpacing: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _copyCode,
                              icon: const Icon(Icons.copy),
                              label: const Text('复制'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[400],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _generateCode,
                              icon: const Icon(Icons.refresh),
                              label: const Text('重新生成'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.grey[800],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '绑定码24小时内有效',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                // 儿童端：输入绑定码
                Text(
                  '请输入6位绑定码',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: '000000',
                    hintStyle: TextStyle(
                      fontSize: 32,
                      color: Colors.grey[300],
                      letterSpacing: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.purple[400]!,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.purple[300]!,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.purple[400]!,
                        width: 3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _bindWithCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            '确认绑定',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
