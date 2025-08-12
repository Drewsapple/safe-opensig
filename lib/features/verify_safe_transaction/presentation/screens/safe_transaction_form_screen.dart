import 'package:animations/animations.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as CupertinoTabBar;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_verify/core/router/app_router.dart';
import 'package:safe_verify/core/theme/theme_config.dart';
import 'package:safe_verify/features/verify_safe_transaction/presentation/widgets/safe_tx_calldata_guide_sheet.dart';
import 'package:safe_verify/features/verify_safe_transaction/presentation/widgets/safe_tx_calldata_input.dart';
import 'package:safe_verify/features/verify_safe_transaction/presentation/widgets/safe_tx_json_guide_sheet.dart';
import 'package:safe_verify/features/verify_safe_transaction/presentation/widgets/safe_tx_json_input.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/models/safe_transaction_model.dart';

class SafeTransactionFormScreen extends StatefulWidget {
  final SafeAccount safeAccount;
  const SafeTransactionFormScreen({super.key, required this.safeAccount});

  @override
  State<SafeTransactionFormScreen> createState() =>
      _SafeTransactionFormScreenState();
}

class _SafeTransactionFormScreenState extends State<SafeTransactionFormScreen> {
  final String _jsonInputHint = '''
{
  "to": "0x....",
  "value": "...",
  "data": "0x...",
  "operation": ...,
  "baseGas": "...",
  "gasPrice": "...",
  "gasToken": "0x...",
  "refundReceiver": "0x...",
  "nonce": ...,
  "safeTxGas": "..."
}
''';
  final String _callDataInputHint = '''0x6a7612020000000000000000000000007abc22d179a5f21d563a6e70da8bb9c4bc8b212700000000000000000000000000000000000000000000000000000....''';
  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _callDataController = TextEditingController();
  late final TextStyle tabSelectedTextStyle;
  late final TextStyle tabDeselectedTextStyle;
  SafeTransaction? safeTransaction;
  int lastIndex = 0;
  int currentIndex = 0;
  int cupertinoTabBarValueGetter() => currentIndex;

  @override
  void initState() {
    var navigatorContext = router.configuration.navigatorKey.currentContext!;
    tabSelectedTextStyle = TextStyle(color: Theme.of(navigatorContext).colorScheme.primary, fontSize: 15, fontWeight: FontWeight.bold,);
    tabDeselectedTextStyle = TextStyle(color: Theme.of(navigatorContext).colorScheme.onPrimary, fontSize: 15, fontWeight: FontWeight.w600,);
    super.initState();
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _callDataController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    GoRouter.of(context).push("/verify-transaction/verify", extra: (widget.safeAccount, safeTransaction!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Safe Transaction'),
      ),
      body: Column(
        children: [
          CupertinoTabBar.CupertinoTabBar(
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.onPrimary,
            [
              Text(
                "JSON",
                style: currentIndex == 0 ? tabSelectedTextStyle : tabDeselectedTextStyle,
                textAlign: TextAlign.center,
              ),
              Text(
                "CallData",
                style: currentIndex == 1 ? tabSelectedTextStyle : tabDeselectedTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
            cupertinoTabBarValueGetter,
            (int index) {
              if (currentIndex == 0){
                _jsonController.clear();
              }else{
                _callDataController.clear();
              }
              lastIndex = currentIndex;
              setState(() {
                safeTransaction = null;
                currentIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(50),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              reverse: currentIndex < lastIndex,
              transitionBuilder: (
                child,
                animation,
                secondaryAnimation,
              ) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: child,
                );
              },
              child: currentIndex == 0 ? safeTxJsonTab() : safeTxCalldataTab(),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: safeTransaction != null ? _onSubmit : null,
            child: const Text('Submit'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget safeTxJsonTab(){
    return Container(
      key: ValueKey<int>(currentIndex),
      child: Column(
        children: [
          SafeTxJsonInput(
            controller: _jsonController,
            hintText: _jsonInputHint,
            onValidInput: (safeTx){
              setState(() => safeTransaction = safeTx);
            },
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const SafeTxJsonGuideSheet(),
                  isScrollControlled: true,
                  showDragHandle: true,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: ThemeConfig.borderRadiusLarge,
                  )
                );
              },
              style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                  visualDensity: VisualDensity.compact,
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: ThemeConfig.borderRadiusSmall
                  ))
              ),
              child: Text(
                '💡 How to get this data',
                style: ThemeConfig.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget safeTxCalldataTab(){
    return Container(
      key: ValueKey<int>(currentIndex),
      child: Column(
        children: [
          SafeTxCalldataInput(
            controller: _callDataController,
            hintText: _callDataInputHint,
            onValidInput: (safeTx){
              setState(() => safeTransaction = safeTx);
            },
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const SafeTxCalldataGuideSheet(),
                  isScrollControlled: true,
                  showDragHandle: true,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: ThemeConfig.borderRadiusLarge,
                  )
                );
              },
              style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                  visualDensity: VisualDensity.compact,
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: ThemeConfig.borderRadiusSmall
                  ))
              ),
              child: Text(
                '💡 How to get this data',
                style: ThemeConfig.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

}