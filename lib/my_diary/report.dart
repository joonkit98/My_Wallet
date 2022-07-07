import 'package:My_Wallet/db/database_client.dart';
import 'package:My_Wallet/json/app_theme_json.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Report extends StatefulWidget {
  Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  var db = DatabaseHelper();
  List<ChartData> chartData = [], chartData2 = [];
  List<BarData> barData = [], barData2 = [];
  late TooltipBehavior _tooltipBehavior;
  late DataLabelSettings _dataLabelSettings;
  late Legend _legend;

  @override
  void initState() {
    getListData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _legend = Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.right
    );
    _dataLabelSettings = DataLabelSettings(
      isVisible: true,
      labelIntersectAction: LabelIntersectAction.hide,
      labelAlignment: ChartDataLabelAlignment.top,
      connectorLineSettings: ConnectorLineSettings(
        length: '10',
        type: ConnectorType.curve,
        width: 2,
      ),
      labelPosition: ChartDataLabelPosition.outside,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: FitnessAppTheme.background,
          title: Text(
            'Report',
            style: TextStyle(color: FitnessAppTheme.darkerText),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: SfCircularChart(
                    title: ChartTitle(text: 'Expense'),
                    legend: _legend,
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        explode: true,
                        enableSmartLabels: true,
                        enableTooltip: true,
                        dataLabelMapper: (data, __) => data.x,
                        dataLabelSettings: _dataLabelSettings,
                      ),
                    ],
                  ),
                ),
                Card(
                  child: SfCircularChart(
                    title: ChartTitle(text: 'Profit'),
                    legend: _legend,
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: chartData2,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        explode: true,
                        enableSmartLabels: true,
                        enableTooltip: true,
                        dataLabelMapper: (data, __) => data.x,
                        dataLabelSettings: _dataLabelSettings,
                      ),
                    ],
                  ),
                ),
                Card(
                  child: SfCartesianChart(
                      title: ChartTitle(text: 'Each month analysis'),
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          position: LegendPosition.bottom),
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(),
                      series: <ChartSeries<BarData, String>>[
                        ColumnSeries<BarData, String>(
                            name: 'Expense',
                            dataSource: barData,
                            xValueMapper: (BarData sales, _) => sales.year,
                            yValueMapper: (BarData sales, _) => sales.sales),

                        ColumnSeries<BarData, String>(
                            name: 'Profit',
                            dataSource: barData2,
                            xValueMapper: (BarData sales, _) => sales.year,
                            yValueMapper: (BarData sales, _) => sales.sales),
                      ]
                  ),
                ),
                SizedBox(
                  height: 75,
                )
              ],
            )
        )
    );
  }

  getListData() async {
    List<ChartData> line1 = [], line2 = [];
    List<BarData> data1 = [], data2 = [];
    line1 = await db.getLastMonthTotalWithPostingKey('Expense');
    line2 = await db.getLastMonthTotalWithPostingKey('Profit');
    data1 = await db.getTotalExpense('Expense');
    data2 = await db.getTotalExpense('Profit');
    setState(() {
      chartData = line1;
      chartData2 = line2;
      barData = data1;
      barData2 = data2;
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  String? x;
  double? y;
  Color? color;

  ChartData.fromMap(Map<String, dynamic> map) {
    this.x = map['wallet'];
    this.y = map['Total'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['wallet'] = x;
    map['Total'] = y;
    return map;
  }
}

class BarData {
  BarData({this.year, required this.sales});
  String? year;
  double sales = 0;

  BarData.fromMap(Map<String, dynamic> map) {
    this.year = DateFormat("MMMM").format(DateTime.parse(map['dateOperation']));
    this.sales = map['Total'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['Month'] = year;
    map['Total'] = sales;
    return map;
  }
}
