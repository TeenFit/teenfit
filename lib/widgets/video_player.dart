import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File? videofile;

  const VideoPlayerWidget({
    Key? key,
    required this.videofile,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? controller;

  @override
  void didChangeDependencies() {
    if (widget.videofile != null && widget.videofile!.existsSync()) {
      controller = VideoPlayerController.file(widget.videofile!)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => controller!.play());
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      controller != null && controller!.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Container(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: VideoPlayer(controller!),
      );
}
