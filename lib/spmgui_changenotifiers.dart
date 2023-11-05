import 'package:flutter/material.dart';

class SPMpageHandler with ChangeNotifier {
  int currentPage = 0;

  void switchPage(int value) {
    currentPage = value;
    notifyListeners();
  }
}

class SPMgeneratorHandler with ChangeNotifier {
  bool _typoify = false;
  bool _randomizeSeparators = false;
  int _length = 1;
  String _passphrase = 'Not yet generated';
  bool _hidePassphrase = false;

  void updateTypoify(bool value) {
    _typoify = value;
    notifyListeners();
  }

  bool getTypoify() {
    return _typoify;
  }

  void updateRandomizeSeparators(bool value) {
    _randomizeSeparators = value;
    notifyListeners();
  }

  bool getRandomizeSeparators() {
    return _randomizeSeparators;
  }

  void updateLength(int value) {
    _length = value;
    notifyListeners();
  }

  int getLength() {
    return _length;
  }

  void updatePassphrase(String value) {
    _passphrase = value;
    notifyListeners();
  }

  String getPassphrase(bool hide) {
    switch (hide) {
      case true:
        return _passphrase.replaceAll(RegExp(r'[^]'), '*');
      case false:
        return _passphrase;
    }
  }

  void toggleHiddenPassphrase(bool value) {
    _hidePassphrase = value;
    notifyListeners();
  }

  bool getHidePassphrase() {
    return _hidePassphrase;
  }
}
