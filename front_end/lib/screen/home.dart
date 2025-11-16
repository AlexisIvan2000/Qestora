import 'package:flutter/material.dart';
import 'package:front_end/screen/login.dart';
import 'package:front_end/widgets/animation.dart';

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);

    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> _images = const [
    'assets/images/event1.png',
    'assets/images/event6.png',
    'assets/images/event2.png',
    'assets/images/event3.png',
    'assets/images/event4.png',
    'assets/images/event5.png',
    
  ];

  void _login(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: Column(
        children: [
          ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 100, bottom: 100),
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Center(
                child: SizedBox(
                  height: 200,
                  child: ImageAnimation(imageList: _images),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                Text(
                  "Your city is alive. Qestora helps you hear its heartbeat.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Discover events happening around you in real-time.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "From concerts to pop-ups, find the pulse of your city.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      "Get Started",
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
