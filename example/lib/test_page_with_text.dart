import 'package:flutter/material.dart';

class TestPageWithText extends StatefulWidget {
  const TestPageWithText({
    super.key,
  });

  @override
  State<TestPageWithText> createState() => _TestPageWithTextState();
}

class _TestPageWithTextState extends State<TestPageWithText> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(),
            ),
          ],
        ),
      ),
    );
  }
}
