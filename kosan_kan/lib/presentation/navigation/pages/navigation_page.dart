import 'package:flutter/material.dart';
import 'package:kosan_kan/app/notifications.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../home/pages/home_page.dart';
import '../../booked/pages/booked_page.dart';
import '../../favorite/pages/favorite_page.dart';
import '../../profile/pages/profile_page.dart';

class NavigationPage extends StatefulWidget {
  final int initialIndex;
  const NavigationPage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    BookedPage(),
    FavoritePage(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    if (index == _selectedIndex) return;
    // If user opens Booked tab, clear the new-booking badge
    if (index == 1) {
      hasNewBooking.value = false;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
