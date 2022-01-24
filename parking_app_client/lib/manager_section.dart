import 'dart:convert';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_app_client/repo.dart';
import 'package:parking_app_client/space.dart';

import 'api.dart';
import 'new_item.dart';

class ManagerSection extends StatefulWidget {
  const ManagerSection({Key? key}) : super(key: key);

  @override
  _ManagerSectionState createState() => _ManagerSectionState();
}

class _ManagerSectionState extends State<ManagerSection> {
  late Future<List<Space>> futureSpaces;
  final DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    futureSpaces = fetchSpaces();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureSpaces,
        builder: (BuildContext context, AsyncSnapshot<List<Space>> snapshot) {
          if (snapshot.hasData) {
            debugPrint('spaces: $futureSpaces');
            return Scaffold(
                backgroundColor: Colors.white10,
                appBar: AppBar(
                    title: const Text('Parking App'),
                    backgroundColor: Colors.white10),
                body: Column(children: <Widget>[
                  const Padding(padding: EdgeInsets.all(5)),
                  RaisedButton(
                    child: const Text('Add New Space'),
                    onPressed: () => showNewItemForm(snapshot.data),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                                snapshot.data![index].id.toString() + "\t"),
                            subtitle: Text(
                                snapshot.data![index].address.toString() +
                                    "    " +
                                    snapshot.data![index].status.toString() +
                                    "   " +
                                    snapshot.data![index].number),
                            tileColor: const Color(0xffE5E5E5),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      if (await confirm(context)) {
                                        SnackBar snackBar = SnackBar(
                                            content: Text(
                                                "SpaceRemoved :  ${snapshot.data![index].number}"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        await deleteItem(
                                            snapshot.data![index].id,
                                            snapshot.data!);
                                        setState(() {
                                          snapshot.data!.removeAt(index);
                                        });
                                      }
                                      ;
                                    },
                                  ),
                                  IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {})
                                ]));
                      },
                    ),
                  )
                ]));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future showNewItemForm(List<Space>? data) async {
    Space space = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddItemFormPage();
        },
      ),
    );
    if (space != null) {
      final response = await postSpace(space);
      final newSpace = Space.fromJson(jsonDecode(response.body));
      await databaseHandler.insertSpace(newSpace);
      print(newSpace.toString());
      setState(() {
        data?.insert(data.length, newSpace);
      });
    }
  }

  Future<void> deleteItem(int? index, List<Space> data) async {
    final response = await deleteSpace(index);
    final removedSpace = Space.fromJson(jsonDecode(response.body));
    databaseHandler.deleteSpace(removedSpace.id);
    setState(() {
      final int index2 =
          data.indexWhere((element) => element.id == removedSpace.id);
      data.removeAt(index2);
    });
  }
}
