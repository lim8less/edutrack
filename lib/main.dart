import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'services/firebase_service.dart';
import 'models/user.dart';
import 'screens/login.dart';
import 'utils/navigation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Continue without Firebase for demo purposes
  }
  
  runApp(const EduTrackApp());
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (_) => FirebaseService(),
        ),
      ],
      child: MaterialApp(
        title: 'EduTrack - Smart Curriculum & Attendance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const AuthWrapper(),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/login',
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);
    
    return StreamBuilder<User?>(
      stream: firebaseService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing EduTrack...'),
                ],
              ),
            ),
          );
        }
        
        // User is not authenticated, show login screen
        if (snapshot.data == null) {
          return const LoginScreen();
        }
        
        // User is authenticated, show role-based dashboard
        return FutureBuilder<AppUser?>(
          future: firebaseService.getUserDocument(snapshot.data!.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading user data...'),
                    ],
                  ),
                ),
              );
            }
            
            if (userSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading user data',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userSnapshot.error.toString(),
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          await firebaseService.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            final appUser = userSnapshot.data;
            if (appUser == null) {
              // User exists in Firebase Auth but not in Firestore
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_off,
                        size: 64,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'User profile not found',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please contact administrator or sign up again',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          await firebaseService.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // Navigate to role-specific dashboard
            return RoleDashboard(user: appUser);
          },
        );
      },
    );
  }
}

class RoleDashboard extends StatelessWidget {
  final AppUser user;
  
  const RoleDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final route = NavigationHelper.getRouteForRole(user.role);
    
    // Use Navigator to replace current route with dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        route,
        (route) => false,
      );
    });
    
    // Show loading while navigating
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                _getRoleColor(user.role),
              ),
            ),
            const SizedBox(height: 16),
            Text('Welcome, ${user.name}!'),
            const SizedBox(height: 8),
            Text(
              'Loading ${_getRoleDisplayName(user.role)} dashboard...',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Colors.blue;
      case UserRole.teacher:
        return Colors.green;
      case UserRole.admin:
        return Colors.deepPurple;
    }
  }
  
  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.admin:
        return 'Admin';
    }
  }
}
