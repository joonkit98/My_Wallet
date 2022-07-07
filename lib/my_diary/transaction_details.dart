import 'package:My_Wallet/db/database_client.dart';
import 'package:My_Wallet/json/colors_json.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../json/app_theme_json.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  var db = DatabaseHelper();
  final ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> dataListDaily = <dynamic>[];
  List<dynamic> listDataDaily = <dynamic>[];
  List<dynamic> dataListWeekly = <dynamic>[];
  List<dynamic> listDataWeekly = <dynamic>[];
  List<dynamic> dataListMonthly = <dynamic>[];
  List<dynamic> listDataMonthly = <dynamic>[];
  List<dynamic> dataListYearly = <dynamic>[];
  List<dynamic> listDataYearly = <dynamic>[];
  late String description;
  double topBarOpacity = 0.0, balance = 0.0, sBalance = 0, rBalance = 0, amount = 0;
  DateTime dateOperation = DateTime.now();

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: widget.animationController!, curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    super.initState();
    readDateList(dataListDaily, "start of day", listDataDaily);
    readDateList(dataListWeekly, "-6 days", listDataWeekly);
    readDateList(dataListMonthly, "start of month", listDataMonthly);
    readDateList(dataListYearly, "start of year", listDataYearly);
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: FitnessAppTheme.background,
          title: Text(
            'Transaction Details',
            style: TextStyle(color: FitnessAppTheme.darkerText),
          ),
          bottom: TabBar(
            indicatorColor: Colors.lime,
            indicatorWeight: 5.0,
            labelColor: FitnessAppTheme.lightText,
            labelPadding: EdgeInsets.only(top: 10.0),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Daily',
              ),
              Tab(
                text: 'Weekly',
              ),
              Tab(
                text: 'Monthly',
              ),
              Tab(
                text: 'Yearly',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: setTabBody(dataListDaily, 'Day', listDataDaily),
            ),
            Container(
              child: setTabBody(dataListWeekly, 'Week', listDataWeekly),
            ),
            Container(
              child: setTabBody(dataListMonthly, 'Month', listDataMonthly),
            ),
            Container(
              child: setTabBody(dataListYearly, 'Year', listDataYearly),
            ),
          ],
        ),
      ),
    );
  }

  Widget setTabBody(List<dynamic> listName, String typeName, List<dynamic> listName2) {
    var size = MediaQuery.of(context).size;
    bool _date = false;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: List.generate(listName.length, (index) {
                double total = 0;
                return Column(
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        title: Text(listName[index][typeName].toString()),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: () {},
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: List.generate(listName2[index].length, (indexI) {
                              setText(listName2[index][indexI]['postingKey']) ?total += listName2[index][indexI]["amount"]:total +=(-(listName2[index][indexI]["amount"]));
                              return Dismissible(
                                key: UniqueKey(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: (size.width - 40) * 0.7,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: grey.withOpacity(0.1),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/images/" + listName2[index][indexI]["wallet"] + ".png",
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Container(
                                                width: (size.width - 90) * 0.5,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      listName2[index][indexI]['description'],
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: black,
                                                          fontWeight: FontWeight.w500
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      listName2[index][indexI]['dateOperation'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: black.withOpacity(0.5),
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: (size.width - 40) * 0.3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "RM" + listName2[index][indexI]["amount"].toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: setText(listName2[index][indexI]['postingKey']) ? Colors.green : Colors.red
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                background: Container(
                                  color: Colors.green,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction == DismissDirection.endToStart) {
                                    final bool res = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text.rich(
                                              TextSpan(
                                                text: "Are you sure you want to delete this item?\n",
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        "Description : ${listName2[index][indexI]['description']}\n"
                                                        "Date : ${listName2[index][indexI]['dateOperation']}\n"
                                                        "Amount : ${listName2[index][indexI]['amount']}",
                                                    style: TextStyle(fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    db.deleteOperation(listName2[index][indexI]["id"]);
                                                  });
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                    return res;
                                  } else {
                                    final bool res = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Padding(
                                              padding: const EdgeInsets.only(),
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Description",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 13,
                                                          color: Color(0xff67727d)
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      onSaved: (val) => description = val!,
                                                      controller: TextEditingController(text: listName2[index][indexI]["description"]),
                                                      cursorColor: black,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.bold,
                                                          color: black
                                                      ),
                                                      decoration: InputDecoration(
                                                          hintText: "Enter a description",
                                                          border: InputBorder.none
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Enter a description';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: (size.width - 140),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "Amount",
                                                                style: TextStyle(
                                                                    fontWeight:FontWeight.w500,
                                                                    fontSize: 13,
                                                                    color: Color(0xff67727d)
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                onSaved: (val) =>amount = double.parse(val!),
                                                                keyboardType:TextInputType.number,
                                                                controller: TextEditingController(text: listName2[index][indexI]["amount"].toString()),
                                                                cursorColor:black,
                                                                style: TextStyle(
                                                                    fontSize: 17,
                                                                    fontWeight:FontWeight.bold,
                                                                    color: black
                                                                ),
                                                                decoration: InputDecoration(
                                                                    hintText: "Amount",
                                                                    border: InputBorder.none
                                                                ),
                                                                validator:(value) {
                                                                  if (value!.isEmpty) {
                                                                    return 'Enter the amount';
                                                                  } else if (double.parse(value) > 10000) {
                                                                    return 'Amount too big, please less than 10000';
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Date",
                                                      style: TextStyle(
                                                          fontWeight:FontWeight.w500,
                                                          fontSize: 13,
                                                          color:Color(0xff67727d)
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    OutlineButton(
                                                      child: _date ? Text(listName2[index][indexI]["dateOperation"]) : Text(formatDate(dateOperation)),
                                                      onPressed: () {
                                                        showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.parse(listName2[index][indexI]["dateOperation"]),
                                                            firstDate: DateTime(2019),
                                                            lastDate: DateTime(2099)
                                                        ).then((date) {
                                                          if (date != null) {
                                                            setState(() {
                                                              dateOperation = date;
                                                              _date = true;
                                                            });
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                                onPressed: () async {
                                                  final FormState? form = _formKey.currentState;
                                                  if (form!.validate()) {
                                                    form.save();
                                                    form.reset();
                                                    setState(() {
                                                      db.updateOperation(listName2[index][indexI]["id"],formatDate(dateOperation),amount,description);
                                                    });
                                                  }
                                                  Navigator.of(context).pop(true);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                    return res;
                                  }
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 65, top: 8),
                      child: Divider(
                        thickness: 0.8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: black.withOpacity(0.4),
                                  fontWeight: FontWeight.w600
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "RM" + total.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                  fontWeight: FontWeight.bold
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 75),
        ],
      ),
    );
  }

  readDateList(List<dynamic> list, String day, List<dynamic> list2) async {
    List<dynamic> listDate = <dynamic>[];
    List<dynamic> _listData = <dynamic>[];
    String type = "", typeName = "";
    if (list == dataListDaily) {
      type = '%d';
      typeName = 'Day';
      listDate = await db.getDay();
    } else if (list == dataListWeekly) {
      type = '%w';
      typeName = 'Week';
      listDate = await db.getWeek();
    } else if (list == dataListMonthly) {
      type = '%m';
      typeName = 'Month';
      listDate = await db.getMonth();
    } else if (list == dataListYearly) {
      type = '%Y';
      typeName = 'Year';
      listDate = await db.getYear();
    }
    listDate.forEach((item) async {
      _listData = await db.getDetailsWithDate(type, item[typeName]);
      if (!mounted) return;
      setState(() {
        list.add(item);
        list2.add(_listData);
      });
    });
  }

  bool setText(String text) {
    bool result = true;
    if (text == "Expense") {
      result = false;
    } else {
      result = true;
    }
    return result;
  }

  String formatDate(DateTime dateTime) {
    var formatter = DateFormat("y-MM-dd");
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }
}
