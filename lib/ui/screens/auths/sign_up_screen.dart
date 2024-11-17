import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/utility/app_constants.dart';
import 'package:task_manager_app/ui/widgets/background_widgets.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

import '../../utility/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _registrationInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidgets(
        child: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your email address.';
                      }
                      if (AppConstants.emailRegExp.hasMatch(value!) == false) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileTEController,
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: _showPassword == false,
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _showPassword = !_showPassword;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        icon: Icon(_showPassword
                            ? Icons.remove_red_eye
                            : Icons.visibility_off),
                      ),
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your password.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _registrationInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerUser();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined)),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  buildBackToSignInSection()
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Widget buildBackToSignInSection() {
    return Center(
      child: RichText(
          text: TextSpan(
              text: "Have an account? ",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
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

  Future<void> _registerUser() async {
    _registrationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestInput = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": ""
    };
    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    _registrationInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        showSnackBarMessage(context, 'Registration success');
        _clearTextFields();
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Registration failed! Try again.');
        _clearTextFields();
      }
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
