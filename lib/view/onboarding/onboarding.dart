import 'package:flutter/material.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/app_spacing.dart';
import 'package:parker_touch/core/widget/custom_button.dart';
import 'package:parker_touch/view/choose%20user/choose_user.dart';
import 'onboarding_screen1.dart';
import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';

class OnboardingPage extends StatefulWidget {
  /// Called when onboarding is finished (user tapped Done or Skip)
  final VoidCallback? onFinish;

  const OnboardingPage({super.key, this.onFinish});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<Widget> _pages = const [
    OnboardingScreen1(),
    OnboardingScreen2(),
    OnboardingScreen3(),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to choose user screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseUser()),
      );
      widget.onFinish?.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: _pages,
            ),
          ),
          _buildDots(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24,
              ),
              child: CustomButton(
                onTap: _next,
                text: _index == _pages.length - 1 ? 'Get Started' : 'Next',
                rightIcon: Icons.arrow_forward_ios,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: _index == i ? 40 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: _index == i ? AppColors.primaryColor : Colors.grey[400],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
