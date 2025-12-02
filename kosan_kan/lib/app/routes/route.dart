import 'package:go_router/go_router.dart';
import 'package:kosan_kan/data/local/app_prefrence.dart';
import 'package:kosan_kan/presentation/intro/pages/introduction_page.dart';
import 'package:kosan_kan/presentation/auth/pages/login_page.dart';
import 'package:kosan_kan/presentation/auth/pages/register_page.dart';
import 'package:kosan_kan/presentation/auth/pages/forget_password_page.dart';
import 'package:kosan_kan/presentation/navigation/pages/navigation_page.dart';
import 'package:kosan_kan/presentation/home/pages/home_page.dart';
import 'package:kosan_kan/presentation/booked/pages/booked_page.dart';
import 'package:kosan_kan/presentation/favorite/pages/favorite_page.dart';
import 'package:kosan_kan/presentation/profile/pages/profile_page.dart';
import 'package:kosan_kan/presentation/kosan/pages/kosan_list_page.dart';
import 'package:kosan_kan/presentation/kosan/pages/kosan_detail_page.dart';
import 'package:kosan_kan/presentation/kosan/pages/kosan_booking_page.dart';
import 'package:kosan_kan/presentation/payment/pages/payment_page.dart';
import 'package:kosan_kan/presentation/payment/pages/payment_detail_page.dart';
import 'package:kosan_kan/presentation/profile/pages/settings_page.dart';
import 'package:kosan_kan/presentation/profile/pages/help_support_page.dart';
import 'package:kosan_kan/presentation/profile/pages/help_contact_page.dart';
import 'package:kosan_kan/presentation/profile/pages/help_faq_page.dart';
import 'package:kosan_kan/presentation/profile/pages/help_report_page.dart';
import 'package:kosan_kan/presentation/profile/pages/change_password_page.dart';
import 'package:kosan_kan/presentation/profile/pages/edit_profile_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) {
        if (!AppPrefrence.hassSeenIntroduction) {
          return '/introduction';
        }
        return '/auth/login';
      },
    ),
    GoRoute(
      path: '/introduction',
      builder: (context, state) => const IntroductionPage(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/auth/forget-password',
      builder: (context, state) => const ForgetPasswordPage(),
    ),
    GoRoute(
      path: '/app',
      builder: (context, state) {
        final tab = state.uri.queryParameters['tab'];
        final mapping = {'home': 0, 'booked': 1, 'favorite': 2, 'profile': 3};
        int idx = 0;
        if (tab != null) {
          idx = mapping[tab] ?? int.tryParse(tab) ?? 0;
        }
        return NavigationPage(initialIndex: idx);
      },
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/booked', builder: (context, state) => const BookedPage()),
    GoRoute(
      path: '/favorite',
      builder: (context, state) => const FavoritePage(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(
      path: '/profile/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpSupportPage(),
    ),
    GoRoute(
      path: '/help/contact',
      builder: (context, state) => const HelpContactPage(),
    ),
    GoRoute(
      path: '/help/faq',
      builder: (context, state) => const HelpFaqPage(),
    ),
    GoRoute(
      path: '/help/report',
      builder: (context, state) => const HelpReportPage(),
    ),
    GoRoute(
      path: '/profile/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/kosan',
      builder: (context, state) =>
          KosanListPage(filter: state.uri.queryParameters['filter']),
    ),
    GoRoute(
      path: '/kosan/detail',
      builder: (context, state) => KosanDetailPage(
        id: state.uri.queryParameters['id'] ?? '',
        item: state.extra is Map<String, String>
            ? state.extra as Map<String, String>
            : null,
      ),
    ),
    GoRoute(
      path: '/kosan/checkout',
      builder: (context, state) => KosanBookingPage(
        item: state.extra is Map<String, String>
            ? state.extra as Map<String, String>
            : null,
      ),
    ),
    GoRoute(
      name: 'payment',
      path: '/payment',
      builder: (context, state) => PaymentPage(
        amount: int.tryParse(state.uri.queryParameters['amount'] ?? '') ?? 0,
      ),
    ),
    GoRoute(
      name: 'payment_detail',
      path: '/payment/detail',
      builder: (context, state) {
        final method = state.uri.queryParameters['method'] ?? 'Transfer Bank';
        final amount =
            int.tryParse(state.uri.queryParameters['amount'] ?? '') ?? 0;
        final booking = state.extra is Map<String, String>
            ? state.extra as Map<String, String>
            : null;
        return PaymentDetailPage(
          method: method,
          amount: amount,
          booking: booking,
        );
      },
    ),
  ],
);
