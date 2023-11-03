import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spm_dart/spm_dart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      // For the page changing
      ChangeNotifierProvider<SPMpageHandler>(
        create: (context) => SPMpageHandler(),
      ),
      // For the passphrase generator page
      ChangeNotifierProvider<SPMgeneratorHandler>(
        create: (context) => SPMgeneratorHandler(),
      ),
    ],
    child: const SPMgui(),
  ));
}

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
  String _passphrase = '';
  void updateTypoify(bool value) {
    _typoify = value;
    notifyListeners();
  }

  void updateRandomizeSeparators(bool value) {
    _randomizeSeparators = value;
    notifyListeners();
  }

  void updateLength(int value) {
    _length = value;
    notifyListeners();
  }

  void updatePassphrase(String value) {
    _passphrase = value;
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

        body: Consumer<SPMpageHandler>(
            builder: (context, value, child) => switch (value.currentPage) {
                  0 => SPMguiGeneratorPage(),
                  1 => Text('To be built'),
                  _ => Text('whoops'),
                }),

        bottomNavigationBar: const SPMguiNavigationBar(),
        // TODO: there's a bug related to this. Changes to the bools or the length of the passphrase only get applied after the 2nd re-generation of the passphrase (aka it takes two clicks on the generate passphrase button to generate a passphrase the way the user wants to)
        floatingActionButton: Consumer<SPMpageHandler>(
            builder: (context, value, child) => switch (value.currentPage) {
                  0 => SPMguiGeneratorPageFAB(
                      randomizeSeparators:
                          Provider.of<SPMgeneratorHandler>(context)
                              ._randomizeSeparators,
                      typoify:
                          Provider.of<SPMgeneratorHandler>(context)._typoify,
                      length: Provider.of<SPMgeneratorHandler>(context)._length,
                    ),
                  1 => Text('To be built'),
                  _ => Text('whoops'),
                }),
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

  // These functions update the UI
  // on the onSubmitted/Changed bits of the widgets we use extra functions to update the values for the generator button

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
            //onChanged: _onTypoifyChanged),
            onChanged: (bool value) {
              _onTypoifyChanged(value);
              var generatorSettings = context.read<SPMgeneratorHandler>();
              generatorSettings.updateTypoify(value);
              print(generatorSettings._typoify);
            }),
        SwitchListTile(
            title: const Text(
              'Randomized separators',
            ),
            value: _randomizeSeparators,
            onChanged: (bool value) {
              _onRandomizeSeparatorsChanged(value);
              var generatorSettings = context.read<SPMgeneratorHandler>();
              generatorSettings.updateRandomizeSeparators(value);
              print(generatorSettings._randomizeSeparators);
            }),
        ListTile(
          title: const Text('Number of words'),
          trailing: SizedBox(
            width: 250,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Length',
              ),
              //onSubmitted: (value) => _updateLength(int.parse(value)),
              onSubmitted: (value) {
                _updateLength(int.parse(value));
                var generatorSettings = context.read<SPMgeneratorHandler>();
                generatorSettings.updateLength(int.parse(value));
                print(generatorSettings._length);
              },
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
                  //labelText: context.read<SPMgeneratorHandler>()._passphrase),
                  labelText:
                      Provider.of<SPMgeneratorHandler>(context)._passphrase),
            ),
          ),
        ),
      ],
    );
  }
}

class SPMguiGeneratorPageFAB extends StatefulWidget {
  const SPMguiGeneratorPageFAB(
      {super.key,
      required this.randomizeSeparators,
      required this.typoify,
      required this.length});
  final bool randomizeSeparators;
  final bool typoify;
  final int length;

  @override
  State<SPMguiGeneratorPageFAB> createState() => _SPMguiGeneratorPageFAB();
}

class _SPMguiGeneratorPageFAB extends State<SPMguiGeneratorPageFAB> {
  String _passphrase = "";
  void _generatePassphrase() async {
    // TODO: add a button to copy this to the clipboard
    _passphrase = await constructPassphrase(widget.length,
        widget.randomizeSeparators, widget.typoify, "dictionary.txt");
    ;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          print("FAB");
          print(widget.length);
          print(widget.randomizeSeparators);
          print(widget.typoify);
          _generatePassphrase();
          var generatorSettings = context.read<SPMgeneratorHandler>();
          generatorSettings.updatePassphrase(_passphrase);
        });
      },
      tooltip: 'Generate a passphrase with the defined settings above',
      child: const Icon(Icons.autorenew),
    );
  }
}

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
          var switcher = context.read<SPMpageHandler>();
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