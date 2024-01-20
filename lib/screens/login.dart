import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.checkLogin});

  final void Function() checkLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcom to your Diary", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 34),
          SizedBox(
            height: 50,
            child: SignInButton(
              Buttons.anonymous,
              onPressed: checkLogin,
              text: "Login",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
