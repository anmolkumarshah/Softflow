import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:softflow_app/Providers/main_provider.dart';
import 'dart:io';

import 'package:softflow_app/Screens/image_viewer_screen.dart';

class CaptureImage extends StatefulWidget {
  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  late List<XFile> _image = [];
  final ImagePicker _picker = ImagePicker();
  late bool _isTaken = false;

  getImage(BuildContext context) async {
    var image = (await _picker.pickImage(source: ImageSource.camera))!;
    List<XFile> temp = [..._image];
    temp.add(image);
    Provider.of<MainProvider>(context, listen: false).setFirst(temp);
    setState(() {
      _image = temp;
      _isTaken = true;
    });
  }

  reset() {
    List<XFile> temp = [];
    Provider.of<MainProvider>(context, listen: false).setFirst(temp);
    setState(() {
      _isTaken = false;
      _image = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: _isTaken
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text("Heading Here"),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: (120 * ((_image.length + 1) / 2).floorToDouble()),
                  child: GridView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ImageViewerScreen.routeName,
                            arguments: File(_image[index].path),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1,
                            ),
                          ),
                          child: Image.file(
                            File(_image[index].path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _image.length,
                  ),
                ),
                Row(
                  children: [

                    ElevatedButton(
                      child: Text(_image.length > 0 ? "Add More" : "Capture"),
                      onPressed: () => getImage(context),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      child: Text("Reset"),
                      onPressed: reset,
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Capture Image"),
                  onPressed: () => getImage(context),
                )
              ],
            ),
    );
  }
}
