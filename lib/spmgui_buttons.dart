import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'spmgui_changenotifiers.dart';
import 'package:spm_dart/spm_dart.dart';

// FIXME: try to turn most widgets into stateless ones

// FIXME: try to use provider stuff more instead of just receiving stuff thru widget variables and the like

class SPMguiButtonCopyCliboard extends StatelessWidget {
  const SPMguiButtonCopyCliboard(
      {super.key, required this.page, required this.name});
  final int page;
  final String name;

  @override
  Widget build(BuildContext context) {
    void onCopyToClipboardButtonPressed() {
      String generatedPassphrase = '';
      switch (page) {
        // generator page
        case 0:
          generatedPassphrase =
              Provider.of<SPMgeneratorHandler>(context, listen: false)
                  .getGeneratorPassphrase(true);
          break;

        case 1:
          generatedPassphrase =
              Provider.of<SPMvaultHandler>(context, listen: false)
                  .getVaultPassphrase(name, true);
          break;
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Copied to clipboard.")));
      }
    }

    return FilledButton.tonal(
      onPressed: onCopyToClipboardButtonPressed,
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
  Icon _forTheHideButton = const Icon(Icons.visibility);
  //bool _obscurePassphrase = false;
  void _onHidePassphraseButtonPressed() {
    setState(() {
      switch (_forTheHideButton) {
        case Icon(icon: Icons.visibility):
          _forTheHideButton = const Icon(Icons.visibility_off);
          break;
        case Icon(icon: Icons.visibility_off):
          _forTheHideButton = const Icon(Icons.visibility);
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
    return const MaterialApp();
  }
}

class SPMguiGeneratePassphraseButton extends StatelessWidget {
  const SPMguiGeneratePassphraseButton(
      {super.key,
      required this.randomizeSeparators,
      required this.typoify,
      required this.length});
  final bool randomizeSeparators;
  final bool typoify;
  final int length;

  @override
  Widget build(BuildContext context) {
    String passphrase = 'Not yet generated [FAB edition]';
    void generatePassphraseWrapped() async {
      passphrase = await constructPassphrase(
          length, randomizeSeparators, typoify, "dictionary.txt");

      if (context.mounted) {
        Provider.of<SPMgeneratorHandler>(context, listen: false)
            .setPassphrase(passphrase);
      }
    }

    return FilledButton.tonal(
      onPressed: generatePassphraseWrapped,
      //tooltip: 'Generate a passphrase with the defined settings above',
      child: const Icon(Icons.autorenew),
    );
  }
}

//TODO: Turn this stateful to make it change icon
class SPMguiGeneratorPageSaveFAB extends StatelessWidget {
  SPMguiGeneratorPageSaveFAB({super.key});

  var fabIcon = Icons.save;

  @override
  Widget build(BuildContext context) {
    void onFABpressed() {
      var name =
          Provider.of<SPMgeneratorHandler>(context, listen: false).getName();
      var generatedPassphrase =
          Provider.of<SPMgeneratorHandler>(context, listen: false)
              .getGeneratorPassphrase(true);
      // FIXME: substitute the right hand by a variable that's called "placeholder"
      // notify the user of the accomplished action, removing any previous snackbar

      if (generatedPassphrase == "Not yet generated") {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        fabIcon = Icons.close;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Nothing to save.")));
      } else {
        fabIcon = Icons.done;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Saved.")));
        Provider.of<SPMvaultHandler>(context, listen: false)
            .addEntry(name, generatedPassphrase);
      }
    }

    return FloatingActionButton(
      onPressed: onFABpressed,
      child: Icon(fabIcon),
    );
  }
}

// I need to have a class that houses the values for the vault page
// array, etc

// This is a WIP. Idk what other kind of FAB to put on the vault page

// When pressed, this would:
// - change the app bar to denote that we are now in deletion mode
// - display checkboxes on the entries of the vault [prototyped]
// - perhaps, do a rotating animation
// - change icon, from trashcan to trashcan filled
// - if pressed with items selected, delete
// - if pressed without items selected, snackbar pops up, saying "Nothing deleted."

class SPMguiVaultPageDeleteFAB extends StatefulWidget {
  const SPMguiVaultPageDeleteFAB({super.key});
  @override
  State<SPMguiVaultPageDeleteFAB> createState() =>
      _SPMguiVaultPageDeleteFABstate();
}

class _SPMguiVaultPageDeleteFABstate extends State<SPMguiVaultPageDeleteFAB> {
  // when the thing is pressed, I want the icon to change to d_f
  // when its pressed again, I want it to change to d
  Icon fabIcon = const Icon(Icons.delete);
  void onFABpressed() {
    // if in deletion mode...
    if (Provider.of<SPMvaultHandler>(context, listen: false)
        .getDeletionMode()) {
      // see if the list is empty or not
      switch (Provider.of<SPMvaultHandler>(context, listen: false)
          .isDeletionListEmpty()) {
        // the list is empty, might either do nothing (display snackbar) or
        case true:
          //FIXME: create a function to show snackbars, saving myself having
          // to write these two lines.
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Nothing to delete.")));
          break;
        // the list is not empty, so, delete
        case false:
          Provider.of<SPMvaultHandler>(context, listen: false).deleteEntries();
          break;
      }
    }

    // send signal that we have been tapped and are either entering or exiting
    // deletion mode
    Provider.of<SPMvaultHandler>(context, listen: false).toggleDeletionMode();
    // change icon
    setState(() {
      switch (fabIcon) {
        case Icon(icon: Icons.delete):
          fabIcon = const Icon(Icons.delete_forever);
          break;

        case Icon(icon: Icons.delete_forever):
          fabIcon = const Icon(Icons.delete);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: onFABpressed, child: fabIcon);
  }
}
