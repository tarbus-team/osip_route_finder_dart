import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/models/algorithms/haversine_alghoritm.dart';
import 'package:osip_route_finder_dart/src/models/heuristic/heuristic.dart';

class HaversineHeuristic implements Heuristic {
  const HaversineHeuristic();
  
  @override
  double calc(TransitNode a, TransitNode b) {
    return HaversineAlgorithm.calcDistance(a.latLng, b.latLng).inKilometers;
  }
}