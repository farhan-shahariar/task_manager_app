import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/user_model.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/controllers/auth_controller.dart';
import 'package:task_manager_app/ui/widgets/background_widgets.dart';
import 'package:task_manager_app/ui/widgets/centered_progress-indicator.dart';
import 'package:task_manager_app/ui/widgets/profile_app_bar.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    final userData = AuthController.userData!;
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameTEController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context, true),
      body: BackgroundWidgets(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  buildPhotoPickerWidget(),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    enabled: false,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _mobileTEController,
                    decoration:
                        const InputDecoration(hintText: 'Mobile Number'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                      visible: _updateProfileInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: _onTapConfirmButton,
                          child:
                              const Icon(Icons.arrow_circle_right_outlined))),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapConfirmButton() async {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    String encodedPhoto = AuthController.userData?.photo ?? '';
    _updateProfileInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text,
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };
    if (_passwordTEController.text.trim().isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }
    if (_selectedImage != null) {
      File file = File(_selectedImage!.path);
      encodedPhoto = base64Encode(file.readAsBytesSync());
      requestBody['photo'] = encodedPhoto;
    }

    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.updateProfile, body: requestBody);
    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel(
          email: _emailTEController.text,
          firstName: _firstNameTEController.text,
          lastName: _lastNameTEController.text,
          mobile: _mobileTEController.text,
          photo: encodedPhoto);
      await AuthController.saveUserData(userModel);
      if (mounted) {
        showSnackBarMessage(context, 'Profile updated.');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMessage ?? 'Profile update failed! Try again.');
      }
    }
    _updateProfileInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Widget buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Container(
        width: double.maxFinite,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              height: 48,
              width: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: Colors.grey,
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Text(
                _selectedImage?.name ?? 'No image selected.',
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ),
    );
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

  Future<void> _pickProfileImage() async {
    final imagePicker = ImagePicker();
    final XFile? result =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (result != null) {
      _selectedImage = result;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
