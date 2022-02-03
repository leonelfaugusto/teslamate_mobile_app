import 'package:flutter/material.dart';
import 'package:teslamate/classes/Charge.dart';

class ChargeCard extends StatelessWidget {
  final Charge charge;
  const ChargeCard({Key? key, required this.charge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => print("teste"),
        child: Column(
          children: [
            ListTile(
                title: const Text("20/03/2022"),
                subtitle: Text(
                  '14:30 - 14:30',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                trailing: Text('${charge.batteryDiff}%')),
          ],
        ),
      ),
    );
  }
}
