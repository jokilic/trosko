import 'package:just_audio/just_audio.dart';

/// Plays the `Welcome to Trosko` sound when long pressing the [Trosko] icon
Future<void> playWelcomeToTrosko() async {
  final player = AudioPlayer();
  await player.setAsset(
    'assets/welcome_to_trosko.mp3',
  );
  await player.play();
  await player.dispose();
}
