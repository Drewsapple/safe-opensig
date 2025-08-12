import 'package:go_router/go_router.dart';
import 'package:safe_verify/core/storage/misc_box.dart';
import 'package:safe_verify/features/account_management/account_addition_form_screen.dart';
import 'package:safe_verify/features/account_management/account_listing_screen.dart';
import 'package:safe_verify/features/onboarding/onboarding_screen.dart';
import 'package:safe_verify/features/verify_safe_transaction/presentation/screens/safe_transaction_form_screen.dart';
import 'package:safe_verify/features/verify_safe_transaction/presentation/screens/safe_transaction_verify_screen.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/models/safe_transaction_model.dart';

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
    GoRoute(
      path: '/verify-transaction',
      builder: (context, state) {
        final SafeAccount safeAccount = state.extra as SafeAccount;
        return SafeTransactionFormScreen(safeAccount: safeAccount,);
      },
      routes: [
        GoRoute(
          path: 'verify',
          builder: (context, state) {
            final extra = state.extra as (SafeAccount, SafeTransaction);
            final SafeAccount safeAccount = extra.$1;
            final SafeTransaction safeTx = extra.$2;
            return SafeTransactionVerifyScreen(
              safeAccount: safeAccount,
              safeTransaction: safeTx
            );
          },
        ),
      ],
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