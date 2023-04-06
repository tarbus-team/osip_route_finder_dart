import 'package:latlong2/latlong.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';

class StopNode extends TransitNode {
  const StopNode({
    required String id,
    required String name,
    required LatLng latLng,
  }) : super(
          id: id,
          name: name,
          latLng: latLng,
        );
  
  @override
  List<Object?> get props => <Object>[id, latLng, name];
}
