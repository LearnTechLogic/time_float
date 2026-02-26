import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bottle.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'bottle_detail_screen.dart';

class MyBottlesScreen extends StatefulWidget {
  const MyBottlesScreen({super.key});

  @override
  State<MyBottlesScreen> createState() => _MyBottlesScreenState();
}

class _MyBottlesScreenState extends State<MyBottlesScreen> {
  int _selectedTab = 0;
  List<Bottle> _myBottles = [];
  List<Bottle> _pickedBottles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBottles();
  }

  Future<void> _loadBottles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final myResponse = await authProvider.apiService.get('/bottle/my');
      final pickedResponse = await authProvider.apiService.get('/bottle/picked');

      if (mounted) {
        setState(() {
          _myBottles = (myResponse['data'] as List)
              .map((json) => Bottle.fromJson(json))
              .toList();
          _pickedBottles = (pickedResponse['data'] as List)
              .map((json) => Bottle.fromJson(json))
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('我的漂流瓶'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            tabs: const [
              Tab(text: '我发送的'),
              Tab(text: '我捞取的'),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _loadBottles,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    _buildBottleList(_myBottles, '还没有发送漂流瓶'),
                    _buildBottleList(_pickedBottles, '还没有捞取漂流瓶'),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBottleList(List<Bottle> bottles, String emptyMessage) {
    if (bottles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bottles.length,
      itemBuilder: (context, index) {
        final bottle = bottles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                bottle.isPicked ? Icons.mark_email_read : Icons.mark_email_unread,
                color: Colors.white,
              ),
            ),
            title: Text(
              bottle.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bottle.username != null && _selectedTab == 1)
                  Text('来自: ${bottle.username}'),
                if (bottle.pickedUsername != null && _selectedTab == 0)
                  Text('被: ${bottle.pickedUsername} 捞取'),
                Text(
                  '${bottle.createdAt.month}-${bottle.createdAt.day} ${bottle.createdAt.hour}:${bottle.createdAt.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottleDetailScreen(bottle: bottle),
                ),
              ).then((_) => _loadBottles());
            },
          ),
        );
      },
    );
  }
}
