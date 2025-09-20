one_solution: Full-Stack Flutter App

This project is a full-stack mobile application developed for a coding assignment. It features a modern, clean UI built with Flutter and a robust RESTful API backend powered by Node.js and Express.js. The application is designed to help users submit various requests, such as booking a venue or planning a trip.

✨ Features

Dynamic Home Screen: The home page displays a list of categories like "Banquets & Venues," "Travel & Stay" and "Retail stores & Shops" that are fetched dynamically from the backend API.

Custom UI Elements: The app includes custom-designed UI components, such as a scroll-aware floating icon on the home page.
Cascading Dropdowns: The forms for "Banquets & Venues" and "Retail stores & Shops" feature cascading dropdowns for Country, State, and City, which are populated dynamically via API calls.

Form Submission: User-submitted data is sent to the backend and stored in a MongoDB Atlas database.

Modular Architecture: The project follows a "Feature-First" folder structure, making the codebase scalable, maintainable, and easy to collaborate on.

🚀 Getting Started
Follow these steps to set up and run the project on your local machine.

 Prerequisites
 Flutter SDK: Ensure you have Flutter installed.
 Node.js & npm: Ensure you have Node.js and npm installed.
 MongoDB Atlas Account: You will need a cloud-hosted database.

 Installation
 1. Clone the Repository
     git clone https://github.com/YourUsername/your-repo-name.git
     cd your-repo-name
 2. Set up the Backend
     Navigate to the one_solution_Backend directory using cd one_solution_Backend
     Install dependencies: using npm install
     Configure your database by creating a .env file in the one_solution_Backend folder and add your MongoDB Atlas connection string and server port.
     # .env
     PORT=5000
     MONGO_URI=mongodb+srv://<username>:<password>@<cluster-name>.mongodb.net/oneSolution?retryWrites=true&w=majority
     Run the backend server: using npm run dev
   The server will start on http://localhost:5000.
 3. Set up the Frontend
    In a same  terminal, navigate to the one_solution_frontend directory using cd ../one_solution_frontend
    Install dependencies: using flutter pub get
    Run the app:
     To run ensure your backend URL is running at correct place
       If you  run on an Real device you can run the same code
       If you  run on an Web/desktop replace https://ssquad-backend.onrender.com with http://localhost:5000 at every occurence
       If you  run on an Android emulator replace https://ssquad-backend.onrender.com with http://172.16.123.89:5000 at every occurence
     To run in Chrome, use the flutter run -d chrome --web-renderer html command to avoid CORS issues or you can also use flutter run

🛠️ Tools and Technology Stack
    Frontend: Flutter, Dart, http package.
    Backend: Node.js, Express.js (deployed on Render for live backend).
    Database: MongoDB Atlas.
    API Testing: Postman.

📂 Folder Structure
The project is organized using a feature-first approach to ensure a clean and scalable codebase.

/One_Solution
├── one_solution_frontend/                  # Flutter Frontend Part
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
└── one_solution_Backend/          # Node.js Backend Part
    ├── src/
    │   ├── config/
    │   │   └── database.js
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
