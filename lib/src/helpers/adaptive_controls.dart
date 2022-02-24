import 'package:chewie/chewie.dart';
import 'package:chewie/src/material/material_desktop_controls.dart';
import 'package:flutter/material.dart';

class AdaptiveControls extends StatelessWidget {
  TargetPlatform? platform;
  final Widget? playNext;
  final Widget? playPrevious;
  AdaptiveControls({Key? key, this.platform, this.playPrevious, this.playNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (platform == null) {
      platform = TargetPlatform.windows;
    }
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return const MaterialControls();

      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return MaterialDesktopControls(
          playNext: playNext,
          playPrevious: playPrevious,
        );

      case TargetPlatform.iOS:
        return const CupertinoControls(
          backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
          iconColor: Color.fromARGB(255, 200, 200, 200),
        );
      default:
        return const MaterialControls();
    }
  }
}
