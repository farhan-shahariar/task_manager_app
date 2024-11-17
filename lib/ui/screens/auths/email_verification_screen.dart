import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/screens/auths/pin_verification_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/utility/app_constants.dart';
import 'package:task_manager_app/ui/widgets/background_widgets.dart';
import 'package:task_manager_app/ui/widgets/centered_progress-indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  bool _emailVerificationInProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                      'Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'A 6 digit verification pin will be sent to your email address.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return 'Enter a valid email address!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _emailVerificationInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapConfirmButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
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
          ])),
    );
  }

  void _onTapConfirmButton() {
    if (_formKey.currentState!.validate()) {
      _emailVerification();
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  Future<void> _emailVerification() async {
    _emailVerificationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.verifyEmail(_emailTEController.text.trim()),
    );

    _emailVerificationInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess && response.responseData["status"] == "success") {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PinVerificationScreen(
                      email: _emailTEController.text.trim(),
                    )));
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Email verification failed! Try again.');
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
