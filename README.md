# FoodTracker - AI-Powered Tamil Cuisine Nutrition App

A sophisticated SwiftUI iOS app that combines AI-powered food recognition with comprehensive nutrition tracking, specifically designed for Tamil and South Indian cuisine.

## Features

### 🍽️ Food Logging
- **Manual Entry**: Add food items with custom nutrition information
- **AI Food Scanner**: Point your camera at food to get instant nutrition analysis
- **Tamil Cuisine Focus**: Specialized recognition for 50+ Tamil and South Indian dishes
- **Meal Categorization**: Breakfast, lunch, dinner, and snack tracking
- **Portion Control**: Flexible portion size adjustment with quick presets

### 👤 Smart Profile Management
- **Personalized Setup**: Height, weight, age, and gender input
- **AI Calorie Goals**: Automatic BMR calculation using Mifflin-St Jeor equation
- **Dynamic Recommendations**: Goals update automatically with profile changes
- **Progress Tracking**: Visual representation of daily and weekly achievements

### 📊 Advanced Analytics
- **Daily Summaries**: Real-time tracking of calories, protein, and fiber
- **Weekly Charts**: Interactive charts using Swift Charts framework
- **AI Insights**: Personalized recommendations based on eating patterns
- **Goal Progress**: Visual progress bars with achievement notifications
- **Tamil Food Analytics**: Specific insights for traditional cuisine choices

### 🔔 Smart Notifications
- **Meal Reminders**: Customizable breakfast, lunch, and dinner alerts
- **Goal Notifications**: Achievement celebrations and progress nudges
- **Motivational Messages**: AI-generated encouragement throughout the day
- **Smart Timing**: Context-aware notification scheduling

### 🎨 Old Money Aesthetic
- **Elegant Design**: Cream, beige, forest green, and navy color palette
- **Premium Typography**: Serif fonts with careful hierarchy
- **Smooth Animations**: Subtle transitions and progress animations
- **Minimalist Layout**: Clean, structured interface with breathing room

## Technical Architecture

### Core Technologies
- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence with cloud sync capability
- **Vision Framework**: Image analysis and food recognition
- **UserNotifications**: Smart notification system
- **Swift Charts**: Interactive data visualization (iOS 16+)

### Data Models
- **UserProfile**: Personal metrics and preferences
- **FoodItem**: Comprehensive food database with Tamil specialization
- **FoodLog**: Detailed meal tracking with timestamps
- **NutritionData**: Structured nutrition information

### AI Components
- **Food Recognition**: Vision-based food identification
- **Tamil Food Database**: 50+ traditional dishes with accurate nutrition data
- **Calorie Estimation**: BMR-based personalized recommendations
- **Pattern Analysis**: AI insights from eating habits

## Tamil Cuisine Database

The app includes a comprehensive database of Tamil and South Indian foods:

### Breakfast Items
- Idli, Dosa varieties, Uttapam, Appam, Puttu, Pongal, Upma

### Rice Dishes
- Plain Rice, Sambar Rice, Rasam Rice, Curd Rice, Lemon Rice, Coconut Rice

### Curries & Gravies
- Sambar, Rasam, Kuzhambu varieties, Kootu, Poriyal, Aviyal

### Snacks & Street Food
- Vadai, Bajji, Bonda, Murukku, Sundal, Paniyaram

### Traditional Sweets
- Payasam, Laddu, Halwa, Mysore Pak, Jangiri

## Installation & Setup

### Requirements
- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

### Permissions Required
- Camera access for food scanning
- Photo library access for image analysis
- Notifications for meal reminders

### Build Instructions
1. Clone the repository
2. Open `FoodTracker.xcodeproj` in Xcode
3. Configure signing and capabilities
4. Build and run on device or simulator

## Usage Guide

### First Time Setup
1. Launch the app and complete profile setup
2. Enter height, weight, age, and gender
3. Allow camera and notification permissions
4. Start logging your first meal

### Food Scanning
1. Tap the Food Scanner tab
2. Point camera at your food
3. Wait for AI analysis (2-3 seconds)
4. Adjust portion size if needed
5. Select meal type and add notes
6. Save to your food log

### Analytics & Insights
1. View daily progress on the main tab
2. Check weekly trends in Analytics
3. Read AI-generated insights
4. Track goal achievement over time

## Web Demo

A fully functional web version is included in the `web-demo` folder:
- Complete food logging system
- AI nutrition calculation
- Profile management
- Food entries table with edit/delete
- Responsive design for all devices

To run the web demo:
1. Open `web-demo/run.html` in any browser
2. Or serve the folder with any HTTP server

## Privacy & Data

- All data stored locally using Core Data
- Optional cloud sync for backup
- No personal data shared with third parties
- Camera images processed on-device only

## Future Enhancements

- [ ] Cloud synchronization across devices
- [ ] Social features and meal sharing
- [ ] Expanded international cuisine database
- [ ] Apple Health integration
- [ ] Barcode scanning for packaged foods
- [ ] Recipe suggestions based on preferences
- [ ] Advanced meal planning features

## Contributing

This is a demonstration project showcasing modern iOS development practices with SwiftUI, Core Data, and AI integration.

## License

MIT License - See LICENSE file for details

---

**Built with ❤️ for the Tamil community and food enthusiasts worldwide**
