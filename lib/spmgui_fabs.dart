import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spm_dart/spm_dart.dart';
import 'spmgui_changenotifiers.dart';

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
  String _passphrase = 'Not yet generated [FAB edition]';
  void _generatePassphraseWrapped() async {
    // TODO: add a button to copy this to the clipboard
    _passphrase = await constructPassphrase(widget.length,
        widget.randomizeSeparators, widget.typoify, "dictionary.txt");

    if (context.mounted) {
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .updatePassphrase(_passphrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _generatePassphraseWrapped,
      tooltip: 'Generate a passphrase with the defined settings above',
      child: const Icon(Icons.autorenew),
    );
  }
}
