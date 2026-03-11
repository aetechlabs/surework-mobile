import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/gig_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/wallet_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/gigs/gig_list_screen.dart';
import 'screens/gigs/gig_detail_screen.dart';
import 'screens/gigs/create_gig_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/wallet/wallet_screen.dart';
import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('auth');

  runApp(const SureWorkApp());
}

class SureWorkApp extends StatelessWidget {
  const SureWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GigProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: 'SureWork',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: _router(authProvider),
          );
        },
      ),
    );
  }

  GoRouter _router(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoading = authProvider.isLoading;

        if (isLoading) {
          return '/splash';
        }

        if (!isAuthenticated && 
            !state.matchedLocation.startsWith('/login') && 
            !state.matchedLocation.startsWith('/register')) {
          return '/login';
        }

        if (isAuthenticated && 
            (state.matchedLocation == '/login' || 
             state.matchedLocation == '/register' ||
             state.matchedLocation == '/splash')) {
          return '/home';
        }

        return null;
      },
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
          path: '/gigs',
          builder: (context, state) => const GigListScreen(),
        ),
        GoRoute(
          path: '/gigs/create',
          builder: (context, state) => const CreateGigScreen(),
        ),
        GoRoute(
          path: '/gigs/:id',
          builder: (context, state) {
            final gigId = state.pathParameters['id']!;
            return GigDetailScreen(gigId: gigId);
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/wallet',
          builder: (context, state) => const WalletScreen(),
        ),
      ],
    );
  }
}
