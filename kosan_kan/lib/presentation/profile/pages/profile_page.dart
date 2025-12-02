import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kosan_kan/presentation/auth/bloc/auth_bloc.dart';
import '../widgets/avatar_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Color get accent => const Color(0xFF2AAE9E);

  // Fallback simulated values while profile is loading
  final String _name = 'Avery Lorem-Ipsum With A Very Long Name Possibly';
  final String _email = 'avery.longemailaddress@example-very-long-domain.com';
  // No wallet balance stored — payments are direct (QRIS/VA/Mobile Banking)

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // navigate to login when logged out
          context.go('/auth/login');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildStatsRow(),
                const SizedBox(height: 16),
                _buildActionsCard(),
                const SizedBox(height: 20),
                _buildLogout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Wallet UI removed — payments are made directly via available methods.

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final displayName = (user?.firstName != null || user?.lastName != null)
            ? '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim()
            : (user?.userName ?? _name);
        final displayEmail = user?.email ?? _email;
        final avatarUrl = user?.profilePicture;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accent, accent.withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              AvatarPicker(
                radius: 36,
                initialUrl: avatarUrl,
                onChanged: (file) {
                  if (file != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Avatar diperbarui')),
                    );
                  }
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.onPrimary,
                            foregroundColor: accent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            context.go('/profile/edit');
                          },
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      displayEmail,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard('Booked', '12'),
        const SizedBox(width: 12),
        _statCard('Favorites', '24'),
        const SizedBox(width: 12),
        _statCard('Reviews', '8'),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: accent,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Payments moved to booking flow. No direct wallet/top-up here.
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            subtitle: const Text('Preferences & privacy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.go('/profile/settings');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            subtitle: const Text('FAQ, contact us'),

            onTap: () {
              context.go('/help');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // dispatch logout through bloc
            final bloc = context.read<AuthBloc>();
            bloc.add(const LogoutRequested());
          },
          icon: const Icon(Icons.logout_outlined),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.onSurface,
            foregroundColor: accent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            // minor action: clear cache or show dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Clear cache (placeholder)')),
            );
          },
          child: Text(
            'Clear cache',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.75),
            ),
          ),
        ),
      ],
    );
  }
}
