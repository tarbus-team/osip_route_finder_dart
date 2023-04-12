import 'dart:async';

import 'package:example/bloc/search_result_state.dart';
import 'package:example/bloc/search_state.dart';
import 'package:example/infra/service/graph_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';

enum NodeSelectType {
  from,
  to
}

class SearchCubit extends Cubit<SearchState> {
  final GraphService graphService = GraphService();
  
  SearchCubit() : super(SearchState(
    dateTime: DateTime(2023, 1, 1, 6, 0),
  ));
  
  Future<void> init() async {
    MultiGraph multiGraph = await graphService.getFullTransitsGraph();
    emit(state.copyWith(multiGraph: multiGraph));
  }
  
  void setFrom(TransitNode transitNode) {
    emit(state.copyWith(from: transitNode));
  }
  
  void setTo(TransitNode transitNode) {
    emit(state.copyWith(to: transitNode));
  }
  
  void setNode(TransitNode transitNode) {
    switch(state.nodeSelectType) {
      case NodeSelectType.from:
        setFrom(transitNode);
        break;
      case NodeSelectType.to:
        setTo(transitNode);
        break;
    }
  }
  
  void setNodeSelectType(NodeSelectType nodeSelectType) {
    emit(state.copyWith(nodeSelectType: nodeSelectType));
  }
  
  void setDateTime(DateTime dateTime) {
    emit(state.copyWith(dateTime: dateTime));
  }
  
  Future<void> search() async {
    if( state.isReady == false) {
      return;
    }
    AStarSearchAlgorithm aStarSearchAlgorithm = AStarSearchAlgorithm();
    SearchRequest searchRequest = SearchRequest(
      from: state.from!,
      to: state.to!,
      dateTime: state.dateTime,
    );
    AStarSearchResult aStarSearchResult = await aStarSearchAlgorithm.process(state.multiGraph!, searchRequest);
    emit(SearchResultState.fromSearchState(state, aStarSearchResult));
  }
}