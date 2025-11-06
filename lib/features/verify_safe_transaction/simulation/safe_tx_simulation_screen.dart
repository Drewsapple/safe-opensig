import 'package:blockies/blockies.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/models/safe_transaction_model.dart';
import 'package:safe_verify/shared/models/simulation/safe_setting_change.dart';
import 'package:safe_verify/shared/models/simulation/simulation_result.dart';
import 'package:safe_verify/shared/models/simulation/token_transfer.dart';
import 'package:safe_verify/shared/models/simulation/warning_transaction.dart';
import 'package:safe_verify/shared/utils/utilities.dart';
import 'package:wallet/wallet.dart';

class SafeTxSimulationScreen extends StatefulWidget {
  final SafeAccount safeAccount;
  final SafeTransaction transaction;
  final BigInt nonce;
  final SimulationResult simulationResult;

  const SafeTxSimulationScreen({
    super.key,
    required this.safeAccount,
    required this.transaction,
    required this.nonce,
    required this.simulationResult,
  });

  @override
  State<SafeTxSimulationScreen> createState() => _SafeTxSimulationScreenState();
}

class _SafeTxSimulationScreenState extends State<SafeTxSimulationScreen> {
  @override
  Widget build(BuildContext context) {
    if (!widget.simulationResult.success) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Simulation'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Simulation Failed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'The transaction simulation failed, which may indicate that this transaction will revert when submitted on-chain.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                // color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detected Revert Reason:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.simulationResult.revertReason,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push(
                    "/verify-transaction/hashes",
                    extra: (widget.safeAccount, widget.transaction, widget.nonce)
                  );
                },
                child: const Text('Verify Hashes anyway'),
              ),
              SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  GoRouter.of(context).go("/accounts",);
                },
                child: const Text('Abort'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Simulation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceChangesCard(context),
            const SizedBox(height: 16),
            _buildSafeSettingsChangesCard(context),
            const SizedBox(height: 16),
            _buildWarningsCard(context),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    GoRouter.of(context).go("/accounts",);
                  },
                  child: const Text('Abort'),
                ),
                SizedBox(width: 4),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push(
                      "/verify-transaction/hashes",
                      extra: (widget.safeAccount, widget.transaction, widget.nonce)
                    );
                  },
                  child: const Text('Verify Hashes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceChangesCard(BuildContext context) {
    final transfers = widget.simulationResult.transfers;
    if (transfers.isEmpty) {
      return _buildCard(
        context,
        title: 'Balance Changes',
        icon: Icons.account_balance_wallet,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'No balance changes detected',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return _buildCard(
      context,
      title: 'Balance Changes',
      icon: Icons.account_balance_wallet,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transfers.length,
        itemBuilder: (context, index) {
          final transfer = transfers[index];
          return _buildTransferItem(transfer, index == transfers.length-1 ? false : true);
        },
      ),
    );
  }

  Widget _buildTransferItem(TokenTransfer transfer, bool drawSeparatorLine) {
    var isReceived = false;
    if (transfer.recipient.with0x.toLowerCase() == widget.safeAccount.address.toLowerCase()){
      isReceived = true;
    }
    final amount = transfer.amount;
    final metadata = transfer.metadata!;
    final readableAmount = Utilities.formatCryptoAmount(amount, metadata.decimals);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: metadata.logoUri == "unknown" ? Container(
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Text("?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                  ) : Image.network(metadata.logoUri),
                ),
              ),
              SizedBox(width: 5,),
              Text(
                metadata.symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                "${isReceived ? "+" : "-"}$readableAmount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isReceived ? Colors.green : Colors.red
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isReceived ? 'From' : 'Recipient',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Spacer(),
              Text(
                Utilities.truncateIfAddress(isReceived ? transfer.sender.with0x : transfer.recipient.with0x, leadingDigits: 8, trailingDigits: 8),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          drawSeparatorLine ? Container(
            margin: EdgeInsets.only(top: 8),
            child: DottedLine(
              direction: Axis.horizontal,
              dashColor: Colors.white54,
              dashGapLength: 2.5,
            ),
          ) : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _buildSafeSettingsChangesCard(BuildContext context) {
    final changes = widget.simulationResult.safeSettingsChanges;
    if (changes.isEmpty) {
      return _buildCard(
        context,
        title: 'Safe Settings Changes',
        icon: Icons.settings,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'No Safe settings changes detected\n(owners, and threshold changes)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return _buildCard(
      context,
      title: 'Safe Settings Changes',
      icon: Icons.settings,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: changes.length,
        itemBuilder: (context, index) {
          final change = changes[index];
          return _buildSafeSettingChangeItem(change, index == changes.length-1 ? false : true);
        },
      ),
    );
  }

  Widget _buildSafeSettingChangeItem(SafeSettingChange change, bool drawSeparatorLine) {
    String title = '';
    String description = '';
    IconData icon = Icons.add;

    switch (change.type) {
      case SafeSettingChangeType.OWNER_ADDITION:
        final owner = change.data[0] as EthereumAddress;
        title = 'Added new owner';
        description = owner.with0x;
        icon = Icons.add;
        break;
      case SafeSettingChangeType.OWNER_REVOCATION:
        final owner = change.data[0] as EthereumAddress;
        title = 'Removed owner';
        description = owner.with0x;
        icon = Icons.remove;
        break;
      case SafeSettingChangeType.THRESHOLD_CHANGE:
        final threshold = change.data[0] as BigInt;
        title = 'Threshold changed';
        description = 'New threshold: $threshold';
        icon = Icons.numbers;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  icon,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(description),
          drawSeparatorLine ? Container(
            margin: EdgeInsets.only(top: 8),
            child: DottedLine(
              direction: Axis.horizontal,
              dashColor: Colors.white54,
              dashGapLength: 2.5,
            ),
          ) : SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _buildWarningsCard(BuildContext context) {
    final warnings = widget.simulationResult.warningTransactions;
    if (warnings.isEmpty) {
      return _buildCard(
        context,
        title: 'Warnings',
        icon: Icons.warning,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'No warnings detected\n(allowances, safe modules, and safe guards changes)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return _buildCard(
      context,
      title: 'Warnings',
      icon: Icons.warning,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: warnings.length,
        itemBuilder: (context, index) {
          final warning = warnings[index];
          return _buildWarningItem(warning, index == warnings.length-1 ? false : true);
        },
      ),
    );
  }

  Widget _buildWarningItem(WarningTransaction warning, bool drawSeparatorLine) {
    String title = '';
    String preDescription = "";
    String description = '';
    final address = warning.data[0] as EthereumAddress;
    if (warning.type == WarningTransactionType.MODULE_ADDITION){
      title = "Module added to your wallet";
      preDescription = "This will grant this module\n";
      description = "\nfull permission to execute transactions on your behalf, only proceed with this transaction if you trust this module";
    }else if (warning.type == WarningTransactionType.MODULE_REVOCATION){
      title = "Module removed from your wallet";
      preDescription = "This will remove this module\n";
      description = "\nfrom your wallet entirely, which removes access for this module on your wallet";
    }else if (warning.type == WarningTransactionType.MODULE_GUARD_CHANGE){
      title = "Changed module guard of your wallet";
      preDescription = "This will place this contract\n";
      description = "\nas a module guard, that performs on-chain checks to approve any transaction initiated on your wallet by one of your enabled modules, only proceed with this transaction if you trust this module guard";
    }else if (warning.type == WarningTransactionType.GUARD_CHANGE){
      title = "Changed transaction guard of your wallet";
      preDescription = "This will place this contract\n";
      description = "\nas a transaction guard, that performs on-chain checks to approve any transaction initiated and signed by the owner(s), only proceed with this transaction if you trust this guard";
    }else if (warning.type == WarningTransactionType.DELEGATE_CALL){
      title = "Delegate call detected";
      preDescription = "A delegated call was detected to this contract\n";
      description = "\nwhich allows this contract to execute any operation on your behalf, only proceed if you trust and know what is the behavior of this contract";
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber,
                size: 16,
              ),
              SizedBox(width: 5,),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
                text: preDescription,
                style: TextStyle(color: Colors.white54),
                children: [
                  WidgetSpan(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      child: _AddressWidget(
                        address: address.with0x,
                        truncateSize: 13,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                  TextSpan(text: description),
                  WidgetSpan(
                    child: drawSeparatorLine ? Container(
                      margin: EdgeInsets.only(top: 8),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        dashColor: Colors.white54,
                        dashGapLength: 2.5,
                      ),
                    ) : SizedBox.shrink()
                  )
                ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

}

class _AddressWidget extends StatelessWidget {
  final String address;
  final double size;
  final int truncateSize;
  final TextStyle? style;
  const _AddressWidget({
    super.key,
    required this.address,
    this.size=25,
    this.truncateSize=8,
    this.style
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Blockies(
              seed: address,
              color: Colors.teal,
              spotColor: Colors.white,
              bgColor: Colors.greenAccent,
              size: 8,
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          Utilities.truncateIfAddress(address, leadingDigits: truncateSize, trailingDigits: truncateSize),
          style: style,
        )
      ],
    );
  }
}
