import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teslamate/classes/drive.dart';
import 'package:teslamate/components/drive_card.dart';
import 'package:teslamate/utils/routes.dart';

class DrivesScreen extends StatefulWidget {
  const DrivesScreen({Key? key}) : super(key: key);

  @override
  State<DrivesScreen> createState() => _DrivesScreenState();
}

class _DrivesScreenState extends State<DrivesScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  List<Drive> drives = [];

  void _onRefresh() async {
    var futureDrives = await fetchDrives();
    setState(() {
      drives = futureDrives;
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
          backgroundColor: RoutesColors.drive,
        ),
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: drives.length,
          itemBuilder: (context, index) {
            return DriveCard(drive: drives[index]);
          },
        ),
      ),
    );
  }
}
