import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teslamate/classes/drive.dart';

class DriveCard extends StatelessWidget {
  final Drive drive;
  const DriveCard({Key? key, required this.drive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => print("teste Drive"),
        child: Column(
          children: [
            ListTile(
                title: Text(DateFormat("E, dd MMM", "pt").format(drive.startDate)),
                subtitle: Text(
                  "${DateFormat("hh:mm", "pt").format(drive.startDate)} - ${DateFormat("hh:mm", "pt").format(drive.endDate)}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                trailing: Text('${drive.distance}Km')),
          ],
        ),
      ),
    );
  }
}
