import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/screens/auths/reset_password_screen.dart';
import 'package:task_manager_app/ui/screens/auths/sign_in_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/background_widgets.dart';
import 'package:task_manager_app/ui/widgets/centered_progress-indicator.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../widgets/snack_bar_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});
  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  bool _pinVerificationInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidgets(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'A 6 digit verification pin has been sent to your email address.',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  _buildPinCodeTextField(),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _pinVerificationInProgress == false,
                    replacement: const CenteredProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapVerifyOTPButton,
                      child: const Text('Verify'),
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
    );
  }

  PinCodeTextField _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.themeColor,
      ),
      keyboardType: TextInputType.number,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
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
          ],
        ),
      ),
    );
  }

  void _onTapVerifyOTPButton() {
    _pinVerification();
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }

  Future<void> _pinVerification() async {
    _pinVerificationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.verifyPin(widget.email, _pinTEController.text));
    _pinVerificationInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess && response.responseData['status'] == 'success') {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              email: widget.email,
              otp: _pinTEController.text.trim(),
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Pin verification failed! Try again.');
      }
    }
  }

  @override
  void dispose() {
    _pinTEController.dispose();
    super.dispose();
  }
}
