import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool locationEnabled = true;
  bool marketingEnabled = false;
  String selectedLanguage = 'English';
  String selectedCurrency = 'EUR (€)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralGray50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: false,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.neutralGray900,
            automaticallyImplyLeading: false,
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizing.paddingLarge),

                // Preferences Section
                _buildSectionTitle('Preferences'),
                _buildSettingsCard([
                  _buildSwitchTile(
                    icon: Icons.notifications_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Receive order and service updates',
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() => notificationsEnabled = value);
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Switch to dark theme',
                    value: darkModeEnabled,
                    onChanged: (value) {
                      setState(() => darkModeEnabled = value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dark mode coming soon!'),
                          backgroundColor: AppTheme.primaryTeal,
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.location_on_outlined,
                    title: 'Location Services',
                    subtitle: 'Enable for better recommendations',
                    value: locationEnabled,
                    onChanged: (value) {
                      setState(() => locationEnabled = value);
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.email_outlined,
                    title: 'Marketing Emails',
                    subtitle: 'Receive deals and promotions',
                    value: marketingEnabled,
                    onChanged: (value) {
                      setState(() => marketingEnabled = value);
                    },
                  ),
                ]),

                const SizedBox(height: AppSizing.paddingXLarge),

                // Regional Section
                _buildSectionTitle('Regional'),
                _buildSettingsCard([
                  _buildSelectTile(
                    icon: Icons.language,
                    title: 'Language',
                    value: selectedLanguage,
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                  _buildDivider(),
                  _buildSelectTile(
                    icon: Icons.euro,
                    title: 'Currency',
                    value: selectedCurrency,
                    onTap: () {
                      _showCurrencyDialog();
                    },
                  ),
                ]),

                const SizedBox(height: AppSizing.paddingXLarge),

                // Admin Section (if admin)
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    if (auth.isAdmin) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Admin'),
                          _buildSettingsCard([
                            _buildNavigationTile(
                              icon: Icons.admin_panel_settings,
                              title: 'Admin Dashboard',
                              subtitle: 'Manage orders and services',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Admin Dashboard - Coming Soon'),
                                    backgroundColor: AppTheme.primaryTeal,
                                  ),
                                );
                              },
                            ),
                          ]),
                          const SizedBox(height: AppSizing.paddingXLarge),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Support Section
                _buildSectionTitle('Support'),
                _buildSettingsCard([
                  _buildNavigationTile(
                    icon: Icons.help_outline,
                    title: 'Help & FAQ',
                    subtitle: 'Get help and answers',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildNavigationTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Contact Support',
                    subtitle: 'Chat with our team',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildNavigationTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and info',
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                ]),

                const SizedBox(height: AppSizing.paddingXLarge),

                // Legal Section
                _buildSectionTitle('Legal'),
                _buildSettingsCard([
                  _buildNavigationTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildNavigationTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: AppSizing.paddingXXLarge),

                // Version Info
                Center(
                  child: Text(
                    'WaterFilterNet v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.neutralGray500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                const SizedBox(height: AppSizing.paddingXXLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizing.paddingLarge,
        vertical: AppSizing.paddingSmall,
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.neutralGray600,
          fontFamily: 'Poppins',
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizing.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutralGray300.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: AppTheme.neutralGray200,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.neutralGray700),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.neutralGray600,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryTeal,
      ),
    );
  }

  Widget _buildSelectTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.neutralGray700),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.neutralGray600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.neutralGray400,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.neutralGray700),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.neutralGray600,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.neutralGray400,
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: selectedLanguage == 'English'
                  ? const Icon(Icons.check, color: AppTheme.primaryTeal)
                  : null,
              onTap: () {
                setState(() => selectedLanguage = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Greek'),
              trailing: selectedLanguage == 'Greek'
                  ? const Icon(Icons.check, color: AppTheme.primaryTeal)
                  : null,
              onTap: () {
                setState(() => selectedLanguage = 'Greek');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('EUR (€)'),
              trailing: selectedCurrency == 'EUR (€)'
                  ? const Icon(Icons.check, color: AppTheme.primaryTeal)
                  : null,
              onTap: () {
                setState(() => selectedCurrency = 'EUR (€)');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About WaterFilterNet'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Your complete water filtration solution for Cyprus.'),
            SizedBox(height: 16),
            Text('© 2024 WaterFilterNet'),
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
}
