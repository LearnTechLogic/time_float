import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bottle.dart';
import '../models/reply.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class BottleDetailScreen extends StatefulWidget {
  final Bottle bottle;

  const BottleDetailScreen({super.key, required this.bottle});

  @override
  State<BottleDetailScreen> createState() => _BottleDetailScreenState();
}

class _BottleDetailScreenState extends State<BottleDetailScreen> {
  List<Reply> _replies = [];
  final _replyController = TextEditingController();
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadReplies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.apiService.get('/reply/list/${widget.bottle.id}');

      if (mounted) {
        setState(() {
          _replies = (response['data'] as List)
              .map((json) => Reply.fromJson(json))
              .toList();
        });
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
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user!.id;
      
      int toUserId;
      if (widget.bottle.userId == userId) {
        toUserId = widget.bottle.pickedUserId!;
      } else {
        toUserId = widget.bottle.userId;
      }

      await authProvider.apiService.post('/reply/send', {
        'bottleId': widget.bottle.id,
        'toUserId': toUserId,
        'content': _replyController.text.trim(),
      });

      if (mounted) {
        _replyController.clear();
        await _loadReplies();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('回复成功！')),
        );
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final canReply = widget.bottle.isPicked && 
        (widget.bottle.userId == authProvider.user?.id || 
         widget.bottle.pickedUserId == authProvider.user?.id);

    return Scaffold(
      appBar: AppBar(title: const Text('漂流瓶详情')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.bottle.username != null)
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: Text(
                                    widget.bottle.username!.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.bottle.username!,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${widget.bottle.createdAt.year}-${widget.bottle.createdAt.month}-${widget.bottle.createdAt.day}',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),
                          Text(
                            widget.bottle.content,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '回复 (${_replies.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_replies.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          '还没有回复',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._replies.map((reply) {
                      final isMe = reply.fromUserId == authProvider.user?.id;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                reply.fromUsername ?? '用户',
                                style: TextStyle(
                                  color: isMe ? Colors.white70 : AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reply.content,
                                style: TextStyle(
                                  color: isMe ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          if (canReply)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        decoration: const InputDecoration(
                          hintText: '写回复...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        enabled: !_isSending,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: _isSending ? null : _sendReply,
                      icon: _isSending
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.send),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
