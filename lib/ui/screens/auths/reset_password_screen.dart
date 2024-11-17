import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/screens/auths/sign_in_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/background_widgets.dart';
import 'package:task_manager_app/ui/widgets/centered_progress-indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _resetPasswordInProgress = false;

  String passwordValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidgets(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Minimum length of password should be more than 6 letters and combination of number and letter.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordTEController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your new password';
                        }
                        passwordValue = value!;

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      decoration: const InputDecoration(
                        hintText: 'Confirm password',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your confirm password';
                        }
                        if (value! != passwordValue) {
                          return 'Confirm password is not correct';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _resetPasswordInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapConfirmButton,
                        child: const Text('Confirm'),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    _buildSignInSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
            text: "Have an account? ",
            children: [
              TextSpan(
                text: "Sign in",
                style: const TextStyle(
                  color: AppColors.themeColor,
                ),
                recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
              )
            ]),
      ),
    );
  }

  void _onTapConfirmButton() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }

  Future<void> _resetPassword() async {
    _resetPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestData = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _passwordTEController.text,
    };
    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.resetPassword, body: requestData);
    _resetPasswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Reset password failed! Try again.');
      }
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
