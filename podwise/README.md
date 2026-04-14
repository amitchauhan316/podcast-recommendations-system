# Podwise

A modern, feature-rich podcast application built with Flutter for discovering, listening, and managing your favorite podcasts.

## Features

### 🎧 Podcast Discovery
- Browse curated podcast collections
- Search podcasts by title, author, or category
- Filter by duration, rating, and categories
- Get personalized recommendations based on your interests

### 📚 Library Management
- **Subscribed**: Keep track of podcasts you're following
- **Saved**: Automatically save podcasts when you start listening
- **Downloaded**: Download episodes for offline listening
- Real-time synchronization with backend
- Smart filtering: All Episodes, Subscribed, Saved, Downloads

### 🎵 Advanced Player
- High-quality audio playback
- Playback speed control (0.5x - 2.0x)
- Seek forward/backward (15 seconds)
- Progress tracking with visual indicators
- Background playback support

### 🔍 Smart Filtering & Sorting
- Filter by status: All, In Progress, New, Done, Saved
- Filter by podcast author/show
- Sort by: Newest, Oldest, A-Z, Duration
- Adjustable duration limits

### 📱 Real-time Features
- Auto-save episodes to library when playing starts
- Move subscribed episodes to saved when listened
- Live progress updates
- Pull-to-refresh library data

## Screenshots

*(Add screenshots here when available)*

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Python 3.8+ (for backend)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd podwise
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up the backend**
   ```bash
   cd ../Backend
   pip install flask flask-cors pandas
   python app.py
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Backend Setup
The app requires a Python Flask backend for:
- Podcast data management
- User library persistence
- Recommendation engine

Make sure `podcast_dataset.csv` exists in the project root.

## Project Structure

```
podwise/
├── lib/
│   ├── core/           # App constants, themes, utilities
│   ├── features/       # Feature modules
│   │   ├── home/       # Home screen
│   │   ├── search/     # Search functionality
│   │   ├── library/    # Library management
│   │   │   ├── library_screen.dart
│   │   │   ├── library_controller.dart
│   │   │   └── widgets/
│   │   ├── player/     # Audio player
│   │   └── onboarding/ # Welcome screens
│   ├── models/         # Data models
│   ├── services/       # API and audio services
│   └── widgets/        # Reusable UI components
├── android/            # Android platform code
├── ios/               # iOS platform code
└── web/               # Web platform code
```

## Key Components

### Library System
- **Real-time Saving**: Episodes automatically save when playback starts
- **Smart Categorization**: Subscribed → Saved when played
- **Progress Tracking**: Visual progress bars and status indicators
- **Advanced Filtering**: Multi-criteria filtering with live updates

### Player Features
- **Audio Controls**: Play/pause, seek, speed adjustment
- **Progress Visualization**: Linear progress indicators
- **Background Playback**: Continue listening while using other apps

### Backend Integration
- **RESTful API**: Flask-based backend for data persistence
- **JSON Storage**: Library data stored in `library_data.json`
- **CSV Data Source**: Podcast data loaded from `podcast_dataset.csv`

## API Endpoints

### Podcasts
- `GET /api/podcasts/` - Get all podcasts
- `GET /api/podcasts/search` - Search with filters

### Recommendations
- `POST /api/recommend/` - Get recommendations
- `POST /api/recommend/related` - Get related podcasts

### Library
- `GET /api/library/subscribed` - Get subscribed episodes
- `GET /api/library/saved` - Get saved episodes
- `GET /api/library/downloaded` - Get downloaded episodes
- `POST /api/library/play` - Save episode when played
- `POST /api/library/subscribe` - Subscribe to episode
- `POST /api/library/download` - Download episode

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Built With

- **Flutter** - UI framework
- **Dart** - Programming language
- **Flask** - Backend API
- **Python** - Backend logic
- **HTTP** - Network requests
- **Audio Service** - Audio playback

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter documentation and community
- Podcast dataset providers
- Open source audio libraries
