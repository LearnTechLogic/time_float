import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bottle.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'bottle_detail_screen.dart';

class PickBottleScreen extends StatefulWidget {
  const PickBottleScreen({super.key});

  @override
  State<PickBottleScreen> createState() => _PickBottleScreenState();
}

class _PickBottleScreenState extends State<PickBottleScreen> with SingleTickerProviderStateMixin {
  bool _isPicking = false;
  Bottle? _pickedBottle;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickBottle() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
      _pickedBottle = null;
    });

    _animationController.repeat();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.apiService.post('/bottle/pick', {});
      
      _animationController.stop();
      
      setState(() {
        _pickedBottle = Bottle.fromJson(response['data']);
        _isPicking = false;
      });
    } catch (e) {
      _animationController.stop();
      setState(() {
        _isPicking = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_pickedBottle != null) ...[
              Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎉 捞到漂流瓶啦！',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_pickedBottle!.username != null)
                        Text(
                          '来自: ${_pickedBottle!.username}',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _pickedBottle!.content,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottleDetailScreen(bottle: _pickedBottle!),
                              ),
                            );
                          },
                          child: const Text('查看详情'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _pickedBottle = null;
                            });
                          },
                          child: const Text('继续捞取'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _isPicking ? _animation.value * 3.14 * 2 : 0,
                    child: Icon(
                      Icons.message_outlined,
                      size: 120,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                _isPicking ? '正在捞取...' : '点击按钮捞取漂流瓶',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: _isPicking ? null : _pickBottle,
                  icon: const Icon(Icons.search),
                  label: const Text('捞取漂流瓶'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
