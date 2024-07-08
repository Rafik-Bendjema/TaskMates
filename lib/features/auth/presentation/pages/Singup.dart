import 'package:flutter/material.dart';
import 'package:taskmates/core/widgets/background.dart';
import 'package:taskmates/features/auth/data/user.dart';
import 'package:taskmates/features/auth/domain/firebase/userDb.dart';
import 'package:taskmates/features/auth/presentation/pages/Signin.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reEmailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateReEmail(String? value) {
    if (value != _emailController.text) {
      return 'Emails do not match';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an ID';
    }
    if (value.length < 4) {
      return 'ID too short';
    }
    return null;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      UserDb userDb = UserDbImpl();
      UserModel u = UserModel(
          id: _idController.text,
          email: _emailController.text,
          pwd: _pwdController.text);
      UserModel? result = await userDb.singUp(u);
      if (result != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Signin()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        background(context),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(labelText: 'ID'),
                    validator: _validateId,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reEmailController,
                    decoration:
                        const InputDecoration(labelText: 'Re-enter Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateReEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pwdController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _reEmailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }
}
