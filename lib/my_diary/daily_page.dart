import 'package:My_Wallet/db/database_client.dart';
import 'package:My_Wallet/json/create_budget_json.dart';
import 'package:My_Wallet/json/daily_json.dart';
import 'package:My_Wallet/json/colors_json.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyPage extends StatefulWidget {
  final String walletName;

  const DailyPage({Key? key, required this.walletName}) : super(key: key);

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  late ValueNotifier<List<dynamic>> _selectedEvents;
  List<dynamic> dataList = <dynamic>[];
  int activeDay = 3;
  double sAmount = 0, rAmount = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  var db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    listData(widget.walletName, DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _selectedDay = _focusedDay;
    _getEventsForDay(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            setHeader(),
            const SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                          children: List.generate(dataList.length, (index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            categories[0]['icon'],
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
                                              dataList[index]['description'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: black,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              dataList[index]['dateOperation'],
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
                                        "RM" + dataList[index]['amount'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: setText(dataList[index]['postingKey'])
                                                ? Colors.green
                                                : Colors.red
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 65, top: 8),
                              child: Divider(
                                thickness: 0.8,
                              ),
                            )
                          ],
                        );
                      })
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
                              "RM" + sAmount.toString(),
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
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget setHeader() {
    return Container(
      decoration: BoxDecoration(color: white, boxShadow: [
        BoxShadow(
          color: grey.withOpacity(0.01),
          spreadRadius: 10,
          blurRadius: 3,
        ),
      ]),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daily Transaction",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: black),
                ),
                Icon(AntDesign.search1)
              ],
            ),
            SizedBox(
              height: 25,
            ),
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
                listData(widget.walletName, DateFormat('yyyy-MM-dd').format(selectedDay));
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget setBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
                children: List.generate(dataList.length, (index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      categories[0]['icon'],
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
                                        dataList[index]['description'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: black,
                                            fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        dataList[index]['dateOperation'],
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
                                  "RM" + dataList[index]['amount'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: setText(dataList[index]['postingKey'])
                                          ? Colors.green
                                          : Colors.red
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 65, top: 8),
                        child: Divider(
                          thickness: 0.8,
                        ),
                      )
                    ],
                  );
            })),
          ),
          SizedBox(
            height: 15,
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
                    "RM" + sAmount.toString(),
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
      ),
    );
  }

  _getEventsForDay(DateTime day) async {
    // Implementation example
    List items = await db.typeDetailsDate(widget.walletName, day.toString());
    items.forEach((item) {
      setState(() {
        _selectedEvents.value.add(item);
      });
    });
  }

  listData(String type, String _selectedDay) async {
    dataList.clear();
    List items = await db.typeDetailsDate(type, _selectedDay);
    items.forEach((item) {
      setState(() {
        dataList.add(item);
        item["postingKey"] == "Expense"
            ? sAmount += (-(item["amount"])!)!
            : sAmount += item["amount"]!;
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
}
