import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF79C7DF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: const Center(
        child: Text(
          'Интернэт холболтоо шалгана уу...',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
            letterSpacing: 0.5,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
