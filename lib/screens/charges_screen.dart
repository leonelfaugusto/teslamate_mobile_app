import 'package:flutter/material.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/components/charge_card.dart';

class ChargesScreen extends StatefulWidget {
  const ChargesScreen({Key? key}) : super(key: key);

  @override
  State<ChargesScreen> createState() => _ChargesScreenState();
}

class _ChargesScreenState extends State<ChargesScreen> {
  late Future<List<Charge>> futureCharges;

  @override
  void initState() {
    super.initState();
    futureCharges = fetchCharges();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: FutureBuilder<List<Charge>>(
        future: futureCharges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ChargeCard(charge: snapshot.data![index]);
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
