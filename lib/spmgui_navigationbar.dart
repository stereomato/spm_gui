import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'spmgui_changenotifiers.dart';

class SPMguiNavigationBar extends StatefulWidget {
  const SPMguiNavigationBar({super.key});
  @override
  State<SPMguiNavigationBar> createState() => _SPMguiNavigationBarState();
}

class _SPMguiNavigationBarState extends State<SPMguiNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SPMpageHandler>(
      builder: (context, page, child) => NavigationBar(
        // update index as user changes it
        onDestinationSelected: (int index) {
          setState(() {
            Provider.of<SPMpageHandler>(context, listen: false)
                .switchPage(index);
            Provider.of<SPMgeneratorHandler>(context, listen: false).reset();
          });
        },
        selectedIndex: page.currentPage,
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
      ),
    )
        /**/
        ;
  }
}
