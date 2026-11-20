// SSH Terminal removed — xterm dependency removed for MarMac build

enum TerminalClipboardWritePermission { denied, unconfigured, allowed }

// Stub replacing RustDeskTerminal (xterm dependency removed)
class RustDeskTerminal {
  RustDeskTerminal({
    int? maxLines,
    required TerminalClipboardWritePermission Function()
        clipboardWritePermission,
    required Future<bool> Function(String) onClipboardWrite,
    void Function(String)? onClipboardWriteBlocked,
    void Function(String)? onClipboardWriteSucceeded,
  });
}
