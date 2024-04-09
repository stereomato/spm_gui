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
  bool passphraseGenerated = false;
  bool passphraseSaved = false;

  void reset() {
    _typoify = false;
    _randomizeSeparators = false;
    _length = 1;
    _passphrase = 'Not yet generated';
    _hidePassphrase = false;
    _name = "Not yet named";
    passphraseSaved = false;
    passphraseGenerated = false;
    notifyListeners();
  }

  void savedPassphrase() {
    passphraseSaved = true;
    notifyListeners();
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
    passphraseGenerated = true;
    notifyListeners();
  }

// FIXME: update to be in line with getVaultPassphrase()
// FIXME: perhaps a bit ugly, reconsider?
// if it's for the copy button it's always returned unobscured, otherwise its visibility can be toggled
  String getGeneratorPassphrase(bool forCopyButton) {
    if (forCopyButton) {
      return _passphrase;
    } else {
      switch (_hidePassphrase) {
        case true:
          return _passphrase.replaceAll(RegExp(r'[^]'), '*');
        case false:
          return _passphrase;
      }
    }
  }

  void togglePassphraseVisibility() {
    _hidePassphrase = !_hidePassphrase;
    notifyListeners();
  }

  bool getPassphraseVisibility() {
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

  // for the deletion mode
  bool deletionMode = false;
  List<String> deletionList = [];

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
  // FIXME: need to rethink how to handle obscuring this one
  // If it's for the copy button, always return the passphrase unobscured
  // if it's for anything else (such as the text box displaying it), let it be returned either obscured or unobscured
  String getVaultPassphrase(String name, bool forCopyButton) {
    var passphraseProperties = getEntries()[name] as Map<bool, String>;
    var visibility = passphraseProperties.keys.toList().first;
    var passphrase = passphraseProperties[visibility] as String;

    if (forCopyButton) {
      return passphrase;
    } else {
      switch (visibility) {
        case true:
          return passphrase;
        case false:
          return passphrase.replaceAll(RegExp(r'[^]'), '*');
      }
    }
  }

  void toggleDeletionMode() {
    deletionMode = !deletionMode;
    notifyListeners();
  }

  bool getDeletionMode() {
    return deletionMode;
  }

  void addEntriesToDeletionList(String name) {
    deletionList.add(name);
  }

  // If an entry's name is in the list, remove it, otherwise add it.
  // Because of the toggling
  void modifyDeletionList(String name) {
    if (deletionList.contains(name)) {
      deletionList.remove(name);
    } else {
      deletionList.add(name);
    }
  }

  List<String> getDeletionList() {
    return deletionList;
  }

  bool isDeletionListEmpty() {
    return deletionList.isEmpty;
  }

// Delete each entry in the deletionList from the _entries hashmap
  void deleteEntries() {
    for (var entryToDelete in deletionList) {
      _entries.remove(entryToDelete);
    }
    // also, empty the deletionList
    deletionList.clear;
    notifyListeners();
  }
}
