import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom gesture-driven carousel with floating, 
/// parallax, scaling, and infinite scroll effects.
class Carousel extends StatefulWidget {
  /// List of widgets to display in the carousel.
  final List<Widget> items;

  /// Height of the carousel.
  final double height;

  /// Width of the carousel items as a fraction of total width (0.0 to 1.0).
  final double viewportFraction;

  /// Whether to enable infinite scrolling.
  final bool infiniteScroll;

  /// Speed of the parallax effect (higher = more movement in background).
  final double parallaxFactor;

  /// Maximum tilt angle in radians.
  final double maxTilt;

  /// Vertical lift amount for the "floating" effect.
  final double liftAmount;

  const Carousel({
    super.key,
    required this.items,
    this.height = 400.0,
    this.viewportFraction = 0.8,
    this.infiniteScroll = true,
    this.parallaxFactor = 0.5,
    this.maxTilt = 0.1, // Approx 5-6 degrees
    this.liftAmount = 30.0,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    // Starting index for infinite scroll to allow scrolling both directions
    final initialPage = widget.infiniteScroll ? 1000 : 0;
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: initialPage,
    );

    _currentPage = initialPage.toDouble();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        // If infinite, we use a very large number and modulo for actual items
        itemCount: widget.infiniteScroll ? 2000 : widget.items.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final itemIndex = index % widget.items.length;
          
          // Calculate relative position to center (-1.0 to 1.0 for visible range)
          final relativePosition = index - _currentPage;
          
          return _buildCarouselItem(
            widget.items[itemIndex],
            relativePosition,
          );
        },
      ),
    );
  }

  Widget _buildCarouselItem(Widget child, double position) {
    // 1. Scaling effect (center is 1.0, sides shrink slightly)
    final scale = 1.0 - (position.abs() * 0.1).clamp(0.0, 0.2);

    // 2. Floating effect (center is lifted, sides lower)
    // We use a parabolic curve for smooth lifting
    final lift = (1.0 - position.abs().clamp(0.0, 1.0)) * widget.liftAmount;

    // 3. 3D Tilt effect
    // Rotate around Y axis based on position
    final tilt = position * widget.maxTilt;

    return Center(
      child: Transform(
        // Identity matrix with perspective set (z-coordinate)
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..translate(0.0, -lift, 0.0) // Translation (lift)
          ..scale(scale) // Scaling
          ..rotateY(tilt), // Tilting
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2 * (1.0 - position.abs().clamp(0.0, 1.0))),
                blurRadius: 20,
                offset: Offset(0, 10 + lift),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // The item itself
                child,
                
                // 4. Parallax Overlay
                // We shift an imaginary inner content slightly faster
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(position * 50 * widget.parallaxFactor, 0),
                        child: _buildParallaxEffect(position),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Adds a subtle light sheen that moves with the gesture for a "premium" feel
  Widget _buildParallaxEffect(double position) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.transparent,
            Colors.black.withOpacity(0.05),
          ],
          transform: GradientRotation(position * math.pi / 4),
        ),
      ),
    );
  }
}
