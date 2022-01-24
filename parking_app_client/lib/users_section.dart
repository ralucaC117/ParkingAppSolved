import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_app_client/space.dart';
import 'api.dart';

class UsersSection extends StatefulWidget {
  const UsersSection({Key? key}) : super(key: key);

  @override
  _UsersSectionState createState() => _UsersSectionState();
}

class _UsersSectionState extends State<UsersSection> {
  late Future<List<Space>> futureFreeSpaces;

  @override
  void initState() {
    super.initState();
    futureFreeSpaces = fetchFreeSpaces();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureFreeSpaces,
        builder: (BuildContext context, AsyncSnapshot<List<Space>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.white10,
                appBar: AppBar(
                    title: const Text('Users Section'),
                    backgroundColor: Colors.white10),
                body: Column(children: <Widget>[
                  const Padding(padding: EdgeInsets.all(5)),
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
                                    icon: const Icon(Icons.add_circle),
                                    onPressed: () async {
                                      SnackBar snackBar = SnackBar(
                                          content: Text(
                                              "Seat Taken :  ${snapshot.data![index].number}"));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      updateItem(snapshot.data![index].id,
                                          snapshot.data);
                                    },
                                  )
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

  void updateItem(int? index, List<Space>? data) async {
    final response = await updateSpace(index);
    final takenSpace = Space.fromJson(jsonDecode(response.body));

    if (index != null) {
      setState(() {
        final i = data!.indexWhere((element) => element.id == index);
        data[i] = takenSpace;
      });
    }
  }
}
