class PlayerController {
  // 🎧 State
  bool isPlaying = false;

  // ⏱ Progress (in seconds)
  double currentPosition = 0;
  double totalDuration = 3600; // 1 hour dummy

  // ⚡ Playback speed
  double playbackSpeed = 1.0;

  // ▶️ Play / Pause toggle
  void togglePlayPause() {
    isPlaying = !isPlaying;
  }

  // ⏩ Seek forward
  void forward() {
    currentPosition += 15;
    if (currentPosition > totalDuration) {
      currentPosition = totalDuration;
    }
  }

  // ⏪ Seek backward
  void backward() {
    currentPosition -= 15;
    if (currentPosition < 0) {
      currentPosition = 0;
    }
  }

  // 🎚 Seek manually (slider)
  void seek(double value) {
    currentPosition = value;
  }

  // ⚡ Change playback speed
  void changeSpeed() {
    if (playbackSpeed == 1.0) {
      playbackSpeed = 1.5;
    } else if (playbackSpeed == 1.5) {
      playbackSpeed = 2.0;
    } else {
      playbackSpeed = 1.0;
    }
  }

  // ⏱ Format time (mm:ss or hh:mm:ss)
  String formatTime(double seconds) {
    final int hrs = seconds ~/ 3600;
    final int mins = (seconds % 3600) ~/ 60;
    final int secs = (seconds % 60).toInt();

    if (hrs > 0) {
      return "$hrs:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    } else {
      return "$mins:${secs.toString().padLeft(2, '0')}";
    }
  }
}