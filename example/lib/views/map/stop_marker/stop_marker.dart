import 'package:example/views/map/stop_marker/stop_marker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';

class StopMarker extends Marker {
  final TransitNode transitNode;
  final VoidCallback onTap;

  StopMarker({
    required this.transitNode,
    required this.onTap,
    WidgetBuilder? builder,
    double width = 30.0,
    double height = 30.0,
  }) : super(
          point: transitNode.latLng,
          width: width,
          height: height,
          anchorPos: AnchorPos.align(AnchorAlign.center),
          builder: builder ?? (_) => StopMarkerWidget(transitNode: transitNode, onTap: onTap),
        );
}
