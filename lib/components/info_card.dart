import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    this.icon,
    required this.info,
  }) : super(key: key);

  final IconData? icon;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 30,
              ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                info,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
