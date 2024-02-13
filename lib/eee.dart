import 'dart:async';

import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  bool active = false;
  Timer? timer;
  Timer? refresh;
  Stopwatch stopwatch = Stopwatch();
  Duration duration = const Duration(seconds: 5);

  _CountdownState() {
    // this is just so the time remaining text is updated
    refresh = Timer.periodic(const Duration(milliseconds: 100), (_) => setState(() {}));
  }

  void start() {
    setState(() {
      active = true;
      timer = Timer(duration, () {
        stop();
        onCountdownComplete();
      });
      stopwatch
        ..reset()
        ..start();
    });
  }

  void stop() {
    setState(() {
      active = false;
      timer?.cancel();
      stopwatch.stop();
    });
  }

  void onCountdownComplete() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Countdown was not stopped!'),
      ),
    );
  }

  int secondsRemaining() {
    return duration.inSeconds - stopwatch.elapsed.inSeconds;
  }

  @override
  void dispose() {
    timer?.cancel();
    refresh?.cancel();
    stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (active) Text(secondsRemaining().toString()),
        if (active) TextButton(onPressed: stop, child: const Text('Stop')) else TextButton(onPressed: start, child: const Text('Start')),
      ],
    );
  }
}
