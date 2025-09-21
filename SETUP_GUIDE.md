# EduTrack Prototype - Setup Guide

## 🚀 Quick Setup for New Developers

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Firebase account
- Git

### 1. Clone the Repository
```bash
git clone <your-github-repo-url>
cd edutrack_prototype
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup (CRITICAL)

#### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `edutrack-prototype` (or your preferred name)
4. Enable Google Analytics (optional)
5. Create project

#### Step 2: Enable Authentication
1. In Firebase Console → Authentication → Sign-in method
2. Enable "Email/Password" provider
3. Save changes

#### Step 3: Enable Firestore Database
1. In Firebase Console → Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to you
5. Create database

#### Step 4: Add Android App
1. In Firebase Console → Project Overview → Add app → Android
2. Package name: `com.example.edutrack_prototype`
3. App nickname: `EduTrack Android`
4. Download `google-services.json`
5. **Replace** the template file: `android/app/google-services.json.template` with your downloaded file
6. Rename it to `android/app/google-services.json`

#### Step 5: Update Firestore Rules (IMPORTANT)
1. Go to Firestore Database → Rules tab
2. Replace the rules with:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access to all documents for development
    // WARNING: This is only for development/testing!
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
3. Click "Publish"

### 4. Run the App
```bash
flutter run
```

## 🔧 Troubleshooting

### Common Issues:

#### 1. "Firebase not initialized" error
- Make sure `google-services.json` is in the correct location
- Run `flutter clean` and `flutter pub get`

#### 2. "Permission denied" error
- Check Firestore rules are set to allow read/write
- Make sure Authentication is enabled

#### 3. "PigeonUserDetails" error
- This is handled automatically in the code
- If it persists, try `flutter clean` and rebuild

### 4. Build Issues
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Testing the App

### Sign Up Process:
1. Open the app
2. Tap "Don't have an account? Sign up"
3. Fill in:
   - Name: `Test User`
   - Email: `test@example.com`
   - Password: `password123`
   - Select role (Student/Teacher/Admin)
4. Tap "Sign Up"

### Expected Results:
- ✅ User created in Firebase Authentication
- ✅ User document created in Firestore Database
- ✅ App navigates to appropriate dashboard

## 🔒 Security Notes

- **Never commit** `google-services.json` to version control
- **Never commit** any files with API keys or secrets
- Use environment variables for production deployments
- Regularly rotate API keys in production

## 📞 Support

If you encounter any issues:
1. Check this setup guide first
2. Verify Firebase configuration
3. Check Flutter and Firebase documentation
4. Contact the project maintainer

---

**Happy Coding! 🎉**
