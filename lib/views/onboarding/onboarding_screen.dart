import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:iot_smart_bulbs/views/device_list_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [
          OnboardingPage(
            title: "Benvenuto in",
            subtitle: "IoT Smart Bulbs",
            description: "",
            isLast: false,
          ),
          OnboardingPage(
            title: "Inizia ora a controllare i tuoi dispositivi",
            description: "",
            isLast: false,
          ),
          OnboardingPage(
            title: "Trova dispositivi compatibili",
            description: "",
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String? subtitle; // opzionale
  final String description;
  final bool isLast;

  const OnboardingPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.description,
    required this.isLast,
  });

  static const colorizeColors = [
    Colors.white60,
    Colors.white38,
    Colors.white30,
    Colors.white60,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/lampadina1.jpg',
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (subtitle != null)
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        title,
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        subtitle!,
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    pause: const Duration(milliseconds: 100),
                    onTap: () {},
                  )
                else
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        title,
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    pause: const Duration(milliseconds: 1000),
                    onTap: () {},
                  ),
                const SizedBox(height: 20),
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 40),
                if (isLast)
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => DeviceListView()),
                    ),
                    child: const Text("Inizia"),
                  )
                else
                  TextButton(
                    onPressed: () => context
                        .findAncestorStateOfType<_OnboardingScreenState>()
                        ?.pageController
                        .nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text(
                      "Avanti",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
