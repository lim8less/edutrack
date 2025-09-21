import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String usersCollection = 'users';

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last login time and ensure user document exists
      if (credential.user != null) {
        await updateUserLastLogin(credential.user!.uid);
        
        // Check if user document exists, create if it doesn't
        final userDoc = await getUserDocument(credential.user!.uid);
        if (userDoc == null) {
          print('User document not found, creating one...');
          try {
            await createUserDocument(
              uid: credential.user!.uid,
              email: credential.user!.email ?? email,
              name: credential.user!.displayName ?? 'User',
              role: UserRole.student, // Default role
            );
            print('User document created during login');
          } catch (e) {
            print('Failed to create user document during login: $e');
          }
        }
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuth Error: ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected error during sign in: $e');
      throw e;
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document directly in Firestore
        await _createUserDocumentDirectly(
          uid: credential.user!.uid,
          email: email,
          name: name,
          role: role,
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuth Error: ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected error during sign up: $e');
      // Handle specific type casting errors
      if (e.toString().contains('PigeonUserDetails') || 
          e.toString().contains('List<Object?>')) {
        // Try to create user document anyway if auth succeeded
        try {
          final currentUser = _auth.currentUser;
          if (currentUser != null) {
            await _createUserDocumentDirectly(
              uid: currentUser.uid,
              email: email,
              name: name,
              role: role,
            );
            return null; // We'll handle this in the UI
          }
        } catch (docError) {
          print('Failed to create document: $docError');
        }
        throw Exception('Authentication service temporarily unavailable. Please try again.');
      }
      throw e;
    }
  }

  // Direct method to create user document without using the problematic AppUser class
  Future<void> _createUserDocumentDirectly({
    required String uid,
    required String email,
    required String name,
    required UserRole role,
  }) async {
    try {
      final now = DateTime.now();
      final userData = {
        'uid': uid,
        'email': email,
        'name': name,
        'role': role.toString().split('.').last,
        'createdAt': now.toIso8601String(),
        'lastLoginAt': now.toIso8601String(),
        'additionalData': <String, dynamic>{},
      };

      await _firestore
          .collection(usersCollection)
          .doc(uid)
          .set(userData);
    } catch (e) {
      print('Error creating user document: $e');
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Clear local cache
      await clearLocalCache();
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      throw e;
    }
  }

  // Create user document in Firestore
  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String name,
    required UserRole role,
  }) async {
    try {
      final now = DateTime.now();
      final appUser = AppUser(
        uid: uid,
        email: email,
        name: name,
        role: role,
        createdAt: now,
        lastLoginAt: now,
      );

      await _firestore
          .collection(usersCollection)
          .doc(uid)
          .set(appUser.toMap());

      // Cache user data locally
      await cacheUserData(appUser);
    } catch (e) {
      print('Error creating user document: $e');
      throw e;
    }
  }

  // Get user document from Firestore
  Future<AppUser?> getUserDocument(String uid) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final user = AppUser.fromMap(doc.data()!);
        // Cache user data locally
        await cacheUserData(user);
        return user;
      }
      return null;
    } catch (e) {
      print('Error getting user document: $e');
      // Try to get from local cache if Firestore fails
      return await getCachedUserData();
    }
  }

  // Update user's last login time
  Future<void> updateUserLastLogin(String uid) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(uid)
          .update({
        'lastLoginAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating last login time: $e');
      // Not critical, so we don't throw
    }
  }

  // Update user document
  Future<void> updateUserDocument(AppUser user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.uid)
          .update(user.toMap());

      // Update local cache
      await cacheUserData(user);
    } catch (e) {
      print('Error updating user document: $e');
      throw e;
    }
  }

  // Get users by role (for admin purposes)
  Future<List<AppUser>> getUsersByRole(UserRole role) async {
    try {
      final querySnapshot = await _firestore
          .collection(usersCollection)
          .where('role', isEqualTo: AppUser.roleToString(role))
          .get();

      return querySnapshot.docs
          .map((doc) => AppUser.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting users by role: $e');
      throw e;
    }
  }

  // Local caching methods for offline support
  Future<void> cacheUserData(AppUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = user.toMap();
      
      // Store each field separately for easier access
      await prefs.setString('cached_user_uid', user.uid);
      await prefs.setString('cached_user_email', user.email);
      await prefs.setString('cached_user_name', user.name);
      await prefs.setString('cached_user_role', AppUser.roleToString(user.role));
      await prefs.setString('cached_user_created_at', user.createdAt.toIso8601String());
      await prefs.setString('cached_user_last_login_at', user.lastLoginAt.toIso8601String());
      
      // Store complete user data as JSON string for backup
      await prefs.setString('cached_user_data', userData.toString());
      await prefs.setBool('user_data_cached', true);
    } catch (e) {
      print('Error caching user data: $e');
    }
  }

  Future<AppUser?> getCachedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasCachedData = prefs.getBool('user_data_cached') ?? false;
      
      if (!hasCachedData) return null;

      final uid = prefs.getString('cached_user_uid');
      final email = prefs.getString('cached_user_email');
      final name = prefs.getString('cached_user_name');
      final role = prefs.getString('cached_user_role');
      final createdAt = prefs.getString('cached_user_created_at');
      final lastLoginAt = prefs.getString('cached_user_last_login_at');

      if (uid != null && email != null && name != null && role != null &&
          createdAt != null && lastLoginAt != null) {
        return AppUser(
          uid: uid,
          email: email,
          name: name,
          role: AppUser.roleFromString(role),
          createdAt: DateTime.parse(createdAt),
          lastLoginAt: DateTime.parse(lastLoginAt),
        );
      }
    } catch (e) {
      print('Error getting cached user data: $e');
    }
    return null;
  }

  Future<void> clearLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_user_uid');
      await prefs.remove('cached_user_email');
      await prefs.remove('cached_user_name');
      await prefs.remove('cached_user_role');
      await prefs.remove('cached_user_created_at');
      await prefs.remove('cached_user_last_login_at');
      await prefs.remove('cached_user_data');
      await prefs.remove('user_data_cached');
    } catch (e) {
      print('Error clearing local cache: $e');
    }
  }

  // Sample data creation methods (for development/testing)
  Future<void> createSampleUsers() async {
    try {
      // Sample student
      await createUserDocument(
        uid: 'sample_student_uid',
        email: 'student@example.com',
        name: 'John Student',
        role: UserRole.student,
      );

      // Sample teacher
      await createUserDocument(
        uid: 'sample_teacher_uid',
        email: 'teacher@example.com',
        name: 'Jane Teacher',
        role: UserRole.teacher,
      );

      // Sample admin
      await createUserDocument(
        uid: 'sample_admin_uid',
        email: 'admin@example.com',
        name: 'Admin User',
        role: UserRole.admin,
      );

      print('Sample users created successfully');
    } catch (e) {
      print('Error creating sample users: $e');
    }
  }

  // Check if user has specific role
  Future<bool> hasRole(String uid, UserRole role) async {
    try {
      final user = await getUserDocument(uid);
      return user?.role == role;
    } catch (e) {
      print('Error checking user role: $e');
      return false;
    }
  }

  // Validate user permissions for specific actions
  Future<bool> canAccessAdminFeatures(String uid) async {
    return await hasRole(uid, UserRole.admin);
  }

  Future<bool> canAccessTeacherFeatures(String uid) async {
    final user = await getUserDocument(uid);
    return user?.role == UserRole.admin || user?.role == UserRole.teacher;
  }
}