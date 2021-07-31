import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  static const routeName = "/imageViewerScreen";

  @override
  Widget build(BuildContext context) {
    final file = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Preview"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InteractiveViewer(
            child: Image.file(
              file,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
