import 'package:flutter/material.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/cars.dart';
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/classes/loading.dart';
import 'package:teslamate/components/drive_card.dart';

class DrivesScreen extends StatefulWidget {
  const DrivesScreen({Key? key}) : super(key: key);

  @override
  State<DrivesScreen> createState() => _DrivesScreenState();
}

class _DrivesScreenState extends State<DrivesScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    Drives drives = Provider.of<Drives>(context, listen: false);
    Loading loading = Provider.of<Loading>(context, listen: false);
    Cars cars = Provider.of<Cars>(context, listen: false);
    loading.state = true;
    drives.page = 1;
    drives.clearItems();
    cars.cars = [];
    await Future.wait([
      fetchCars(context),
      fetchDrives(context),
    ]);
    _refreshController.refreshCompleted();
    loading.state = false;
  }

  void _onLoading() async {
    Drives drives = Provider.of<Drives>(context, listen: false);
    Loading loading = Provider.of<Loading>(context, listen: false);
    loading.state = true;
    drives.page += 1;
    await fetchDrives(context);
    _refreshController.loadComplete();
    loading.state = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Consumer<Drives>(
          builder: (context, drives, child) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: const WaterDropMaterialHeader(),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: drives.items.isNotEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverGroupedListView<Drive, String>(
                          elements: drives.items,
                          groupBy: (drive) => DateFormat("yMMdd").format(drive.startDate),
                          indexedItemBuilder: (c, element, index) {
                            return DriveCard(
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
                      child: Text("Não existem percursos"),
                    ),
            );
          },
        ),
      ),
    );
  }
}
