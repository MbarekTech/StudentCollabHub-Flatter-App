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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'state/app_state.dart';
import 'models/user_model.dart';
import 'models/project_model.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize sample data
  await initializeSampleData();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

// Function to initialize sample users and projects
Future<void> initializeSampleData() async {
  final databaseService = DatabaseService();

  // Create sample users
  final users = [
    UserModel(
      uid: '1',
      username: 'Ali',
      email: 'ali@example.com',
      name: 'Ali Ben Ali',
      major: 'Computer Science',
      skills: ['Flutter', 'Dart', 'Firebase'],
      bio: 'I love coding!',
    ),
    UserModel(
      uid: '2',
      username: 'Mohamed',
      email: 'mohamed@example.com',
      name: 'Mohamed Ben Mohamed',
      major: 'Software Engineering',
      skills: ['Java', 'Python', 'SQL'],
      bio: 'Passionate about software development.',
    ),
    UserModel(
      uid: '3',
      username: 'Said',
      email: 'said@example.com',
      name: 'Said Ben Said',
      major: 'Data Science',
      skills: ['Python', 'Machine Learning', 'Data Analysis'],
      bio: 'Data enthusiast.',
    ),
    UserModel(
      uid: '4',
      username: 'Yassine',
      email: 'yassine@example.com',
      name: 'Yassine Ben Yassine',
      major: 'Web Development',
      skills: ['JavaScript', 'React', 'Node.js'],
      bio: 'Full-stack developer.',
    ),
    UserModel(
      uid: '5',
      username: 'Fatima',
      email: 'fatima@example.com',
      name: 'Fatima Ben Fatima',
      major: 'Mobile Development',
      skills: ['Flutter', 'Kotlin', 'Swift'],
      bio: 'Mobile app developer.',
    ),
    UserModel(
      uid: '6',
      username: 'Laila',
      email: 'laila@example.com',
      name: 'Laila Ben Laila',
      major: 'UI/UX Design',
      skills: ['Figma', 'Adobe XD', 'Prototyping'],
      bio: 'Designing beautiful interfaces.',
    ),
  ];

  // Add users to Firestore
  for (final user in users) {
    await databaseService.updateUserProfile(
      uid: user.uid,
      username: user.username,
      email: user.email,
      name: user.name,
      major: user.major,
      skills: user.skills,
      bio: user.bio,
      receiveNotifications: true,
    );
  }

  // Create sample projects
  final projects = [
    ProjectModel(
      projectId: '1',
      title: 'Flutter E-Commerce App',
      description: 'Build a cross-platform e-commerce app using Flutter.',
      skillsNeeded: ['Flutter', 'Dart', 'Firebase'],
      postedBy: '1', // Posted by Ali
      numberOfCollaboratorsNeeded: 3,
    ),
    ProjectModel(
      projectId: '2',
      title: 'Machine Learning Model for Fraud Detection',
      description: 'Develop a machine learning model to detect fraudulent transactions.',
      skillsNeeded: ['Python', 'Machine Learning', 'Data Analysis'],
      postedBy: '3', // Posted by Said
      numberOfCollaboratorsNeeded: 2,
    ),
    ProjectModel(
      projectId: '3',
      title: 'React Native Social Media App',
      description: 'Create a social media app using React Native.',
      skillsNeeded: ['JavaScript', 'React Native', 'Firebase'],
      postedBy: '4', // Posted by Yassine
      numberOfCollaboratorsNeeded: 4,
    ),
    ProjectModel(
      projectId: '4',
      title: 'UI/UX Redesign for Travel App',
      description: 'Redesign the UI/UX of an existing travel app.',
      skillsNeeded: ['Figma', 'Adobe XD', 'Prototyping'],
      postedBy: '6', // Posted by Laila
      numberOfCollaboratorsNeeded: 2,
    ),
  ];

  // Add projects to Firestore
  for (final project in projects) {
    await databaseService.createProject(
      title: project.title,
      description: project.description,
      skillsNeeded: project.skillsNeeded,
      numberOfCollaboratorsNeeded: project.numberOfCollaboratorsNeeded,
    );
  }
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