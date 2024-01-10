import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_app/Providers/image_path_provider.dart';
import 'package:image_editor_app/Providers/screen_provider.dart';
import 'package:image_editor_app/Views/edit_photo.dart';
import 'package:image_editor_app/Views/photo_collage.dart';
import 'package:image_editor_app/Views/remove_background.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider1 = Provider.of<ScreenProvider>(context);
//ImagePathProvider
    return Consumer<ImagePathProvider>(
        builder: (context, path, _) => Consumer<ScreenProvider>(
            builder: (context, screen, _) => PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  if (screen.getPage == 0) {
                    SystemNavigator.pop();

                    return;
                  }
                  if (screen.getPage != 0) {
                    screen.setPage(0);
                    path.setPath(null);
                  }
                  // if (screen.getPage == 0) Navigator.of(context).pop();
                },
                // canPop: true,
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    titleTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                    title: const Text("Photo Editor"),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    leading: screen.getPage != 0
                        ? GestureDetector(
                            onTap: () {
                              screen.setPage(0);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))
                        : Container(),
                  ),
                  body: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.purpleAccent,
                        Colors.deepOrange
                      ])),
                      child: Center(
                        child: screen.getPage == 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        screen.setPage(1);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.orangeAccent)),
                                      child: const Text(
                                        "Edit Your Photo",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        screen.setPage(2);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.orangeAccent)),
                                      child: const Text(
                                        "Make Photo Collage",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RemoveBackground()));
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.orangeAccent)),
                                      child: const Text(
                                        "Remove Photo Background",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
                            : screen.getPage == 1
                                ? editPhoto(context)
                                : screen.getPage == 2
                                    ? photoCollage(context)
                                    : Container(),
                      )),
                ))));
  }
}
