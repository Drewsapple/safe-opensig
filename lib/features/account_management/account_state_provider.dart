import 'package:flutter_riverpod/legacy.dart';
import 'package:safe_verify/core/storage/accounts_box.dart';
import 'package:safe_verify/core/storage/misc_box.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';

final accountsProvider = StateNotifierProvider<AccountsNotifier, List<SafeAccount>>((ref) {
  return AccountsNotifier();
});

class AccountsNotifier extends StateNotifier<List<SafeAccount>> {
  AccountsNotifier() : super([]) {
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    state = AccountsBox.getAccounts();
  }

  Future<void> addAccount(SafeAccount account) async {
    await AccountsBox.addAccount(account);
    state = [...state, account];
  }

  Future<void> removeAccount(String accountId) async {
    await AccountsBox.removeAccount(accountId);
    final selectedAccountId = MiscBox.getSelectedAccountId();
    if (selectedAccountId == accountId) {
      await MiscBox.setSelectedAccountId(null);
    }
    state = AccountsBox.getAccounts();
  }

  Future<void> selectAccount(String accountId) async {
    final accountExists = state.any((account) => account.id == accountId);
    if (accountExists) {
      await MiscBox.setSelectedAccountId(accountId);
    }
  }
}