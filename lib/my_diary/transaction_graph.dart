import 'package:My_Wallet/db/database_client.dart';
import 'package:My_Wallet/json/app_theme_json.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionGraph extends StatefulWidget {
  TransactionGraph({Key? key}) : super(key: key);

  @override
  _TransactionGraphState createState() => _TransactionGraphState();
}

class _TransactionGraphState extends State<TransactionGraph> {
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;
  late Legend _legend;
  List<SalesData> ChartData = [], ChartData1 = [];
  var db = DatabaseHelper();

  @override
  void initState() {
    setData();
    _trackballBehavior = TrackballBehavior(
        activationMode: ActivationMode.doubleTap,
        shouldAlwaysShow: true,
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        enable: true,
        markerSettings: TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.visible
        )
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableSelectionZooming: true,
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 1,
      selectionRectColor: Colors.grey,
      enablePanning: true,
      zoomMode: ZoomMode.xy,
      enableMouseWheelZooming: true,
    );
    _tooltipBehavior = TooltipBehavior(enable: true, shared: true);
    _legend = Legend(
        isVisible: true,
        iconHeight: 10,
        iconWidth: 10,
        toggleSeriesVisibility: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FitnessAppTheme.background,
        title: Text(
          'Graph',
          style: TextStyle(color: FitnessAppTheme.darkerText),
        ),
      ),
      body: Center(
        child: Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                enableAutoIntervalOnZooming: false
              ),
              title: ChartTitle(text: 'Graph'),
              trackballBehavior: _trackballBehavior,
              tooltipBehavior: _tooltipBehavior,
              legend: _legend,
              series: <LineSeries<SalesData, DateTime>>[
                LineSeries<SalesData, DateTime>(
                  name: 'Expense',
                  dataSource: ChartData,
                  markerSettings: MarkerSettings(isVisible: true),
                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                ),
                LineSeries<SalesData, DateTime>(
                    name: 'Profit',
                    dataSource: ChartData1,
                    markerSettings: MarkerSettings(isVisible: true),
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales),
              ],
              zoomPanBehavior: _zoomPanBehavior,
            )),
      ),
    );
  }

  void setData() async {
    List<SalesData> line1 = [], line2 = [];
    line1 = await db.getTotalEachDay('Expense');
    line2 = await db.getTotalEachDay('Profit');
    setState(() {
      ChartData = line1;
      ChartData1 = line2;
    });
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  DateTime? year;
  double? sales;

  SalesData.fromMap(Map<String, dynamic> map) {
    this.year = DateTime.parse(map['dateOperation']);
    this.sales = map['Total'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['dateOperation'] = year;
    map['Total'] = sales;
    return map;
  }
}
