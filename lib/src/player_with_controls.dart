import 'package:chewie/src/chewie_player.dart';
import 'package:chewie/src/helpers/adaptive_controls.dart';
import 'package:chewie/src/notifiers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PlayerWithControls extends StatelessWidget {
  final TargetPlatform? platform;
  final Widget? playNext;
  final Widget? playPrevious;
  PlayerWithControls(
      {Key? key, this.platform, this.playNext, this.playPrevious})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    double _calculateAspectRatio(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;

      return width > height ? width / height : height / width;
    }

    Widget _buildControls(
      BuildContext context,
      ChewieController chewieController,
      TargetPlatform platform,
      Widget? playNext,
      Widget? playPrevious,
    ) {
      return chewieController.showControls
          ? chewieController.customControls ??
              AdaptiveControls(
                platform: platform,
                playPrevious: playPrevious ?? SizedBox(),
                playNext: playNext ?? SizedBox(),
              )
          : Container();
    }

    Widget _buildPlayerWithControls(
      ChewieController chewieController,
      BuildContext context,
      TargetPlatform platform,
      Widget? playNext,
      Widget? playPrevious,
    ) {
      return Stack(
        children: <Widget>[
          if (chewieController.placeholder != null)
            chewieController.placeholder!,
          Center(
            child: AspectRatio(
              aspectRatio: chewieController.aspectRatio ??
                  chewieController.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(chewieController.videoPlayerController),
            ),
          ),
          if (chewieController.overlay != null) chewieController.overlay!,
          if (Theme.of(context).platform != TargetPlatform.iOS)
            Consumer<PlayerNotifier>(
              builder: (
                BuildContext context,
                PlayerNotifier notifier,
                Widget? widget,
              ) =>
                  AnimatedOpacity(
                opacity: notifier.hideStuff ? 0.0 : 0.8,
                duration: const Duration(
                  milliseconds: 250,
                ),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: Container(),
                ),
              ),
            ),
          if (!chewieController.isFullScreen)
            _buildControls(
                context, chewieController, platform, playNext, playPrevious)
          else
            SafeArea(
              bottom: false,
              child: _buildControls(
                  context, chewieController, platform, playNext, playPrevious),
            ),
        ],
      );
    }

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: _calculateAspectRatio(context),
          child: _buildPlayerWithControls(
              chewieController, context, platform!, playNext, playPrevious),
        ),
      ),
    );
  }
}