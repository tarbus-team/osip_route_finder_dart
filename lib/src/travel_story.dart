import 'package:osip_route_finder_dart/osip_route_finder_dart.dart';
import 'package:osip_route_finder_dart/src/search_state.dart';

class TravelStory {
  final List<TravelStoryEvent> _story = <TravelStoryEvent>[];

  List<TravelStoryEvent> tellStory(AStarSearchResult aStarSearchResult) {
    SearchState currentState = aStarSearchResult.searchState;

    _story.add(EndTravelStoryEvent(endTime: aStarSearchResult.endTime));
    do {
      TransitEdge currentEdge = currentState.edge!;
      TransitEdge? previousEdge = currentState.backState?.edge;

      if (currentEdge is WalkEdge) {
        _handleWalkEdge(currentState, previousEdge);
      } else if (currentEdge is VehicleEdge) {
        _handleVehicleEdge(currentState, previousEdge);
      }

      currentState = currentState.backState!;
    } while (currentState.backState != null);

    _story.add(BeginTravelStoryEvent(startTime: aStarSearchResult.startTime));
    return _story.reversed.toList();
  }
  

  void _handleWalkEdge(SearchState currentState, TransitEdge? previousEdge) {
    _story.add(WalkTravelStoryEvent(
      startTime: currentState.departureTime,
      endTime: currentState.endTime,
      from: currentState.edge!.from,
      to: currentState.edge!.to,
    ));
    if (previousEdge is VehicleEdge) {
      _story.add(ExitVehicleTravelStoryEvent());
    }
  }

  void _handleVehicleEdge(SearchState currentState, TransitEdge? previousEdge) {
    VehicleEdge currentVehicleEdge = currentState.edge! as VehicleEdge;
    bool isPreviousVehicle = previousEdge is VehicleEdge;

    bool enterVehicle = (previousEdge is WalkEdge || previousEdge == null);
    bool stayInVehicle = isPreviousVehicle && previousEdge.trackId == currentVehicleEdge.trackId;
    bool changeVehicle = isPreviousVehicle && previousEdge.trackId != currentVehicleEdge.trackId;

    if (enterVehicle) {
      _handleStayInVehicle(currentState);
      _handleVehicleEnter(currentState);
    } else if (stayInVehicle) {
      _handleStayInVehicle(currentState);
    } else if (changeVehicle) {
      _handleVehicleChange(currentState);
    }
  }

  void _handleVehicleEnter(SearchState currentState) {
    VehicleEdge currentVehicleEdge = currentState.edge! as VehicleEdge;
    _story.add(EnterVehicleTravelStoryEvent(
      stop: currentState.edge!.from,
      time: currentState.departureTime,
      lineName: currentVehicleEdge.name,
      trackId: currentVehicleEdge.trackId,
    ));
    if (currentState.stepWaitingTime > 0) {
      _story.add(WaitTravelStoryEvent(duration: Duration(minutes: currentState.stepWaitingTime)));
    }
  }

  void _handleStayInVehicle(SearchState currentState) {
    VehicleEdge currentVehicleEdge = currentState.edge! as VehicleEdge;
    
    _story.add(StayVehicleTravelStoryEvent(
      from: currentState.edge!.from,
      to: currentState.edge!.to,
      startTime: currentState.departureTime,
      endTime: currentState.endTime,
      lineName: currentVehicleEdge.name,
      trackId: currentVehicleEdge.trackId,
    ));
  }

  void _handleVehicleChange(SearchState currentState) {
    _story.add(ExitVehicleTravelStoryEvent());
    if (currentState.stepWaitingTime > 0) {
      _story.add(WaitTravelStoryEvent(duration: Duration(minutes: currentState.stepWaitingTime)));
    }
    VehicleEdge currentVehicleEdge = currentState.edge! as VehicleEdge;
    _story.add(EnterVehicleTravelStoryEvent(
      stop: currentState.edge!.from,
      time: currentState.departureTime,
      lineName: currentVehicleEdge.name,
      trackId: currentVehicleEdge.trackId,
    ));
  }
}

abstract class TravelStoryEvent {}

class BeginTravelStoryEvent extends TravelStoryEvent {
  final DateTime startTime;

  BeginTravelStoryEvent({
    required this.startTime,
  });

  @override
  String toString() {
    return 'BeginTravelStoryEvent | $startTime';
  }
}

class EnterVehicleTravelStoryEvent extends TravelStoryEvent {
  final TransitNode stop;
  final DateTime time;
  final String lineName;
  final String trackId;

  EnterVehicleTravelStoryEvent({
    required this.stop,
    required this.time,
    required this.lineName,
    required this.trackId,
  });

  @override
  String toString() {
    return 'EnterVehicleTravelStoryEvent | $time \x1B[32m${stop.name}\x1B[0m | \x1B[33m$lineName\x1B[0m | \x1B[34m$trackId\x1B[0m';
  }
}

class StayVehicleTravelStoryEvent extends TravelStoryEvent {
  final TransitNode from;
  final TransitNode to;
  final DateTime startTime;
  final DateTime endTime;
  final String lineName;
  final String trackId;

  StayVehicleTravelStoryEvent({
    required this.from,
    required this.to,
    required this.startTime,
    required this.endTime,
    required this.lineName,
    required this.trackId,
  });

  @override
  String toString() {
    return 'StayVehicleTravelStoryEvent | \x1B[33m$lineName\x1B[0m | \x1B[34m$trackId\x1B[0m | $startTime \x1B[32m${from.name}\x1B[0m -> $endTime \x1B[31m${to.name}\x1B[0m';
  }
}

class ExitVehicleTravelStoryEvent extends TravelStoryEvent {}

class WalkTravelStoryEvent extends TravelStoryEvent {
  final DateTime startTime;
  final DateTime endTime;
  final TransitNode from;
  final TransitNode to;

  WalkTravelStoryEvent({
    required this.startTime,
    required this.endTime,
    required this.from,
    required this.to,
  });

  @override
  String toString() {
    return 'WalkTravelStoryEvent | $startTime \x1B[32m${from.name}\x1B[0m -> $endTime \x1B[31m${to.name}\x1B[0m';
  }
}

class WaitTravelStoryEvent extends TravelStoryEvent {
  final Duration duration;

  WaitTravelStoryEvent({
    required this.duration,
  });

  @override
  String toString() {
    return 'WaitTravelStoryEvent | $duration';
  }
}

class EndTravelStoryEvent extends TravelStoryEvent {
  final DateTime endTime;

  EndTravelStoryEvent({
    required this.endTime,
  });

  @override
  String toString() {
    return 'EndTravelStoryEvent | $endTime';
  }
}
