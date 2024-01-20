import 'package:diaryapp/widgets/sign_in_button_github.dart';
import 'package:diaryapp/widgets/sign_in_button_google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen(
      {super.key,
      required this.handleGoogleSignIn,
      required this.handleGitHubSignIn});

  final void Function(GoogleAuthProvider googleAuthProvider) handleGoogleSignIn;
  final void Function(GithubAuthProvider gitHubAuthProvider) handleGitHubSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Sign in to continue", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 16),
        SignInButtonGoogle(handleGoogleSignIn: handleGoogleSignIn),
        const SizedBox(height: 16),
        SignInButtonGitHub(handleGitHubSignIn: handleGitHubSignIn),
      ],
    );
  }
}
