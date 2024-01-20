import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInButtonGitHub extends StatelessWidget {
  const SignInButtonGitHub({super.key, required this.handleGitHubSignIn});

  final void Function(GithubAuthProvider gitHubAuthProvider) handleGitHubSignIn;

  void _handleGithubSignIn(BuildContext context) async {
    try {
      GithubAuthProvider githubAuthProvider = GithubAuthProvider();

      handleGitHubSignIn(githubAuthProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to login with github: ${e.toString()}}"),
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
          Buttons.gitHub,
          text: "Sigh up with gitHub",
          onPressed: () {_handleGithubSignIn(context);},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
