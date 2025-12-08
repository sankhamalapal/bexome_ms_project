# 🏥 Bexome - Interactive Diet Logging App

A cross-platform mobile health monitoring application for tracking daily routines including diet, physical activity, and health metrics. Developed using Flutter for iOS and Android compatibility.

## 📋 Overview

Bexome is a smartphone application that combines self-monitoring by users with sensor monitoring capabilities to track daily health activities. The app enables participants in scientific studies to log dietary information while automatically collecting health-related data through smartphone sensors and Google Fit/Google Connect APIs. All collected data is securely transmitted to a back-end server for research purposes.

## ✨ Features

### 🎯 Core Functionality
- **🌐 Multi-language Support**: Available in German and English with easy extensibility for additional languages
- **🍽️ Diet Logging**: Search and log food items with nutritional information
- **📱 Barcode & QR Code Scanning**: Quick food entry using smartphone camera
- **⭐ Favorite & Recent Meals**: Quick access to frequently consumed items
- **⚖️ Weight Tracking**: Log and monitor weight changes over time
- **👤 User Profile Management**: Save and update personal health information

### 📊 Data Collection
- **🏃 Google Fit Integration**: Automatic collection of fitness and activity data
- **💪 Google Connect Data**: Health metrics synchronization
- **📍 Location Services**: Current location tracking and address resolution
- **🌤️ Weather Data**: Contextual weather information based on location
- **📡 Sensor Data**: Accelerometer and other smartphone sensor monitoring

### 💎 User Experience
- Intuitive interface with save, back, and info buttons
- Persistent data storage (meals, weight, user details)
- Real-time data synchronization with cloud server
- Pause functionality to temporarily stop data transmission (1-hour intervals)

## 🛠️ Technology Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart
- **Database**: SQLite (sqflite package)
- **Key Packages**:
  - `health` (v8.0.0) - Google Fit/Connect integration
  - `geolocator` - Location services
  - `geocoding` - Address resolution
  - `weather` - Weather information
  - `qr_code_scanner` - QR code scanning
  - `flutter_localization` - Multi-language support
  - `permission_handler` - App permissions management

## 🗄️ Database

The app uses an optimized food database that integrates:
- 🇩🇪 BLS (German Nutrient Data Base)
- 🔢 Barcode database
- 💊 Bodymed database
- ➕ Additional custom food items

**📈 Database Statistics**:
- Original entries: 143,584
- After duplicate removal: 86,924
- Standardized metrics for energy, fat, proteins, carbohydrates, and fiber

## 🚀 Installation

### ⚙️ Prerequisites
- Flutter SDK 3.10 or higher
- Dart SDK
- Android Studio / Xcode for platform-specific builds
- Google API Console project with Fitness API enabled

### 📦 Setup

1. Clone the repository:
```bash
git clone https://github.com/sankhamalapal/bexome_ms_project.git
cd bexome_ms_project/bexome_flutter_ss2023_v_3_10_5_1/
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Google Fit API:
   - Create a project in Google API Console
   - Enable the Fitness API
   - Create OAuth 2.0 credentials
   - Add your app's SHA-1 fingerprint and package name

4. Run the app:
```bash
flutter run
```

## 🔐 Permissions

The app requires the following permissions:
- **📍 Location**: Access current location for contextual data
- **📷 Camera**: Barcode and QR code scanning
- **🔑 Google Account**: Access to Google Fit and Google Connect data

## 📤 Data Transmission

Data is automatically sent to the IES Lab cloud server in JSON format at app startup. The following data types are transmitted:
- 🍽️ Meal logs
- ⚖️ Weight entries
- 📍 Location data (address and coordinates)
- 🌤️ Weather information
- 💪 Google Fit/Connect health metrics

A timestamp system prevents duplicate data transmission between sessions.

## 📁 Project Structure

- **Food Database**: Optimized relational database with nutritional information
- **Local Storage**: SQLite tables for food, weight, and user data
- **API Integration**: RESTful communication with back-end server
- **Sensor Management**: Location, accelerometer, and camera access

## 🔮 Future Development

Areas identified for future enhancement:
- ✅ Complete study registration screen integration
- 💧 Enhanced water detection logic
- 📏 Automatic metric separation (g vs ml) for food and drinks
- 🏠 Context-aware location tracking (home, work, sports venues, etc.)
- 👥 User-contributed food items with validation workflow
- 🔗 Extended QR code back-end connectivity

## 🤝 Contributing

This project was developed as a Master's thesis at the University of Freiburg. 

## 👨‍💻 Author

**Sankhamala Pal**  
**📅 Date**: September 29, 2023

**🎓 Supervisors**:
- Prof. Dr. Oliver Amft
- Dijana Ivezic

## 🙏 Acknowledgments

- 🏛️ Chair of Digital Health, University of Freiburg
- 👥 Previous Bexome development teams
- 📚 Contributors to the food database integration

## 📄 License

Developed for research purposes at the University of Freiburg.

## 🔗 References

For more information about the Bexome platform and related research:
- 🌐 [Bexome Official Website](https://bexome.com/)
- 📖 [Google Fit API Documentation](https://developers.google.com/fit/android/get-api-key)

