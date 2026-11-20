import 'package:flutter/material.dart';

import '../../common.dart';

// QR Scanner removed (qr_code_scanner and zxing2 dependencies removed)
class ScanPage extends StatefulWidget {
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
      ),
      body: Center(
        child: Text(translate('QR scanning not available')),
      ),
    );
  }
}
