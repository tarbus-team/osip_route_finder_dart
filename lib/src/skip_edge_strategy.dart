import 'package:osip_route_finder_dart/src/models/edge/walk_edge.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';
import 'package:osip_route_finder_dart/src/models/edge/transit_edge.dart';

abstract class SkipEdgeStrategy {
  bool shouldSkipEdge(SearchState state, TransitEdge edge);
} 

class DefaultSkipEdgeStrategy implements SkipEdgeStrategy {
  const DefaultSkipEdgeStrategy();
  
  @override
  bool shouldSkipEdge(SearchState state, TransitEdge edge) {
    int departureTime = edge.getDepartureTimeInMin(state);
    bool timeOverflows = departureTime != - 1 && state.time > departureTime;

    bool secondWalk = state.previousEdge is WalkEdge && edge is WalkEdge;
    
    if(secondWalk || timeOverflows) {
      return true;
    }
    return false;
  }
}