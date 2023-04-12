import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';
import 'package:osip_route_finder_dart/src/utils/google_coords_utils.dart';

class VehicleEdge extends TransitEdge {
  final String trackId;
  final String name;
  final int departureTimeInMin;
  final int timeToNextStopInMin;

  VehicleEdge({
    required TransitNode from,
    required TransitNode to,
    required this.trackId,
    required this.name,
    required this.departureTimeInMin,
    required this.timeToNextStopInMin,
  }) : super(
          from: from,
          to: to,
          path: [
            GoogleCoordsUtils.encodePolyline([from.latLng, to.latLng])
          ],
        );

  @override
  Duration getTotalDuration(SearchState searchState) {
    int timeBeforeState = searchState.currentTimeInMin;
    int waitingTime = departureTimeInMin - timeBeforeState;
    if( waitingTime < 0 ) {
       throw Exception('Waiting time is less than 0');
    } else if( waitingTime > 0 ) {
      return Duration(minutes: waitingTime + timeToNextStopInMin);
    } else {
      return Duration(minutes: timeToNextStopInMin);
    }
  }

  @override
  int getDepartureTimeInMin(SearchState searchState) {
    return departureTimeInMin;
  }
  
  @override
  int getTripTimeInMin(SearchState searchState) {
    return timeToNextStopInMin;
  }

  @override
  List<Object?> get props => [from, to, trackId, name, departureTimeInMin, timeToNextStopInMin];
}
