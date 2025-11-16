import 'package:flutter/material.dart';
import 'package:front_end/widgets/dashboard/navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Screen'),
      ),
      bottomNavigationBar: NavigateBar(),
    );
  }

}