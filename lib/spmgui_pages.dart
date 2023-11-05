import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'spmgui_changenotifiers.dart';

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

  // These functions update the UI
  // on the onSubmitted/Changed bits of the widgets we use extra functions to update the values for the generator button

  void _onTypoifyChanged(bool value) {
    setState(() {
      _typoify = value;
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .updateTypoify(value);
    });
  }

  void _onRandomizeSeparatorsChanged(bool value) {
    setState(() {
      _randomizeSeparators = value;
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .updateRandomizeSeparators(value);
    });
  }

  void _onLengthChanged(int value) {
    setState(() {
      _length = value;
      Provider.of<SPMgeneratorHandler>(context, listen: false)
          .updateLength(value);
    });
  }

  Icon _forTheHideButton = Icon(Icons.visibility);
  //bool _obscurePassphrase = false;
  void _onHidePassphraseButtonPressed() {
    setState(() {
      switch (_forTheHideButton) {
        case Icon(icon: Icons.visibility):
          _forTheHideButton = Icon(Icons.visibility_off);
          Provider.of<SPMgeneratorHandler>(context, listen: false)
              .toggleHiddenPassphrase(true);
          break;
        case Icon(icon: Icons.visibility_off):
          _forTheHideButton = Icon(Icons.visibility);
          Provider.of<SPMgeneratorHandler>(context, listen: false)
              .toggleHiddenPassphrase(false);
          break;
        default:
      }
    });
  }

  void _onCopyToClipboardButtonPressed() {
    // TODO: display a toast saying "nothing to copy" when the passphrase is empty
    Clipboard.setData(ClipboardData(
        text: Provider.of<SPMgeneratorHandler>(context, listen: false)
            .getPassphrase(false)));
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
            height: 45,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Length',
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
                      .getPassphrase(Provider.of<SPMgeneratorHandler>(context)
                          .getHidePassphrase())),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Spacer(),
            // TODO: Improve the look of these buttons
            Expanded(
                child: ListTile(
              trailing: FilledButton.tonal(
                  onPressed: _onCopyToClipboardButtonPressed,
                  child: const Icon(Icons.content_copy)),
            )),
            Flexible(
              fit: FlexFit.loose,
              child: FilledButton(
                  onPressed: _onHidePassphraseButtonPressed,
                  child: _forTheHideButton),
            ),
            const Padding(padding: EdgeInsets.only(right: 30)),
          ],
        )
      ],
    );
  }
}
