// SSH Terminal removed — xterm dependency removed for MarMac build
import 'package:flutter/widgets.dart';

// Stub replacing TerminalScrollController (xterm dependency removed)
class TerminalScrollController extends ScrollController {
  TerminalScrollController(dynamic terminal);
}
