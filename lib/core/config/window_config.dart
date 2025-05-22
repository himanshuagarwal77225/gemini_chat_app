import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart' as window_size;

/// Configures the window size and properties for desktop platforms.
void configureWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();

    // Set minimum window size
    window_size.setWindowMinSize(const Size(400, 600));

    // Set default window size
    window_size.setWindowMinSize(const Size(800, 700));

    // Center the window on the screen
    window_size.getCurrentScreen().then((screen) {
      if (screen != null) {
        final screenFrame = screen.visibleFrame;
        const windowSize = Size(800, 700);

        final left =
            ((screenFrame.width - windowSize.width) / 2).roundToDouble();
        final top =
            ((screenFrame.height - windowSize.height) / 2).roundToDouble();

        window_size.setWindowFrame(
          Rect.fromLTWH(left, top, windowSize.width, windowSize.height),
        );
      }
    });
  }
}
