import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'spmgui_navigationbar.dart';
import 'spmgui_pages.dart';
import 'spmgui_fabs.dart';
import 'spmgui_changenotifiers.dart';

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
        floatingActionButton: Consumer<SPMpageHandler>(
            builder: (context, value, child) => switch (value.currentPage) {
                  0 => SPMguiGeneratorPageFAB(
                      randomizeSeparators:
                          Provider.of<SPMgeneratorHandler>(context)
                              .getRandomizeSeparators(),
                      typoify: Provider.of<SPMgeneratorHandler>(context)
                          .getTypoify(),
                      length:
                          Provider.of<SPMgeneratorHandler>(context).getLength(),
                    ),
                  1 => Text('To be built'),
                  _ => Text('whoops'),
                }),
      ),
    );
  }
}
