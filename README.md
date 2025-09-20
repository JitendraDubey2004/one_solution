# One_Solution: Full-Stack Flutter App

**One_Solution** is a full-stack mobile application developed for a coding assignment. It features a clean and modern UI built with Flutter and a robust RESTful API backend powered by Node.js and Express.js. The app allows users to submit various requests, such as booking venues, planning trips, or exploring retail stores.

---

## ✨ Features

- **Dynamic Home Screen:**  
  Displays categories like "Banquets & Venues," "Travel & Stay" and "Retail Stores & Shops," fetched dynamically from the backend.

- **Custom UI Elements:**  
  Includes custom-designed components such as a scroll-aware floating action icon.

- **Cascading Dropdowns:**  
  Forms for "Banquets & Venues" and "Retail Stores & Shops" feature Country → State → City dropdowns, dynamically populated via API calls.

- **Form Submission:**  
  User-submitted data is stored in a MongoDB Atlas database through the backend API.

- **Modular Architecture:**  
  Feature-first folder structure ensures scalability, maintainability, and easy collaboration.

---

## 🚀 Getting Started

Follow these steps to set up and run the project locally.

### Prerequisites
- **Flutter SDK** – [Install Flutter](https://docs.flutter.dev/get-started/install)  
- **Node.js & npm** – [Install Node.js](https://nodejs.org/)  
- **MongoDB Atlas Account** – Cloud-hosted database

---

### Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/YourUsername/your-repo-name.git
cd your-repo-name
```

#### 2. Set up the Backend
```bash
cd one_solution_Backend
npm install
```
- Configure your database: create a `.env` file with the following:  
```env
PORT=5000
MONGO_URI=mongodb+srv://<username>:<password>@<cluster-name>.mongodb.net/oneSolution?retryWrites=true&w=majority
```
- Run the backend server:
```bash
npm run dev
```
Server will start at `http://localhost:5000`.

#### 3. Set up the Frontend
```bash
cd ../one_solution_frontend
flutter pub get
```
- Run the app:  
  - **Real Device:** Ensure backend URL is correct.  
  - **Web/Desktop:** Replace `https://ssquad-backend.onrender.com` with `http://localhost:5000` in the code.  
  - **Android Emulator:** Replace with `http://<your-local-IP>:5000`.  
```bash
flutter run -d chrome --web-renderer html   # for web (avoids CORS issues)
flutter run                                
```

---

## 🛠️ Technology Stack

- **Frontend:** Flutter, Dart, `http` package  
- **Backend:** Node.js, Express.js (deployed on Render for live backend)  
- **Database:** MongoDB Atlas  
- **API Testing:** Postman

---

## 📂 Folder Structure

```
/One_Solution
├── one_solution_frontend/                  # Flutter Frontend
│   ├── android/
│   ├── ios/
│   ├── lib/
│   │   ├── features/
│   │   │   ├── banquets_venues/
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── catering_preference_option.dart
│   │   │   │   │   ├── cuisine_option_card.dart
│   │   │   │   │   └── venue_dropdown.dart
│   │   │   │   └── banquets_venues_page.dart
│   │   │   ├── home/
│   │   │   │   ├── widgets/
│   │   │   │   │   └── category_card.dart
│   │   │   │   └── home_page.dart
│   │   │   ├── retail/
│   │   │   │   └── retail_shops_page.dart
│   │   │   └── travel/
│   │   │       └── travel_stay_page.dart
│   │   └── main.dart
│   └── pubspec.yaml
│
└── one_solution_Backend/          # Node.js Backend
    ├── src/
    │   ├── config/
    │   │   └── db.js
    │   ├── controllers/
    │   │   ├── banquetsController.js
    │   │   ├── geoController.js
    │   │   ├── retailController.js
    │   │   └── travelController.js
    │   ├── models/
    │   │   ├── Request.js
    │   │   ├── RetailRequest.js
    │   │   └── TravelRequest.js
    │   ├── routes/
    │   │   └── api.js
    │   └── app.js
    ├── .env
    ├── package.json
    └── server.js
```

