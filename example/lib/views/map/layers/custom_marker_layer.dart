import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class CustomMarkerLayer extends StatelessWidget {
  final List<Marker> markers;

  const CustomMarkerLayer({
    required this.markers,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: 120,
        disableClusteringAtZoom: 13,
        size: const Size(40, 40),
        fitBoundsOptions: const FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: markers,
        polygonOptions: const PolygonOptions(borderColor: Colors.transparent, color: Colors.transparent, borderStrokeWidth: 1),
        builder: (BuildContext context, List<Marker> markers) {
          return FloatingActionButton(
            onPressed: null,
            child: Text(markers.length.toString()),
          );
        },
      ),
    );
  }
}
