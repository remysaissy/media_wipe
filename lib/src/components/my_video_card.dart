import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:video_player/video_player.dart';

class MyVideoCard extends StatefulWidget {
  final Asset asset;

  const MyVideoCard({super.key, required this.asset});

  @override
  State<StatefulWidget> createState() => _MyVideoCardState();
}

class _MyVideoCardState extends State<MyVideoCard> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    final assetUri = Uri.parse(widget.asset.assetUrl);
    _controller = VideoPlayerController.networkUrl(assetUri);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center,
        children: [
      FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown.
              setState(() {
                // If the video is playing, pause it.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // If the video is paused, play it.
                  _controller.play();
                }
              });
            },
            // Display the correct icon depending on the state of the player.
            child: Icon(
              _controller.value.isPlaying ? Symbols.pause : Symbols.play_arrow,
            ),
          )
    ]);
  }
}