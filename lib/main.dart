import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'spmgui_navigationbar.dart';
import 'spmgui_pages.dart';
import 'spmgui_buttons.dart';
import 'spmgui_changenotifiers.dart';

// FIXME: adopt a style for naming variables and functions!

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
      // For the vault page
      ChangeNotifierProvider<SPMvaultHandler>(
        create: (context) => SPMvaultHandler(),
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
        // Here we switch between the pages
        body: Consumer<SPMpageHandler>(
            builder: (context, value, child) => switch (value.currentPage) {
                  0 => const SPMguiGeneratorPage(),
                  1 => const SPMguiVaultPage(),
                  _ => const Text('whoops'),
                }),

        bottomNavigationBar: const SPMguiNavigationBar(),
        // FAB handling
        // (this) first Consumer is for determining what FAB the app should show
        floatingActionButton: Consumer<SPMpageHandler>(
            builder: (context, value, child) => switch (value.currentPage) {
                  // (this) second Consumer is for determining whether to show
                  // the save FAB (unsaved changes indicator, basically)
                  0 => Consumer<SPMgeneratorHandler>(
                      builder: ((context, value, child) =>
                          switch (value.passphraseGenerated) {
                            true => const SPMguiGeneratorPageSaveFAB(),
                            false => const SizedBox.shrink(),
                          })),
                  1 => Consumer<SPMvaultHandler>(
                      builder: ((context, value, child) =>
                          switch (value.areEntriesEmpty()) {
                            true => const SizedBox.shrink(),
                            false => const SPMguiVaultPageDeleteFAB(),
                          })),
                  _ => const Text('whoops'),
                }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
