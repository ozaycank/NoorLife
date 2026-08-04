import 'package:flutter/material.dart';

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NoorLife')),
      body: const Center(
        child: Text('Foundation Architecture Initialized Successfully.'),
      ),
    );
  }
}
