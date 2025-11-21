import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/screens.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google
      try {
        final googleSignIn = GoogleSignIn();
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.signOut();
        }
      } catch (e) {
        print("Google sign-out error: $e");
      }

      // Sign out from Facebook
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {
        print("Facebook sign-out error: $e");
      }

      if(context.mounted){
        // Navigate back to login
        GoRouter.of(context).pushReplacement(InitialScreens.login);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _logout(context),
      icon: const Icon(Icons.logout, color: Colors.white),
      tooltip: 'Logout', // Optional: shows on long press
    );
  }
}
