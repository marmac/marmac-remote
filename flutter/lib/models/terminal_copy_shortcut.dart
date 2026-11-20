// SSH Terminal removed — xterm dependency removed for MarMac build
import 'package:flutter/widgets.dart';

// Stubs replacing xterm types (xterm dependency removed)
typedef TerminalClipboardWriter = Future<bool> Function(
  String text, {
  required bool userInitiated,
});

class TerminalClipboardNoticeRequest<T> {
  const TerminalClipboardNoticeRequest({
    required this.source,
    required this.text,
    required this.persistAllowed,
  });
  final T source;
  final String text;
  final bool persistAllowed;
  String get actionKey => persistAllowed ? 'Enable' : 'Copy to clipboard';
  String get negativeActionKey => persistAllowed ? 'Decline' : 'Dismiss';
}

const kTerminalClipboardNoticeMessageKey = 'terminal-clipboard-write-tip';

class TerminalClipboardNoticeCoordinator<T> extends ChangeNotifier {
  TerminalClipboardNoticeRequest<T>? _current;

  TerminalClipboardNoticeRequest<T>? get current => _current;
  bool get canClaimAction => false;

  TerminalClipboardNoticeRequest<T>? currentForSource(T source) => null;

  TerminalClipboardNoticeRequest<T>? recordBlocked({
    required T source,
    required String text,
    required String option,
    required bool Function(T source) canWrite,
  }) => null;

  TerminalClipboardNoticeRequest<T>? claimCurrentAction() => null;
  void releaseAction() {}
  bool beginClose() => false;
  void noticeClosed() => clear();
  void clear() { _current = null; }
}

Future<bool> writeTerminalClipboard(
  String text, {
  bool userInitiated = false,
}) async => false;

Future<bool> completeTerminalClipboardWrite({
  required String clipboardText,
  required bool Function() canWrite,
  required TerminalClipboardWriter writeClipboard,
  Future<void> Function()? persistAllowed,
}) async => false;

Map<ShortcutActivator, Intent>? platformTerminalShortcuts() => null;

FocusOnKeyEventCallback terminalCopyHandler(
  dynamic terminal,
  dynamic controller, {
  FocusOnKeyEventCallback? fallback,
}) =>
    (focusNode, event) =>
        fallback?.call(focusNode, event) ?? KeyEventResult.ignored;

bool canConfigureTerminalClipboardPermission({
  required bool settingsDisabled,
  required bool optionFixed,
}) => false;

bool canHandleTerminalClipboardWriteRequest({
  required String localOption,
  required bool canConfigurePermission,
}) => false;
