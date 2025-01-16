import 'package:flutter/material.dart';
import 'package:project_mate/screens/messages_screen.dart';
import 'package:project_mate/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'screens/create_profile_screen.dart';
import 'screens/create_project_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/project_listing_screen.dart';
import 'state/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/favorites_screen.dart';
import 'screens/users_screen.dart';
import 'screens/user_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Match',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blueAccent,
          secondary: Colors.greenAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-profile': (context) => const CreateProfileScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/create-project': (context) => const CreateProjectScreen(),
        '/projects': (context) => const ProjectListingScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/users': (context) => const UsersScreen(),
        '/user-profile': (context) => UserProfileScreen(user: ModalRoute.of(context)!.settings.arguments as UserModel),
        '/messages': (context) => const MessagesScreen(),
        '/settings': (context) => const SettingsScreen(),

      },
    );
  }
}