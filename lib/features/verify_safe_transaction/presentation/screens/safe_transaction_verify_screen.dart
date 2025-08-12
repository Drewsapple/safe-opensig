import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_verify/shared/models/safe_account_model.dart';
import 'package:safe_verify/shared/models/safe_transaction_model.dart';

class SafeTransactionVerifyScreen extends StatelessWidget {
  final SafeAccount safeAccount;
  final SafeTransaction safeTransaction;

  const SafeTransactionVerifyScreen({
    super.key,
    required this.safeAccount,
    required this.safeTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Transaction')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AccountDetailsCard(safeAccount: safeAccount),
            _TransactionHashesCard(
              safeAccount: safeAccount,
              safeTransaction: safeTransaction,
            ),
            const SizedBox(height: 16),
            _TransactionJsonCard(safeTransaction: safeTransaction),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AccountDetailsCard extends StatefulWidget {
  final SafeAccount safeAccount;

  const _AccountDetailsCard({required this.safeAccount});

  @override
  State<_AccountDetailsCard> createState() => _AccountDetailsCardState();
}

class _AccountDetailsCardState extends State<_AccountDetailsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(widget.safeAccount.name),
            subtitle: Text(
              '${widget.safeAccount.network.name} · Safe v${widget.safeAccount.version}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              icon: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5).animate(_expandAnimation),
                child: const Icon(Icons.expand_more),
              ),
              onPressed: _toggleExpansion,
            ),
            onTap: _toggleExpansion,
          ),
          ClipRect(
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Account Details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _AccountDetailRow(label: 'Name', value: widget.safeAccount.name),
                    _AccountDetailRow(
                      label: 'Address',
                      value: widget.safeAccount.address,
                    ),
                    _AccountDetailRow(
                      label: 'Network',
                      value: widget.safeAccount.network.name,
                    ),
                    _AccountDetailRow(
                      label: 'Version',
                      value: widget.safeAccount.version,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionHashesCard extends StatefulWidget {
  final SafeAccount safeAccount;
  final SafeTransaction safeTransaction;

  const _TransactionHashesCard({
    required this.safeAccount,
    required this.safeTransaction,
  });

  @override
  State<_TransactionHashesCard> createState() => _TransactionHashesCardState();
}

class _TransactionHashesCardState extends State<_TransactionHashesCard> {
  late Future<(bool, String, String, String)> _hashesFuture;

  @override
  void initState() {
    super.initState();
    _hashesFuture = widget.safeTransaction.calculateHashes(widget.safeAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hashes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FutureBuilder<(bool, String, String, String)>(
              future: _hashesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || !snapshot.data!.$1) {
                  return const Text('Failed to calculate hashes');
                }
                final (_, domainHash, messageHash, txHash) = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HashDetailRow(
                      label: 'Domain',
                      value: domainHash,
                    ),
                    _HashDetailRow(
                      label: 'Message',
                      value: messageHash,
                    ),
                    _HashDetailRow(
                      label: 'Transaction',
                      value: txHash,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _AccountDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _HashDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _HashDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                  child: IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    splashRadius: 16,
                    tooltip: 'Copy to clipboard',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionJsonCard extends StatefulWidget {
  final SafeTransaction safeTransaction;

  const _TransactionJsonCard({required this.safeTransaction});

  @override
  State<_TransactionJsonCard> createState() => _TransactionJsonCardState();
}

class _TransactionJsonCardState extends State<_TransactionJsonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionData = {
      'to': widget.safeTransaction.to,
      'value': widget.safeTransaction.value.toString(),
      'data': widget.safeTransaction.data,
      'operation': widget.safeTransaction.operation,
      'safeTxGas': widget.safeTransaction.safeTxGas.toString(),
      'baseGas': widget.safeTransaction.baseGas.toString(),
      'gasPrice': widget.safeTransaction.gasPrice.toString(),
      'gasToken': widget.safeTransaction.gasToken,
      'refundReceiver': widget.safeTransaction.refundReceiver,
    };
    final jsonString = const JsonEncoder.withIndent('  ').convert(transactionData);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Transaction Data'),
            trailing: IconButton(
              icon: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5).animate(_expandAnimation),
                child: const Icon(Icons.expand_more),
              ),
              onPressed: _toggleExpansion,
            ),
            onTap: _toggleExpansion,
          ),
          ClipRect(
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        jsonString,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: jsonString));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to clipboard'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                          tooltip: 'Copy JSON to clipboard',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
