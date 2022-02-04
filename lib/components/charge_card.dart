import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/utils/routes.dart';

class ChargeCard extends StatelessWidget {
  final Charge charge;
  const ChargeCard({Key? key, required this.charge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.charge,
            arguments: charge,
          );
        },
        child: Column(
          children: [
            ListTile(
                title: Text(DateFormat("d MMMM y", "pt").format(charge.startDate)),
                subtitle: Text(
                  "${DateFormat("HH:mm", "pt").format(charge.startDate)} - ${DateFormat("HH:mm", "pt").format(charge.endDate)}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${charge.batteryDiff}%'),
                    Text(charge.address),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
