import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/components/charge_card.dart';
import 'package:teslamate/utils/routes.dart';

class ChargesScreen extends StatefulWidget {
  const ChargesScreen({Key? key}) : super(key: key);

  @override
  State<ChargesScreen> createState() => _ChargesScreenState();
}

class _ChargesScreenState extends State<ChargesScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    Charges charges = Provider.of<Charges>(context, listen: false);
    charges.page = 1;
    charges.clearItems();
    await fetchCharges(context);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    Charges charges = Provider.of<Charges>(context, listen: false);
    charges.page += 1;
    await fetchCharges(context);
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    List<Charge> charges = Provider.of<Charges>(context, listen: false).items;
    if (charges.isEmpty) {
      fetchCharges(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Charges>(
        builder: (context, charges, child) {
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropMaterialHeader(
              backgroundColor: RoutesColors.charge,
            ),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: charges.items.isNotEmpty
                ? ListView.builder(
                    itemCount: charges.items.length,
                    itemBuilder: (context, index) {
                      return ChargeCard(charge: charges.items[index]);
                    },
                  )
                : const Center(
                    child: Text("Não existem carregamentos"),
                  ),
          );
        },
      ),
    );
  }
}
