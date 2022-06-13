import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/loading.dart';
import 'package:teslamate/utils/routes.dart';

class DriveCard extends StatefulWidget {
  final int index;
  const DriveCard({Key? key, required this.index}) : super(key: key);

  @override
  State<DriveCard> createState() => _DriveCardState();
}

class _DriveCardState extends State<DriveCard> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Drives drives = Provider.of<Drives>(context, listen: false);
    Drive drive = drives.items[widget.index];
    Loading appLoading = Provider.of<Loading>(context, listen: false);
    return Card(
      shape: loading ? RoundedRectangleBorder(side: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(5)) : null,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTapCancel: () {
          setState(() {
            loading = false;
          });
        },
        onTap: () async {
          appLoading.state = true;
          setState(() {
            loading = true;
          });
          if (drive.driveDetails.isEmpty) {
            await drives.getMoreInfo(widget.index);
          }
          Navigator.pushNamed(
            context,
            Routes.drive,
            arguments: drive,
          );
          setState(() {
            loading = false;
          });
          appLoading.state = false;
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
                            MdiIcons.steering,
                            size: 15,
                            color: Colors.amber[700],
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              "${DateFormat("HH:mm").format(drive.startDate)} - ${DateFormat("HH:mm").format(drive.endDate)}",
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
                            "${drive.durationStr.replaceFirst(":", "h")}m",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${drive.batteryDiff}%",
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
                      flex: int.parse(drive.endBatteryLevel.toString()),
                      child: Container(
                        height: 3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2), topLeft: Radius.circular(2)),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: -int.parse(drive.batteryDiff.toString()),
                      child: Container(
                        height: 3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(2), topRight: Radius.circular(2)),
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 100 - int.parse(drive.startBatteryLevel.toString()),
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
                  Row(
                    children: [
                      Transform.rotate(
                        angle: 45,
                        child: const Icon(
                          MdiIcons.navigation,
                          size: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${drive.distance} Km",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  Text(
                    "${drive.rangeDiff} Km",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
