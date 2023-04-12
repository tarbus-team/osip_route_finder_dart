import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';
import 'package:osip_route_finder_dart/src/travel_story.dart';

class AStarSearchResult extends SearchResult {
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final List<TransitEdge> transitEdges;
  final SearchRequest searchRequest;
  final SearchState searchState;

  const AStarSearchResult({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.transitEdges,
    required this.searchRequest,
    required this.searchState,
  });

  factory AStarSearchResult.constructFromSearchState(SearchState searchState) {
    SearchState currentState = searchState;
    List<TransitEdge> vehicleEdges = <TransitEdge>[];
    Duration duration = Duration(minutes: currentState.currentTimeInMin);
    print('duration: ${duration.inMinutes}');
    
    while (currentState.backState != null) {
      vehicleEdges.add(currentState.edge!);
      currentState = currentState.backState!;
    }

    
    AStarSearchResult aStarSearchResult = AStarSearchResult(
      searchState: searchState,
      startTime: searchState.searchRequest.dateTime,
      endTime: searchState.searchRequest.dateTime.copyWith(hour: duration.inMinutes ~/ 60, minute: duration.inMinutes % 60),
      duration: duration,
      transitEdges: vehicleEdges,
      searchRequest: searchState.searchRequest,
    );
    
    print('\n\n${TravelStory().tellStory(aStarSearchResult).join('\n')}');

    return aStarSearchResult;
  }

  @override
  List<Object?> get props => <Object?>[startTime, endTime];
}