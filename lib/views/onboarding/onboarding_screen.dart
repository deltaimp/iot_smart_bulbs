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
            title: "Benvenuto in IoT smart bulbs",
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
  final String description;
  final bool isLast;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (isLast)
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) =>  DeviceListView()),
              ),
              child: const Text("Inizia"),
            ),
          if (!isLast)
            TextButton(
              onPressed: () => (context.findAncestorStateOfType<_OnboardingScreenState>()?.pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )),
              child: const Text("Avanti"),
            ),
        ],
      ),
    );
  }
}