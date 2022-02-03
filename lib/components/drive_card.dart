import 'package:flutter/material.dart';

class DriveCard extends StatelessWidget {
  const DriveCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => print("teste Drive"),
        child: Column(
          children: [
            ListTile(
                title: const Text("20/03/2022"),
                subtitle: Text(
                  '14:30 - 14:30',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                trailing: const Text("200Km")),
          ],
        ),
      ),
    );
  }
}
