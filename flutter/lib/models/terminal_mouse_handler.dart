// SSH Terminal removed — xterm dependency removed for MarMac build
import 'package:flutter/material.dart';

// Stub replacing TerminalMouseInteraction widget (xterm dependency removed)
class TerminalMouseInteraction extends StatelessWidget {
  const TerminalMouseInteraction(
    this.terminal, {
    super.key,
    required this.controller,
    this.focusNode,
    this.autofocus = false,
    this.backgroundOpacity = 1.0,
    this.padding,
    this.onSecondaryTapDown,
    this.textStyle,
    this.deleteDetection = false,
    this.reportTouchInput = false,
    this.shortcuts,
    this.onKeyEvent,
  });

  final dynamic terminal;
  final dynamic controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double backgroundOpacity;
  final EdgeInsets? padding;
  final void Function(dynamic, dynamic)? onSecondaryTapDown;
  final dynamic textStyle;
  final bool deleteDetection;
  final bool reportTouchInput;
  final dynamic shortcuts;
  final dynamic onKeyEvent;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('SSH Terminal not available in this build.'),
    );
  }
}

// Stub for WheelButtonFixMouseHandler
class WheelButtonFixMouseHandler {
  const WheelButtonFixMouseHandler({dynamic positionProvider, dynamic suppressLeftButton});
}
