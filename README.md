# 🎓 CCMS — College Complaint Management System

A Flutter mobile application that allows college students to submit complaints about different college facilities and services, while teachers, staff, and administrators can view, manage, update, and resolve those complaints.

## ✨ Features

### 👨‍🎓 Student
- Register and login
- Submit complaints with category, priority, description, and location
- Track complaint status with visual timeline
- View complaint history
- Receive notifications
- Give feedback after resolution

### 👨‍🏫 Teacher/Staff
- View complaints assigned to their department
- Update complaint status and add comments
- Mark complaints as resolved

### 🛡️ Administrator
- View all complaints and system statistics
- Manage students, teachers/staff, categories, departments, and locations
- Assign complaints to responsible staff
- Change complaint priority and status
- Monitor unresolved and urgent complaints
- View reports and analytics

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Material Design 3**
- **Provider** (State Management)
- **Firebase** (Auth, Firestore, Storage — ready to configure)
- **Google Fonts** (Poppins)

## 📱 Screenshots

| Splash Screen | Login | Student Dashboard |
|:---:|:---:|:---:|
| Blue gradient with CCMS logo | Email/password with demo accounts | Summary cards + quick actions |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x+
- Dart SDK 3.x+
- Android Studio / VS Code
- Chrome (for web testing)

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ccms.git
cd ccms

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome
```

### Demo Accounts

All accounts use password: `123456`

| Role | Email |
|------|-------|
| Student | student@ccms.com |
| Staff | staff@ccms.com |
| Admin | admin@ccms.com |

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   ├── complaint_model.dart
│   └── notification_model.dart
├── screens/
│   ├── auth/ (login, registration, forgot password)
│   ├── student/ (dashboard)
│   ├── staff/ (dashboard)
│   ├── admin/ (dashboard)
│   └── common/ (splash screen)
├── widgets/ (custom_text_field, custom_button)
├── services/ (auth_service)
├── providers/ (auth_provider)
├── utils/ (constants, validators, helpers)
└── theme/ (app_theme)
```

## 🔒 Complaint Statuses

`Submitted` → `Under Review` → `Assigned` → `In Progress` → `Resolved` → `Closed`

## 📌 Complaint Categories

Teacher/Faculty, Classroom, Laboratory, Library, Canteen, Hostel, Washroom, Drinking Water, Electricity, Internet/Wi-Fi, Computer/IT Equipment, Projector/Smart Classroom, Furniture, Sports Facilities, Transportation, Campus Cleanliness, Security, Parking, Examination, Academic Issues, Administrative Office, Fees/Accounts, Other

## 📄 License

This project is for educational purposes.

## 👤 Author

**Indrajeet Pal Gaderiya**
