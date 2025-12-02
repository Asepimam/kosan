import 'package:flutter/material.dart';
import 'package:kosan_kan/app/notifications.dart';
import 'package:kosan_kan/l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  Color _activeColor(BuildContext context) => const Color(0xFF2AAE9E);
  Color _inactiveColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final bool active = index == selectedIndex;
    final color = active ? _activeColor(context) : _inactiveColor(context);
    // For Booked tab (index == 1) show a green dot when there's a new booking
    final Widget iconWidget = (index == 1)
        ? ValueListenableBuilder<bool>(
            valueListenable: hasNewBooking,
            builder: (context, hasNew, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: color, size: 22),
                  if (hasNew)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2AAE9E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          )
        : Icon(icon, color: color, size: 22);

    final labelStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: color, fontSize: 11);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 4),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 8),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildItem(
              context,
              Icons.home,
              AppLocalizations.of(context).t('nav_home'),
              0,
            ),
            _buildItem(
              context,
              Icons.bedtime,
              AppLocalizations.of(context).t('nav_booked'),
              1,
            ),
            _buildItem(
              context,
              Icons.favorite,
              AppLocalizations.of(context).t('nav_favorite'),
              2,
            ),
            _buildItem(
              context,
              Icons.person,
              AppLocalizations.of(context).t('nav_profile'),
              3,
            ),
          ],
        ),
      ),
    );
  }
}
