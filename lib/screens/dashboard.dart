import 'package:flutter/material.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/components/charge_card.dart';
import 'package:teslamate/components/drive_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Charge>> futureCharge;
  late Future<List<Drive>> futureDrive;

  @override
  void initState() {
    super.initState();
    futureCharge = fetchCharges();
    futureDrive = fetchDrives();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Charges",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              FutureBuilder<List<Charge>>(
                future: fetchCharges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ChargeCard(
                          charge: snapshot.data![0],
                        ),
                        ChargeCard(
                          charge: snapshot.data![1],
                        ),
                        ChargeCard(
                          charge: snapshot.data![2],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Drives",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              FutureBuilder<List<Drive>>(
                future: fetchDrives(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        DriveCard(
                          drive: snapshot.data![0],
                        ),
                        DriveCard(
                          drive: snapshot.data![1],
                        ),
                        DriveCard(
                          drive: snapshot.data![2],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
