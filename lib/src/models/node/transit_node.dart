import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class TransitNode extends Equatable {
  final String id;
  final String name;
  final LatLng latLng;

  const TransitNode({
    required this.id,
    required this.name,
    required this.latLng,
  });
}