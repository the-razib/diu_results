import 'package:flutter/material.dart';

class SgpaCalculator extends StatefulWidget {
  const SgpaCalculator({super.key});

  @override
  State<SgpaCalculator> createState() => _SgpaCalculatorState();
}

class _SgpaCalculatorState extends State<SgpaCalculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SGPA Calculator'),
      ),
      body: Center(
        child: Text('SGPA Calculator'),
      ),
    );
  }
}
