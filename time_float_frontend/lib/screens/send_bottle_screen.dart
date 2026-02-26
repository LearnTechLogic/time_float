import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class SendBottleScreen extends StatefulWidget {
  const SendBottleScreen({super.key});

  @override
  State<SendBottleScreen> createState() => _SendBottleScreenState();
}

class _SendBottleScreenState extends State<SendBottleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _sendBottle() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.apiService.post('/bottle/send', {
          'content': _contentController.text.trim(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('漂流瓶发送成功！')),
          );
          _contentController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '写下你的故事',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '让它漂向未知的远方',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _contentController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: '写下你想说的话...',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入内容';
                    }
                    if (value.trim().length > 500) {
                      return '内容不能超过500字';
                    }
                    return null;
                  },
                  enabled: !_isSending,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isSending ? null : _sendBottle,
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    label: Text(_isSending ? '发送中...' : '发送漂流瓶'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
