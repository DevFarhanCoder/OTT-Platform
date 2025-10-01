import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/auth_provider.dart';
import 'providers/content_provider.dart';
import 'providers/subscription_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/content/video_player_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/subscription/subscription_screen.dart';
import 'screens/content/content_detail_screen.dart';
import 'screens/search/search_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const EmmarOTTApp());
}

class EmmarOTTApp extends StatelessWidget {
  const EmmarOTTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Emmar Films & Music',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: AppColors.backgroundColor,
              fontFamily: GoogleFonts.poppins().fontFamily,
              textTheme: GoogleFonts.poppinsTextTheme(),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.backgroundColor,
                elevation: 0,
                titleTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: AppColors.cardColor,
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
              ),
            ),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/video/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return VideoPlayerScreen(videoId: id);
      },
    ),
    GoRoute(
      path: '/content/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ContentDetailScreen(contentId: id);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);