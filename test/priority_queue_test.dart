import 'package:flutter_test/flutter_test.dart';
import 'package:osip_route_finder_dart/src/utils/priority_queue.dart';

void main() {
  test('', (){
    PriorityQueue<String> priorityQueue = PriorityQueue<String>();
    
    priorityQueue.add('a', 1);
    priorityQueue.add('b', 2);
    priorityQueue.add('c', 3);
    
    expect(priorityQueue.pop().value, 'a');
    expect(priorityQueue.pop().value, 'b');
    expect(priorityQueue.pop().value, 'c');
  });
  
  test('', (){
    PriorityQueue<String> priorityQueue = PriorityQueue<String>();
    
    priorityQueue.add('a', 3);
    priorityQueue.add('b', 2);
    priorityQueue.add('c', 1);
    
    expect(priorityQueue.pop().value, 'c');
    expect(priorityQueue.pop().value, 'b');
    expect(priorityQueue.pop().value, 'a');
  });
}