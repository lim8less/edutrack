# EduTrack - Smart Curriculum Activity & Attendance Prototype

A Flutter-based mobile application prototype for educational institutions with multi-role authentication, attendance tracking via QR codes, and AI-powered activity suggestions.

## 🚀 Quick Start

**New to this project?** Check out our [**Setup Guide**](SETUP_GUIDE.md) for detailed instructions on getting started with Firebase configuration and running the app.

## ⚠️ Important Security Notice

This repository contains **NO sensitive API keys or configuration files**. You must set up your own Firebase project and configuration files. See the [Setup Guide](SETUP_GUIDE.md) for detailed instructions.

## 🚀 Features

### Core Functionality
- **Multi-Role Authentication**: Support for Students, Teachers, and Administrators
- **Role-Based Dashboards**: Customized interfaces for each user type
- **QR Code Attendance Scanning**: Camera-based attendance tracking
- **AI Activity Suggestions**: Personalized learning activity recommendations
- **Offline Mode**: Basic local caching with SharedPreferences
- **Firebase Integration**: Authentication and Firestore database connectivity

### User Roles

#### 👨‍🎓 Student Dashboard
- Personal attendance statistics
- Daily class schedule
- Quick access to QR scanner
- AI-powered activity suggestions
- Recent activity feed
- Performance metrics

#### 👩‍🏫 Teacher Dashboard
- Class management interface
- Attendance taking tools
- Student overview
- Assignment creation (placeholder)
- Analytics and reporting (placeholder)

#### 👨‍💼 Admin Dashboard
- System overview and statistics
- User management tools
- Analytics and reporting
- System health monitoring
- Administrative controls

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase setup
├── firebase_options.dart     # Firebase configuration
├── models/
│   └── user.dart            # User model with role definitions
├── services/
│   └── firebase_service.dart # Firebase wrapper service
├── screens/
│   ├── login.dart           # Authentication screen
│   ├── student_dashboard.dart
│   ├── teacher_dashboard.dart
│   ├── admin_dashboard.dart
│   ├── attendance_scan.dart  # QR code scanner
│   └── activity_suggestions.dart
└── utils/
    └── navigation.dart       # Route management and navigation helpers
```

## 🛠 Setup Instructions

### Prerequisites
- Flutter SDK (>= 3.9.2)
- Dart SDK
- Android Studio / VS Code
- Firebase project (for production use)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd edutrack_prototype
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup (Optional for Demo)**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Download and configure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Demo Accounts

For testing purposes, the app includes demo account credentials:

| Role | Email | Password |
|------|--------|-----------|
| Student | `student@example.com` | `password123` |
| Teacher | `teacher@example.com` | `password123` |
| Admin | `admin@example.com` | `password123` |

> **Note**: These are placeholder credentials for demonstration. The app will work in offline mode without actual Firebase authentication.

## 🔧 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  qr_code_scanner: ^1.0.1
  shared_preferences: ^2.2.2
  provider: ^6.1.1
```

## 🌐 API Integration Points

### Firebase Services
- **Authentication**: Email/password login with role management
- **Firestore**: User profiles, attendance records, activity data
- **Local Storage**: Offline caching with SharedPreferences

### Future Integration Opportunities
- **AI/ML Services**: Activity recommendation engine
- **Push Notifications**: Firebase Cloud Messaging
- **Analytics**: Firebase Analytics for usage tracking
- **Real-time Updates**: Firestore real-time listeners

## 📊 Data Models

### User Model
```dart
enum UserRole { student, teacher, admin }

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final Map<String, dynamic>? additionalData;
}
```

## 🎯 Usage Examples

### Authentication Flow
```dart
// Sign in with email/password
final credential = await firebaseService.signInWithEmailAndPassword(
  email: 'student@example.com',
  password: 'password123',
);

// Navigate to role-specific dashboard
NavigationHelper.navigateToDashboard(context, user.role);
```

### QR Code Scanning
```dart
// Process QR code for attendance
void _onQRViewCreated(QRViewController controller) {
  controller.scannedDataStream.listen((scanData) {
    if (scanData.code != null) {
      _processAttendance(scanData.code!);
    }
  });
}
```

## 🔒 Security Considerations

- User input validation on all forms
- Secure storage of authentication tokens
- Role-based access control for all features
- Offline data encryption (implement in production)
- Firebase security rules (configure for production)

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web (if Firebase Web is configured)
```bash
flutter build web
```

## 🐛 Known Limitations

1. **Firebase Configuration**: Currently uses placeholder configuration
2. **Camera Permissions**: QR scanner requires camera permissions
3. **Offline Mode**: Limited offline functionality
4. **AI Features**: Activity suggestions use mock data
5. **Push Notifications**: Not implemented in prototype

## 🔄 Future Enhancements

### Phase 1
- [ ] Complete Firebase integration
- [ ] Real-time data synchronization
- [ ] Push notifications
- [ ] Enhanced offline mode

### Phase 2
- [ ] AI-powered activity recommendations
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Dark mode theme

### Phase 3
- [ ] Integration with Learning Management Systems
- [ ] Advanced reporting features
- [ ] Parent portal access
- [ ] Biometric authentication

## 📞 Support

For technical issues or feature requests:
1. Check existing issues in the repository
2. Create a new issue with detailed information
3. Contact the development team

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Changelog

### Version 1.0.0 (Prototype)
- Multi-role authentication system
- Role-based dashboards
- QR code attendance scanning
- AI activity suggestions (mock data)
- Basic offline caching
- Firebase integration foundation

---

**Built with Flutter 💙**

*This is a prototype application designed to demonstrate core functionality for an educational technology platform. For production deployment, additional security measures, testing, and Firebase configuration are required.*
