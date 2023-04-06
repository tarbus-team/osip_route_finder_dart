import 'package:equatable/equatable.dart';
import 'package:example/bloc/search_cubit.dart';
import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';

class SearchState extends Equatable {
  final MultiGraph? multiGraph;
  final TransitNode? from;
  final TransitNode? to;
  final DateTime dateTime;
  final NodeSelectType nodeSelectType;

  SearchState({
    this.multiGraph,
    this.from,
    this.to,
    this.nodeSelectType = NodeSelectType.from,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();
  
  SearchState copyWith({
    MultiGraph? multiGraph,
    TransitNode? from,
    TransitNode? to,
    DateTime? dateTime,
    NodeSelectType? nodeSelectType,
  }) {
    return SearchState(
      multiGraph: multiGraph ?? this.multiGraph,
      from: from ?? this.from,
      to: to ?? this.to,
      dateTime: dateTime ?? this.dateTime,
      nodeSelectType: nodeSelectType ?? this.nodeSelectType,
    );
  }
  
  bool get isReady => multiGraph != null && from != null && to != null && dateTime != null;
  
  @override
  List<Object?> get props => <Object?>[multiGraph, from, to, dateTime, nodeSelectType];
}
