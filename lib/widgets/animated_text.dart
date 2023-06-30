import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sqlpro/notifications/slogan_notification.dart';

class SQLSlogan extends StatelessWidget {
  const SQLSlogan({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 25.0,
        ),
        child: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              'Your wish is my command',
              speed: const Duration(milliseconds: 100),
              textAlign: TextAlign.center,
            ),
            TypewriterAnimatedText(
              'What do you want from your database?',
              speed: const Duration(milliseconds: 100),
              textAlign: TextAlign.center,
            ),
          ],
          onFinished: () => SloganNotification(true).dispatch(context),
        ),
      ),
    );
  }
}
