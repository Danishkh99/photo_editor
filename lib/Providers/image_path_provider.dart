import 'package:flutter/cupertino.dart';

class ImagePathProvider extends ChangeNotifier {
  String? _path = null;

  get getPath => _path;

  void setPath(String? newPath) {
    _path = newPath;
    notifyListeners();
  }
}
