import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Operation extends StatelessWidget {
  int? _dateAdded;
  String? _dateOperation;
  double? _amount;
  double? _totalSAmount;
  double? _totalRAmount;
  String? _wallet;
  String? _description;
  String? _postingKey;
  int? _id;

  Operation(this._dateAdded, this._dateOperation, this._amount, this._wallet,
      this._description, this._postingKey);

  Operation.map(dynamic obj) {
    this._dateAdded = obj["dateAdded"];
    this._dateOperation = obj["dateOperation"];
    this._amount = obj["amount"];
    this._wallet = obj["wallet"];
    this._description = obj["description"];
    this._postingKey = obj["postingKey"];
    this._id = obj["id"];
  }

  int? get dateAdded => _dateAdded;

  String? get dateOperation => _dateOperation;

  double? get amount => _amount;

  String? get wallet => _wallet;

  double? get totalSAmount => _totalSAmount;

  double? get totalRAmount => _totalRAmount;

  String? get description => _description;

  String? get postingKey => _postingKey;

  int? get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["dateAdded"] = _dateAdded;
    map["dateOperation"] = _dateOperation;
    map["amount"] = _amount;
    map["wallet"] = _wallet;
    map["description"] = _description;
    map["postingKey"] = _postingKey;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  Operation.fromMap(Map<String, dynamic> map) {
    this._dateAdded = map["dateAdded"];
    this._dateOperation = map["dateOperation"];
    this._amount = map["amount"];
    this._wallet = map["wallet"];
    this._totalSAmount = map["totalSAmount"];
    this._totalRAmount = map["totalRAmount"];
    this._description = map["description"];
    this._postingKey = map["postingKey"];
    this._id = map["id"];
  }

  double getValue() {
    double value;
    this.postingKey == "Expense"
        ? value = (-(this.amount)!)!
        : value = this.amount!;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.currency(decimalDigits: 2);
    return new Container(
      color: Colors.white,
      child: ListTile(
        title: Text(
          _description!,
          style: TextStyle(fontSize: 20.0),
        ),
        subtitle: Text("$_dateOperation"),
        trailing: Text(formatCurrency.format(_amount)),
        leading: _postingKey == 'Profit'
            ? Icon(
                Icons.arrow_upward,
                color: Colors.green,
              )
            : Icon(
                Icons.arrow_downward,
                color: Colors.red,
              ),
      ),
    );
  }
}
