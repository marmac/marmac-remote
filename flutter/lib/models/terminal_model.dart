// SSH Terminal removed — xterm dependency removed for MarMac build
import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/consts.dart';
import 'rustdesk_terminal.dart';

export 'terminal_copy_shortcut.dart'
    show
        TerminalClipboardWriter,
        TerminalClipboardNoticeRequest,
        TerminalClipboardNoticeCoordinator,
        kTerminalClipboardNoticeMessageKey,
        completeTerminalClipboardWrite,
        canConfigureTerminalClipboardPermission,
        canHandleTerminalClipboardWriteRequest,
        platformTerminalShortcuts;

// Stub terminal and controller types replacing xterm
class _StubBuffer {
  String getText(dynamic selection) => '';
}

class _StubTerminal {
  void Function(String)? onOutput;
  void Function(int, int, int, int)? onResize;
  int viewWidth = 0;
  int viewHeight = 0;
  bool bracketedPasteMode = false;
  bool isUsingAltBuffer = false;
  final buffer = _StubBuffer();
  void write(String text) {}
  void paste(String text) {}
  void textInput(String text) {}
}

class _StubTerminalController {
  dynamic selection;
  void clearSelection() {}
}

TerminalClipboardWritePermission terminalClipboardWritePermission(
  String localOption, {
  required bool remoteClipboardEnabled,
  bool canRequestConsent = true,
}) =>
    TerminalClipboardWritePermission.denied;

class TerminalModel with ChangeNotifier {
  final String id;
  final dynamic parent;
  final int terminalId;
  final _terminal = _StubTerminal();
  final _controller = _StubTerminalController();

  bool _disposed = false;

  bool Function()? isCtrlLocked;
  void Function()? clearCtrlLock;
  bool Function()? isAltLocked;
  void Function()? clearAltLock;

  void Function(int w, int h, int pw, int ph)? onResizeExternal;
  VoidCallback? onClosed;
  ValueChanged<String>? onClipboardWriteBlocked;
  ValueChanged<String>? onClipboardWriteSucceeded;

  // Expose stub terminal/controller with the same names as before
  _StubTerminal get terminal => _terminal;
  _StubTerminalController get terminalController => _controller;

  bool get terminalOpened => false;

  TerminalModel(this.parent, [this.terminalId = 0]) : id = parent.id;

  static int getTerminalIdFromEvt(Map<String, dynamic> evt) {
    final v = evt['terminal_id'];
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static bool getSuccessFromEvt(Map<String, dynamic> evt) {
    final v = evt['success'];
    if (v is bool) return v;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }

  static int getExitCodeFromEvt(Map<String, dynamic> evt) {
    final v = evt['exit_code'];
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  void onReady() {}
  Future<void> openTerminal({bool force = false}) async {}
  Future<void> closeTerminal() async {}
  Future<void> sendVirtualKey(String data) async {}
  Future<void> pasteText(String data) async {}
  void handleTerminalResponse(Map<String, dynamic> evt) {}

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    isCtrlLocked = null;
    clearCtrlLock = null;
    isAltLocked = null;
    clearAltLock = null;
    onResizeExternal = null;
    onClosed = null;
    onClipboardWriteBlocked = null;
    onClipboardWriteSucceeded = null;
    super.dispose();
  }
}

Future<bool> writeTerminalClipboard(
  String text, {
  bool userInitiated = false,
}) async =>
    false;
