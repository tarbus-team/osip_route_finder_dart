import 'package:equatable/equatable.dart';
import 'package:osip_route_finder_dart/src/models/node/transit_node.dart';

class SearchRequest extends Equatable {
  final TransitNode from;
  final TransitNode to;
  final DateTime dateTime;
  final double walkingSpeed;

  const SearchRequest({
    required this.from,
    required this.to,
    required this.dateTime,
    this.walkingSpeed = 50,
  });
  
  int get startTimeMin => dateTime.hour * 60 + dateTime.minute; 
  
  @override
  List<Object?> get props => [from, to, dateTime, walkingSpeed];
}
