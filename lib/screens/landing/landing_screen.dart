import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildHeroSection(context),
            _buildFeaturesSection(context),
            _buildPricingSection(context),
            _buildTestimonialsSection(context),
            _buildCTASection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 48,
        vertical: 16,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Row(
            children: [
              const Icon(Icons.person_pin, color: AppTheme.primaryColor, size: 36),
              const SizedBox(width: 8),
              Text(
                'NetaPro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (!isSmall) ...[
            TextButton(
              onPressed: () {},
              child: const Text('Features'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Pricing'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Templates'),
            ),
            const SizedBox(width: 16),
          ],
          OutlinedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Login'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => context.go('/signup'),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 24 : 80,
        vertical: isSmall ? 40 : 80,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Create Your Professional\nPolitical Profile',
            style: TextStyle(
              fontSize: isSmall ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Build a stunning online presence. Connect with voters.\nShowcase your achievements and vision.',
            style: TextStyle(
              fontSize: isSmall ? 16 : 20,
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Start Free Trial', style: TextStyle(fontSize: 16)),
              ),
              OutlinedButton(
                onPressed: () => context.go('/p/rajeshkumar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('View Demo', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: isSmall ? 200 : 400,
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.web, size: 60, color: AppTheme.primaryColor.withAlpha(100)),
                      const SizedBox(height: 16),
                      Text(
                        'Beautiful Profile Templates',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    final features = [
      _Feature(
        icon: Icons.palette,
        title: 'Beautiful Templates',
        description: 'Choose from multiple professionally designed templates',
      ),
      _Feature(
        icon: Icons.phone_android,
        title: 'Mobile Responsive',
        description: 'Your profile looks great on all devices',
      ),
      _Feature(
        icon: Icons.link,
        title: 'Custom URLs',
        description: 'Get your own personalized profile link',
      ),
      _Feature(
        icon: Icons.volunteer_activism,
        title: 'Donation Support',
        description: 'Accept donations via UPI directly on your profile',
      ),
      _Feature(
        icon: Icons.analytics,
        title: 'Analytics',
        description: 'Track profile views and visitor engagement',
      ),
      _Feature(
        icon: Icons.share,
        title: 'Easy Sharing',
        description: 'Share your profile on social media with one click',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 24 : 80,
        vertical: 60,
      ),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Text(
            'Everything You Need',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Powerful features to build your political brand',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: features.map((f) => SizedBox(
              width: isSmall ? double.infinity : 340,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(f.icon, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        f.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        f.description,
                        style: TextStyle(color: AppTheme.textSecondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 24 : 80,
        vertical: 60,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Simple Pricing',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose the plan that fits your needs',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _buildPricingCard(
                context,
                title: 'Starter',
                price: '499',
                period: '/month',
                features: [
                  'Single Page Profile',
                  'Basic Analytics',
                  'Mobile Responsive',
                  'Social Links',
                  'Email Support',
                ],
                isPopular: false,
              ),
              _buildPricingCard(
                context,
                title: 'Pro Campaign',
                price: '999',
                period: '/month',
                features: [
                  'Multi-Page Profile',
                  'Advanced Analytics',
                  'Custom Domain',
                  'Donation Integration',
                  'Priority Support',
                  'Remove Branding',
                ],
                isPopular: true,
              ),
              _buildPricingCard(
                context,
                title: 'Enterprise',
                price: 'Custom',
                period: '',
                features: [
                  'Everything in Pro',
                  'Dedicated Manager',
                  'Custom Development',
                  'API Access',
                  'SLA Guarantee',
                  'White Label Option',
                ],
                isPopular: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required bool isPopular,
  }) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return Container(
      width: isSmall ? double.infinity : 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isPopular ? AppTheme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? AppTheme.primaryColor : Colors.grey[300]!,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withAlpha(50),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Most Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPopular ? Colors.white : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price == 'Custom' ? '' : '₹',
                style: TextStyle(
                  fontSize: 20,
                  color: isPopular ? Colors.white70 : AppTheme.textSecondaryColor,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: isPopular ? Colors.white : AppTheme.primaryColor,
                ),
              ),
              Text(
                period,
                style: TextStyle(
                  fontSize: 16,
                  color: isPopular ? Colors.white70 : AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: isPopular ? Colors.white70 : AppTheme.successColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(
                      color: isPopular ? Colors.white : AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? Colors.white : AppTheme.primaryColor,
                foregroundColor: isPopular ? AppTheme.primaryColor : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(price == 'Custom' ? 'Contact Us' : 'Get Started'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 24 : 80,
        vertical: 60,
      ),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Text(
            'Trusted by 500+ Leaders',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _buildTestimonialCard(
                name: 'Rahul Sharma',
                position: 'MLA, Rajasthan',
                text: 'NetaPro helped me create a professional online presence. My constituents love being able to connect with me easily.',
              ),
              _buildTestimonialCard(
                name: 'Priya Patel',
                position: 'Councillor, Gujarat',
                text: 'The donation feature has been a game changer for my campaigns. Highly recommend!',
              ),
              _buildTestimonialCard(
                name: 'Amit Kumar',
                position: 'Social Worker',
                text: 'Setting up my profile took just minutes. The templates are beautiful and professional.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String position,
    required String text,
  }) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (i) => const Icon(Icons.star, color: Colors.amber, size: 18),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"$text"',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withAlpha(25),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    position,
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 24 : 80,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Get Started?',
            style: TextStyle(
              fontSize: isSmall ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Create your professional profile in minutes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/signup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text(
              'Start Free Trial',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      color: AppTheme.primaryColor.withAlpha(230),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_pin, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              const Text(
                'NetaPro',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2024 NetaPro. All rights reserved.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;

  _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });
}
