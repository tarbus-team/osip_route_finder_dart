import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

abstract class PenaltyStrategy {
  double calcPenalty(SearchState searchState, TransitEdge transitEdge);
}
