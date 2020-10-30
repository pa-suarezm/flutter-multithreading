import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyViewModel extends ChangeNotifier {
  static double _maxCnt = 300000000.0; //300_000_000

  static int _timeSeq = 0;
  static int _timeCon = 0;

  static double _cntSeq1 = 0.0;
  static double _cntSeq2 = 0.0;

  static double _cntCon1 = 0.0;
  static double _cntCon2 = 0.0;


  //----------------------------------------------------------------------------
  //This will be run by the 'Sequential' button
  Future<void> executeSeq() async {
    _timeSeq = 0;
    _cntSeq1 = null;
    _cntSeq2 = 0.0;
    notifyListeners();

    //Port to receive the message from the Isolate when execution is done
    var receivePort = new ReceivePort();

    final stopwatch = Stopwatch();
    stopwatch.start();

    //This code must run on an Isolated thread to not interrupt the main thread
    //Nonetheless, the process itself is sequential
    Isolate.spawn(_meaninglessCounterSeq1, receivePort.sendPort);
    await for (var retMsg in receivePort) {
      //When seq1 is done, seq2 launches
      if(retMsg[0] == "seq1Done") {
        _cntSeq1 = 1.0;
        _cntSeq2 = null;
        notifyListeners();
        Isolate.spawn(_meaninglessCounterSeq2, receivePort.sendPort);
      }
      //This runs after second process is done
      else if(retMsg[0] == "seq2Done") {
        stopwatch.stop();
        _cntSeq2 = 1.0;
        _timeSeq = stopwatch.elapsedMilliseconds;
        notifyListeners();
      }
    }
  }

  static void _meaninglessCounterSeq1(SendPort port) {
    double aux;
    double ans;
    for(aux = 1.0; aux <= _maxCnt; aux+=1) {
      ans = aux/_maxCnt;
    }
    port.send(["seq1Done", ans]);
  }

  static void _meaninglessCounterSeq2(SendPort port) {
    double aux;
    double ans;
    for(aux = 1.0; aux <= _maxCnt; aux+=1) {
      ans = aux/_maxCnt;
    }
    port.send(["seq2Done", ans]);
  }

  //----------------------------------------------------------------------------
  //This will be run by the 'Concurrent' button
  Future<void> executeCon() async {
    final stopwatch = Stopwatch();

    _timeCon = 0;
    _cntCon1 = 0.0;
    _cntCon2 = 0.0;

    notifyListeners();

    //Port to receive the message from the Isolates when execution is done
    var receivePort = new ReceivePort();

    stopwatch.start();

    _cntCon1 = null;
    notifyListeners();
    //Runs the code on different threads allowing for concurrency
    Isolate.spawn(_meaninglessCounterCon1, receivePort.sendPort);

    _cntCon2 = null;
    notifyListeners();
    //Runs the code on different threads allowing for concurrency
    Isolate.spawn(_meaninglessCounterCon2, receivePort.sendPort);

    var con1Finished = false;
    var con2Finished = false;

    //When the messages form the thread get through and say execution finished
    await for (var retMsg in receivePort) {
      if(retMsg[0] == "con1") {
        _cntCon1 = 1.0;
        notifyListeners();
        con1Finished = true;
      }
      else if(retMsg[0] == "con2") {
        _cntCon2 = 1.0;
        notifyListeners();
        con2Finished = true;
      }

      if(con1Finished && con2Finished) {
        stopwatch.stop();
        _timeCon = stopwatch.elapsedMilliseconds;
        notifyListeners();
      }
    }

  }

  //Needs to be static for Isolate.spawn to take it
  static void _meaninglessCounterCon1(SendPort port){
    double aux;

    for(aux = 1.0; aux <= _maxCnt; aux+=1) {
      _cntCon1 = aux/_maxCnt;
    }

    port.send(["con1", aux]);
  }

  //Needs to be static for Isolate.spawn to take it
  static void _meaninglessCounterCon2(SendPort port) {
    double aux;

    for(aux = 1.0; aux <= _maxCnt; aux+=1) {
      _cntCon2 = aux/_maxCnt;
    }

    port.send(["con2", aux]);
  }
  //----------------------------------------------------------------------------

  //These getters (getTime and getCnt) are a TERRIBLE practice
  //There are way better ways to do these
  //But, for the purposes of this example, it's good enough

  int getTime(String item)
  {
    switch(item) {
      case '_timeSeq': {
        return _timeSeq;
      }
      break;

      case '_timeCon': {
        return _timeCon;
      }
      break;

      default: {
        return -1;
      }
      break;
    }
  }

  double getCnt(String item)
  {
    switch(item) {
      case '_cntSeq1': {
        return _cntSeq1;
      }
      break;

      case '_cntSeq2': {
        return _cntSeq2;
      }
      break;

      case '_cntCon1': {
        return _cntCon1;
      }
      break;

      case '_cntCon2': {
        return _cntCon2;
      }
      break;

      default: {
        return -1.0;
      }
      break;
    }
  }

}