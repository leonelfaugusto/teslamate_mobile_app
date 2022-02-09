import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/charts/line_chart.dart';
import 'package:teslamate/charts_series/series_data.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/components/info_card.dart';

class ChargeScreen extends StatefulWidget {
  const ChargeScreen({Key? key}) : super(key: key);

  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  @override
  void didChangeDependencies() {
    int index = ModalRoute.of(context)!.settings.arguments as int;
    Charges charges = Provider.of<Charges>(context, listen: false);
    if (charges.items[index].chargeDetails.isEmpty) {
      charges.getMoreInfo(index);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)!.settings.arguments as int;
    Charge charge = Provider.of<Charges>(context, listen: false).items[index];

    return Scaffold(
      appBar: AppBar(
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
                  Consumer<Charges>(
                    builder: (context, charges, child) {
                      if (charges.items[index].chargeDetails.isNotEmpty) {
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
                      return const Center(
                        child: Text("Sem detalhes"),
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
