import 'package:My_Wallet/json/app_theme_json.dart';
import 'package:flutter/material.dart';

class BodyMeasurementView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final double totalSpend;
  final String? lastDateTime;

  const BodyMeasurementView(
      {Key? key, this.animationController, this.animation, required this.totalSpend, this.lastDateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                            child: Text(
                              'Total spend',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: FitnessAppTheme.darkText
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 8),
                                    child: Text(
                                      'RM',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      '${totalSpend!.toInt()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 32,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: FitnessAppTheme.grey.withOpacity(0.5),
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          //'Today 8:26 AM',
                                          lastDateTime.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, bottom: 14),
                                    child: Text(
                                      'Last Date',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
