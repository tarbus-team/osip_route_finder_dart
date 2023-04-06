import 'package:equatable/equatable.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

abstract class TransitEdge extends Equatable {
  final TransitNode from;
  final TransitNode to;

  const TransitEdge({
    required this.from,
    required this.to,
  });
  
  Duration getTotalDuration(SearchState searchState);
  
  int getDepartureTimeInMin(SearchState searchState);
}
