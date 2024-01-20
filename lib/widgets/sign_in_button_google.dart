import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInButtonGoogle extends StatelessWidget {
  const SignInButtonGoogle({super.key, required this.handleGoogleSignIn});

  final void Function(GoogleAuthProvider googleAuthProvider) handleGoogleSignIn;

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

      handleGoogleSignIn(googleAuthProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to login with google: ${e.toString()}}"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sigh up with google",
          onPressed: () {
            _handleGoogleSignIn(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
