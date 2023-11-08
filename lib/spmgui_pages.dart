import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'spmgui_changenotifiers.dart';
import 'spmgui_buttons.dart';

// page for the generator
class SPMguiGeneratorPage extends StatefulWidget {
  const SPMguiGeneratorPage({super.key});

  @override
  State<SPMguiGeneratorPage> createState() => _SPMguiGeneratorPageState();
}

// state for the generator
class _SPMguiGeneratorPageState extends State<SPMguiGeneratorPage> {
  // UI Code

  // Code for the passphrase generation

  int _length = 1;
  bool _typoify = false;
  bool _randomizeSeparators = false;
  String _name = '';

  // These functions update the UI
  // on the onSubmitted/Changed bits of the widgets we use extra functions to update the values for the generator button

  void _onTypoifyChanged(bool value) {
    setState(() {
      _typoify = value;
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .toggleTypoify(value);
    });
  }

  void _onRandomizeSeparatorsChanged(bool value) {
    setState(() {
      _randomizeSeparators = value;
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .toggleRandomizeSeparators(value);
    });
  }

  void _onLengthChanged(int value) {
    setState(() {
      _length = value;
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .updateLength(value);
    });
  }

  void _onNameChanged(String value) {
    setState(() {
      _name = value;
      Provider.of<SPMgeneratorHandler>(context, listen: false).setName(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: <Widget>[
        ListTile(
          title: const Text('Name'),
          trailing: SizedBox(
            width: 250,
            height: 45,
            child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => _onLengthChanged(int.parse(value)),
                // update value as soon as user writes
                // i think it's better this way
                onChanged: (value) => _onNameChanged(value)),
          ),
        ),
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
            height: 45,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _onLengthChanged(int.parse(value)),
              // update value as soon as user writes
              // i think it's better this way
              onChanged: (value) {
                if (int.tryParse(value) != null) {
                  _onLengthChanged(int.parse(value));
                }
              },
            ),
          ),
        ),
        //const Padding(padding: EdgeInsets.only(bottom: 10)),
        ListTile(
          title: const Text('Generated passphrase'),
          trailing: SizedBox(
            width: 250,
            height: 45,
            child: TextField(
              enabled: false,
              readOnly: true,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  //labelText: context.read<SPMgeneratorHandler>()._passphrase),
                  // why doesnt this get updated immediately?
                  labelText: Provider.of<SPMgeneratorHandler>(context)
                      .getPassphrase()),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Spacer(),
            // TODO: Improve the look of these buttons
            Expanded(
                child: ListTile(
              trailing: SPMguiButtonCopyCliboard(),
            )),
            Flexible(
              fit: FlexFit.loose,
              child: SPMguiGeneratePassphraseButton(
                length: _length,
                randomizeSeparators: _randomizeSeparators,
                typoify: _typoify,
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 20)),
            const Flexible(
              fit: FlexFit.loose,
              child: SPMguitogglePassphraseVisibilityButton(
                page: 0,
                name: '',
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 30)),
          ],
        )
      ],
    );
  }
}

class SPMguiVaultPage extends StatefulWidget {
  const SPMguiVaultPage({super.key});

  @override
  State<SPMguiVaultPage> createState() => _SPMguiVaultPageState();
}

class _SPMguiVaultPageState extends State<SPMguiVaultPage> {
  // properties of each entry
  int index = 0;
  String name = '';
  String passphrase = '';

  ListEntry _actualBuildEntries(
      Map<String, Map<bool, String>> inputEntries, int index) {
    String finalName = inputEntries.keys.toList()[index];
    String finalPassphrase =
        Provider.of<SPMvaultHandler>(context).getPassphrase(finalName);
    //print('length: ${inputEntries.length}');
    return ListEntry(name: finalName, passphrase: finalPassphrase);
  }

  List<Widget> buildList() {
    List<Widget> rowList = [];
    Map<String, Map<bool, String>> inputEntries =
        Provider.of<SPMvaultHandler>(context).getEntries();
    for (var index = 1; index < inputEntries.length; index += 1) {
      rowList.add(_actualBuildEntries(inputEntries, index));
    }
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: buildList(),
    );
  }
}
// Every passphrase entry should have an index to know which thing we are acting
// upon

class ListEntry extends StatefulWidget {
  const ListEntry({super.key, required this.name, required this.passphrase});
  final String name;
  final String passphrase;
  // index perhaps not needed

  @override
  State<ListEntry> createState() => _ListEntryState();
}

// I want a class that I can access by index
// has name
// passphrase
// the 3 buttons
// when the save button is clicked in the generator page
// the event is detected, and a new entry is added in the vault page
// in the column

class _ListEntryState extends State<ListEntry> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // name of the passphrase entry
        //Flexible(child: ListTile(title: Text(widget.index.toString()))),
        Expanded(
          child: ListTile(
            title: Text(widget.name),
            trailing: SizedBox(
              width: 250,
              child: TextField(
                enabled: false,
                readOnly: true,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: widget.passphrase),
              ),
            ),
          ),
        ),
        // regenerate
        const SPMguiEditButton(),
        // copy
        const SPMguiButtonCopyCliboard(),
        //show/hide
        SPMguitogglePassphraseVisibilityButton(
          page: 1,
          name: widget.name,
        ),
      ],
    );
  }
}
