import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/profile_provider.dart';
import '../../models/profile_model.dart';
import '../../utils/app_theme.dart';

class ProfileViewScreen extends StatefulWidget {
  final String username;

  const ProfileViewScreen({super.key, required this.username});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await context.read<ProfileProvider>().loadProfileByUsername(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = profileProvider.currentProfile;
        if (profile == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Profile Not Found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The profile you\'re looking for doesn\'t exist.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        final template = ProfileTemplate.getTemplate(profile.templateId);
        return _ProfileView(profile: profile, template: template);
      },
    );
  }
}

class _ProfileView extends StatelessWidget {
  final ProfileModel profile;
  final ProfileTemplate template;

  const _ProfileView({required this.profile, required this.template});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(context, isSmallScreen),

            // Stats Section
            if (profile.yearsOfService > 0 ||
                profile.projectsCompleted > 0 ||
                profile.livesImpacted > 0 ||
                profile.volunteers > 0)
              _buildStatsSection(context, isSmallScreen),

            // About Section
            if (profile.about.isNotEmpty)
              _buildAboutSection(context, isSmallScreen),

            // Achievements Section
            if (profile.achievements.isNotEmpty)
              _buildAchievementsSection(context, isSmallScreen),

            // Contact Section
            _buildContactSection(context, isSmallScreen),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
      floatingActionButton: profile.donationEnabled && profile.upiId.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showDonationDialog(context),
              backgroundColor: template.accentColor,
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Donate'),
            )
          : null,
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [template.primaryColor, template.secondaryColor],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 24 : 48,
            vertical: isSmallScreen ? 40 : 60,
          ),
          child: isSmallScreen
              ? Column(
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 24),
                    _buildHeroText(context, true),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildHeroText(context, false)),
                    const SizedBox(width: 48),
                    _buildProfileImage(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 96,
        backgroundColor: Colors.white,
        backgroundImage: profile.photoUrl.isNotEmpty
            ? NetworkImage(profile.photoUrl)
            : null,
        child: profile.photoUrl.isEmpty
            ? Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'P',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: template.primaryColor,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildHeroText(BuildContext context, bool centered) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (profile.party.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              profile.party,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ),
        if (profile.position.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            profile.position,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white70,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ],
        if (profile.tagline.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            profile.tagline,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ],
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            if (profile.whatsapp.isNotEmpty)
              _buildSocialButton(
                icon: Icons.chat,
                label: 'WhatsApp',
                onTap: () => _launchWhatsApp(profile.whatsapp),
              ),
            if (profile.phone.isNotEmpty)
              _buildSocialButton(
                icon: Icons.phone,
                label: 'Call',
                onTap: () => _launchPhone(profile.phone),
              ),
            if (profile.email.isNotEmpty)
              _buildSocialButton(
                icon: Icons.email,
                label: 'Email',
                onTap: () => _launchEmail(profile.email),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            if (profile.facebook.isNotEmpty)
              _buildIconButton(Icons.facebook, profile.facebook),
            if (profile.twitter.isNotEmpty)
              _buildIconButton(Icons.close, profile.twitter), // X icon
            if (profile.instagram.isNotEmpty)
              _buildIconButton(Icons.camera_alt, profile.instagram),
            if (profile.youtube.isNotEmpty)
              _buildIconButton(Icons.play_circle, profile.youtube),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: template.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildIconButton(IconData icon, String url) {
    return IconButton(
      onPressed: () => _launchUrl(url),
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withAlpha(50),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isSmallScreen) {
    final stats = [
      if (profile.yearsOfService > 0)
        _StatData('${profile.yearsOfService}+', 'Years of Service'),
      if (profile.projectsCompleted > 0)
        _StatData('${profile.projectsCompleted}+', 'Projects'),
      if (profile.livesImpacted > 0)
        _StatData(_formatNumber(profile.livesImpacted), 'Lives Impacted'),
      if (profile.volunteers > 0)
        _StatData('${profile.volunteers}+', 'Volunteers'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : 48,
        vertical: 40,
      ),
      color: Colors.white,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: isSmallScreen ? 20 : 60,
        runSpacing: 20,
        children: stats.map((stat) {
          return SizedBox(
            width: isSmallScreen ? 140 : 180,
            child: Column(
              children: [
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 32 : 40,
                    fontWeight: FontWeight.bold,
                    color: template.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : 48,
        vertical: 40,
      ),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Text(
            'About Me',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: template.accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Text(
              profile.about,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.8,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : 48,
        vertical: 40,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Key Achievements',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: template.accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: profile.achievements.map((achievement) {
                return SizedBox(
                  width: isSmallScreen ? double.infinity : 300,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: template.primaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.emoji_events,
                                  color: template.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (achievement.year.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: template.accentColor.withAlpha(25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    achievement.year,
                                    style: TextStyle(
                                      color: template.accentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            achievement.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (achievement.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              achievement.description,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : 48,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [template.primaryColor, template.secondaryColor],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Get In Touch',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              if (profile.phone.isNotEmpty)
                _buildContactCard(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: profile.phone,
                  onTap: () => _launchPhone(profile.phone),
                ),
              if (profile.email.isNotEmpty)
                _buildContactCard(
                  icon: Icons.email,
                  label: 'Email',
                  value: profile.email,
                  onTap: () => _launchEmail(profile.email),
                ),
              if (profile.whatsapp.isNotEmpty)
                _buildContactCard(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  value: profile.whatsapp,
                  onTap: () => _launchWhatsApp(profile.whatsapp),
                ),
            ],
          ),
          if (profile.address.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white70),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    profile.address,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: template.primaryColor.withAlpha(230),
      child: Column(
        children: [
          Text(
            'Created with NetaPro',
            style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.volunteer_activism, color: template.accentColor),
            const SizedBox(width: 12),
            const Text('Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Scan the QR code or use UPI ID to donate:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                profile.upiId,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final upiUrl = 'upi://pay?pa=${profile.upiId}&pn=${Uri.encodeComponent(profile.name)}';
                launchUrl(Uri.parse(upiUrl));
              },
              icon: const Icon(Icons.payment),
              label: const Text('Pay via UPI App'),
              style: ElevatedButton.styleFrom(
                backgroundColor: template.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _launchWhatsApp(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'[^\d+]'), '');
    _launchUrl('https://wa.me/$cleanNumber');
  }

  void _launchPhone(String number) {
    _launchUrl('tel:$number');
  }

  void _launchEmail(String email) {
    _launchUrl('mailto:$email');
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}k';
    }
    return number.toString();
  }
}

class _StatData {
  final String value;
  final String label;

  _StatData(this.value, this.label);
}
