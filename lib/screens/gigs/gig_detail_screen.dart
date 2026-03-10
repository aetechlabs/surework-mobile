import 'package:flutter/material.dart';

class GigDetailScreen extends StatelessWidget {
  final String gigId;
  
  const GigDetailScreen({super.key, required this.gigId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gig Details')),
      body: Center(
        child: Text('Gig Detail Screen - Gig ID: $gigId'),
      ),
    );
  }
}
