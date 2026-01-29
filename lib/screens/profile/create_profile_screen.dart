import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/profile_model.dart';
import '../../utils/app_theme.dart';

class CreateProfileScreen extends StatefulWidget {
  final String? profileId;

  const CreateProfileScreen({super.key, this.profileId});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  ProfileModel? _existingProfile;

  // Controllers
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _partyController = TextEditingController();
  final _positionController = TextEditingController();
  final _aboutController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _facebookController = TextEditingController();
  final _twitterController = TextEditingController();
  final _instagramController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _yearsController = TextEditingController(text: '0');
  final _projectsController = TextEditingController(text: '0');
  final _livesController = TextEditingController(text: '0');
  final _volunteersController = TextEditingController(text: '0');
  final _upiController = TextEditingController();

  String _selectedTemplateId = 'modern_blue';
  bool _donationEnabled = false;
  bool _isPublished = false;
  List<Achievement> _achievements = [];

  @override
  void initState() {
    super.initState();
    if (widget.profileId != null) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await context.read<ProfileProvider>().loadProfile(widget.profileId!);
    if (profile != null && mounted) {
      _existingProfile = profile;
      _populateFields(profile);
    }
    setState(() => _isLoading = false);
  }

  void _populateFields(ProfileModel profile) {
    _usernameController.text = profile.username;
    _nameController.text = profile.name;
    _taglineController.text = profile.tagline;
    _partyController.text = profile.party;
    _positionController.text = profile.position;
    _aboutController.text = profile.about;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _whatsappController.text = profile.whatsapp;
    _addressController.text = profile.address;
    _facebookController.text = profile.facebook;
    _twitterController.text = profile.twitter;
    _instagramController.text = profile.instagram;
    _youtubeController.text = profile.youtube;
    _yearsController.text = profile.yearsOfService.toString();
    _projectsController.text = profile.projectsCompleted.toString();
    _livesController.text = profile.livesImpacted.toString();
    _volunteersController.text = profile.volunteers.toString();
    _upiController.text = profile.upiId;
    _selectedTemplateId = profile.templateId;
    _donationEnabled = profile.donationEnabled;
    _isPublished = profile.isPublished;
    _achievements = List.from(profile.achievements);
    setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _taglineController.dispose();
    _partyController.dispose();
    _positionController.dispose();
    _aboutController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    _youtubeController.dispose();
    _yearsController.dispose();
    _projectsController.dispose();
    _livesController.dispose();
    _volunteersController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    // Check username availability for new profiles
    if (_existingProfile == null) {
      final isAvailable = await profileProvider.isUsernameAvailable(
        _usernameController.text.trim().toLowerCase(),
      );
      if (!isAvailable) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username is already taken'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
        return;
      }
    }

    final now = DateTime.now();
    final profile = ProfileModel(
      id: _existingProfile?.id ?? const Uuid().v4(),
      userId: auth.user!.uid,
      username: _usernameController.text.trim().toLowerCase(),
      name: _nameController.text.trim(),
      tagline: _taglineController.text.trim(),
      party: _partyController.text.trim(),
      position: _positionController.text.trim(),
      about: _aboutController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      address: _addressController.text.trim(),
      templateId: _selectedTemplateId,
      facebook: _facebookController.text.trim(),
      twitter: _twitterController.text.trim(),
      instagram: _instagramController.text.trim(),
      youtube: _youtubeController.text.trim(),
      yearsOfService: int.tryParse(_yearsController.text) ?? 0,
      projectsCompleted: int.tryParse(_projectsController.text) ?? 0,
      livesImpacted: int.tryParse(_livesController.text) ?? 0,
      volunteers: int.tryParse(_volunteersController.text) ?? 0,
      achievements: _achievements,
      donationEnabled: _donationEnabled,
      upiId: _upiController.text.trim(),
      isPublished: _isPublished,
      views: _existingProfile?.views ?? 0,
      createdAt: _existingProfile?.createdAt ?? now,
      updatedAt: now,
      photoUrl: _existingProfile?.photoUrl ?? '',
      coverPhotoUrl: _existingProfile?.coverPhotoUrl ?? '',
      galleryImages: _existingProfile?.galleryImages ?? [],
      videos: _existingProfile?.videos ?? [],
    );

    bool success;
    if (_existingProfile != null) {
      success = await profileProvider.updateProfile(profile);
    } else {
      final created = await profileProvider.createProfile(profile);
      success = created != null;
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_existingProfile != null ? 'Profile updated!' : 'Profile created!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileId != null ? 'Edit Profile' : 'Create Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: _isLoading && _existingProfile == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: isSmallScreen
                  ? _buildMobileLayout()
                  : _buildDesktopLayout(),
            ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 4) {
                setState(() => _currentStep++);
              } else {
                _saveProfile();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : details.onStepContinue,
                      child: _isLoading && _currentStep == 4
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_currentStep == 4 ? 'Save Profile' : 'Next'),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('Basic Info'),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: _buildBasicInfoSection(),
              ),
              Step(
                title: const Text('Contact'),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: _buildContactSection(),
              ),
              Step(
                title: const Text('Statistics'),
                isActive: _currentStep >= 2,
                state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                content: _buildStatsSection(),
              ),
              Step(
                title: const Text('Social & Donation'),
                isActive: _currentStep >= 3,
                state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                content: _buildSocialDonationSection(),
              ),
              Step(
                title: const Text('Template & Publish'),
                isActive: _currentStep >= 4,
                state: _currentStep > 4 ? StepState.complete : StepState.indexed,
                content: _buildTemplateSection(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar navigation
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildNavItem(0, Icons.person_outline, 'Basic Info'),
              _buildNavItem(1, Icons.contact_mail_outlined, 'Contact'),
              _buildNavItem(2, Icons.bar_chart_outlined, 'Statistics'),
              _buildNavItem(3, Icons.share_outlined, 'Social & Donation'),
              _buildNavItem(4, Icons.palette_outlined, 'Template & Publish'),
            ],
          ),
        ),
        // Content area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getSectionContent(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_currentStep > 0)
                        OutlinedButton(
                          onPressed: () => setState(() => _currentStep--),
                          child: const Text('Previous'),
                        ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_currentStep < 4) {
                                  setState(() => _currentStep++);
                                } else {
                                  _saveProfile();
                                }
                              },
                        child: _isLoading && _currentStep == 4
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_currentStep == 4 ? 'Save Profile' : 'Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentStep == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppTheme.primaryColor.withAlpha(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => setState(() => _currentStep = index),
    );
  }

  Widget _getSectionContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoSection();
      case 1:
        return _buildContactSection();
      case 2:
        return _buildStatsSection();
      case 3:
        return _buildSocialDonationSection();
      case 4:
        return _buildTemplateSection();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the basic details for your profile',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username (for URL)',
            hintText: 'e.g., johndoe',
            prefixText: 'yoursite.com/p/',
            helperText: 'This will be your profile URL',
          ),
          enabled: _existingProfile == null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a username';
            }
            if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value.toLowerCase())) {
              return 'Only lowercase letters, numbers, and underscore allowed';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name *',
            hintText: 'e.g., Rajesh Kumar',
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _taglineController,
          decoration: const InputDecoration(
            labelText: 'Tagline',
            hintText: 'e.g., Building a Stronger Future',
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _partyController,
          decoration: const InputDecoration(
            labelText: 'Party / Organization',
            hintText: 'e.g., Bhartiya Janata Party',
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _positionController,
          decoration: const InputDecoration(
            labelText: 'Position / Title',
            hintText: 'e.g., MLA, Councillor, Social Worker',
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _aboutController,
          decoration: const InputDecoration(
            labelText: 'About',
            hintText: 'Write about yourself, your vision, and achievements...',
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How can people reach you?',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone_outlined),
            hintText: '+91 9876543210',
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _whatsappController,
          decoration: const InputDecoration(
            labelText: 'WhatsApp Number',
            prefixIcon: Icon(Icons.chat_outlined),
            hintText: '+91 9876543210',
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Office Address',
            prefixIcon: Icon(Icons.location_on_outlined),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Showcase your achievements in numbers',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _yearsController,
                decoration: const InputDecoration(
                  labelText: 'Years of Service',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _projectsController,
                decoration: const InputDecoration(
                  labelText: 'Projects Completed',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _livesController,
                decoration: const InputDecoration(
                  labelText: 'Lives Impacted',
                  prefixIcon: Icon(Icons.people_outline),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _volunteersController,
                decoration: const InputDecoration(
                  labelText: 'Volunteers',
                  prefixIcon: Icon(Icons.volunteer_activism_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addAchievement,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_achievements.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No achievements added yet',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ),
          )
        else
          ..._achievements.asMap().entries.map((entry) {
            final index = entry.key;
            final achievement = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withAlpha(25),
                  child: Text(
                    achievement.year.isNotEmpty ? achievement.year : '${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                title: Text(achievement.title),
                subtitle: achievement.description.isNotEmpty
                    ? Text(achievement.description)
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _achievements.removeAt(index);
                    });
                  },
                ),
              ),
            );
          }),
      ],
    );
  }

  void _addAchievement() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Achievement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'e.g., Clean Water Project',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: 'Year',
                hintText: 'e.g., 2023',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _achievements.add(Achievement(
                    id: const Uuid().v4(),
                    title: titleController.text,
                    description: descController.text,
                    year: yearController.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialDonationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social Media Links',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connect your social media profiles',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _facebookController,
          decoration: const InputDecoration(
            labelText: 'Facebook URL',
            prefixIcon: Icon(Icons.facebook),
            hintText: 'https://facebook.com/yourpage',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _twitterController,
          decoration: const InputDecoration(
            labelText: 'Twitter/X URL',
            prefixIcon: Icon(Icons.close), // X icon
            hintText: 'https://twitter.com/yourhandle',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _instagramController,
          decoration: const InputDecoration(
            labelText: 'Instagram URL',
            prefixIcon: Icon(Icons.camera_alt_outlined),
            hintText: 'https://instagram.com/yourhandle',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _youtubeController,
          decoration: const InputDecoration(
            labelText: 'YouTube URL',
            prefixIcon: Icon(Icons.play_circle_outline),
            hintText: 'https://youtube.com/yourchannel',
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Donation Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enable donations on your profile',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Enable Donations'),
          subtitle: const Text('Allow visitors to donate via UPI'),
          value: _donationEnabled,
          onChanged: (value) => setState(() => _donationEnabled = value),
        ),
        if (_donationEnabled) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _upiController,
            decoration: const InputDecoration(
              labelText: 'UPI ID',
              prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              hintText: 'yourname@upi',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTemplateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Template',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a design template for your profile',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
        const SizedBox(height: 24),
        ...ProfileTemplate.templates.map((template) {
          final isSelected = _selectedTemplateId == template.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedTemplateId = template.id),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? template.primaryColor : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [template.primaryColor, template.secondaryColor],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: template.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: template.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: template.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: template.primaryColor),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 32),
        Text(
          'Publish Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Publish Profile'),
          subtitle: const Text('Make your profile visible to everyone'),
          value: _isPublished,
          onChanged: (value) => setState(() => _isPublished = value),
        ),
      ],
    );
  }
}
