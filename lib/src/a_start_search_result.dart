import 'package:osip_route_finder_dart/src/search_result.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

class AStarSearchResult extends SearchResult {
  final int tripStartTime;
  final int tripEndTime;
  
  const AStarSearchResult({
    required this.tripStartTime,
    required this.tripEndTime,
  });
  
  factory AStarSearchResult.constructFromSearchState(SearchState searchState) {
    SearchState currentState = searchState;
    while (currentState.backState != null) {
      print(currentState);
      currentState = currentState.backState!;
    }
    
    return AStarSearchResult(
      tripStartTime: searchState.searchRequest.startTimeMin,
      tripEndTime: searchState.time
    );
  }
  
  @override
  List<Object?> get props => <Object?>[tripStartTime, tripEndTime];
}