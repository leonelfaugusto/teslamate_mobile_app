import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class MapWrapperController {
  _FlutterMapWrapperState? _state;
  bool _controllerReady = false;

  MapController? _controller;
  MapController? get controller => _controller;
  void _setController(controller) {
    _controllerReady = false;
    _controller = controller;
    _controller?.onReady.then((_) => _controllerReady = true);
  }

  MapWrapperController();

  bool get readyAndMounted => _state?.mounted == true && _controller != null && _controllerReady;
}

class FlutterMapWrapper extends StatefulWidget {
  final MapWrapperController wrapperController;
  final MapOptions options;
  final List<LayerOptions> layers;
  final List<LayerOptions> nonRotatedLayers;
  final List<Widget> children;
  final List<Widget> nonRotatedChildren;

  const FlutterMapWrapper({
    Key? key,
    required this.wrapperController,
    required this.options,
    this.layers = const [],
    this.nonRotatedLayers = const [],
    this.children = const [],
    this.nonRotatedChildren = const [],
  }) : super(key: key);

  @override
  _FlutterMapWrapperState createState() => _FlutterMapWrapperState();
}

class _FlutterMapWrapperState extends State<FlutterMapWrapper> {
  MapController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = MapController();
    widget.wrapperController._state = this;
    widget.wrapperController._setController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: widget.options,
      layers: widget.layers,
      nonRotatedLayers: widget.nonRotatedLayers,
      children: widget.children,
      nonRotatedChildren: widget.nonRotatedChildren,
      mapController: _controller,
    );
  }
}
