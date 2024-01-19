import 'package:acount_manager/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';

class view extends StatefulWidget {

  Map data;

  static Database? database;

  view(this.data);

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {

  List<Map> l1 = [];

  String rad = '';
  String credit = "";
  String debit = "";
  List cre = [];
  List deb = [];
  List bal = [];
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  data() async {
    String qry = "select * from student1 where p_id=${widget.data['id']}";
    l1 = await dashboard.database!.rawQuery(qry);

    String sql = "select sum(credit) from student1 where p_id=${widget.data['id']}";
    cre = await dashboard.database!.rawQuery(sql);
    String sql1 = "select sum(debit) from student1 where p_id=${widget.data['id']}";
    deb = await dashboard.database!.rawQuery(sql1);
    String sql2 = "select sum(credit)-sum(debit) FROM student1 where p_id=${widget.data['id']}";
    bal = await dashboard.database!.rawQuery(sql2);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: Text("${widget.data['name']}"),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("CLANDER"),
                          content: Container(
                            height: 300,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextfieldDatePicker(
                                      cupertinoDatePickerBackgroundColor:
                                          Colors.white,
                                      cupertinoDatePickerMaximumDate:
                                          DateTime(2099),
                                      cupertinoDatePickerMaximumYear: 2099,
                                      cupertinoDatePickerMinimumYear: 1990,
                                      cupertinoDatePickerMinimumDate:
                                          DateTime(1990),
                                      cupertinoDateInitialDateTime:
                                          DateTime.now(),
                                      materialDatePickerFirstDate:
                                          DateTime.now(),
                                      materialDatePickerInitialDate:
                                          DateTime.now(),
                                      materialDatePickerLastDate:
                                          DateTime(2099),
                                      preferredDateFormat:
                                          DateFormat('dd-MM-' 'yyyy'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        helperStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 0),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            borderSide: const BorderSide(
                                              width: 0,
                                              color: Colors.white,
                                            )),
                                        hintText: 'Select Date',
                                        hintStyle: TextStyle(
                                            // fontSize: displayWidth(context) * 0.04,
                                            fontWeight: FontWeight.normal),
                                        filled: true,
                                        fillColor: Colors.grey[300],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      textfieldDatePickerController: t1),
                                  Expanded(
                                    child: Container(
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return Row(
                                            children: [
                                              Text("Transaction Type",
                                                  style:
                                                      TextStyle(fontSize: 8)),
                                              Radio(
                                                value: "Credit",
                                                groupValue: rad,
                                                onChanged: (value) {
                                                  rad = value!;
                                                  setState(() {});
                                                },
                                              ),
                                              Text("Credit(+)",
                                                  style:
                                                      TextStyle(fontSize: 9)),
                                              Radio(
                                                value: "Debit",
                                                groupValue: rad,
                                                onChanged: (value) {
                                                  rad = value!;
                                                  setState(() {});
                                                },
                                              ),
                                              Text("Debit(-)",
                                                  style:
                                                      TextStyle(fontSize: 9)),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    controller: t2,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecoration(label: Text('Amount')),
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.text,
                                    controller: t3,
                                    decoration: InputDecoration(
                                        label: Text('Particular')),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text('CANCLE'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          String date = t1.text;
                                          String particular = t3.text;

                                          if (rad == "Credit") {
                                            String qry =
                                                "insert into student1 values(null,'${widget.data['id']}','$date','$particular','${t2.text}','0')";
                                            dashboard.database!.rawInsert(qry);
                                            setState(() {});
                                          }
                                          if (rad == "Debit") {
                                            String qry =
                                                "insert into student1 values(null,'${widget.data['id']}','$date','$particular','0','${t2.text}')";
                                            dashboard.database!.rawInsert(qry);
                                            setState(() {});
                                          }
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text('ADD'),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add)),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search_rounded),
              ),
              PopupMenuButton(
                onCanceled: () {},
                onSelected: (value) {
                  if (value == 1) {
                    setState(() {});
                  } else if (value == 2) {
                    setState(() {});
                  } else if (value == 3) {
                    setState(() {});
                  } else if (value == 4) {
                    setState(() {});
                  } else if (value == 5) {
                    setState(() {});
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Save as PDF"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Save as Excel"),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text("Share the App"),
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: Text("Rate the App"),
                  ),
                  PopupMenuItem(
                    value: 5,
                    child: Text("More Apps"),
                  ),
                ],
              ),
            ],
          ),
          body: FutureBuilder(
            future: data(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return Column(children: [
                 Expanded(
                   child: Row(
                     children: [
                       Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             child: Text("Date"),
                             height: double.infinity,
                           )),
                       Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             child: Text("Particular"),
                             height: double.infinity,
                           )),
                       Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             child: Text("Credit(+)"),
                             height: double.infinity,
                           )),
                       Expanded(
                           child: Container(
                             alignment: Alignment.center,
                             child: Text("Debit(-)"),
                             height: double.infinity,
                           )),
                     ],
                   ),
                 ),
                 Expanded(
                   flex: 15,
                   child: ListView.builder(
                     scrollDirection: Axis.vertical,
                     itemCount: l1.length,
                     itemBuilder: (context, index) {
                       return Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Text("${l1[index]['date']}"),
                             Text("${l1[index]['particular']}"),
                             Text("${l1[index]['credit']}"),
                             Text("${l1[index]['debit']}"),
                           ]);
                     },
                   ),
                 ),
                 Expanded(
                   flex: 2,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Expanded(
                         child: Container(
                           alignment: Alignment.center,
                           height: 100,
                           child: (cre[0]['sum(credit)']!=null)
                               ? Text("Credit()\n  ${cre[0]['sum(credit)']}")
                               : Text("Credit()\n  0"),
                           color: Colors.red,
                         ),
                       ),
                       Expanded(
                         child: Container(
                           alignment: Alignment.center,
                           height: 100,
                           child: (deb[0]['sum(debit)']!=null)
                               ? Text("Debit()\n    ${deb[0]['sum(debit)']}")
                               : Text("Debit()\n   0"),
                           color: Colors.red,
                         ),
                       ),
                       Expanded(
                         child: Container(
                           height: 100,
                           alignment: Alignment.center,
                           child: (bal[0]['sum(credit)-sum(debit)']!=null)
                               ? Text("Balance\n     ${bal[0]['sum(credit)-sum(debit)']}")
                               : Text("Balance\n     0"),
                           color: Colors.red,
                         ),
                       ),
                     ],
                   ),
                 )
               ]);
              }else{
                return Center(child: CircularProgressIndicator(),);
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
                          return dashboard();
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
