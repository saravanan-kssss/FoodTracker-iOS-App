// FoodTracker Web Demo JavaScript
class FoodTrackerApp {
    constructor() {
        this.foodEntries = JSON.parse(localStorage.getItem('foodEntries')) || [];
        this.userProfile = JSON.parse(localStorage.getItem('userProfile')) || null;
        this.currentEditingId = null;
        this.tamilFoods = this.initializeTamilFoods();
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.updateCurrentDate();
        this.loadProfile();
        this.updateDailySummary();
        this.renderFoodEntries();
        this.renderQuickAddItems();
        this.updateAnalytics();
    }

    initializeTamilFoods() {
        return [
            { name: "Idli", calories: 58, protein: 2.0, carbs: 12.0, fat: 0.1, fiber: 0.6, category: "Breakfast" },
            { name: "Dosa", calories: 168, protein: 4.0, carbs: 28.0, fat: 4.0, fiber: 1.2, category: "Breakfast" },
            { name: "Sambar", calories: 85, protein: 4.5, carbs: 15.0, fat: 1.0, fiber: 4.0, category: "Curry" },
            { name: "Rasam", calories: 45, protein: 2.0, carbs: 8.0, fat: 0.5, fiber: 1.5, category: "Curry" },
            { name: "Plain Rice", calories: 130, protein: 2.7, carbs: 28.0, fat: 0.3, fiber: 0.4, category: "Rice" },
            { name: "Curd Rice", calories: 98, protein: 3.5, carbs: 18.0, fat: 1.2, fiber: 0.5, category: "Rice" },
            { name: "Chicken Curry", calories: 165, protein: 25.0, carbs: 5.0, fat: 5.5, fiber: 1.0, category: "Non-Veg" },
            { name: "Fish Curry", calories: 145, protein: 22.0, carbs: 3.0, fat: 5.0, fiber: 0.5, category: "Non-Veg" },
            { name: "Vadai", calories: 245, protein: 8.0, carbs: 25.0, fat: 12.0, fiber: 5.0, category: "Snack" },
            { name: "Payasam", calories: 185, protein: 4.0, carbs: 35.0, fat: 4.5, fiber: 1.0, category: "Sweet" }
        ];
    }

    setupEventListeners() {
        // Tab navigation
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.addEventListener('click', (e) => this.switchTab(e.target.dataset.tab));
        });

        // Quantity type toggle
        document.querySelectorAll('input[name="quantity-type"]').forEach(radio => {
            radio.addEventListener('change', this.toggleQuantityType);
        });

        // Food name input for suggestions
        document.getElementById('food-name').addEventListener('input', this.handleFoodNameInput.bind(this));

        // Meal type buttons
        document.querySelectorAll('.meal-btn').forEach(btn => {
            btn.addEventListener('click', (e) => this.selectMealType(e.target));
        });

        // Profile form inputs
        ['height', 'weight', 'age', 'gender', 'activity-level'].forEach(id => {
            document.getElementById(id).addEventListener('input', this.calculateBMR.bind(this));
        });
    }

    switchTab(tabName) {
        // Update tab buttons
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

        // Update tab content
        document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));
        document.getElementById(`${tabName}-tab`).classList.add('active');

        // Update analytics when switching to analytics tab
        if (tabName === 'analytics') {
            this.updateAnalytics();
        }
    }

    updateCurrentDate() {
        const today = new Date();
        document.getElementById('current-date').textContent = today.toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }

    toggleQuantityType() {
        const isCustom = document.querySelector('input[name="quantity-type"]:checked').value === 'custom';
        document.getElementById('preset-quantity').style.display = isCustom ? 'none' : 'block';
        document.getElementById('custom-quantity').style.display = isCustom ? 'block' : 'none';
    }

    handleFoodNameInput(e) {
        const query = e.target.value.trim();
        if (query.length > 1) {
            const suggestions = this.searchFoodSuggestions(query);
            this.displayFoodSuggestions(suggestions);
        } else {
            document.getElementById('food-suggestions').innerHTML = '';
        }
    }

    searchFoodSuggestions(query) {
        return this.tamilFoods
            .filter(food => food.name.toLowerCase().includes(query.toLowerCase()))
            .slice(0, 6)
            .map(food => food.name);
    }

    displayFoodSuggestions(suggestions) {
        const container = document.getElementById('food-suggestions');
        container.innerHTML = suggestions.map(suggestion => 
            `<span class="suggestion-item" onclick="selectFoodSuggestion('${suggestion}')">${suggestion}</span>`
        ).join('');
    }

    selectMealType(button) {
        document.querySelectorAll('.meal-btn').forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');
    }

    calculateNutritionForFood(foodName, quantity, unit) {
        const tamilFood = this.tamilFoods.find(food => 
            food.name.toLowerCase() === foodName.toLowerCase()
        );

        let multiplier = this.calculateMultiplier(quantity, unit);
        
        if (tamilFood) {
            return {
                calories: Math.round(tamilFood.calories * multiplier),
                protein: Math.round(tamilFood.protein * multiplier * 10) / 10,
                carbs: Math.round(tamilFood.carbs * multiplier * 10) / 10,
                fat: Math.round(tamilFood.fat * multiplier * 10) / 10,
                fiber: Math.round(tamilFood.fiber * multiplier * 10) / 10,
                found: true
            };
        }

        // AI estimation for unknown foods
        return this.estimateNutrition(foodName, multiplier);
    }

    calculateMultiplier(quantity, unit) {
        const unitMultipliers = {
            'piece': 0.5, 'cup': 1.5, 'bowl': 2.0,
            '50g': 0.5, '100g': 1.0, '150g': 1.5, '200g': 2.0
        };
        return quantity * (unitMultipliers[unit] || 1.0);
    }

    estimateNutrition(foodName, multiplier) {
        const lowerName = foodName.toLowerCase();
        let baseNutrition;

        if (lowerName.includes('rice')) {
            baseNutrition = { calories: 130, protein: 2.7, carbs: 28.0, fat: 0.3, fiber: 0.4 };
        } else if (lowerName.includes('chicken')) {
            baseNutrition = { calories: 165, protein: 31.0, carbs: 0.0, fat: 3.6, fiber: 0.0 };
        } else if (lowerName.includes('dal') || lowerName.includes('lentil')) {
            baseNutrition = { calories: 116, protein: 9.0, carbs: 20.0, fat: 0.4, fiber: 8.0 };
        } else {
            baseNutrition = { calories: 100, protein: 5.0, carbs: 15.0, fat: 3.0, fiber: 2.0 };
        }

        return {
            calories: Math.round(baseNutrition.calories * multiplier),
            protein: Math.round(baseNutrition.protein * multiplier * 10) / 10,
            carbs: Math.round(baseNutrition.carbs * multiplier * 10) / 10,
            fat: Math.round(baseNutrition.fat * multiplier * 10) / 10,
            fiber: Math.round(baseNutrition.fiber * multiplier * 10) / 10,
            found: false
        };
    }

    addFood() {
        const foodName = document.getElementById('food-name').value.trim();
        const calories = parseInt(document.getElementById('calories').value) || 0;
        const protein = parseFloat(document.getElementById('protein').value) || 0;
        const fiber = parseFloat(document.getElementById('fiber').value) || 0;
        const selectedMeal = document.querySelector('.meal-btn.active').dataset.meal;

        if (!foodName || !calories) {
            this.showNotification('Please enter food name and calories', 'error');
            return;
        }

        const isCustom = document.querySelector('input[name="quantity-type"]:checked').value === 'custom';
        let quantity, unit;

        if (isCustom) {
            const customGrams = document.getElementById('custom-grams').value;
            if (!customGrams) {
                this.showNotification('Please enter custom quantity in grams', 'error');
                return;
            }
            quantity = parseFloat(customGrams);
            unit = 'g';
        } else {
            quantity = parseFloat(document.getElementById('quantity-amount').value);
            unit = document.getElementById('quantity-unit').value;
        }

        const entry = {
            id: Date.now(),
            foodName,
            quantity,
            unit,
            calories,
            protein,
            fiber,
            mealType: selectedMeal,
            timestamp: new Date().toISOString(),
            icon: this.getFoodIcon(foodName)
        };

        this.foodEntries.unshift(entry);
        this.saveFoodEntries();
        this.updateDailySummary();
        this.renderFoodEntries();
        this.clearForm();
        this.showNotification('Food added successfully!', 'success');
        this.switchTab('daily');
    }

    getFoodIcon(foodName) {
        const name = foodName.toLowerCase();
        if (name.includes('idli') || name.includes('dosa')) return '🥟';
        if (name.includes('rice')) return '🍚';
        if (name.includes('chicken')) return '🍗';
        if (name.includes('fish')) return '🐟';
        if (name.includes('curry')) return '🍛';
        if (name.includes('sweet') || name.includes('payasam')) return '🍮';
        return '🍽️';
    }

    clearForm() {
        document.getElementById('food-name').value = '';
        document.getElementById('calories').value = '';
        document.getElementById('protein').value = '';
        document.getElementById('fiber').value = '';
        document.getElementById('nutrition-preview').style.display = 'none';
        document.getElementById('food-suggestions').innerHTML = '';
    }

    updateDailySummary() {
        const today = new Date().toDateString();
        const todayEntries = this.foodEntries.filter(entry => 
            new Date(entry.timestamp).toDateString() === today
        );

        const totalCalories = todayEntries.reduce((sum, entry) => sum + entry.calories, 0);
        const totalProtein = todayEntries.reduce((sum, entry) => sum + entry.protein, 0);
        const totalFiber = todayEntries.reduce((sum, entry) => sum + entry.fiber, 0);
        const goalCalories = this.userProfile?.calorieGoal || 2000;

        document.getElementById('calories-consumed').textContent = totalCalories;
        document.getElementById('calorie-goal').textContent = goalCalories;
        document.getElementById('protein-consumed').textContent = `${totalProtein.toFixed(1)}g`;
        document.getElementById('fiber-consumed').textContent = `${totalFiber.toFixed(1)}g`;
        document.getElementById('meals-count').textContent = todayEntries.length;

        const progress = Math.min((totalCalories / goalCalories) * 100, 100);
        document.getElementById('calorie-progress').style.width = `${progress}%`;
    }

    renderFoodEntries() {
        const today = new Date().toDateString();
        const todayEntries = this.foodEntries.filter(entry => 
            new Date(entry.timestamp).toDateString() === today
        );

        const container = document.getElementById('food-entries-table');
        const countElement = document.getElementById('entry-count');
        
        countElement.textContent = `${todayEntries.length} items`;

        if (todayEntries.length === 0) {
            container.innerHTML = `
                <div class="no-entries">
                    <div class="no-entries-icon">🍽️</div>
                    <p>No food entries for today</p>
                    <small>Use the Scanner tab to add your first meal</small>
                </div>
            `;
            return;
        }

        container.innerHTML = todayEntries.map(entry => `
            <div class="food-entry">
                <div class="food-icon">${entry.icon}</div>
                <div class="food-details">
                    <div class="food-name">${entry.foodName}</div>
                    <div class="food-quantity">${entry.quantity} ${entry.unit} • ${entry.mealType}</div>
                </div>
                <div class="food-nutrition">
                    <div class="food-calories">${entry.calories} cal</div>
                    <div class="food-macros">${entry.protein}p • ${entry.fiber}f</div>
                </div>
                <div class="food-actions">
                    <button class="action-btn edit-btn" onclick="app.editFoodEntry(${entry.id})">✏️</button>
                    <button class="action-btn delete-btn" onclick="app.deleteFoodEntry(${entry.id})">🗑️</button>
                </div>
            </div>
        `).join('');
    }

    renderQuickAddItems() {
        const container = document.getElementById('quick-add-grid');
        const popularFoods = this.tamilFoods.slice(0, 6);

        container.innerHTML = popularFoods.map(food => `
            <div class="quick-add-item" onclick="app.quickAddFood('${food.name}')">
                <div class="quick-add-name">${food.name}</div>
                <div class="quick-add-calories">${food.calories} cal/100g</div>
            </div>
        `).join('');
    }

    quickAddFood(foodName) {
        const food = this.tamilFoods.find(f => f.name === foodName);
        if (!food) return;

        const entry = {
            id: Date.now(),
            foodName: food.name,
            quantity: 1,
            unit: 'serving',
            calories: food.calories,
            protein: food.protein,
            fiber: food.fiber,
            mealType: this.getCurrentMealType(),
            timestamp: new Date().toISOString(),
            icon: this.getFoodIcon(food.name)
        };

        this.foodEntries.unshift(entry);
        this.saveFoodEntries();
        this.updateDailySummary();
        this.renderFoodEntries();
        this.showNotification(`${foodName} added!`, 'success');
    }

    getCurrentMealType() {
        const hour = new Date().getHours();
        if (hour >= 5 && hour < 11) return 'Breakfast';
        if (hour >= 11 && hour < 16) return 'Lunch';
        if (hour >= 16 && hour < 20) return 'Dinner';
        return 'Snack';
    }

    editFoodEntry(id) {
        const entry = this.foodEntries.find(e => e.id === id);
        if (!entry) return;

        this.currentEditingId = id;
        document.getElementById('edit-food-name').value = entry.foodName;
        document.getElementById('edit-quantity').value = entry.quantity;
        document.getElementById('edit-unit').value = entry.unit;
        document.getElementById('edit-calories').value = entry.calories;
        document.getElementById('edit-protein').value = entry.protein;
        document.getElementById('edit-fiber').value = entry.fiber;

        document.getElementById('edit-modal').classList.add('active');
    }

    updateFoodEntry() {
        if (!this.currentEditingId) return;

        const entry = this.foodEntries.find(e => e.id === this.currentEditingId);
        if (!entry) return;

        entry.foodName = document.getElementById('edit-food-name').value;
        entry.quantity = parseFloat(document.getElementById('edit-quantity').value);
        entry.unit = document.getElementById('edit-unit').value;
        entry.calories = parseInt(document.getElementById('edit-calories').value);
        entry.protein = parseFloat(document.getElementById('edit-protein').value);
        entry.fiber = parseFloat(document.getElementById('edit-fiber').value);
        entry.icon = this.getFoodIcon(entry.foodName);

        this.saveFoodEntries();
        this.updateDailySummary();
        this.renderFoodEntries();
        this.closeEditModal();
        this.showNotification('Entry updated!', 'success');
    }

    deleteFoodEntry(id) {
        if (confirm('Are you sure you want to delete this entry?')) {
            this.foodEntries = this.foodEntries.filter(entry => entry.id !== id);
            this.saveFoodEntries();
            this.updateDailySummary();
            this.renderFoodEntries();
            this.showNotification('Entry deleted!', 'success');
        }
    }

    closeEditModal() {
        document.getElementById('edit-modal').classList.remove('active');
        this.currentEditingId = null;
    }

    calculateBMR() {
        const height = parseFloat(document.getElementById('height').value);
        const weight = parseFloat(document.getElementById('weight').value);
        const age = parseInt(document.getElementById('age').value);
        const gender = document.getElementById('gender').value;
        const activityLevel = document.getElementById('activity-level').value;

        if (!height || !weight || !age) {
            document.getElementById('bmr-display').style.display = 'none';
            return;
        }

        let bmr;
        if (gender === 'Male') {
            bmr = 10 * weight + 6.25 * height - 5 * age + 5;
        } else {
            bmr = 10 * weight + 6.25 * height - 5 * age - 161;
        }

        const activityMultipliers = {
            'Sedentary': 1.2,
            'Light': 1.375,
            'Moderate': 1.55,
            'Active': 1.725,
            'Very Active': 1.9
        };

        const dailyCalories = Math.round(bmr * activityMultipliers[activityLevel]);
        
        document.getElementById('bmr-value').textContent = `${dailyCalories} calories`;
        document.getElementById('bmr-display').style.display = 'block';

        return dailyCalories;
    }

    saveProfile() {
        const name = document.getElementById('user-name').value.trim();
        const height = parseFloat(document.getElementById('height').value);
        const weight = parseFloat(document.getElementById('weight').value);
        const age = parseInt(document.getElementById('age').value);
        const gender = document.getElementById('gender').value;
        const activityLevel = document.getElementById('activity-level').value;

        if (!name || !height || !weight || !age) {
            this.showNotification('Please fill in all fields', 'error');
            return;
        }

        const calorieGoal = this.calculateBMR();
        
        this.userProfile = {
            name, height, weight, age, gender, activityLevel, calorieGoal,
            createdAt: new Date().toISOString()
        };

        localStorage.setItem('userProfile', JSON.stringify(this.userProfile));
        document.getElementById('profile-name').textContent = name;
        this.updateDailySummary();
        this.showNotification('Profile saved successfully!', 'success');
    }

    loadProfile() {
        if (this.userProfile) {
            document.getElementById('user-name').value = this.userProfile.name || '';
            document.getElementById('height').value = this.userProfile.height || '';
            document.getElementById('weight').value = this.userProfile.weight || '';
            document.getElementById('age').value = this.userProfile.age || '';
            document.getElementById('gender').value = this.userProfile.gender || 'Male';
            document.getElementById('activity-level').value = this.userProfile.activityLevel || 'Moderate';
            document.getElementById('profile-name').textContent = this.userProfile.name || 'Your Profile';
            this.calculateBMR();
        }
    }

    updateAnalytics() {
        const weekAgo = new Date();
        weekAgo.setDate(weekAgo.getDate() - 7);
        
        const weekEntries = this.foodEntries.filter(entry => 
            new Date(entry.timestamp) >= weekAgo
        );

        const totalCalories = weekEntries.reduce((sum, entry) => sum + entry.calories, 0);
        const avgCalories = weekEntries.length > 0 ? Math.round(totalCalories / 7) : 0;
        
        const uniqueDays = new Set(weekEntries.map(entry => 
            new Date(entry.timestamp).toDateString()
        )).size;

        const foodCounts = {};
        weekEntries.forEach(entry => {
            foodCounts[entry.foodName] = (foodCounts[entry.foodName] || 0) + 1;
        });
        
        const favoriteFood = Object.keys(foodCounts).reduce((a, b) => 
            foodCounts[a] > foodCounts[b] ? a : b, '-'
        );

        document.getElementById('week-avg-calories').textContent = avgCalories;
        document.getElementById('days-logged').textContent = uniqueDays;
        document.getElementById('favorite-food').textContent = favoriteFood;

        this.generateInsights(weekEntries, avgCalories, uniqueDays);
    }

    generateInsights(weekEntries, avgCalories, daysLogged) {
        const insights = [];
        const goalCalories = this.userProfile?.calorieGoal || 2000;

        if (daysLogged >= 5) {
            insights.push('Great consistency! You\'ve been logging regularly this week.');
        } else if (daysLogged > 0) {
            insights.push('Try to log your meals more consistently for better tracking.');
        }

        if (avgCalories > 0) {
            if (avgCalories < goalCalories * 0.8) {
                insights.push('You might be eating below your calorie goal. Consider adding healthy snacks.');
            } else if (avgCalories > goalCalories * 1.2) {
                insights.push('You\'re exceeding your calorie goal. Focus on portion control.');
            } else {
                insights.push('You\'re maintaining good calorie balance!');
            }
        }

        if (weekEntries.length === 0) {
            insights.push('Start logging your meals to get personalized insights!');
        }

        const container = document.getElementById('insights-list');
        container.innerHTML = insights.map(insight => `
            <div class="insight-item">
                <span class="insight-icon">✅</span>
                <span class="insight-text">${insight}</span>
            </div>
        `).join('');
    }

    saveFoodEntries() {
        localStorage.setItem('foodEntries', JSON.stringify(this.foodEntries));
    }

    showNotification(message, type = 'success') {
        const notification = document.getElementById('notification');
        notification.textContent = message;
        notification.className = `notification ${type} show`;
        
        setTimeout(() => {
            notification.classList.remove('show');
        }, 3000);
    }
}

// Global functions
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

function recalculateNutrition() {
    const foodName = document.getElementById('edit-food-name').value.trim();
    const quantity = parseFloat(document.getElementById('edit-quantity').value);
    const unit = document.getElementById('edit-unit').value;
    
    if (!foodName || !quantity) return;
    
    const nutrition = app.calculateNutritionForFood(foodName, quantity, unit);
    
    document.getElementById('edit-calories').value = nutrition.calories;
    document.getElementById('edit-protein').value = nutrition.protein;
    document.getElementById('edit-fiber').value = nutrition.fiber;
    
    app.showNotification('Nutrition recalculated!');
}

function addFood() {
    app.addFood();
}

function saveProfile() {
    app.saveProfile();
}

function updateFoodEntry() {
    app.updateFoodEntry();
}

function closeEditModal() {
    app.closeEditModal();
}

// Initialize app
const app = new FoodTrackerApp();
