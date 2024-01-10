import 'package:flutter/cupertino.dart';

class ScreenProvider extends ChangeNotifier {
  int _page = 0;

  int get getPage => _page;

  void setPage(int pageNum) {
    _page = pageNum;
    notifyListeners();
  }
}
