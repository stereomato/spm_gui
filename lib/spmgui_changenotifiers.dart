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
  String _name = "Not yet named";

  void reset() {
    _typoify = false;
    _randomizeSeparators = false;
    _length = 1;
    _passphrase = 'Not yet generated';
    _hidePassphrase = false;
    _name = "Not yet named";
  }

  void toggleTypoify(bool value) {
    _typoify = value;
    notifyListeners();
  }

  bool getTypoify() {
    return _typoify;
  }

  void toggleRandomizeSeparators(bool value) {
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

  void setPassphrase(String value) {
    _passphrase = value;
    notifyListeners();
  }

  String getPassphrase() {
    switch (_hidePassphrase) {
      case true:
        return _passphrase.replaceAll(RegExp(r'[^]'), '*');
      case false:
        return _passphrase;
    }
  }

  void togglePassphraseVisibility() {
    _hidePassphrase = !_hidePassphrase;
    notifyListeners();
  }

  bool getHidePassphrase() {
    return _hidePassphrase;
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  String getName() {
    return _name;
  }
}

class SPMvaultHandler with ChangeNotifier {
  // values to add, remove or search for an entry
  String _name = '';
  String _passphrase = '';

  // name: visibility: passphrase
  final Map<String, Map<bool, String>> _entries = {
    'name': {true: 'passphrase'}
  };

  void setPassphrase(String value) {
    _passphrase = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  String getName() {
    return _name;
  }

  void addEntry(String name, String passphrase) {
    _entries[name] = {false: passphrase};
    notifyListeners();
  }

  Map<String, Map<bool, String>> getEntries() {
    return _entries;
  }

  // getting names
  List<String> getEntryNames() {
    return getEntries().keys.toList();
  }

  void togglePassphraseVisibility(String name) {
    var passphraseProperties = getEntries();
    var visibility = passphraseProperties[name]!.keys.toList().first;
    var passphrase = passphraseProperties[name]![visibility] as String;
    passphraseProperties.update(name, (value) => {!visibility: passphrase});
    notifyListeners();
  }

  // getting passphrase
  String getPassphrase(String name) {
    var passphraseProperties = getEntries()[name] as Map<bool, String>;
    var visibility = passphraseProperties.keys.toList().first;
    var passphrase = passphraseProperties[visibility] as String;

    switch (visibility) {
      case true:
        return passphrase;
      case false:
        return passphrase.replaceAll(RegExp(r'[^]'), '*');
    }
  }
}
