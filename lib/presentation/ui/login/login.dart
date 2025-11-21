import 'package:easacc_flutter_task/navigation/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/cubits/login_cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is already signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Navigate to settings immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).pushReplacement(InitialScreens.settings);
      });
    }

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          print("Login Success → ${state.user}");

          // Navigate to settings screen :
          GoRouter.of(context).pushReplacement(InitialScreens.settings);

        }
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final bool loading = state is LoginLoading;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [

                        const SizedBox(height: 40),

                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          height: 280,
                          child: Image.asset(
                            "assets/images/login.png",
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 50),

                        ElevatedButton(
                          onPressed: loading
                              ? null
                              : () => context.read<LoginCubit>().loginWithGoogle(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/google_icon.png", height: 28),
                              const SizedBox(width: 12),
                              Text(
                                loading ? "Loading..." : "Login with Google",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: loading
                              ? null
                              : () => context.read<LoginCubit>().loginWithFacebook(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/facebook_icon.png", height: 28),
                              const SizedBox(width: 12),
                              Text(
                                loading ? "Loading..." : "Login with Facebook",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

            ),
          ),
        );
      },
    );
  }
}
