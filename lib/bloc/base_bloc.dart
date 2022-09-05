import 'package:rxdart/rxdart.dart';

class BaseBloc extends Object {


  int get defaultFetchLimit => 10;
  int get defaultFetchLimitChatMessage => 20;
  bool isApiCallDone = false;

  String getValue(BehaviorSubject<String> subject) {
    if(subject.hasValue) return subject.value;
    return '';
  }

  void dispose() {
    print('------------------- ${this} Dispose ------------------- ');
  }

}