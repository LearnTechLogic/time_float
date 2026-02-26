import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.register(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('注册成功，请登录')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('注册')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                    prefixIcon: Icon(Icons.person_outline),
                    helperText: '3-20个字符',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入用户名';
                    }
                    if (value.trim().length < 3 || value.trim().length > 20) {
                      return '用户名长度必须在3-20之间';
                    }
                    return null;
                  },
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: '密码',
                    prefixIcon: const Icon(Icons.lock_outline),
                    helperText: '6-20个字符',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入密码';
                    }
                    if (value.trim().length < 6 || value.trim().length > 20) {
                      return '密码长度必须在6-20之间';
                    }
                    return null;
                  },
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: '确认密码',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请确认密码';
                    }
                    if (value != _passwordController.text) {
                      return '两次输入的密码不一致';
                    }
                    return null;
                  },
                  enabled: !authProvider.isLoading,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _submit,
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('注册'),
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
