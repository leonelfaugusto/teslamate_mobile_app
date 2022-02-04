import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:teslamate/classes/car.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<Car>(
          builder: (context, car, child) {
            return Column(
              children: [
                Text(car.insideTemp),
                Text(car.speed),
                Text(car.isClimateOn),
                Text(car.state),
                Text(car.ltd),
                Text(car.lng),
                Text(car.heading.toString()),
                SizedBox(
                  height: 200,
                  child: OSMFlutter(
                    controller: car.map,
                    trackMyPosition: false,
                    initZoom: 16,
                    minZoomLevel: 8,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                    onMapIsReady: (p0) => car.setMapIsReady(),
                    showZoomController: true,
                    showDefaultInfoWindow: true,
                    markerOption: MarkerOption(
                      defaultMarker: MarkerIcon(
                        assetMarker: AssetMarker(
                          image: const AssetImage('lib/assets/images/tesla.png'),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
