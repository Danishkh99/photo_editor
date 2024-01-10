import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_collage_widget/image_collage_widget.dart';
import 'package:image_collage_widget/model/college_type.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

Widget photoCollage(BuildContext context) {
  pushImageWidget(CollageType type) async {
    await Navigator.of(context).push(
      FadeRouteTransition(page: CollageSample(type)),
    );
  }

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  }

  Widget buildRaisedButton(CollageType collageType, String text) {
    return ElevatedButton(
      onPressed: () => pushImageWidget(collageType),
      style: ElevatedButton.styleFrom(
          shape: buttonShape(), backgroundColor: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  ///Create multple shapes
  return Center(
      child: ListView(
    padding: const EdgeInsets.all(16.0),
    shrinkWrap: true,
    children: <Widget>[
      buildRaisedButton(CollageType.vSplit, 'Vsplit'),
      buildRaisedButton(CollageType.hSplit, 'HSplit'),
      buildRaisedButton(CollageType.fourSquare, 'FourSquare'),
      buildRaisedButton(CollageType.nineSquare, 'NineSquare'),
      buildRaisedButton(CollageType.threeVertical, 'ThreeVertical'),
      buildRaisedButton(CollageType.threeHorizontal, 'ThreeHorizontal'),
      buildRaisedButton(CollageType.leftBig, 'LeftBig'),
      buildRaisedButton(CollageType.rightBig, 'RightBig'),
      buildRaisedButton(CollageType.fourLeftBig, 'FourLeftBig'),
      buildRaisedButton(CollageType.vMiddleTwo, 'VMiddleTwo'),
      buildRaisedButton(CollageType.centerBig, 'CenterBig'),
    ],
  ));

  ///On click of perticular type of button show that type of widget
}

class FadeRouteTransition extends PageRouteBuilder {
  final Widget page;

  FadeRouteTransition({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class CollageSample extends StatefulWidget {
  final CollageType collageType;

  const CollageSample(this.collageType, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _CollageSample();
  }
}

class _CollageSample extends State<CollageSample> {
  final GlobalKey _screenshotKey = GlobalKey();
  bool _startLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            "Collage maker",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () => _capturePng(),
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(
                  child: Icon(
                    Icons.share,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _saveLocalImage(),
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(
                  child: Icon(
                    Icons.download,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ]),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepOrange])),
        child: Stack(
          children: [
            RepaintBoundary(
              key: _screenshotKey,

              /// @param withImage:- If withImage = true, It will load image from given {filePath (default = "Camera")}
              /// @param collageType:- CollageType.CenterBig

              child: ImageCollageWidget(
                collageType: widget.collageType,
                withImage: true,
              ),
            ),
            if (_startLoading)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const IgnorePointer(
                  ignoring: true,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  /// call this method to share file
  _shareScreenShot(String imgpath) async {
    setState(() {
      _startLoading = false;
    });
    try {
      Share.shareFiles([imgpath]);
    } on PlatformException catch (e) {
      log('Platform Exception: $e');
    } catch (e) {
      log('Exception: $e');
    }
  }

  _saveLocalImage() async {
    RenderRepaintBoundary? boundary = _screenshotKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    await Future.delayed(const Duration(milliseconds: 2000));
    Directory dir;

    if (Platform.isIOS) {
      ///For iOS
      dir = await getApplicationDocumentsDirectory();
    } else {
      ///For Android
      dir = (await getExternalStorageDirectory())!;
    }
    var image = await boundary?.toImage();
    ByteData? byteData =
        await (image?.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      Fluttertoast.showToast(msg: "Photo saved");
    }
  }

  ///Used for capture screenshot
  Future<Uint8List> _capturePng() async {
    try {
      setState(() {
        _startLoading = true;
      });
      Directory dir;
      RenderRepaintBoundary? boundary = _screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      await Future.delayed(const Duration(milliseconds: 2000));
      if (Platform.isIOS) {
        ///For iOS
        dir = await getApplicationDocumentsDirectory();
      } else {
        ///For Android
        dir = (await getExternalStorageDirectory())!;
      }
      var image = await boundary?.toImage();
      var byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      File screenshotImageFile =
          File('${dir.path}/${DateTime.now().microsecondsSinceEpoch}.png');
      await screenshotImageFile.writeAsBytes(byteData!.buffer.asUint8List());
      _shareScreenShot(screenshotImageFile.path);
      return byteData.buffer.asUint8List();
    } catch (e) {
      setState(() {
        _startLoading = false;
      });
      if (kDebugMode) {
        print("Capture Image Exception Main : $e");
      }
      throw Exception();
    }
  }
}
