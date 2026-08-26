import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/entry_reveal.dart';
import '../../widgets/primary_button.dart';
import '../onboarding/onboarding_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _farmNameController = TextEditingController(text: 'Green Valley Farm');
  final _cattleCountController = TextEditingController(text: '15');

  bool _isPasswordVisible = false;
  String _selectedLanguageCode = 'en';

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    final cattleCount = int.tryParse(_cattleCountController.text.trim()) ?? 10;

    // Apply selected language preference
    await settingsProvider.setLanguage(_selectedLanguageCode);

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      farmName: _farmNameController.text.trim(),
      cattleCount: cattleCount,
      isMock: settingsProvider.isMockMode,
    );

    if (success && mounted) {
      farmProvider.updateFarmDetails(
        name: _farmNameController.text.trim(),
        cattleCount: cattleCount,
      );
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background AI Farm Image with dark gradient overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/aerial_farm_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDark.withValues(alpha: 0.75),
                    AppColors.primaryDark.withValues(alpha: 0.94),
                  ],
                ),
              ),
            ),
          ),

          // Main Form Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Create Farm Account',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  EntryReveal(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.glassForestCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.glassForestBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Register Your Farm',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Enter farm details & language preference.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Language Selection Dropdown (Un-truncated & Clean)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.language, color: AppColors.primary, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Language:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedLanguageCode,
                                        isExpanded: true,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'en',
                                            child: Text('🇬🇧 English', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                          ),
                                          DropdownMenuItem(
                                            value: 'ta',
                                            enabled: false,
                                            child: Text('🇮🇳 தமிழ் (Coming Soon)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                          ),
                                          DropdownMenuItem(
                                            value: 'hi',
                                            enabled: false,
                                            child: Text('🇮🇳 हिंदी (Coming Soon)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                          ),
                                          DropdownMenuItem(
                                            value: 'kn',
                                            enabled: false,
                                            child: Text('🇮🇳 ಕನ್ನಡ (Coming Soon)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                          ),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(() => _selectedLanguageCode = val);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (authProvider.errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.errorBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // Farmer Name Label & Field
                            const Text(
                              'Farmer Full Name',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Enter your full name',
                                prefixIcon: Icon(Icons.person_outline, color: AppColors.primary, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Please enter your full name';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email Address Label & Field
                            const Text(
                              'Email Address',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'e.g. farmer@smartfodder.com',
                                prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Please enter your email';
                                if (!val.contains('@') || !val.contains('.')) return 'Please enter a valid email format';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Label & Field
                            const Text(
                              'Password (min 6 characters)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Enter password',
                                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return 'Please enter a password';
                                if (val.length < 6) return 'Password must be at least 6 characters long';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Farm Name Label & Field
                            const Text(
                              'Farm Name',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _farmNameController,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'e.g. Green Valley Farm',
                                prefixIcon: Icon(Icons.agriculture_outlined, color: AppColors.primary, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Please enter your farm name';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Cattle Count Label & Field
                            const Text(
                              'Number of Cattle (Cows / Calves)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _cattleCountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'e.g. 15',
                                prefixIcon: Icon(Icons.pets_outlined, color: AppColors.primary, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Please enter cattle count';
                                final num = int.tryParse(val.trim());
                                if (num == null || num <= 0) return 'Please enter a valid cattle number (> 0)';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Register Submit Button
                            PrimaryButton(
                              text: 'REGISTER & START FARMING',
                              icon: Icons.check_circle_outline,
                              isLoading: authProvider.status == AuthStatus.loading,
                              onPressed: _handleRegister,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
