import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class MyVideoViewerCard extends StatefulWidget {
  final AssetEntity assetEntity;

  const MyVideoViewerCard({super.key, required this.assetEntity});

  @override
  State<StatefulWidget> createState() => _MyVideoViewerState();
}

class _MyVideoViewerState extends State<MyVideoViewerCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    widget.assetEntity.getMediaUrl().then((value) => {
    _controller = VideoPlayerController.networkUrl(Uri.parse(value!))
    ..initialize().then((_) {
    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    setState(() {});
    })
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: [
      _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller))
          : Container(),
      FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      )
    ]));
  }
}
