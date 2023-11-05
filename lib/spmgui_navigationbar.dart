import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'spmgui_changenotifiers.dart';

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
          Provider.of<SPMpageHandler>(context, listen: false)
              .switchPage(currentPageIndex);
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
