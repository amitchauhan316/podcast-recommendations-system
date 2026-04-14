import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  // ▶️ Play audio from URL
  Future<void> play(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      // Error playing audio
    }
  }

  // ⏸ Pause
  void pause() {
    _player.pause();
  }

  // ⏹ Stop
  void stop() {
    _player.stop();
  }

  // ⏩ Seek
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // ⏱ Get current position
  Stream<Duration> get positionStream => _player.positionStream;

  // 📏 Get duration
  Duration? get duration => _player.duration;

  // 🎚 Playback speed
  void setSpeed(double speed) {
    _player.setSpeed(speed);
  }

  // 🔊 Dispose (important!)
  void dispose() {
    _player.dispose();
  }
}