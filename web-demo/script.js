// FoodTracker Web Demo JavaScript
class FoodTracker {
    constructor() {
        this.currentTab = 'daily';
        this.foodLogs = this.loadFoodLogs();
        this.tamilFoods = this.initializeTamilFoods();
        this.userProfile = this.loadUserProfile();
        this.init();
    }

    init() {
        this.setupTabNavigation();
        this.updateCurrentDate();
        this.updateNutritionDisplay();
        this.setupMealTypeSelector();
        this.updateProfileDisplay();
        this.updateFoodEntriesTable();
    }

    // Tab Navigation
    setupTabNavigation() {
        const tabButtons = document.querySelectorAll('.tab-button');
        const tabContents = document.querySelectorAll('.tab-content');

        tabButtons.forEach(button => {
            button.addEventListener('click', () => {
                const tabName = button.dataset.tab;
                
                // Update active states
                tabButtons.forEach(btn => btn.classList.remove('active'));
                tabContents.forEach(content => content.classList.remove('active'));
                
                button.classList.add('active');
                document.getElementById(`${tabName}-tab`).classList.add('active');
                
                this.currentTab = tabName;
            });
        });
    }

    // Date and Time
    updateCurrentDate() {
        const dateElement = document.getElementById('current-date');
        const now = new Date();
        const options = { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        };
        dateElement.textContent = now.toLocaleDateString('en-US', options);
    }

    // Comprehensive Food Database
    initializeTamilFoods() {
        return [
            // Tamil Foods
            { name: 'Idli', category: 'Breakfast', calories: 58, protein: 4.2, fiber: 1.0, carbs: 8.5, isTamil: true, unit: 'piece' },
            { name: 'Masala Dosa', category: 'Breakfast', calories: 150, protein: 3.5, fiber: 2.5, carbs: 28, isTamil: true, unit: 'piece' },
            { name: 'Uttapam', category: 'Breakfast', calories: 120, protein: 4.5, fiber: 2.0, carbs: 22, isTamil: true, unit: 'piece' },
            { name: 'Sambar Rice', category: 'Rice', calories: 110, protein: 3.5, fiber: 2.0, carbs: 20, isTamil: true, unit: 'bowl' },
            { name: 'Curd Rice', category: 'Rice', calories: 90, protein: 4.0, fiber: 0.5, carbs: 16, isTamil: true, unit: 'bowl' },
            { name: 'Rasam', category: 'Curry', calories: 20, protein: 1.5, fiber: 2.0, carbs: 3, isTamil: true, unit: 'bowl' },
            { name: 'Sambar', category: 'Curry', calories: 40, protein: 2.5, fiber: 3.0, carbs: 6, isTamil: true, unit: 'bowl' },
            { name: 'Vadai', category: 'Snacks', calories: 210, protein: 8.0, fiber: 2.5, carbs: 18, isTamil: true, unit: 'piece' },
            { name: 'Pongal', category: 'Breakfast', calories: 130, protein: 5.0, fiber: 1.2, carbs: 24, isTamil: true, unit: 'bowl' },
            { name: 'Appam', category: 'Breakfast', calories: 110, protein: 3.0, fiber: 0.8, carbs: 22, isTamil: true, unit: 'piece' },
            { name: 'Biryani', category: 'Rice', calories: 200, protein: 8.0, fiber: 1.5, carbs: 35, isTamil: true, unit: 'bowl' },
            { name: 'Chapati', category: 'Bread', calories: 104, protein: 3.1, fiber: 3.7, carbs: 18, isTamil: false, unit: 'piece' },
            
            // International Foods
            { name: 'Apple', category: 'Fruit', calories: 52, protein: 0.3, fiber: 2.4, carbs: 14, isTamil: false, unit: 'piece' },
            { name: 'Banana', category: 'Fruit', calories: 89, protein: 1.1, fiber: 2.6, carbs: 23, isTamil: false, unit: 'piece' },
            { name: 'Orange', category: 'Fruit', calories: 47, protein: 0.9, fiber: 2.4, carbs: 12, isTamil: false, unit: 'piece' },
            { name: 'White Rice', category: 'Rice', calories: 130, protein: 2.7, fiber: 0.4, carbs: 28, isTamil: false, unit: '100g' },
            { name: 'Brown Rice', category: 'Rice', calories: 111, protein: 2.6, fiber: 1.8, carbs: 23, isTamil: false, unit: '100g' },
            { name: 'Chicken Breast', category: 'Protein', calories: 165, protein: 31, fiber: 0, carbs: 0, isTamil: false, unit: '100g' },
            { name: 'Egg', category: 'Protein', calories: 155, protein: 13, fiber: 0, carbs: 1.1, isTamil: false, unit: 'piece' },
            { name: 'Milk', category: 'Dairy', calories: 42, protein: 3.4, fiber: 0, carbs: 5, isTamil: false, unit: '100g' },
            { name: 'Yogurt', category: 'Dairy', calories: 59, protein: 10, fiber: 0, carbs: 3.6, isTamil: false, unit: '100g' },
            { name: 'Bread', category: 'Bread', calories: 265, protein: 9, fiber: 2.7, carbs: 49, isTamil: false, unit: '100g' },
            { name: 'Oats', category: 'Cereal', calories: 389, protein: 16.9, fiber: 10.6, carbs: 66, isTamil: false, unit: '100g' }
        ];
    }

    // Food Logging
    loadFoodLogs() {
        const stored = localStorage.getItem('foodTracker_logs');
        if (stored) {
            return JSON.parse(stored);
        }
        
        // Default sample data
        return [
            {
                id: 1,
                name: 'Idli',
                portion: 150,
                calories: 150,
                protein: 6,
                fiber: 2,
                mealType: 'breakfast',
                timestamp: new Date().toISOString(),
                isTamil: true
            }
        ];
    }

    saveFoodLogs() {
        localStorage.setItem('foodTracker_logs', JSON.stringify(this.foodLogs));
    }

    // User Profile Management
    loadUserProfile() {
        const stored = localStorage.getItem('foodTracker_profile');
        if (stored) {
            return JSON.parse(stored);
        }
        
        // Default profile
        return {
            name: 'User Profile',
            height: 172, // cm
            weight: 63,  // kg
            age: 30,
            gender: 'male',
            activityLevel: 'light'
        };
    }

    saveUserProfile() {
        localStorage.setItem('foodTracker_profile', JSON.stringify(this.userProfile));
    }

    updateProfile(profileData) {
        this.userProfile = { ...this.userProfile, ...profileData };
        this.saveUserProfile();
        this.updateProfileDisplay();
        this.updateCalorieGoal();
    }

    updateProfileDisplay() {
        document.getElementById('profile-name').textContent = this.userProfile.name;
        document.getElementById('profile-height').textContent = `${this.userProfile.height} cm`;
        document.getElementById('profile-weight').textContent = `${this.userProfile.weight} kg`;
        document.getElementById('profile-age').textContent = this.userProfile.age;
        document.getElementById('profile-gender').textContent = 
            this.userProfile.gender.charAt(0).toUpperCase() + this.userProfile.gender.slice(1);
    }

    calculateBMR() {
        // Mifflin-St Jeor Equation
        const { weight, height, age, gender } = this.userProfile;
        let bmr;
        
        if (gender === 'male') {
            bmr = 10 * weight + 6.25 * height - 5 * age + 5;
        } else {
            bmr = 10 * weight + 6.25 * height - 5 * age - 161;
        }
        
        return Math.round(bmr);
    }

    calculateDailyCalories() {
        const bmr = this.calculateBMR();
        const activityMultipliers = {
            'sedentary': 1.2,
            'light': 1.375,
            'moderate': 1.55,
            'active': 1.725,
            'very-active': 1.9
        };
        
        const multiplier = activityMultipliers[this.userProfile.activityLevel] || 1.375;
        return Math.round(bmr * multiplier);
    }

    updateCalorieGoal() {
        const dailyCalories = this.calculateDailyCalories();
        const bmr = this.calculateBMR();
        
        document.getElementById('daily-calorie-goal').textContent = dailyCalories;
        document.getElementById('bmr-display').textContent = `BMR: ${bmr} cal/day`;
        
        // Update nutrition display with new goal
        this.updateNutritionDisplay();
    }

    addFoodLog(foodData) {
        const newLog = {
            id: Date.now(),
            name: foodData.name,
            portion: foodData.portion || `${foodData.quantity} ${foodData.unit}`,
            calories: parseFloat(foodData.calories),
            protein: parseFloat(foodData.protein) || 0,
            fiber: parseFloat(foodData.fiber) || 0,
            mealType: foodData.mealType,
            timestamp: new Date().toISOString(),
            isTamil: this.isTamilFood(foodData.name)
        };

        this.foodLogs.unshift(newLog);
        this.saveFoodLogs();
        this.updateNutritionDisplay();
        this.updateLatestMeal();
        this.updateFoodEntriesTable();
    }

    updateFoodEntriesTable() {
        const today = new Date().toDateString();
        const todaysLogs = this.foodLogs.filter(log => 
            new Date(log.timestamp).toDateString() === today
        );

        const tableContainer = document.getElementById('food-entries-table');
        const entriesCount = document.getElementById('entries-count');
        
        entriesCount.textContent = `${todaysLogs.length} item${todaysLogs.length !== 1 ? 's' : ''}`;

        if (todaysLogs.length === 0) {
            tableContainer.innerHTML = `
                <div class="no-entries" id="no-entries">
                    <span class="no-entries-icon">🍽️</span>
                    <p>No food entries yet</p>
                    <small>Add your first meal to start tracking</small>
                </div>
            `;
            return;
        }

        tableContainer.innerHTML = todaysLogs.map(log => `
            <div class="food-entry">
                <div class="entry-icon">${this.getFoodIcon(log.name)}</div>
                <div class="entry-details">
                    <div class="entry-name">${log.name}</div>
                    <div class="entry-info">
                        <span>${log.portion}</span>
                        <span>•</span>
                        <span>${log.mealType}</span>
                        <span>•</span>
                        <span>${new Date(log.timestamp).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}</span>
                    </div>
                </div>
                <div class="entry-nutrition">
                    <div class="entry-calories">${Math.round(log.calories)} cal</div>
                    <div class="entry-macros">${Math.round(log.protein)}p • ${Math.round(log.fiber)}f</div>
                </div>
                <div class="entry-actions">
                    <button class="entry-btn edit-btn" onclick="editFoodEntry(${log.id})" title="Edit">✏️</button>
                    <button class="entry-btn delete-btn" onclick="deleteFoodEntry(${log.id})" title="Delete">🗑️</button>
                </div>
            </div>
        `).join('');
    }

    getFoodIcon(foodName) {
        const icons = {
            'idli': '🥟', 'dosa': '🫓', 'uttapam': '🥞', 'sambar': '🍲', 'rasam': '🍵',
            'rice': '🍚', 'biryani': '🍛', 'vadai': '🍩', 'appam': '🥞', 'pongal': '🍚',
            'apple': '🍎', 'banana': '🍌', 'orange': '🍊', 'mango': '🥭',
            'chicken': '🍗', 'egg': '🥚', 'milk': '🥛', 'yogurt': '🥛', 'bread': '🍞'
        };
        
        const key = foodName.toLowerCase().split(' ')[0];
        return icons[key] || '🍽️';
    }

    deleteFoodEntry(id) {
        if (confirm('Are you sure you want to delete this food entry?')) {
            this.foodLogs = this.foodLogs.filter(log => log.id !== id);
            this.saveFoodLogs();
            this.updateNutritionDisplay();
            this.updateLatestMeal();
            this.updateFoodEntriesTable();
            this.showNotification('Food entry deleted successfully! 🗑️');
        }
    }

    getFoodEntryById(id) {
        return this.foodLogs.find(log => log.id === id);
    }

    updateFoodEntry(id, updatedData) {
        const index = this.foodLogs.findIndex(log => log.id === id);
        if (index !== -1) {
            this.foodLogs[index] = { ...this.foodLogs[index], ...updatedData };
            this.saveFoodLogs();
            this.updateNutritionDisplay();
            this.updateLatestMeal();
            this.updateFoodEntriesTable();
        }
    }

    isTamilFood(foodName) {
        return this.tamilFoods.some(food => 
            food.name.toLowerCase() === foodName.toLowerCase()
        );
    }

    // Nutrition Calculations
    calculateTotalNutrition() {
        const today = new Date().toDateString();
        const todaysLogs = this.foodLogs.filter(log => 
            new Date(log.timestamp).toDateString() === today
        );

        return todaysLogs.reduce((total, log) => ({
            calories: total.calories + log.calories,
            protein: total.protein + log.protein,
            fiber: total.fiber + log.fiber
        }), { calories: 0, protein: 0, fiber: 0 });
    }

    updateNutritionDisplay() {
        const nutrition = this.calculateTotalNutrition();
        const calorieGoal = this.calculateDailyCalories();
        const goals = { 
            calories: calorieGoal, 
            protein: Math.round(calorieGoal * 0.15 / 4), // 15% of calories from protein
            fiber: 25 
        };

        // Update values
        document.getElementById('calories-value').textContent = Math.round(nutrition.calories);
        document.getElementById('protein-value').textContent = Math.round(nutrition.protein);
        document.getElementById('fiber-value').textContent = Math.round(nutrition.fiber);

        // Update progress bars with animation
        setTimeout(() => {
            const caloriesProgress = Math.min(nutrition.calories / goals.calories, 1) * 100;
            const proteinProgress = Math.min(nutrition.protein / goals.protein, 1) * 100;
            const fiberProgress = Math.min(nutrition.fiber / goals.fiber, 1) * 100;

            document.querySelector('.calories .progress-fill').style.width = `${caloriesProgress}%`;
            document.querySelector('.protein .progress-fill').style.width = `${proteinProgress}%`;
            document.querySelector('.fiber .progress-fill').style.width = `${fiberProgress}%`;
        }, 100);
    }

    updateLatestMeal() {
        if (this.foodLogs.length > 0) {
            const latest = this.foodLogs[0];
            document.getElementById('latest-meal').textContent = latest.name;
        }
    }

    // Food Scanner Simulation
    simulateScanning() {
        const cameraView = document.getElementById('camera-view');
        const originalContent = cameraView.innerHTML;

        // Show scanning animation
        cameraView.innerHTML = `
            <div class="viewfinder-content">
                <div class="loading"></div>
                <p>Analyzing food...</p>
                <small>AI recognizing Tamil cuisine</small>
            </div>
        `;

        // Simulate AI analysis
        setTimeout(() => {
            const randomFood = this.tamilFoods[Math.floor(Math.random() * this.tamilFoods.length)];
            const portion = 150; // Default portion
            
            cameraView.innerHTML = `
                <div class="scan-result">
                    <div class="food-icon" style="font-size: 40px; margin-bottom: 16px;">🍽️</div>
                    <h3 style="margin-bottom: 8px;">${randomFood.name}</h3>
                    <p style="color: rgba(64, 64, 64, 0.7); margin-bottom: 8px;">${randomFood.category}</p>
                    <div style="display: flex; gap: 16px; justify-content: center; font-size: 14px; color: rgba(64, 64, 64, 0.6);">
                        <span>${Math.round(randomFood.calories * portion / 100)} cal</span>
                        <span>•</span>
                        <span>${Math.round(randomFood.protein * portion / 100)}g protein</span>
                        <span>•</span>
                        <span>${Math.round(randomFood.fiber * portion / 100)}g fiber</span>
                    </div>
                    <button onclick="app.addScannedFood('${randomFood.name}', ${portion}, ${randomFood.calories * portion / 100}, ${randomFood.protein * portion / 100}, ${randomFood.fiber * portion / 100})" 
                            style="margin-top: 16px; padding: 8px 16px; background: var(--forest-green); color: white; border: none; border-radius: 8px; cursor: pointer;">
                        Add to Log
                    </button>
                </div>
            `;
        }, 2000);

        // Reset after 10 seconds
        setTimeout(() => {
            cameraView.innerHTML = originalContent;
        }, 10000);
    }

    addScannedFood(name, portion, calories, protein, fiber) {
        this.addFoodLog({
            name: name,
            portion: portion,
            calories: calories,
            protein: protein,
            fiber: fiber,
            mealType: this.getCurrentMealType()
        });

        // Show success message
        this.showNotification(`${name} added to your food log!`);
        
        // Switch to daily tab
        document.querySelector('[data-tab="daily"]').click();
    }

    getCurrentMealType() {
        const hour = new Date().getHours();
        if (hour < 11) return 'breakfast';
        if (hour < 16) return 'lunch';
        if (hour < 20) return 'dinner';
        return 'snack';
    }

    simulateGallery() {
        this.showNotification('Gallery feature would open photo library on mobile device');
    }

    resetScanner() {
        const cameraView = document.getElementById('camera-view');
        cameraView.innerHTML = `
            <div class="viewfinder-content">
                <span class="camera-icon">📷</span>
                <p>Tap to scan food</p>
                <small>Supports Tamil & International cuisine</small>
            </div>
        `;
    }

    // Modal Management
    setupMealTypeSelector() {
        const mealTypes = document.querySelectorAll('.meal-type');
        mealTypes.forEach(button => {
            button.addEventListener('click', () => {
                mealTypes.forEach(btn => btn.classList.remove('active'));
                button.classList.add('active');
            });
        });
    }

    // Notifications
    // AI Food Recognition and Calculation
    searchFoodInDatabase(foodName) {
        const query = foodName.toLowerCase().trim();
        return this.tamilFoods.filter(food => 
            food.name.toLowerCase().includes(query)
        ).slice(0, 5); // Return top 5 matches
    }

    calculateNutritionForFood(foodName, quantity, unit) {
        const food = this.tamilFoods.find(f => 
            f.name.toLowerCase() === foodName.toLowerCase()
        );
        
        if (!food) {
            // If not found, use AI estimation
            return this.estimateNutritionAI(foodName, quantity, unit);
        }

        // Calculate based on quantity and unit
        let multiplier = quantity;
        
        // Convert units to standard portions
        if (unit.includes('g')) {
            const grams = parseInt(unit.replace('g', ''));
            multiplier = quantity * (grams / 100); // Assume base values are per 100g
        } else if (unit === 'cup') {
            multiplier = quantity * 1.5; // 1 cup ≈ 1.5 standard portions
        } else if (unit === 'bowl') {
            multiplier = quantity * 2; // 1 bowl ≈ 2 standard portions
        }
        // 'piece' uses quantity as-is

        return {
            calories: Math.round(food.calories * multiplier),
            protein: Math.round(food.protein * multiplier * 10) / 10,
            fiber: Math.round(food.fiber * multiplier * 10) / 10,
            carbs: Math.round(food.carbs * multiplier * 10) / 10,
            found: true
        };
    }

    estimateNutritionAI(foodName, quantity, unit) {
        // AI estimation for unknown foods
        const estimations = {
            // Fruits (per piece)
            'mango': { calories: 60, protein: 0.8, fiber: 1.6, carbs: 15 },
            'grapes': { calories: 62, protein: 0.6, fiber: 0.9, carbs: 16 },
            'watermelon': { calories: 30, protein: 0.6, fiber: 0.4, carbs: 8 },
            
            // Vegetables (per 100g)
            'potato': { calories: 77, protein: 2, fiber: 2.2, carbs: 17 },
            'tomato': { calories: 18, protein: 0.9, fiber: 1.2, carbs: 3.9 },
            'onion': { calories: 40, protein: 1.1, fiber: 1.7, carbs: 9.3 },
            
            // Default estimation
            'default': { calories: 100, protein: 3, fiber: 2, carbs: 20 }
        };

        const baseNutrition = estimations[foodName.toLowerCase()] || estimations['default'];
        
        let multiplier = quantity;
        if (unit.includes('g')) {
            const grams = parseInt(unit.replace('g', ''));
            multiplier = quantity * (grams / 100);
        } else if (unit === 'cup') {
            multiplier = quantity * 1.5;
        } else if (unit === 'bowl') {
            multiplier = quantity * 2;
        }

        return {
            calories: Math.round(baseNutrition.calories * multiplier),
            protein: Math.round(baseNutrition.protein * multiplier * 10) / 10,
            fiber: Math.round(baseNutrition.fiber * multiplier * 10) / 10,
            carbs: Math.round(baseNutrition.carbs * multiplier * 10) / 10,
            found: false
        };
    }

    showNotification(message) {
        // Create notification element
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: var(--forest-green);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            z-index: 3000;
            font-family: var(--body-font);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            animation: slideDown 0.3s ease-out;
        `;
        notification.textContent = message;

        // Add animation keyframes
        if (!document.querySelector('#notification-styles')) {
            const style = document.createElement('style');
            style.id = 'notification-styles';
            style.textContent = `
                @keyframes slideDown {
                    from { transform: translateX(-50%) translateY(-100%); opacity: 0; }
                    to { transform: translateX(-50%) translateY(0); opacity: 1; }
                }
            `;
            document.head.appendChild(style);
        }

        document.body.appendChild(notification);

        // Remove after 3 seconds
        setTimeout(() => {
            notification.style.animation = 'slideDown 0.3s ease-out reverse';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }
}

// Global functions for HTML onclick handlers
function showAddFoodModal() {
    document.getElementById('add-food-modal').classList.add('active');
}

function closeAddFoodModal() {
    document.getElementById('add-food-modal').classList.remove('active');
    // Reset form
    document.getElementById('food-name').value = '';
    document.getElementById('quantity-amount').value = '1';
    document.getElementById('quantity-unit').value = '100g';
    document.getElementById('calories').value = '';
    document.getElementById('protein').value = '';
    document.getElementById('fiber').value = '';
    document.getElementById('food-suggestions').innerHTML = '';
    document.getElementById('nutrition-preview').style.display = 'none';
    
    // Reset meal type to breakfast
    document.querySelectorAll('.meal-type').forEach(btn => btn.classList.remove('active'));
    document.querySelector('.meal-type[data-meal="breakfast"]').classList.add('active');
}

// Profile editing functions
function showEditProfileModal() {
    const modal = document.getElementById('edit-profile-modal');
    const profile = app.userProfile;
    
    // Populate form with current values
    document.getElementById('edit-name').value = profile.name;
    document.getElementById('edit-height').value = profile.height;
    document.getElementById('edit-weight').value = profile.weight;
    document.getElementById('edit-age').value = profile.age;
    document.getElementById('edit-gender').value = profile.gender;
    document.getElementById('edit-activity').value = profile.activityLevel;
    
    modal.classList.add('active');
}

function closeEditProfileModal() {
    document.getElementById('edit-profile-modal').classList.remove('active');
}

function saveProfile() {
    const profileData = {
        name: document.getElementById('edit-name').value || 'User Profile',
        height: parseInt(document.getElementById('edit-height').value) || 172,
        weight: parseInt(document.getElementById('edit-weight').value) || 63,
        age: parseInt(document.getElementById('edit-age').value) || 30,
        gender: document.getElementById('edit-gender').value,
        activityLevel: document.getElementById('edit-activity').value
    };

    // Validation
    if (profileData.height < 100 || profileData.height > 250) {
        app.showNotification('Please enter a valid height (100-250 cm)');
        return;
    }
    
    if (profileData.weight < 30 || profileData.weight > 200) {
        app.showNotification('Please enter a valid weight (30-200 kg)');
        return;
    }
    
    if (profileData.age < 13 || profileData.age > 120) {
        app.showNotification('Please enter a valid age (13-120 years)');
        return;
    }

    app.updateProfile(profileData);
    closeEditProfileModal();
    app.showNotification('Profile updated successfully! 🎉');
}

// AI Food Calculation Functions
function searchFoodSuggestions() {
    const foodName = document.getElementById('food-name').value;
    const suggestionsDiv = document.getElementById('food-suggestions');
    
    if (foodName.length < 2) {
        suggestionsDiv.innerHTML = '';
        return;
    }
    
    const suggestions = app.searchFoodInDatabase(foodName);
    
    if (suggestions.length === 0) {
        suggestionsDiv.innerHTML = '';
        return;
    }
    
    suggestionsDiv.innerHTML = suggestions.map(food => `
        <div class="suggestion-item" onclick="selectFoodSuggestion('${food.name}')">
            <div>
                <div class="suggestion-name">${food.name}</div>
                <div class="suggestion-info">${food.category} • ${food.calories} cal per ${food.unit}</div>
            </div>
        </div>
    `).join('');
}

function selectFoodSuggestion(foodName) {
    document.getElementById('food-name').value = foodName;
    document.getElementById('food-suggestions').innerHTML = '';
    
    // Auto-calculate nutrition
    setTimeout(() => calculateNutritionAI(), 100);
}

function calculateNutritionAI() {
    const foodName = document.getElementById('food-name').value.trim();
    const isCustom = document.querySelector('input[name="quantity-type"]:checked').value === 'custom';
    
    let quantity, unit;
    if (isCustom) {
        const customGrams = document.getElementById('custom-grams').value;
        if (!customGrams) {
            app.showNotification('Please enter custom quantity in grams first');
            return;
        }
        quantity = parseFloat(customGrams) / 100; // Convert to 100g units for calculation
        unit = '100g';
    } else {
        quantity = parseFloat(document.getElementById('quantity-amount').value);
        unit = document.getElementById('quantity-unit').value;
    }
    
    if (!foodName) {
        app.showNotification('Please enter a food name first');
        return;
    }
    
    // Show loading state
    const btn = document.querySelector('.ai-calculate-btn');
    const originalText = btn.innerHTML;
    btn.innerHTML = '🤖 Calculating...';
    btn.disabled = true;
    
    // Simulate AI processing delay
    setTimeout(() => {
        const nutrition = app.calculateNutritionForFood(foodName, quantity, unit);
        
        // Update preview
        document.getElementById('preview-calories').textContent = nutrition.calories;
        document.getElementById('preview-protein').textContent = `${nutrition.protein} g`;
        document.getElementById('preview-fiber').textContent = `${nutrition.fiber} g`;
        document.getElementById('preview-carbs').textContent = `${nutrition.carbs} g`;
        
        // Update form fields
        document.getElementById('calories').value = nutrition.calories;
        document.getElementById('protein').value = nutrition.protein;
        document.getElementById('fiber').value = nutrition.fiber;
        
        // Show preview
        document.getElementById('nutrition-preview').style.display = 'block';
        
        // Reset button
        btn.innerHTML = originalText;
        btn.disabled = false;
        
        // Show success message
        const message = nutrition.found ? 
            `✅ Found ${foodName} in database!` : 
            `🤖 AI estimated nutrition for ${foodName}`;
        app.showNotification(message);
        
    }, 1500); // 1.5 second delay for realism
}

function updateNutritionPreview() {
    const foodName = document.getElementById('food-name').value.trim();
    if (foodName && document.getElementById('nutrition-preview').style.display === 'block') {
        calculateNutritionAI();
    }
}

function saveFoodLog() {
    const foodName = document.getElementById('food-name').value.trim();
    const isCustom = document.querySelector('input[name="quantity-type"]:checked').value === 'custom';
    
    let quantity, unit;
    if (isCustom) {
        const customGrams = document.getElementById('custom-grams').value;
        if (!customGrams) {
            app.showNotification('Please enter custom quantity in grams');
            return;
        }
        quantity = parseFloat(customGrams);
        unit = 'g';
    } else {
        quantity = parseFloat(document.getElementById('quantity-amount').value);
        unit = document.getElementById('quantity-unit').value;
    }
    
    const calories = document.getElementById('calories').value;
    const protein = document.getElementById('protein').value;
    const fiber = document.getElementById('fiber').value;
    const mealType = document.querySelector('.meal-type.active').dataset.meal;

    if (!foodName) {
        app.showNotification('Please enter a food name');
        return;
    }
    
    if (!calories) {
        app.showNotification('Please calculate nutrition first using the AI button');
        return;
    }

    const foodData = {
        name: foodName,
        quantity: quantity,
        unit: unit,
        calories: calories,
        protein: protein,
        fiber: fiber,
        mealType: mealType
    };

    app.addFoodLog(foodData);
    closeAddFoodModal();
    app.showNotification(`${foodName} (${quantity}${unit}) added to your food log! 🍽️`);
}

// Quantity toggle functions
function toggleQuantityType() {
    const isCustom = document.querySelector('input[name="quantity-type"]:checked').value === 'custom';
    document.getElementById('preset-quantity').style.display = isCustom ? 'none' : 'block';
    document.getElementById('custom-quantity').style.display = isCustom ? 'block' : 'none';
}

function toggleEditQuantityType() {
    const isCustom = document.querySelector('input[name="edit-quantity-type"]:checked').value === 'custom';
    document.getElementById('edit-preset-quantity').style.display = isCustom ? 'none' : 'block';
    document.getElementById('edit-custom-quantity').style.display = isCustom ? 'block' : 'none';
}

// Food entry management functions
function editFoodEntry(id) {
    const entry = app.getFoodEntryById(id);
    if (!entry) return;
    
    // Populate edit modal
    document.getElementById('edit-food-id').value = id;
    document.getElementById('edit-food-name').value = entry.name;
    document.getElementById('edit-calories').value = entry.calories;
    document.getElementById('edit-protein').value = entry.protein;
    document.getElementById('edit-fiber').value = entry.fiber;
    
    // Set meal type
    document.querySelectorAll('#edit-food-modal .meal-type').forEach(btn => btn.classList.remove('active'));
    document.querySelector(`#edit-food-modal .meal-type[data-meal="${entry.mealType}"]`).classList.add('active');
    
    // Show modal
    document.getElementById('edit-food-modal').classList.add('active');
}

function deleteFoodEntry(id) {
    app.deleteFoodEntry(id);
}

function closeEditFoodModal() {
    document.getElementById('edit-food-modal').classList.remove('active');
}

function updateFoodLog() {
    const id = parseInt(document.getElementById('edit-food-id').value);
    const foodName = document.getElementById('edit-food-name').value.trim();
    const isCustom = document.querySelector('input[name="edit-quantity-type"]:checked').value === 'custom';
    
    let quantity, unit;
    if (isCustom) {
        const customGrams = document.getElementById('edit-custom-grams').value;
        if (!customGrams) {
            app.showNotification('Please enter custom quantity in grams');
            return;
        }
        quantity = parseFloat(customGrams);
        unit = 'g';
    } else {
        quantity = parseFloat(document.getElementById('edit-quantity-amount').value);
        unit = document.getElementById('edit-quantity-unit').value;
    }
    
    const calories = document.getElementById('edit-calories').value;
    const protein = document.getElementById('edit-protein').value;
    const fiber = document.getElementById('edit-fiber').value;
    const mealType = document.querySelector('#edit-food-modal .meal-type.active').dataset.meal;

    if (!foodName || !calories) {
        app.showNotification('Please fill in all required fields');
        return;
    }

    const updatedData = {
        name: foodName,
        portion: `${quantity}${unit}`,
        calories: parseFloat(calories),
        protein: parseFloat(protein),
        fiber: parseFloat(fiber),
        mealType: mealType
    };

    app.updateFoodEntry(id, updatedData);
    closeEditFoodModal();
    app.showNotification(`${foodName} updated successfully! ✅`);
}

// Edit modal AI calculation functions
function searchEditFoodSuggestions() {
    const foodName = document.getElementById('edit-food-name').value;
    const suggestionsDiv = document.getElementById('edit-food-suggestions');
    
    if (foodName.length < 2) {
        suggestionsDiv.innerHTML = '';
        return;
    }
    
    const suggestions = app.searchFoodInDatabase(foodName);
    
    if (suggestions.length === 0) {
        suggestionsDiv.innerHTML = '';
        return;
    }
    
    suggestionsDiv.innerHTML = suggestions.map(food => `
        <div class="suggestion-item" onclick="selectEditFoodSuggestion('${food.name}')">
            <div>
                <div class="suggestion-name">${food.name}</div>
                <div class="suggestion-info">${food.category} • ${food.calories} cal per ${food.unit}</div>
            </div>
        </div>
    `).join('');
}

function selectEditFoodSuggestion(foodName) {
    document.getElementById('edit-food-name').value = foodName;
    document.getElementById('edit-food-suggestions').innerHTML = '';
    setTimeout(() => calculateEditNutritionAI(), 100);
}

function calculateEditNutritionAI() {
    const foodName = document.getElementById('edit-food-name').value.trim();
    const isCustom = document.querySelector('input[name="edit-quantity-type"]:checked').value === 'custom';
    
    let quantity, unit;
    if (isCustom) {
        const customGrams = document.getElementById('edit-custom-grams').value;
        if (!customGrams) {
            app.showNotification('Please enter custom quantity in grams first');
            return;
        }
        quantity = parseFloat(customGrams) / 100; // Convert to 100g units
        unit = '100g';
    } else {
        quantity = parseFloat(document.getElementById('edit-quantity-amount').value);
        unit = document.getElementById('edit-quantity-unit').value;
    }
    
    if (!foodName) {
        app.showNotification('Please enter a food name first');
        return;
    }
    
    const btn = document.querySelector('#edit-food-modal .ai-calculate-btn');
    const originalText = btn.innerHTML;
    btn.innerHTML = '🤖 Calculating...';
    btn.disabled = true;
    
    setTimeout(() => {
        const nutrition = app.calculateNutritionForFood(foodName, quantity, unit);
        
        // Update preview
        document.getElementById('edit-preview-calories').textContent = nutrition.calories;
        document.getElementById('edit-preview-protein').textContent = `${nutrition.protein} g`;
        document.getElementById('edit-preview-fiber').textContent = `${nutrition.fiber} g`;
        document.getElementById('edit-preview-carbs').textContent = `${nutrition.carbs} g`;
        
        // Update form fields
        document.getElementById('edit-calories').value = nutrition.calories;
        document.getElementById('edit-protein').value = nutrition.protein;
        document.getElementById('edit-fiber').value = nutrition.fiber;
        
        // Show preview
        document.getElementById('edit-nutrition-preview').style.display = 'block';
        
        // Reset button
        btn.innerHTML = originalText;
        btn.disabled = false;
        
        const message = nutrition.found ? 
            `✅ Found ${foodName} in database!` : 
            `🤖 AI estimated nutrition for ${foodName}`;
        app.showNotification(message);
        
    }, 1500);
}

function updateEditNutritionPreview() {
    const foodName = document.getElementById('edit-food-name').value.trim();
    if (foodName && document.getElementById('edit-nutrition-preview').style.display === 'block') {
        calculateEditNutritionAI();
    }
}

function simulateScanning() {
    app.simulateScanning();
}

function simulateGallery() {
    app.simulateGallery();
}

function resetScanner() {
    app.resetScanner();
}

// Initialize app when DOM is loaded
let app;
document.addEventListener('DOMContentLoaded', () => {
    app = new FoodTracker();
    
    // Add click handler for camera viewfinder
    document.getElementById('camera-view').addEventListener('click', simulateScanning);
    
    // Show welcome message
    setTimeout(() => {
        app.showNotification('Welcome to FoodTracker! 🍽️ Try scanning some Tamil food!');
    }, 1000);
    
    // Update calorie goal on initial load
    app.updateCalorieGoal();
});
