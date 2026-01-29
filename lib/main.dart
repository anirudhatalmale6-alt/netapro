import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/profile/create_profile_screen.dart';
import 'screens/profile/profile_view_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NetaProApp());
}

class NetaProApp extends StatelessWidget {
  const NetaProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return MaterialApp.router(
            title: 'NetaPro - Political Profile Platform',
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
            routerConfig: _createRouter(auth),
          );
        },
      ),
    );
  }

  GoRouter _createRouter(AuthProvider auth) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final isLoggedIn = auth.isAuthenticated;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';
        final isPublicProfile = state.matchedLocation.startsWith('/p/');

        // Allow public profiles without auth
        if (isPublicProfile) return null;

        // Redirect to dashboard if logged in and on auth page
        if (isLoggedIn && isAuthRoute) {
          return '/dashboard';
        }

        // Redirect to login if not logged in and not on auth page
        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/create-profile',
          builder: (context, state) => const CreateProfileScreen(),
        ),
        GoRoute(
          path: '/edit-profile/:id',
          builder: (context, state) => CreateProfileScreen(
            profileId: state.pathParameters['id'],
          ),
        ),
        GoRoute(
          path: '/p/:username',
          builder: (context, state) => ProfileViewScreen(
            username: state.pathParameters['username']!,
          ),
        ),
      ],
    );
  }
}
