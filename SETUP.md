# Firebase Setup Guide

This guide will help you set up Firebase for StudentCollabHub.

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name (e.g., "student-collab-hub")
4. Choose whether to enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Enable Required Services

### Authentication
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password"
5. Optionally enable other providers (Google, Facebook, etc.)

### Firestore Database
1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (you'll secure it later)
4. Select a location for your database

## Step 3: Add Apps to Firebase Project

### For Android:
1. Click "Add app" and select Android
2. Enter package name: `com.student.collabhub`
3. Download `google-services.json`
4. Replace the template file in `android/app/google-services.json`

### For iOS:
1. Click "Add app" and select iOS
2. Enter bundle ID: `com.student.collabhub`
3. Download `GoogleService-Info.plist`
4. Add it to your iOS project in Xcode under `ios/Runner/`

### For Web:
1. Click "Add app" and select Web
2. Enter app nickname: "StudentCollabHub Web"
3. Copy the configuration object

## Step 4: Update Firebase Configuration

### Update `lib/firebase_options.dart`

Replace the placeholder values with your actual Firebase configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-web-api-key',
  appId: 'your-web-app-id',
  messagingSenderId: 'your-messaging-sender-id',
  projectId: 'your-project-id',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.firebasestorage.app',
  measurementId: 'your-measurement-id',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-android-api-key',
  appId: 'your-android-app-id',
  messagingSenderId: 'your-messaging-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.firebasestorage.app',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'your-ios-api-key',
  appId: 'your-ios-app-id',
  messagingSenderId: 'your-messaging-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.firebasestorage.app',
  iosBundleId: 'com.student.collabhub',
);
```

## Step 5: Configure Firestore Security Rules

In Firebase Console, go to Firestore Database > Rules and update with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Projects are readable by all authenticated users
    // Only the creator can update/delete their projects
    match /projects/{projectId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.postedBy;
    }
    
    // Messages are only accessible to participants
    match /messages/{messageId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid in resource.data.participants);
    }
  }
}
```

## Step 6: Test Your Setup

1. Run the app: `flutter run`
2. Try creating an account
3. Test creating a project
4. Verify data appears in Firestore Console

## Troubleshooting

### Common Issues:

1. **Build errors**: Make sure `google-services.json` is in the correct location
2. **Authentication not working**: Check if Email/Password is enabled in Firebase Console
3. **Firestore permission denied**: Update security rules as shown above
4. **iOS build issues**: Ensure `GoogleService-Info.plist` is added to the Xcode project

### Getting Help:

- Check [FlutterFire documentation](https://firebase.flutter.dev/)
- Review [Firebase documentation](https://firebase.google.com/docs)
- Open an issue in this repository

## Security Best Practices

1. **Never commit real configuration files** to version control
2. **Use proper Firestore security rules** in production
3. **Enable App Check** for additional security
4. **Monitor usage** in Firebase Console
5. **Set up billing alerts** to avoid unexpected charges
