import 'package:example/views/map/layers/custom_marker_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GraphMap extends StatelessWidget {
  final List<Marker> markers;

  const GraphMap({
    required this.markers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(50.012100, 20.985842),
        zoom: 9.2,
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        // CustomPolylineLayer(mapPolylinesCubit: mapCubit.mapPolylinesCubit),
        CustomMarkerLayer(markers: markers),
        // CustomDraggableMarkerLayer(mapMarkersCubit: mapCubit.mapMarkersCubit, mapPolylinesCubit: mapCubit.mapPolylinesCubit),
      ],
    );
  }
}
