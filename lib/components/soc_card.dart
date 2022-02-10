import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teslamate/classes/car_status.dart';

class SocCard extends StatelessWidget {
  final CarStatus carStatus;

  const SocCard({
    Key? key,
    required this.carStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: LinearProgressIndicator(
                color: Colors.green[700],
                backgroundColor: Colors.black.withOpacity(0.3),
                minHeight: 10,
                value: double.parse((carStatus.stateOfCharge / 100).toString()),
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Icon(carStatus.stateOfCharge < 80 ? CupertinoIcons.battery_25 : CupertinoIcons.battery_full),
                      ),
                      Text(
                        "Estado da carga",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${carStatus.stateOfCharge}",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "%",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        " / ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        carStatus.batteryRange.toStringAsFixed(0),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        " Km",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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
