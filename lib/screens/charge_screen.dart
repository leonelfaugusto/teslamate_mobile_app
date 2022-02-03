import 'package:flutter/material.dart';
import 'package:teslamate/charts/line_chart.dart';
import 'package:teslamate/charts_series/series.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/utils/routes.dart';

class ChargeScreen extends StatefulWidget {
  const ChargeScreen({Key? key}) : super(key: key);

  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  @override
  Widget build(BuildContext context) {
    final charge = ModalRoute.of(context)!.settings.arguments as Charge;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: RoutesColors.charge,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: charge.fetchMoreInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Series> data = charge.chargeDetails
                  .asMap()
                  .map((i, chargeDetail) {
                    return MapEntry(
                        i,
                        Series(
                          x: i,
                          y: chargeDetail.chargePower,
                        ));
                  })
                  .values
                  .toList();

              return SizedBox(
                height: 200,
                child: LineChart(data: data, id: 'Power'),
              );
            }
            return SizedBox(
              height: 200,
              child: Text(charge.chargeId.toString()),
            );
          },
        ),
      ),
    );
  }
}
