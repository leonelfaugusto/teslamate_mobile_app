import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/components/charge_card.dart';
import 'package:teslamate/utils/routes.dart';

class ChargesScreen extends StatefulWidget {
  const ChargesScreen({Key? key}) : super(key: key);

  @override
  State<ChargesScreen> createState() => _ChargesScreenState();
}

class _ChargesScreenState extends State<ChargesScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  List<Charge> charges = [];

  void _onRefresh() async {
    var futureCharges = await fetchCharges();
    setState(() {
      charges = futureCharges;
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const WaterDropMaterialHeader(
          backgroundColor: RoutesColors.charge,
        ),
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: charges.length,
          itemBuilder: (context, index) {
            return ChargeCard(charge: charges[index]);
          },
        ),
      ),
    );
  }
}
