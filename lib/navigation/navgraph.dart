import 'package:easacc_flutter_task/navigation/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/colors.dart';
import '../core/utils/service_locator.dart';
import '../data/repository/task_repository_impl.dart';
import '../presentation/manager/cubits/login_cubit/login_cubit.dart';
import '../presentation/ui/login/login.dart';
import '../presentation/ui/settings/settings.dart';
import '../presentation/ui/webview/webview.dart';

class NavGraph extends StatelessWidget {
  const NavGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LoginCubit(getIt.get<TaskRepositoryImpl>())
        ),


      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.appColor,
          textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: InitialScreens.login,
  routes: [
    GoRoute(
      path: InitialScreens.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: InitialScreens.settings,
      name: 'settings',
      builder: (context, state) => SettingsScreen(),
    ),
    GoRoute(
      path: InitialScreens.webview,
      name: 'webview',
      builder: (context, state) => const WebViewScreen(),
    ),

  ],
);



