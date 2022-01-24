import 'package:flutter/material.dart';
import 'package:parking_app_client/space.dart';

class AddItemFormPage extends StatefulWidget {
  @override
  _AddItemFormPageState createState() => _AddItemFormPageState();
}

class _AddItemFormPageState extends State<AddItemFormPage> {
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void submitPup(BuildContext context) {
    if (numberController.text.isEmpty) {
      print('Name is required!');
    } else {
      var newSpace = Space(
          number: numberController.text,
          address: addressController.text,
          id: null,
          status: null,
          count: null);
      Navigator.of(context).pop(newSpace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Add a New Space'), backgroundColor: Colors.white10),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                  controller: numberController,
                  onChanged: (v) => {
                        numberController.text = v,
                        numberController.selection = TextSelection.fromPosition(
                            TextPosition(offset: numberController.text.length))
                      },
                  decoration: const InputDecoration(
                    labelText: 'Number:',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                  controller: addressController,
                  onChanged: (v) => {
                        addressController.text = v,
                        addressController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: addressController.text.length))
                      },
                  decoration: const InputDecoration(
                    labelText: "Address:",
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  // The basic Material Design action button.
                  return RaisedButton(
                    onPressed: () => submitPup(context),
                    child: Text('Submit'),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
