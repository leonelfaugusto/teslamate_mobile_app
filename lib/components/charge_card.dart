import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/utils/routes.dart';

class ChargeCard extends StatelessWidget {
  final int index;
  const ChargeCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Charge charge = Provider.of<Charges>(context, listen: false).items[index];
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.charge,
            arguments: index,
          );
        },
        child: Column(
          children: [
            ListTile(
                title: Text(DateFormat("d MMMM y").format(charge.startDate)),
                subtitle: Text(
                  "${DateFormat("HH:mm").format(charge.startDate)} - ${DateFormat("HH:mm").format(charge.endDate)}",
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
