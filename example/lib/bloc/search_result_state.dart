import 'package:example/bloc/search_state.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';

class SearchResultState extends SearchState {
  final SearchResult searchResult;
  
  SearchResultState({
    required this.searchResult,
    required MultiGraph multiGraph,
    required TransitNode from,
    required TransitNode to,
    required DateTime dateTime,
  }) : super(
          multiGraph: multiGraph,
          from: from,
          to: to,
          dateTime: dateTime,
        );
  
  factory SearchResultState.fromSearchState(SearchState searchState, SearchResult searchResult) {
    return SearchResultState(
      searchResult: searchResult,
      multiGraph: searchState.multiGraph!,
      from: searchState.from!,
      to: searchState.to!,
      dateTime: searchState.dateTime!,
    );
  }
  
  @override
  List<Object?> get props => <Object?>[searchResult, multiGraph, from, to, dateTime];
}