import 'package:equatable/equatable.dart';

class PriorityQueue<T> {
  final List<PriorityQueueElement<T>> _queue = List<PriorityQueueElement<T>>.empty(growable: true);

  PriorityQueueElement<T> pop() {
    PriorityQueueElement<T> removedElement = _queue.removeAt(0);
    return removedElement;
  }

  void clear() {
    _queue.clear();
  }

  bool get isEmpty {
    return _queue.isEmpty;
  }

  bool get isNotEmpty {
    return _queue.isNotEmpty;
  }

  int get length => _queue.length;

  /// Add a new item to the queue and ensure the highest priority element
  /// is at the front of the queue.
  void add(T value, double cost) {
    PriorityQueueElement<T> element = PriorityQueueElement<T>(value: value, priority: cost);
    _queue
      ..add(element)
      ..sort((PriorityQueueElement<T> a, PriorityQueueElement<T> b) {
        if( a.priority == double.infinity || b.priority == double.infinity) {
          return -1;
        }
        return a.priority.compareTo(b.priority);
      });
  }
}

class PriorityQueueElement<T> extends Equatable {
  final T value;
  final double priority;

  const PriorityQueueElement({
    required this.value,
    required this.priority,
  });

  @override
  List<Object?> get props => <Object?>[value, priority];
}
