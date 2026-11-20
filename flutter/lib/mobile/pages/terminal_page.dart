// SSH Terminal removed — xterm dependency removed for MarMac build
import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({
    Key? key,
    required this.id,
    required this.password,
    required this.isSharedPassword,
    this.forceRelay,
    this.connToken,
    this.loginMethod = '',
  }) : super(key: key);
  final String id;
  final String loginMethod;
  final String? password;
  final bool? forceRelay;
  final bool? isSharedPassword;
  final String? connToken;
  final terminalId = 0;

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate('SSH Terminal'))),
      body: Center(
        child: Text(translate('SSH Terminal not available in this build.')),
      ),
    );
  }
}
