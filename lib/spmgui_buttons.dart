import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'spmgui_changenotifiers.dart';
import 'package:spm_dart/spm_dart.dart';

// FIXME: try to turn most widgets into stateless ones

// FIXME: try to use provider stuff more instead of just receiving stuff thru widget variables and the like
class SPMguiButtonCopyCliboard extends StatefulWidget {
  const SPMguiButtonCopyCliboard(
      {super.key, required this.page, required this.name});
  final int page;
  final String name;

  @override
  State<SPMguiButtonCopyCliboard> createState() =>
      _SPMguiButtonCopyClipboardState();
}

// FIXME: getting the passphrase obscured and copying it, copies the obscuring characters....
class _SPMguiButtonCopyClipboardState extends State<SPMguiButtonCopyCliboard> {
  void _onCopyToClipboardButtonPressed() {
    // TODO: display a toast saying "nothing to copy" when the passphrase is empty
    String generatedPassphrase = '';
    switch (widget.page) {
      // generator page
      case 0:
        generatedPassphrase =
            Provider.of<SPMgeneratorHandler>(context, listen: false)
                .getPassphrase();
        break;

      case 1:
        generatedPassphrase =
            Provider.of<SPMvaultHandler>(context, listen: false)
                .getPassphrase(widget.name);
        break;
      default:
    }

    // FIXME: replace the right hand by a placeholder variable
    // shows snackbar notifying user of the accomplished action, removing any previous snackbar
    if (generatedPassphrase == "Not yet generated") {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nothing to copy to clipboard.")));
    } else {
      Clipboard.setData(ClipboardData(text: generatedPassphrase));
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Copied to clipboard.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: _onCopyToClipboardButtonPressed,
      child: const Icon(Icons.content_copy),
    );
  }
}

// i think we don't actually need an index
class SPMguitogglePassphraseVisibilityButton extends StatefulWidget {
  const SPMguitogglePassphraseVisibilityButton(
      {super.key, required this.page, required this.name});
  final int page;
  final String name;
  @override
  State<SPMguitogglePassphraseVisibilityButton> createState() =>
      _SPMguitogglePassphraseVisibilityButtonState();
}

class _SPMguitogglePassphraseVisibilityButtonState
    extends State<SPMguitogglePassphraseVisibilityButton> {
  Icon _forTheHideButton = Icon(Icons.visibility);
  //bool _obscurePassphrase = false;
  void _onHidePassphraseButtonPressed() {
    setState(() {
      switch (_forTheHideButton) {
        case Icon(icon: Icons.visibility):
          _forTheHideButton = Icon(Icons.visibility_off);
          break;
        case Icon(icon: Icons.visibility_off):
          _forTheHideButton = Icon(Icons.visibility);
          break;
        default:
      }
      switch (widget.page) {
        case 0:
          Provider.of<SPMgeneratorHandler>(context, listen: false)
              .togglePassphraseVisibility();
          break;
        case 1:
          Provider.of<SPMvaultHandler>(context, listen: false)
              .togglePassphraseVisibility(widget.name);
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: _onHidePassphraseButtonPressed, child: _forTheHideButton);
  }
}

// TODO: Make this button actual work lol
class SPMguiEditButton extends StatefulWidget {
  const SPMguiEditButton({super.key});

  @override
  State<SPMguiEditButton> createState() => _SPMguiEditButtonState();
}

class _SPMguiEditButtonState extends State<SPMguiEditButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class SPMguiGeneratePassphraseButton extends StatefulWidget {
  const SPMguiGeneratePassphraseButton(
      {super.key,
      required this.randomizeSeparators,
      required this.typoify,
      required this.length});
  final bool randomizeSeparators;
  final bool typoify;
  final int length;

  @override
  State<SPMguiGeneratePassphraseButton> createState() =>
      _SPMguiGeneratePassphraseButtonState();
}

class _SPMguiGeneratePassphraseButtonState
    extends State<SPMguiGeneratePassphraseButton> {
  String _passphrase = 'Not yet generated [FAB edition]';
  void _generatePassphraseWrapped() async {
    // TODO: add a button to copy this to the clipboard
    _passphrase = await constructPassphrase(widget.length,
        widget.randomizeSeparators, widget.typoify, "dictionary.txt");

    if (context.mounted) {
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .setPassphrase(_passphrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: _generatePassphraseWrapped,
      //tooltip: 'Generate a passphrase with the defined settings above',
      child: const Icon(Icons.autorenew),
    );
  }
}

class SPMguiGeneratorPageSaveFAB extends StatelessWidget {
  const SPMguiGeneratorPageSaveFAB({super.key});

  @override
  Widget build(BuildContext context) {
    void _onFABpressed() {
      var name =
          Provider.of<SPMgeneratorHandler>(context, listen: false).getName();
      var generatedPassphrase =
          Provider.of<SPMgeneratorHandler>(context, listen: false)
              .getPassphrase();
      // FIXME: substitute the right hand by a variable that's called "placeholder"
      // notify the user of the accomplished action, removing any previous snackbar

      if (generatedPassphrase == "Not yet generated") {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Nothing to save.")));
      } else {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Saved.")));
        Provider.of<SPMvaultHandler>(context, listen: false)
            .addEntry(name, generatedPassphrase);
      }
    }

    return FloatingActionButton(
      onPressed: _onFABpressed,
      child: const Icon(Icons.save),
    );
  }
}

// I need to have a class that houses the values for the vault page
// array, etc


