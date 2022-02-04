import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teslamate/charts/line_chart.dart';
import 'package:teslamate/charts_series/series_data.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/components/info_card.dart';
import 'package:teslamate/utils/routes.dart';

class ChargeScreen extends StatelessWidget {
  const ChargeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final charge = ModalRoute.of(context)!.settings.arguments as Charge;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: RoutesColors.charge,
        title: Text(DateFormat("d MMMM y", "pt").format(charge.startDate)),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: Text(
                      charge.address,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              delegate: SliverChildListDelegate(
                [
                  InfoCard(
                    icon: Icons.euro,
                    info: charge.cost.toString(),
                  ),
                  InfoCard(
                    info: "${charge.chargeEnergyAdded.toStringAsFixed(2)}Kwh",
                  ),
                  InfoCard(
                    icon: Icons.timer,
                    info: charge.durationStr,
                  ),
                  InfoCard(
                    icon: Icons.battery_saver,
                    info: "${charge.batteryDiff}%",
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  FutureBuilder(
                    future: charge.fetchMoreInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<SeriesData> data = charge.chargeDetails
                            .asMap()
                            .map((i, chargeDetail) {
                              return MapEntry(
                                  i,
                                  SeriesData(
                                    x: chargeDetail.date,
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
                      return const SizedBox(
                        height: 200,
                        child: null,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
