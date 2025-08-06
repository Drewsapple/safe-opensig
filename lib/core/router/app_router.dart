import 'package:go_router/go_router.dart';
import 'package:safe_verify/core/storage/misc_box.dart';
import 'package:safe_verify/features/account_management/account_addition_form_screen.dart';
import 'package:safe_verify/features/account_management/account_listing_screen.dart';
import 'package:safe_verify/features/onboarding/onboarding_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountListingScreen(),
      routes: [
        GoRoute(
          path: '/add-account',
          builder: (context, state) => const AccountAdditionFormScreen(),
        ),
      ]
    ),
  ],
  redirect: (context, state) async {
    final isOnboardingCompleted = MiscBox.isOnboardingCompleted();
    if (isOnboardingCompleted && state.uri.path == '/onboarding') {
      return '/accounts';
    }
    if (!isOnboardingCompleted && state.uri.path != '/onboarding') {
      return '/onboarding';
    }
    return null;
  },
);