import 'dart:async';
import 'package:flutter/cupertino.dart';

class TimerWidget extends StatefulWidget {
  late int _H;
  late int _M;
  late int _S;
  bool _done = false;
  bool _loading = true;

  TimerWidget(this._H, this._M, this._S, {super.key});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();

  void stopTimer() {
    _done = true;
  }

  void startTimer() {
    _loading = false;
  }

  int get H => _H;
  int get M => _M;
  int get S => _S;
}

class _TimerWidgetState extends State<TimerWidget>{

  @override
  void initState() {
    iniTimer();
    super.initState();
  }

  void iniTimer() {
    while(widget._loading){}
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!widget._done) {
        _updateTimer();
      } else {
        timer.cancel();
      }
    });
  }
  void _updateTimer() {
    widget._S++;
    if( widget._S == 60) {
      widget._S = 0;
      widget._M++;
    }
    if(widget._M == 60) {
      widget._M = 0;
      widget._H++;
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    String text;
    if (widget._H == 0){
      if (widget._M == 0){
        text = "${widget._S}S";
      } else {
        text = "${widget._M}M ${widget._S}S";
      }
    } else {
      text = "${widget._H}H ${widget._M}M ${widget._S}S";
    }
    return Text(text, style: const TextStyle(fontSize: 16),);
  }
}

