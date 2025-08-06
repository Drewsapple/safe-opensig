import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_verify/core/storage/misc_box.dart';
import 'package:safe_verify/core/theme/theme_config.dart';
import 'package:safe_verify/features/account_management/account_state_provider.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/widgets/network_logo.dart';

class AccountListingScreen extends ConsumerWidget {
  const AccountListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final selectedAccountId = MiscBox.getSelectedAccountId();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          accounts.isNotEmpty ? IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).go('/accounts/add-account');
            },
          ) : const SizedBox.shrink(),
        ],
      ),
      body: accounts.isEmpty ? _EmptyStateWidget() : ListView.builder(
        padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return _AccountCard(
            account: account,
            isActive: account.id == selectedAccountId,
            onTap: () {
              ref.read(accountsProvider.notifier).selectAccount(account.id);
              ref.invalidate(accountsProvider);
            },
          );
        },
      ),
      floatingActionButton: accounts.isNotEmpty ? FloatingActionButton.extended(
        onPressed: () {
          // TODO: impl
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verify Safe Transaction feature coming soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        label: const Text('Verify Safe Transaction', style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _AccountCard extends StatelessWidget {
  final SafeAccount account;
  final bool isActive;
  final VoidCallback onTap;

  const _AccountCard({
    required this.account,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var borderColor = isActive ? Theme.of(context).colorScheme.primary : Colors.white.withValues(alpha: 0.5);
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: const EdgeInsets.only(bottom: ThemeConfig.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: ThemeConfig.borderRadiusLarge,
        boxShadow: ThemeConfig.shadowMedium,
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: isActive ? 4.0 : 0.5,
          ),
          right: BorderSide(color: borderColor, width: 0.5),
          top: BorderSide(color: borderColor, width: 0.5),
          bottom: BorderSide(color: borderColor, width: 0.5)
        ),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: isActive ? 3 : 8,
        child: InkWell(
          onTap: onTap,
          borderRadius: ThemeConfig.borderRadiusLarge,
          child: Padding(
            padding: const EdgeInsets.all(ThemeConfig.spacingMedium),
            child: Row(
              children: [
                Container(
                  width: ThemeConfig.iconSizeLarge,
                  height: ThemeConfig.iconSizeLarge,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: NetworkLogo(network: account.network),
                ),
                const SizedBox(width: ThemeConfig.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: ThemeConfig.spacingXSmall),
                      Text(
                        _trimAddress(account.address),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _trimAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

}

class _EmptyStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          const Text(
            'No accounts yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first account to get started',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/accounts/add-account');
            },
            child: const Text('Add Account'),
          ),
        ],
      ),
    );
  }
}
