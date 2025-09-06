# 🚀 How to Build and Run FoodTracker App

## Prerequisites
- **macOS** (required for iOS development)
- **Xcode 14.0+** (free from Mac App Store)
- **iOS 15.0+** device or simulator
- **Apple ID** (free, required for device deployment)

## 📱 Option 1: Run on iPhone Simulator (Laptop)

### Step 1: Install Xcode
1. Open **Mac App Store**
2. Search for "Xcode"
3. Click **Install** (it's free, ~15GB download)
4. Wait for installation to complete

### Step 2: Open the Project
1. Navigate to your project folder: `c:\food tracker ios`
2. Double-click **FoodTracker.xcodeproj**
3. Xcode will open with the project loaded

### Step 3: Select Simulator
1. In Xcode toolbar, click the device selector (next to the play button)
2. Choose **iPhone 15 Pro** or **iPhone 14** simulator
3. If simulators aren't installed, Xcode will download them automatically

### Step 4: Build and Run
1. Click the **▶️ Play button** in Xcode toolbar
2. Or press **Cmd + R**
3. Xcode will compile and launch the app in simulator
4. First launch may take 2-3 minutes

### ✅ Expected Result
- iPhone simulator opens
- FoodTracker app launches automatically
- You'll see the profile setup screen first
- All features work except camera (simulator limitation)

---

## 📱 Option 2: Run on Your iPhone

### Step 1: Connect Your iPhone
1. Connect iPhone to Mac with USB cable
2. Unlock your iPhone
3. Trust the computer when prompted

### Step 2: Set Up Apple Developer Account
1. In Xcode, go to **Xcode → Preferences → Accounts**
2. Click **+** and sign in with your Apple ID
3. This creates a free developer account

### Step 3: Configure Code Signing
1. In Xcode project navigator, click **FoodTracker** (blue icon)
2. Select **FoodTracker** target
3. Go to **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. Select your **Team** (your Apple ID)
6. Xcode will create certificates automatically

### Step 4: Select Your iPhone
1. In device selector, choose your connected iPhone
2. It will show as "Your iPhone Name"

### Step 5: Build and Run
1. Click **▶️ Play button** or press **Cmd + R**
2. Xcode compiles and installs app on your iPhone

### Step 6: Trust Developer (First Time Only)
1. On iPhone: **Settings → General → VPN & Device Management**
2. Find your Apple ID under "Developer App"
3. Tap it and select **Trust**
4. Confirm by tapping **Trust** again

### ✅ Expected Result
- App installs on your iPhone
- All features work including camera scanning
- Notifications work (after granting permission)
- Data persists between app launches

---

## 🛠️ Troubleshooting

### Common Issues:

**"No code signing identities found"**
- Solution: Add your Apple ID in Xcode Preferences → Accounts

**"App installation failed"**
- Solution: Check iPhone storage, restart Xcode, clean build (Cmd+Shift+K)

**"Simulator not found"**
- Solution: Xcode → Window → Devices and Simulators → Add simulator

**Camera doesn't work in simulator**
- Expected: Camera features only work on real iPhone

**Build errors about missing files**
- Solution: Make sure all Swift files are in the correct folders

### Performance Tips:
- **First build**: Takes 3-5 minutes (normal)
- **Subsequent builds**: 30-60 seconds
- **Clean build**: Product → Clean Build Folder if issues occur

---

## 🎯 Quick Start Commands

### For Simulator:
```bash
# Open project in Xcode
open "FoodTracker.xcodeproj"

# Or from terminal
xcodebuild -project FoodTracker.xcodeproj -scheme FoodTracker -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
```

### For iPhone:
```bash
# List connected devices
xcrun devicectl list devices

# Build for device
xcodebuild -project FoodTracker.xcodeproj -scheme FoodTracker -destination 'platform=iOS' build
```

---

## 📋 App Features to Test

### ✅ On Simulator:
- Profile setup and BMR calculation
- Manual food logging
- Analytics and charts
- Notifications (with permission)
- Data persistence

### ✅ On iPhone (Full Experience):
- **Camera food scanning** 🔥
- **AI food recognition**
- **Tamil cuisine detection**
- **Photo library access**
- **Real notifications**
- **All simulator features**

---

## 🎉 Success Indicators

**App is working correctly when you see:**
1. **Profile Setup**: Height, weight, age input screen
2. **Tab Navigation**: 4 tabs at bottom (Daily, Scanner, Profile, Analytics)
3. **Old Money Theme**: Cream/beige colors with elegant design
4. **Tamil Foods**: Idli, Dosa, Sambar in food database
5. **Camera Scanner**: Works on iPhone, shows placeholder on simulator
6. **Notifications**: Permission request on first launch

**Ready to use!** 🚀
