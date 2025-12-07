import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../auth/auth_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralGray50,
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isAuthenticated) {
            return _buildNotLoggedInState(context);
          }
          return _buildLoggedInState(context, auth);
        },
      ),
    );
  }

  Widget _buildNotLoggedInState(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryTeal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 50,
                  color: AppTheme.primaryTeal,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to WaterFilterNet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.neutralGray900,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to manage your orders, track services, and more.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.neutralGray600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Sign In',
                fullWidth: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Create Account',
                fullWidth: true,
                variant: ButtonVariant.outline,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedInState(BuildContext context, AuthProvider auth) {
    final user = auth.currentUser!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: false,
          pinned: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.neutralGray900,
          automaticallyImplyLeading: false,
          title: const Text(
            'Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: AppSizing.paddingLarge),

              // Profile Header
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizing.paddingLarge),
                padding: const EdgeInsets.all(AppSizing.paddingXLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neutralGray300.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryTeal.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user.displayName.isNotEmpty
                            ? user.displayName[0].toUpperCase()
                            : 'U',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryTeal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizing.paddingLarge),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.neutralGray900,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.neutralGray600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (auth.isAdmin) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryTeal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ADMIN',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryTeal,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppTheme.neutralGray500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizing.paddingXLarge),

              // Menu Items
              _buildMenuItem(
                context,
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View your order history',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.location_on_outlined,
                title: 'My Addresses',
                subtitle: 'Manage delivery addresses',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                subtitle: 'Manage your payment cards',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.water_drop_outlined,
                title: 'My Filters',
                subtitle: 'Track your filter installations',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.calendar_today_outlined,
                title: 'Service History',
                subtitle: 'View past service appointments',
                onTap: () {},
              ),

              const SizedBox(height: AppSizing.paddingXLarge),

              // Sign Out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingLarge),
                child: PrimaryButton(
                  text: 'Sign Out',
                  fullWidth: true,
                  variant: ButtonVariant.outline,
                  icon: Icons.logout,
                  onPressed: () async {
                    await auth.signOut();
                  },
                ),
              ),

              const SizedBox(height: AppSizing.paddingXXLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizing.paddingLarge,
        vertical: AppSizing.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutralGray300.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.neutralGray100,
            borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          ),
          child: Icon(icon, color: AppTheme.neutralGray700),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.neutralGray900,
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
      ),
    );
  }
}
