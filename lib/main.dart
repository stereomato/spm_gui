import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spm_dart/spm_dart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SPMPageHandler(),
      child: const SPMgui(),
    ),
  );
}

class SPMPageHandler with ChangeNotifier {
  int currentPage = 0;

  void switchPage(int value) {
    currentPage = value;
    notifyListeners();
  }
}

class SPMgui extends StatefulWidget {
  const SPMgui({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<SPMgui> createState() => _SPMguiScreen();
}

class _SPMguiScreen extends State<SPMgui> {
  // For the navigationBar
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Simple Passphrase Manager'),
        ),
        // Here we switch between the page setup

        body: Consumer<SPMPageHandler>(
            builder: (context, value, child) => switch (value.currentPage) {
                  0 => SPMguiGeneratorPage(),
                  1 => Text('To be built'),
                  _ => Text('whoops'),
                }),
        bottomNavigationBar: const SPMguiNavigationBar(),
      ),
    );
  }
}

class SPMguiGeneratorPage extends StatefulWidget {
  const SPMguiGeneratorPage({super.key});

  @override
  State<SPMguiGeneratorPage> createState() => _SPMguiGeneratorPageState();
}

// For the time being lets treat this as the main view...

class _SPMguiGeneratorPageState extends State<SPMguiGeneratorPage> {
  // UI Code

  // Code for the passphrase generation
  int _length = 1;
  bool _typoify = false;
  bool _randomizeSeparators = false;

  void _onTypoifyChanged(bool value) {
    setState(() {
      _typoify = value;
    });
  }

  void _onRandomizeSeparatorsChanged(bool value) {
    setState(() {
      _randomizeSeparators = value;
    });
  }

  void _updateLength(int value) {
    setState(() {
      _length = value;
    });
  }

  String _passphrase = "Not even once yet...";
  var random = Random();
  void _generatePassphrase() async {
    // TODO: add a button to copy this to the clipboard
    _passphrase = await constructPassphrase(
        _length, _randomizeSeparators, _typoify, "dictionary.txt");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: <Widget>[
        SwitchListTile(
            title: const Text(
              'Typoification',
            ),
            value: _typoify,
            onChanged: _onTypoifyChanged),
        SwitchListTile(
            title: const Text(
              'Randomized separators',
            ),
            value: _randomizeSeparators,
            onChanged: _onRandomizeSeparatorsChanged),
        ListTile(
          title: const Text('Number of words'),
          trailing: SizedBox(
            width: 250,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Length',
              ),
              onSubmitted: (value) => _updateLength(int.parse(value)),
            ),
          ),
        ),
        ListTile(
          title: const Text('Generated passphrase'),
          trailing: SizedBox(
            width: 250,
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: _passphrase,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/*
          floatingActionButton: FloatingActionButton(
            onPressed: _generatePassphrase,
            tooltip: 'Generate a passphrase with the defined settings above',
            child: const Icon(Icons.autorenew),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
          bottomNavigationBar: const SPMguiNavigationBar()),*/

class SPMguiNavigationBar extends StatefulWidget {
  const SPMguiNavigationBar({super.key});
  @override
  State<SPMguiNavigationBar> createState() => _SPMguiNavigationBarState();
}

class _SPMguiNavigationBarState extends State<SPMguiNavigationBar> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      // update index as user changes it
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
          var switcher = context.read<SPMPageHandler>();
          switcher.switchPage(currentPageIndex);
        });
      },
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.settings),
          label: 'Generate',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2),
          label: 'Vault',
        ),
      ],
    );
  }
}





// Not really wanted anymore
/*
class SPMguiBottomAppBar extends StatelessWidget {
  const SPMguiBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blueAccent,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save_alt),
              tooltip: 'Save generated passphrase',
            )
          ],
        ),
      ),
    );
  }
}
*/