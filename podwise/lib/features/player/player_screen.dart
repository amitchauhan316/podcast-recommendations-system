import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/podcast_model.dart';
import '../../services/audio_service.dart';
import '../../services/user_state.dart';
import '../../services/api_service.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';

class PlayerScreen extends StatefulWidget {
  final Podcast podcast;
  const PlayerScreen({super.key, required this.podcast});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioService _audioService = AudioService();
  final ApiService _apiService = ApiService();
  bool isPlaying = false;
  double currentPosition = 0;
  double totalDuration = 0;
  double playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    final url = widget.podcast.audioUrl;
    if (url.isNotEmpty) {
      if (_isYoutubeUrl(url)) {
        setState(() {
          isPlaying = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openExternalUrl(url);
        });
      } else {
        await _audioService.play(url);
        setState(() {
          isPlaying = true;
        });
        // Save to backend when playing starts
        _saveToPlayed();
      }
    }

    _audioService.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position.inSeconds.toDouble();
          totalDuration = _audioService.duration?.inSeconds.toDouble() ?? 1.0;
        });
      }
    });
  }

  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open YouTube link')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open YouTube link')),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    final url = widget.podcast.audioUrl;
    if (_isYoutubeUrl(url)) {
      _openExternalUrl(url);
      return;
    }

    if (isPlaying) {
      _audioService.pause();
    } else {
      _audioService.play(url);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void seek(double value) {
    if (value < 0) value = 0;
    if (value > totalDuration) value = totalDuration;
    _audioService.seek(Duration(seconds: value.toInt()));
    setState(() {
      currentPosition = value;
    });
  }

  void changeSpeed() {
    setState(() {
      if (playbackSpeed == 1.0) {
        playbackSpeed = 1.5;
      } else if (playbackSpeed == 1.5) {
        playbackSpeed = 2.0;
      } else {
        playbackSpeed = 1.0;
      }
    });
    _audioService.setSpeed(playbackSpeed);
  }

  void _saveToPlayed() {
    final episodeData = {
      "id": widget.podcast.id,
      "title": widget.podcast.title,
      "author": widget.podcast.author,
      "category": widget.podcast.category,
      "statusTag": "",
      "timeLeft": "",
      "progress": 0.0,
    };
    _apiService.playEpisode(widget.podcast.id, episodeData);
  }

  void dislikePodcast() {
    UserState().excludedIds.add(widget.podcast.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Podcast disliked. Getting new recommendations...')),
    );
    // Optionally, navigate back or refresh recommendations
    Navigator.pop(context);
  }
  
  void forward() {
    seek(currentPosition + 15);
  }

  void backward() {
    seek(currentPosition - 15);
  }

  String formatTime(double seconds) {
    if (seconds < 0 || seconds.isNaN || seconds.isInfinite) return "0:00";
    final int hrs = seconds ~/ 3600;
    final int mins = (seconds % 3600) ~/ 60;
    final int secs = (seconds % 60).toInt();

    if (hrs > 0) {
      return "$hrs:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    } else {
      return "$mins:${secs.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌊 Background Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.playerGradientStart,
              AppColors.playerGradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 🔙 Top Bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    const Spacer(),
                    const Text(
                      AppStrings.nowPlaying,
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert),
                  ],
                ),

                const SizedBox(height: 20),

                // 🎧 Podcast Image
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(widget.podcast.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🎙 Podcast Info
                Text(
                  widget.podcast.author,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.podcast.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.podcast.category,
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                // 🎚 Progress Bar
                Slider(
                  value: currentPosition.clamp(0.0, totalDuration > 0 ? totalDuration : 1.0),
                  max: totalDuration > 0 ? totalDuration : 1.0,
                  onChanged: (value) {
                    seek(value);
                  },
                ),

                // ⏱ Time Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(currentPosition)),
                    Text(
                      "-${formatTime(totalDuration - currentPosition)}",
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🎮 Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        backward();
                      },
                      icon: const Icon(Icons.replay_10),
                      iconSize: 30,
                    ),

                    GestureDetector(
                      onTap: () {
                        togglePlayPause();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        forward();
                      },
                      icon: const Icon(Icons.forward_10),
                      iconSize: 30,
                    ),
                  ],
                ),

                const Spacer(),

                // ⚙ Bottom Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionItem(
                      icon: Icons.speed,
                      label: "${playbackSpeed}x",
                      onTap: () {
                        changeSpeed();
                      },
                    ),
                    _actionItem(
                      icon: Icons.thumb_down,
                      label: "Dislike",
                      onTap: () {
                        dislikePodcast();
                      },
                    ),
                    _actionItem(
                      icon: Icons.timer,
                      label: AppStrings.sleepTimer,
                      onTap: () {},
                    ),
                    _actionItem(
                      icon: Icons.queue_music,
                      label: AppStrings.queue,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔧 Reusable Bottom Item
  Widget _actionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}