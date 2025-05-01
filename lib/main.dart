import 'package:fig_app/screens/dashboard_screen.dart';
import 'package:fig_app/screens/get_details_screen.dart';
import 'package:fig_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3dmtqdXpnaXZ5ZHl0YXBlemJwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NTUxODYsImV4cCI6MjA2MTIzMTE4Nn0.r4FuYuyqpndtiyoWf_qZilL-EHeNbmf_YnUJlDus7A0',
    url: 'https://ywvkjuzgivydytapezbp.supabase.co',
  );
  final user = Supabase.instance.client.auth.currentUser;
  Map<String, dynamic>? userProfile;
  bool showGetDetailsScreen = false;

  if (user != null) {
    final response =
        await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.id)
            .maybeSingle();
    userProfile = response;

    if (userProfile == null ||
        (userProfile['nickname'] == null || userProfile['nickname'].isEmpty) ||
        (userProfile['full_name'] == null ||
            userProfile['full_name'].isEmpty) ||
        (userProfile['company'] == null || userProfile['company'].isEmpty)) {
      showGetDetailsScreen = true;
    }
  }

  runApp(
    MyApp(
      isLoggedIn: user != null,
      userProfile: userProfile,
      showGetDetailsScreen: showGetDetailsScreen,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Map<String, dynamic>? userProfile;
  final bool showGetDetailsScreen;
  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.userProfile,
    required this.showGetDetailsScreen,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
          background: Colors.grey[50]!,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            inherit: true,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.deepPurple[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              inherit: true,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              inherit: true,
            ),
          ),
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          displayMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
            fontFamily: 'Roboto',
            inherit: true,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.deepPurple,
            fontFamily: 'Roboto',
            inherit: true,
          ),
        ),
      ),
      home:
          isLoggedIn
              ? (showGetDetailsScreen
                  ? const GetDetailsScreen()
                  : DashboardScreen(
                    nickname: userProfile?['nickname'] ?? '',
                    fullname: userProfile?['full_name'] ?? '',
                    company: userProfile?['company'] ?? '',
                  ))
              : const LoginScreen(),
    );
  }
}
