import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/login.dart';
import '../screens/student_dashboard.dart';
import '../screens/teacher_dashboard.dart';
import '../screens/admin_dashboard.dart';
import '../screens/attendance_scan.dart';
import '../screens/activity_suggestions.dart';

class AppRoutes {
  static const String login = '/login';
  static const String studentDashboard = '/student-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  static const String attendanceScan = '/attendance-scan';
  static const String activitySuggestions = '/activity-suggestions';
}

class NavigationHelper {
  // Get route based on user role
  static String getRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppRoutes.studentDashboard;
      case UserRole.teacher:
        return AppRoutes.teacherDashboard;
      case UserRole.admin:
        return AppRoutes.adminDashboard;
    }
  }

  // Navigate to role-specific dashboard
  static void navigateToDashboard(BuildContext context, UserRole role) {
    final route = getRouteForRole(role);
    Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => false,
    );
  }

  // Navigate to login and clear stack
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  // Navigate to attendance scanner
  static void navigateToAttendanceScanner(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.attendanceScan);
  }

  // Navigate to activity suggestions
  static void navigateToActivitySuggestions(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.activitySuggestions);
  }
}

// Route generator for the app
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case AppRoutes.studentDashboard:
        return MaterialPageRoute(
          builder: (_) => const StudentDashboard(),
          settings: settings,
        );

      case AppRoutes.teacherDashboard:
        return MaterialPageRoute(
          builder: (_) => const TeacherDashboard(),
          settings: settings,
        );

      case AppRoutes.adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
          settings: settings,
        );

      case AppRoutes.attendanceScan:
        return MaterialPageRoute(
          builder: (_) => const AttendanceScanScreen(),
          settings: settings,
        );

      case AppRoutes.activitySuggestions:
        return MaterialPageRoute(
          builder: (_) => const ActivitySuggestionsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found!'),
            ),
          ),
        );
    }
  }
}

// Custom page transitions
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  
  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

// Permission helper for navigation
class PermissionHelper {
  // Check if user can access a specific route
  static bool canAccessRoute(UserRole userRole, String route) {
    switch (route) {
      case AppRoutes.studentDashboard:
        return userRole == UserRole.student;
      
      case AppRoutes.teacherDashboard:
        return userRole == UserRole.teacher || userRole == UserRole.admin;
      
      case AppRoutes.adminDashboard:
        return userRole == UserRole.admin;
      
      case AppRoutes.attendanceScan:
        // All authenticated users can scan attendance
        return true;
      
      case AppRoutes.activitySuggestions:
        // Students and teachers can view activity suggestions
        return userRole == UserRole.student || userRole == UserRole.teacher;
      
      default:
        return false;
    }
  }

  // Get available routes for user role
  static List<String> getAvailableRoutes(UserRole userRole) {
    final List<String> routes = [];
    
    switch (userRole) {
      case UserRole.student:
        routes.addAll([
          AppRoutes.studentDashboard,
          AppRoutes.attendanceScan,
          AppRoutes.activitySuggestions,
        ]);
        break;
      
      case UserRole.teacher:
        routes.addAll([
          AppRoutes.teacherDashboard,
          AppRoutes.attendanceScan,
          AppRoutes.activitySuggestions,
        ]);
        break;
      
      case UserRole.admin:
        routes.addAll([
          AppRoutes.adminDashboard,
          AppRoutes.teacherDashboard,
          AppRoutes.studentDashboard,
          AppRoutes.attendanceScan,
          AppRoutes.activitySuggestions,
        ]);
        break;
    }
    
    return routes;
  }
}

// Bottom navigation helper for role-specific navigation
class BottomNavHelper {
  static List<BottomNavigationBarItem> getBottomNavItems(UserRole role) {
    switch (role) {
      case UserRole.student:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Activities',
          ),
        ];
      
      case UserRole.teacher:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
        ];
      
      case UserRole.admin:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ];
    }
  }

  static void handleBottomNavTap(BuildContext context, int index, UserRole role) {
    switch (role) {
      case UserRole.student:
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed(AppRoutes.studentDashboard);
            break;
          case 1:
            NavigationHelper.navigateToAttendanceScanner(context);
            break;
          case 2:
            NavigationHelper.navigateToActivitySuggestions(context);
            break;
        }
        break;
      
      case UserRole.teacher:
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed(AppRoutes.teacherDashboard);
            break;
          case 1:
            NavigationHelper.navigateToAttendanceScanner(context);
            break;
          case 2:
            // Navigate to student management (placeholder for now)
            break;
        }
        break;
      
      case UserRole.admin:
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed(AppRoutes.adminDashboard);
            break;
          case 1:
            // Navigate to user management (placeholder for now)
            break;
          case 2:
            // Navigate to analytics (placeholder for now)
            break;
        }
        break;
    }
  }
}