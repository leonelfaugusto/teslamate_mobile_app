import 'package:flutter/material.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/charge.dart';
import 'package:teslamate/classes/charges.dart';
import 'package:teslamate/classes/loading.dart';
import 'package:teslamate/components/charge_card.dart';

class ChargesScreen extends StatefulWidget {
  const ChargesScreen({Key? key}) : super(key: key);

  @override
  State<ChargesScreen> createState() => _ChargesScreenState();
}

class _ChargesScreenState extends State<ChargesScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    Charges charges = Provider.of<Charges>(context, listen: false);
    Loading loading = Provider.of<Loading>(context, listen: false);
    Cars cars = Provider.of<Cars>(context, listen: false);
    loading.state = true;
    charges.page = 1;
    charges.clearItems();
    cars.cars = [];
    await Future.wait([
      fetchCars(context),
      fetchCharges(context),
    ]);
    _refreshController.refreshCompleted();
    loading.state = false;
  }

  void _onLoading() async {
    Charges charges = Provider.of<Charges>(context, listen: false);
    Loading loading = Provider.of<Loading>(context, listen: false);
    loading.state = true;
    charges.page += 1;
    await fetchCharges(context);
    _refreshController.loadComplete();
    loading.state = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Consumer<Charges>(
          builder: (context, charges, child) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: const WaterDropMaterialHeader(),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: charges.items.isNotEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverGroupedListView<Charge, String>(
                          elements: charges.items,
                          groupBy: (charge) => DateFormat("yMMdd").format(charge.startDate),
                          indexedItemBuilder: (c, element, index) {
                            return ChargeCard(
                              index: index,
                            );
                          },
                          order: GroupedListOrder.DESC,
                          groupSeparatorBuilder: (value) {
                            var date = DateTime.parse(value).toLocal();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat("dd MMM, y").format(date),
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  : const Center(
                      child: Text("Não existem carregamentos"),
                    ),
            );
          },
        ),
      ),
    );
  }
}
