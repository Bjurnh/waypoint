import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';
import '../widgets/gradient_background.dart';
import '../widgets/gradient_card.dart';
import '../widgets/status_bar_style.dart';

/// Lightweight, local-only editable profile.
///
/// Since the current app doesn't have a dedicated user model persisted in Hive,
/// this screen edits values stored in [AppState] as UI-only fields.
///
/// If you later add a real user model, this file can be wired to storage.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _displayNameController = TextEditingController(
text: appState.displayName ?? 'Prayer Warrior',


    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return StatusBarStyle(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          leading: BackButton(onPressed: () => Navigator.maybePop(context)),
          actions: [
            TextButton(
              onPressed: () async {
                if (!(_formKey.currentState?.validate() ?? false)) return;

                await appState.saveProfile(
                  displayName: _displayNameController.text.trim(),
                );

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Color.fromARGB(255, 4, 3, 3)),
              ),
            ),
            const SizedBox(width: Spacing.md),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              GradientBackground(
                startColor: isDarkMode 
                    ? Colors.transparent 
                    : Colors.blue.withValues(alpha: 0.05),
                midColor: isDarkMode 
                    ? null 
                    : Colors.indigo.withValues(alpha: 0.05),
                endColor: isDarkMode
                    ? Theme.of(context).colorScheme.surface
                    : Colors.white,
                child: Container(),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: Spacing.lg,
                  right: Spacing.lg,
                  bottom: Spacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Spacing.lg),
                    GradientCard(
                      borderColor: AppColors.border.withValues(alpha: 0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.md),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Profile details',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.foreground,
                                    ),
                              ),
                              const SizedBox(height: Spacing.md),
                              TextFormField(
                                controller: _displayNameController,
                                decoration: InputDecoration(
                                  labelText: 'Display name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) return 'Display name is required';
                                  if (value.length < 2) return 'Too short';
                                  if (value.length > 40) return 'Max 40 characters';
                                  return null;
                                },
                              ),
                              const SizedBox(height: Spacing.md),
                              Text(
                                'Changes are stored locally for this app session/device.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    GradientCard(
                      borderColor: AppColors.border.withValues(alpha: 0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preview',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.foreground,
                                  ),
                            ),
                            const SizedBox(height: Spacing.md),
                            Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.primary.withValues(alpha: 0.7),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 34,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: Spacing.md),
                                Expanded(
                                  child: Text(
                                    _displayNameController.text.trim().isEmpty
                                        ? 'Prayer Warrior'
                                        : _displayNameController.text.trim(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.foreground,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

