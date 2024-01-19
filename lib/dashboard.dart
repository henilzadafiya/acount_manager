import 'dart:io';

import 'package:acount_manager/view.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class dashboard extends StatefulWidget {
  static Database? database;

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  TextEditingController t1 = TextEditingController();
  String name = '';
  List<Map> l = [];
  List<Map> l1 = [];
  List cre = [];
  List deb = [];
  List bal = [];
  List na = [
    'Home',
    'Backup',
    'Restore',
    'Change currency',
    'Change password',
    'Change security question',
    'Setting',
    'Share the app',
    'Rate the app',
    'Privacy policy',
    'More apps',
    'Ads Free',
  ];
  List icon = [
    Icon(Icons.home),
    Icon(Icons.backup),
    Icon(Icons.restore),
    Icon(Icons.settings),
    Icon(Icons.settings),
    Icon(Icons.security),
    Icon(Icons.settings),
    Icon(Icons.share),
    Icon(Icons.star_rate),
    Icon(Icons.policy),
    Icon(Icons.apps),
    Icon(Icons.ads_click),
  ];
  List cr = [];
  List de = [];
  List to = [];

  get() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    dashboard.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
      await db.execute(
          'CREATE TABLE student1 (id INTEGER PRIMARY KEY AUTOINCREMENT,p_id INTEGER,date TEXT,particular TEXT,credit INTEGER,debit INTEGER)');
    });
    String qry = "select * from student";
    l = await dashboard.database!.rawQuery(qry);

    String qry1 = "select * from student1";
    l1 = await dashboard.database!.rawQuery(qry1);

    cr = List.filled(l.length, 0);
    de = List.filled(l.length, 0);
    bal = List.filled(l.length, 0);

    if (l.length != 0) {
      for (int i = 0; i < l.length; i++) {
        String sql =
            "select sum(credit) from student1 where p_id=${l[i]['id']}";
        String sql1 =
            "select sum(debit) from student1 where p_id=${l[i]['id']}";

        cre = await dashboard.database!.rawQuery(sql);
        deb = await dashboard.database!.rawQuery(sql1);

        cr[i] = cre[0]['sum(credit)'];
        de[i] = deb[0]['sum(debit)'];
        bal[i] = cr[i] - de[i];

        print(cr);
        print(de);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // drawer: Drawer(
          //     child: Column(
          //   children: [
          //     Expanded(
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 image: DecorationImage(
          //                   fit: BoxFit.fill,
          //                   image: AssetImage('img/Fy.png'),
          //                 ),
          //               ),
          //               child: Column(
          //                 children: [
          //                   Image.asset('img/tf.png'),
          //                   Center(
          //                     child: Text("Account Manager",
          //                         style: TextStyle(
          //                             fontSize: 20, color: Colors.white)),
          //                   ),
          //                   Divider(
          //                     color: Colors.white,
          //                     height: 10,
          //                     thickness: 2,
          //                     endIndent: 15,
          //                     indent: 15,
          //                   ),
          //                   Expanded(
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                           color: Colors.deepPurple,
          //                           borderRadius:
          //                               BorderRadius.all(Radius.circular(5))),
          //                       margin: EdgeInsets.only(
          //                           left: 15, right: 15, bottom: 50, top: 15),
          //                       child: Column(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceEvenly,
          //                           children: [
          //                             Row(
          //                               children: [
          //                                 Text(
          //                                   "Credit(+)",
          //                                   style: TextStyle(
          //                                       fontSize: 12,
          //                                       color: Colors.white),
          //                                 )
          //                               ],
          //                             ),
          //                             Row(
          //                               children: [
          //                                 Text(
          //                                   "Debit(-)",
          //                                   style: TextStyle(
          //                                       fontSize: 12,
          //                                       color: Colors.white),
          //                                 )
          //                               ],
          //                             ),
          //                             Divider(
          //                               color: Colors.white,
          //                               indent: 15,
          //                               endIndent: 15,
          //                               thickness: 1,
          //                             ),
          //                             Row(
          //                               children: [
          //                                 Text(
          //                                   "Balance",
          //                                   style: TextStyle(
          //                                       fontSize: 15,
          //                                       color: Colors.white),
          //                                 )
          //                               ],
          //                             ),
          //                           ]),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       flex: 2,
          //       child: ListView.builder(
          //         itemCount: icon.length,
          //         itemBuilder: (context, index) {
          //           return Column(
          //             children: [
          //               ListTile(
          //                 onTap: () {
          //                   setState(() {});
          //                   Navigator.pop(context);
          //                 },
          //                 leading: icon[index],
          //                 title: Text("${na[index]}"),
          //               ),
          //             ],
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // )),
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Dashboard"),
          ),
          floatingActionButton: IconButton(
              onPressed: () {
                t1.clear();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Add new account"),
                      content: TextField(
                        controller: t1,
                        decoration:
                            InputDecoration(label: Text('Account name')),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("CANCLE")),
                        TextButton(
                            onPressed: () {
                              name = t1.text;
                              String qry =
                                  "insert into student values(null,'$name')";
                              dashboard.database!.rawInsert(qry);
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text("SAVE")),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.add_box)),
          body: FutureBuilder(
            future: get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              itemCount: l.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return view(l[index]);
                                      },
                                    ));
                                  },
                                  child: Card(
                                      child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "${l[index]['name']}",
                                                style: TextStyle(fontSize: 30),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Wrap(
                                              alignment: WrapAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      String qry =
                                                          "delete from student where id=${l[index]['id']}";
                                                      String qry1 =
                                                          "delete from student1 where p_id=${l[index]['id']}";
                                                      dashboard.database!
                                                          .rawDelete(qry);
                                                      dashboard.database!
                                                          .rawDelete(qry1);

                                                      setState(() {});
                                                    },
                                                    icon: Icon(Icons.delete)),
                                                IconButton(
                                                    onPressed: () {
                                                      t1.text =
                                                          l[index]['name'];
                                                      showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Add new account"),
                                                            content: TextField(
                                                              controller: t1,
                                                              decoration:
                                                                  InputDecoration(
                                                                      label: Text(
                                                                          'Account name')),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "CANCLE")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    name =
                                                                        t1.text;
                                                                    String qry =
                                                                        "update student set name='${name}' where id=${l[index]['id']}";
                                                                    dashboard
                                                                        .database!
                                                                        .rawUpdate(
                                                                            qry);
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                      "SAVE")),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(Icons.edit)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 100,
                                              child: (cr[index] != null)
                                                  ? Text(
                                                      "Credit()\n  ${cr[index]}")
                                                  : Text("Credit() \n 0"),
                                              color: Colors.red,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 100,
                                              child: (de[index] != null)
                                                  ? Text(
                                                      "Debit()\n   ${de[index]}")
                                                  : Text("Debit() \n 0"),
                                              color: Colors.red,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 100,
                                              alignment: Alignment.center,
                                              child: Text(
                                                  "Balance\n ${bal[index]}"),
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                                );
                              },
                            )),
                          ],
                        )),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Are you Exit"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text("CANCLE")),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return exit(0);
                        },
                      ));
                    },
                    child: Text("OK")),
              ],
            );
          },
        );
        return true;
      },
    );
  }
}
