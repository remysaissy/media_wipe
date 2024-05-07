import 'package:app/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MyVideoViewerCard extends StatefulWidget {
  final AssetEntity assetEntity;

  const MyVideoViewerCard({super.key, required this.assetEntity});

  @override
  State<StatefulWidget> createState() => _MyVideoViewerState();
}

class _MyVideoViewerState extends State<MyVideoViewerCard> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    widget.assetEntity.getMediaUrl().then((value) => {
          _controller = VideoPlayerController.networkUrl(Uri.parse(value!))
            ..initialize().then((_) {
              _chewieController = ChewieController(
                videoPlayerController: _controller!,
              );
              setState(() {});
            })
        });

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && _chewieController != null) {
      return Center(
          child: _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: Chewie(controller: _chewieController!))
              : Container());
    }
    return Utils.buildLoading(context);
  }
}
