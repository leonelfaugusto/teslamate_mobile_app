import 'package:flutter/material.dart';
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/components/drive_card.dart';

class DrivesScreen extends StatefulWidget {
  const DrivesScreen({Key? key}) : super(key: key);

  @override
  State<DrivesScreen> createState() => _DrivesScreenState();
}

class _DrivesScreenState extends State<DrivesScreen> {
  late Future<List<Drive>> futureDrives;

  @override
  void initState() {
    super.initState();
    futureDrives = fetchDrives();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: FutureBuilder<List<Drive>>(
        future: futureDrives,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return DriveCard(drive: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
