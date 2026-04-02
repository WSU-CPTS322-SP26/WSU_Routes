import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Uses similar logic to verification page, can be navigated to by the login page or preferences page (forgot or change password options)

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  late final TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isSendingCode = false;
  bool _isResettingPassword = false;
  bool _codeSent = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  Future<void> _sendResetCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email first.');
      return;
    }

    setState(() {
      _isSendingCode = true;
      _errorMessage = null;
    });

    final url = Uri.parse('http://10.0.2.2:5000/reset-password'); //http destination

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() => _codeSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              body['message'] ?? 'Reset code sent to your email.',
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              body['error'] ?? body['message'] ?? 'Unable to send reset code.';
        });
      }
      //other error cases
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _errorMessage = 'Request timed out. Please try again.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Unable to reach server. Please try again.');
    } finally {
      if (!mounted) return;
      setState(() => _isSendingCode = false);
    }
  }

  Future<void> _completePasswordReset() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (email.isEmpty || otp.isEmpty || newPassword.isEmpty) {
      setState(() => _errorMessage = 'Enter email, reset code, and new password.');
      return;
    }

    setState(() {
      _isResettingPassword = true;
      _errorMessage = null;
    });

    final url = Uri.parse('http://10.0.2.2:5000/reset-password/confirm');

    //confirm that password reset matches backend
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'otp': otp,
              'newPassword': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body['message'] ?? 'Password reset complete.'),
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage =
              body['error'] ?? body['message'] ?? 'Unable to reset password.';
        });
      }
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _errorMessage = 'Request timed out. Please try again.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Unable to reach server. Please try again.');
    } finally {
      if (!mounted) return;
      setState(() => _isResettingPassword = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isSendingCode ? null : _sendResetCode,
                child: _isSendingCode
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Reset Code'),
              ),
              if (_codeSent) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(labelText: 'Reset Code'),
                ),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isResettingPassword ? null : _completePasswordReset,
                  child: _isResettingPassword
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Reset Password'),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
