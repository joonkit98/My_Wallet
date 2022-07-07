import 'package:My_Wallet/db/database_client.dart';
import 'package:My_Wallet/json/create_budget_json.dart';
import 'package:My_Wallet/models/operation.dart';
import 'package:My_Wallet/json/colors_json.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewOperation extends StatefulWidget {
  @override
  _NewOperationState createState() => _NewOperationState();
}

class _NewOperationState extends State<NewOperation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _budgetName = TextEditingController();
  TextEditingController _budgetPrice = TextEditingController();
  late String description;
  late double amount, totalAmount;
  int radioValue = 0, activeCategory = 0;
  String postingKey = "Expense";
  DateTime dateOperation = DateTime.now();
  var db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New operation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Choose category",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: black.withOpacity(0.5)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(categories.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                activeCategory = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                ),
                                width: 150,
                                height: 170,
                                decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(
                                        width: 2,
                                        color: activeCategory == index
                                            ? primary
                                            : Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: grey.withOpacity(0.01),
                                        spreadRadius: 10,
                                        blurRadius: 3,
                                        // changes position of shadow
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, top: 20, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: grey.withOpacity(0.15)),
                                          child: Center(
                                            child: Image.asset(
                                              categories[index]['icon'],
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                      Text(
                                        categories[index]['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          OutlineButton(
                            child: Text(formatDate(dateOperation)),
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2019),
                                      lastDate: DateTime(2099))
                                  .then((date) {
                                if (date != null) {
                                  setState(() {
                                    dateOperation = date;
                                  });
                                }
                              });
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
                                      "Type",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Radio<int>(
                                          value: 0,
                                          groupValue: radioValue,
                                          onChanged: handleRadioValueChanged,
                                        ),
                                        Text('Expense'),
                                        Radio<int>(
                                          value: 1,
                                          groupValue: radioValue,
                                          onChanged: handleRadioValueChanged,
                                        ),
                                        Text('Profit'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextFormField(
                            onSaved: (val) => description = val!,
                            controller: _budgetName,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: black),
                            decoration: InputDecoration(
                                hintText: "Enter a description",
                                border: InputBorder.none),
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
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d)),
                                    ),
                                    TextFormField(
                                      onSaved: (val) =>
                                          amount = double.parse(val!),
                                      keyboardType: TextInputType.number,
                                      controller: _budgetPrice,
                                      cursorColor: black,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                      decoration: InputDecoration(
                                          hintText: "Amount",
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter the amount';
                                        }else if (double.parse(value) > 10000){
                                          return 'Amount too big, please less than 10000';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleSubmit();
        },
        tooltip: 'Add operation',
        child: Icon(Icons.save),
      ),
    );
  }

  void handleRadioValueChanged(int? value) {
    setState(() {
      radioValue = value!;
      switch (radioValue) {
        case 0:
          postingKey = 'Expense';
          break;
        case 1:
          postingKey = 'Profit';
          break;
        default:
          postingKey = '';
      }
    });
  }

  void handleSubmit() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      form.reset();
      Operation operation = Operation(nowTimeStamp(), formatDate(dateOperation),
          amount, categories[activeCategory]['name'], description, postingKey);
      await db.saveItem(operation);
      Navigator.pop(context, true);
    }
  }

  String formatDate(DateTime dateTime) {
    var formatter = DateFormat("y-MM-dd");
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  int nowTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
