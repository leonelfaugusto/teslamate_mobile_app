import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/components/info_card.dart';
import 'package:teslamate/utils/custom_colors.dart';

class ChargeScreen extends StatefulWidget {
  const ChargeScreen({Key? key}) : super(key: key);

  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  List<LineChartBarData> data = [];

  @override
  void initState() {
    super.initState();
  }

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
          left: 8,
          right: 8,
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
                        final List<FlSpot> initData = [];
                        for (var i = 0; i < charge.chargeDetails.length; i++) {
                          if (0 == i % 5) {
                            initData.add(FlSpot(
                                charge.chargeDetails[i].date.microsecondsSinceEpoch.toDouble(), charge.chargeDetails[i].chargePower.toDouble()));
                          }
                          if (i == charge.chargeDetails.length - 1 && 0 != i % 5) {
                            initData.add(FlSpot(
                                charge.chargeDetails[i].date.microsecondsSinceEpoch.toDouble(), charge.chargeDetails[i].chargePower.toDouble()));
                          }
                        } /* 
                        final List<FlSpot> initData2 = [];
                        for (var i = 0; i < charge.chargeDetails.length; i++) {
                          if (0 == i % 5) {
                            initData2.add(FlSpot(charge.chargeDetails[i].date.microsecondsSinceEpoch.toDouble(),
                                charge.chargeDetails[i].chargeEnergyAdded.toDouble()));
                          }
                          if (i == charge.chargeDetails.length - 1 && 0 != i % 5) {
                            initData2.add(FlSpot(charge.chargeDetails[i].date.microsecondsSinceEpoch.toDouble(),
                                charge.chargeDetails[i].chargeEnergyAdded.toDouble()));
                          }
                        } */
                        final List<FlSpot> initData3 = [];
                        for (var i = 0; i < charge.chargeDetails.length; i++) {
                          if (0 == i % 5) {
                            initData3.add(FlSpot(
                                charge.chargeDetails[i].date.microsecondsSinceEpoch.toDouble(), charge.chargeDetails[i].bateryLevel.toDouble()));
                          }
                          if (i == charge.chargeDetails.length - 1 && 0 != i % 5) {
                            initData3.add(FlSpot(
                                charge.chargeDetails[i].date.microsecondsSinceEpoch.toDouble(), charge.chargeDetails[i].bateryLevel.toDouble()));
                          }
                        }
                        data = [
                          LineChartBarData(
                            isCurved: true,
                            colors: [const Color(0xff4af699)],
                            barWidth: 5,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                            spots: initData,
                          ),
                          /* LineChartBarData(
                            isCurved: true,
                            colors: [CustomColors.red],
                            barWidth: 5,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                            spots: initData2,
                          ), */
                          LineChartBarData(
                            isCurved: true,
                            colors: [Colors.blue],
                            barWidth: 6,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                            spots: initData3,
                          ),
                        ];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: LineChart(
                                    LineChartData(
                                      clipData: FlClipData.none(),
                                      borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            bottom: BorderSide(
                                              width: 2,
                                              color: Colors.blueGrey,
                                            ),
                                          )),
                                      lineTouchData: LineTouchData(
                                        handleBuiltInTouches: true,
                                        touchTooltipData: LineTouchTooltipData(
                                          fitInsideVertically: true,
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                        rightTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                        leftTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                        bottomTitles: SideTitles(
                                          getTextStyles: ((context, value) {
                                            return const TextStyle(fontSize: 10);
                                          }),
                                          showTitles: true,
                                          checkToShowTitle: (minValue, maxValue, sideTitles, appliedInterval, value) {
                                            if (value == minValue || value == maxValue) {
                                              return true;
                                            }
                                            return false;
                                          },
                                          getTitles: (value) {
                                            DateTime date = DateTime.fromMicrosecondsSinceEpoch(value.toInt());
                                            return DateFormat("hh:mm", "pt").format(date);
                                          },
                                        ),
                                      ),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                      ),
                                      lineBarsData: data,
                                    ),
                                    swapAnimationDuration: const Duration(milliseconds: 150),
                                    swapAnimationCurve: Curves.linear,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(
                                          MdiIcons.chartLine,
                                          color: Color(0xff4af699),
                                        ),
                                        Text(
                                          "Power",
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: const Color(0xff4af699),
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(
                                          MdiIcons.chartLine,
                                          color: CustomColors.red,
                                        ),
                                        Text(
                                          "Energy added",
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: CustomColors.red,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(
                                          MdiIcons.chartLine,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          "Battery level",
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: Colors.blue,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
