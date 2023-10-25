import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SizeMeasurer extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const SizeMeasurer({
    super.key,
    required this.onChange,
    required this.child,
  });

  @override
  State<SizeMeasurer> createState() => _SizeMeasurerState();
}

class _SizeMeasurerState extends State<SizeMeasurer> {
  final GlobalKey _key = GlobalKey();
  Size? _size;
  
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

    return Container(
      key: _key,
      child: widget.child,
    );
  }

  void postFrameCallback(_) {
    Size? newSize = _key.currentContext?.size;

    if (_size != newSize) {
      _size = newSize;
      widget.onChange(newSize);
    }
  }
}
