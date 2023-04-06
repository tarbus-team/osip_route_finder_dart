import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

class VehicleEdge extends TransitEdge {
  final String trackId;
  final String name;
  final int departureTimeInMin;
  final int timeToNextStopInMin;

  const VehicleEdge({
    required TransitNode from,
    required TransitNode to,
    required this.trackId,
    required this.name,
    required this.departureTimeInMin,
    required this.timeToNextStopInMin,
  }) : super(from: from, to: to);

  @override
  Duration getTotalDuration(SearchState searchState) {
    int currentTime = searchState.time;
    int waitingTime = departureTimeInMin - currentTime;
    
    return Duration(minutes: waitingTime + timeToNextStopInMin);
  }
  
  @override
  int getDepartureTimeInMin(SearchState searchState) {
    return departureTimeInMin;
  }

  @override
  List<Object?> get props => [from, to, trackId, name, departureTimeInMin, timeToNextStopInMin];
}
