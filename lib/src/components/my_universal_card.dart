import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/components/my_image_card.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';
// import 'package:material_symbols_icons/material_symbols_icons.dart';
// import 'package:sortmaster_photos/src/models/assets_model.dart';
// import 'package:video_player/video_player.dart';

class MyUniversalCard extends StatefulWidget {
  final AssetData assetData;

  const MyUniversalCard({super.key, required this.assetData});

  @override
  State<StatefulWidget> createState() => _MyUniversalCardState();
}

class _MyUniversalCardState extends State<MyUniversalCard> {

  late Future<AssetEntity?> _entityFuture;

  @override
  void initState() {
    _entityFuture = widget.assetData.loadEntity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('====> ${widget.assetData.id}');
    return FutureBuilder(future: _entityFuture, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        final entity = snapshot.requireData;
        if (entity != null) {
          if (entity.isLivePhoto || entity.type == AssetType.image) {
            return MyImageCard(assetData: widget.assetData, assetEntity: entity);
          }
          return const Text('Video');
        }
        return const Text('Unable to load asset');
      } else {
        return Utils.buildLoading(context);
      }
    });
    // if (!_loaded) {
    //   return Utils.buildLoading(context);
    // }
    // if (_entity != null) {
    //   if (_entity!.isLivePhoto || _entity!.type == AssetType.image) {
    //     return const Text('Image');
    //   }
    //   return const Text('Video');
    // }
    // return const Text('Unable to load asset');
//     return Stack(alignment: Alignment.center,
//         children: [
//       FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the VideoPlayerController has finished initialization, use
//             // the data it provides to limit the aspect ratio of the video.
//             return AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               // Use the VideoPlayer widget to display the video.
//               child: Card(
//                 semanticContainer: true,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 5,
//                 margin: const EdgeInsets.all(10),
//                 child: VideoPlayer(_controller),
//               ),
//             );
//           } else {
//             // If the VideoPlayerController is still initializing, show a
//             // loading spinner.
//             return Card(
//               semanticContainer: true,
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               elevation: 5,
//               margin: const EdgeInsets.all(10),
//               child: const Center(child: CircularProgressIndicator()),
//             );
//           }
//         },
//       ),
//           FloatingActionButton(
//             backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
//             onPressed: () {
//               // Wrap the play or pause in a call to `setState`. This ensures the
//               // correct icon is shown.
//               setState(() {
//                 // If the video is playing, pause it.
//                 if (_controller.value.isPlaying) {
//                   _controller.pause();
//                 } else {
//                   // If the video is paused, play it.
//                   _controller.play();
//                 }
//               });
//             },
//             // Display the correct icon depending on the state of the player.
//             child: Icon(
//               _controller.value.isPlaying ? Symbols.pause : Symbols.play_arrow,
//             ),
//           )
//     ]);
  }
}