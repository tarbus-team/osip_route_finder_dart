import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

class WalkEdge extends TransitEdge {
  final int distanceInMeters;
  final List<String> polylines;

  const WalkEdge({
    required TransitNode from,
    required TransitNode to,
    required this.distanceInMeters,
    required this.polylines,
  }) : super(from: from, to: to);

  @override
  Duration getTotalDuration(SearchState searchState) {
    return Duration(seconds: distanceInMeters ~/ searchState.searchRequest.walkingSpeed);
  }

  @override
  int getDepartureTimeInMin(SearchState searchState) {
    return searchState.time;
  }

  @override
  List<Object?> get props => [from, to, distanceInMeters, polylines];
}
