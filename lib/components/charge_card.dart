import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/utils/routes.dart';

class ChargeCard extends StatefulWidget {
  final int index;
  const ChargeCard({Key? key, required this.index}) : super(key: key);

  @override
  State<ChargeCard> createState() => _ChargeCardState();
}

class _ChargeCardState extends State<ChargeCard> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Charges charges = Provider.of<Charges>(context, listen: false);
    Charge charge = Provider.of<Charges>(context, listen: false).items[widget.index];
    return Card(
      shape: loading
          ? RoundedRectangleBorder(side: const BorderSide(color: Color.fromARGB(255, 56, 142, 60)), borderRadius: BorderRadius.circular(5))
          : null,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTapCancel: () {
          setState(() {
            loading = false;
          });
        },
        onTap: () async {
          setState(() {
            loading = true;
          });
          await charges.getMoreInfo(widget.index);
          Navigator.pushNamed(
            context,
            Routes.charge,
            arguments: charge,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            MdiIcons.lightningBolt,
                            size: 15,
                            color: Colors.green[700],
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              "${DateFormat("HH:mm").format(charge.startDate)} - ${DateFormat("HH:mm").format(charge.endDate)}",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            MdiIcons.clockOutline,
                            size: 15,
                            color: Colors.grey,
                          ),
                          Text(
                            "${charge.durationStr.replaceFirst(":", "h")}m",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "+${charge.batteryDiff}%",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const Icon(
                        Icons.navigate_next,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: charge.startBatteryLevel,
                      child: Container(
                        height: 3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2), topLeft: Radius.circular(2)),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: charge.endBatteryLevel - charge.startBatteryLevel,
                      child: Container(
                        height: 3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(2), topRight: Radius.circular(2)),
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 100 - charge.endBatteryLevel,
                      child: Container(
                        height: 1,
                        color: Colors.black38,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(charge.address),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "€${charge.cost}",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "+${charge.rangeDiff.toStringAsFixed(0)} Km",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
