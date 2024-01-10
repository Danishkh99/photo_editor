import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_photo_editor/flutter_photo_editor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_editor_app/Providers/image_path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

Widget editPhoto(BuildContext context) {
  final provider1 = Provider.of<ImagePathProvider>(context);

  void editImage(String path) async {
    print("path: $path");

    var b = await FlutterPhotoEditor().editImage(path);

    provider1.setPath(path);

    print("end : $b");
  }

  void gallery() async {
    print("start");

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    String? path = image?.path;
    // onImageEdit(path);
    if (path != null) {
      editImage(path);
    }
  }

  void openCamera() async {
    print("start");

    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    String? path = image?.path;
    // onImageEdit(path);
    if (path != null) {
      editImage(path);
    }
  }

  void saveImage() async {
    print("Saving Image");

    if (provider1.getPath != null) {
      await ImageGallerySaver.saveFile(provider1.getPath!);
      Fluttertoast.showToast(
          msg: "Image saved in the gallery",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orangeAccent)),
          onPressed: () {
            showModalBottomSheet<void>(
                // context and builder are
                // required properties in this widget
                context: context,
                builder: (BuildContext context) {
                  // we set up a container inside which
                  // we create center column and display text

                  // Returning SizedBox instead of a Container
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.camera_alt_outlined),
                            title: const Text("Camera"),
                            onTap: () {
                              Navigator.pop(context);
                              openCamera();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_album),
                            title: const Text("Gallery"),
                            onTap: () {
                              Navigator.pop(context);
                              gallery();
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
            // test();
          },
          child: const Text(
            "Add photo",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      if (provider1.getPath != null)
        Image.file(
          File(provider1.getPath!),
          width: 300,
          height: 500,
        ),
      if (provider1.getPath != null)
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: () {
              saveImage();
            },
            child: const Text("Save photo"),
          ),
        ),
    ],
  );
}
