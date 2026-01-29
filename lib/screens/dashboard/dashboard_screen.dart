import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/profile_model.dart';
import '../../utils/app_theme.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final auth = context.read<AuthProvider>();
    final profile = context.read<ProfileProvider>();
    if (auth.user != null) {
      profile.listenToUserProfiles(auth.user!.uid);
      profile.loadUserStats(auth.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NetaPro Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, ProfileProvider>(
        builder: (context, auth, profile, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          Text(
                            auth.user?.displayName ?? 'User',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/create-profile'),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Profile'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats cards
                _buildStatsGrid(profile.stats, isSmallScreen),
                const SizedBox(height: 32),

                // Profiles section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Profiles',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${profile.profiles.length} profiles',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (profile.profiles.isEmpty)
                  _buildEmptyState()
                else
                  _buildProfilesList(profile.profiles, isSmallScreen),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, int> stats, bool isSmallScreen) {
    final items = [
      _StatItem(
        icon: Icons.person_outline,
        label: 'Total Profiles',
        value: '${stats['totalProfiles'] ?? 0}',
        color: AppTheme.primaryColor,
      ),
      _StatItem(
        icon: Icons.visibility_outlined,
        label: 'Total Views',
        value: '${stats['totalViews'] ?? 0}',
        color: AppTheme.secondaryColor,
      ),
      _StatItem(
        icon: Icons.public,
        label: 'Published',
        value: '${stats['publishedProfiles'] ?? 0}',
        color: AppTheme.successColor,
      ),
    ];

    if (isSmallScreen) {
      return Column(
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildStatCard(item),
        )).toList(),
      );
    }

    return Row(
      children: items.map((item) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildStatCard(item),
        ),
      )).toList(),
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.label,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 64,
              color: AppTheme.textSecondaryColor.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No profiles yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first profile to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/create-profile'),
              icon: const Icon(Icons.add),
              label: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilesList(List<ProfileModel> profiles, bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        children: profiles.map((p) => _buildProfileCard(p)).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: profiles.length,
      itemBuilder: (context, index) => _buildProfileCard(profiles[index]),
    );
  }

  Widget _buildProfileCard(ProfileModel profile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryColor.withAlpha(25),
              backgroundImage: profile.photoUrl.isNotEmpty
                  ? NetworkImage(profile.photoUrl)
                  : null,
              child: profile.photoUrl.isEmpty
                  ? Text(
                      profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'P',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          profile.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: profile.isPublished
                              ? AppTheme.successColor.withAlpha(25)
                              : Colors.orange.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          profile.isPublished ? 'Published' : 'Draft',
                          style: TextStyle(
                            fontSize: 12,
                            color: profile.isPublished
                                ? AppTheme.successColor
                                : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.party.isNotEmpty ? profile.party : profile.position,
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.views} views',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(profile.updatedAt),
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleProfileAction(value, profile),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('View Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share_outlined, size: 20),
                      SizedBox(width: 12),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outlined, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleProfileAction(String action, ProfileModel profile) async {
    switch (action) {
      case 'view':
        context.go('/p/${profile.username}');
        break;
      case 'edit':
        context.go('/edit-profile/${profile.id}');
        break;
      case 'share':
        _showShareDialog(profile);
        break;
      case 'delete':
        _showDeleteDialog(profile);
        break;
    }
  }

  void _showShareDialog(ProfileModel profile) {
    final url = '${Uri.base.origin}/p/${profile.username}';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Share this link with others:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                url,
                style: const TextStyle(fontFamily: 'monospace'),
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

  void _showDeleteDialog(ProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: Text(
          'Are you sure you want to delete "${profile.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<ProfileProvider>().deleteProfile(profile.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
