import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/classes/drives.dart';
import 'package:teslamate/components/drive_card.dart';
import 'package:teslamate/utils/routes.dart';

class DrivesScreen extends StatefulWidget {
  const DrivesScreen({Key? key}) : super(key: key);

  @override
  State<DrivesScreen> createState() => _DrivesScreenState();
}

class _DrivesScreenState extends State<DrivesScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    Drives drives = Provider.of<Drives>(context, listen: false);
    drives.page = 1;
    drives.clearItems();
    await fetchDrives(context);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    Drives drives = Provider.of<Drives>(context, listen: false);
    drives.page += 1;
    await fetchDrives(context);
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    List<Drive> charges = Provider.of<Drives>(context, listen: false).items;
    if (charges.isEmpty) {
      fetchDrives(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Drives>(
        builder: (context, drives, child) {
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropMaterialHeader(
              backgroundColor: RoutesColors.drive,
            ),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: drives.items.isNotEmpty
                ? ListView.builder(
                    itemCount: drives.items.length,
                    itemBuilder: (context, index) {
                      return DriveCard(drive: drives.items[index]);
                    },
                  )
                : const Center(
                    child: Text("Não existem percursos"),
                  ),
          );
        },
      ),
    );
  }
}
