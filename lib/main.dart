import 'package:flutter/material.dart';
import 'carousel.dart';

void main() {
  runApp(const CarouselDemoApp());
}

class CarouselDemoApp extends StatelessWidget {
  const CarouselDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carousel Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const CarouselDemoScreen(),
    );
  }
}

class CarouselDemoScreen extends StatelessWidget {
  const CarouselDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample items for the carousel
    final List<Widget> carouselItems = [
      _DemoCard(
        title: 'Nebula Space',
        subtitle: 'Floating through stardust',
        gradient: const [Color(0xFF6A11CB), Color(0xFF2575FC)],
        icon: Icons.rocket_launch,
      ),
      _DemoCard(
        title: 'Ocean Deep',
        subtitle: 'Submerged in tranquility',
        gradient: const [Color(0xFF48C6EF), Color(0xFF6F86D6)],
        icon: Icons.waves,
      ),
      _DemoCard(
        title: 'Sunset Peak',
        subtitle: 'The golden hour glow',
        gradient: const [Color(0xFFF093FB), Color(0xFFF5576C)],
        icon: Icons.wb_sunny,
      ),
      _DemoCard(
        title: 'Forest Mist',
        subtitle: 'Breathe in the silence',
        gradient: const [Color(0xFF536976), Color(0xFF292E49)],
        icon: Icons.park,
      ),
      _DemoCard(
        title: 'Arctic Frost',
        subtitle: 'Crystal clear silence',
        gradient: const [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
        icon: Icons.ac_unit,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carousel',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Gesture-Driven Carousel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Carousel(
                    items: carouselItems,
                    height: 500,
                    viewportFraction: 0.75,
                    maxTilt: 0.15,
                    liftAmount: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'SWIPE TO EXPLORE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;

  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'View Details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
