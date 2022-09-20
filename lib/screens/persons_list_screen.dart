import 'package:flutter/material.dart';
import 'package:form/db/database.dart';
import 'package:form/model/person.dart';

class PersonsListScreen extends StatefulWidget {
  const PersonsListScreen({super.key});

  @override
  State<PersonsListScreen> createState() => _PersonsListScreenState();
}

class _PersonsListScreenState extends State<PersonsListScreen> {
  final dbHelper = DBHelper.instance;
  Future<List<Person>> loadingUsers() async {
    List<Person> personList = [];
    try {
      final List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();
      if (rows.length == 0) {
        print('NO DATA BD');
      } else {
        for (var row in rows) {
          personList.add(Person(
            id: row["id"],
            name: row["name"],
            phone: row["phone"],
            email: row["email"],
            story: row["story"],
            country: row["country"],
            password: row["password"],
          ));
        }
      }

      return personList;
    } catch (e) {
      print("Error loaded data $e");
      return personList;
    }
  }

  @override
  Widget build(BuildContext context) {
    // var loader = false;

    return FutureBuilder(
      future: loadingUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Person> personList = snapshot.data ?? [];
          return Scaffold(
            body: SafeArea(
                child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: personList.length,
                    itemBuilder: (context, index) {
                      final personItem = personList[index];
                      return Container(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                          left: 12.0,
                          right: 5.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black54,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person, size: 30),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'ID: ${personItem.id}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${personItem.name}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await dbHelper.delete(personItem.id);
                                    personList.removeWhere((element) =>
                                        element.id == personItem.id);
                                    setState(() {
                                      personList;
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '${personItem.phone}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '${personItem.email}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '${personItem.country}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '${personItem.story}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 16, right: 16, bottom: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.white12),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/sign_up');
                    },
                    child: Text('Add User'),
                  ),
                ),
              ],
            )),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
