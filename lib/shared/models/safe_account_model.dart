import 'package:equatable/equatable.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:safe_verify/shared/constants/network_constants.dart';
import 'package:safe_verify/shared/models/network_model.dart';

class SafeAccount extends HiveObject with EquatableMixin {
  final String id;
  final String name;
  final String address;
  final int chainId;
  final String version;

  SafeAccount({
    required this.id,
    required this.name,
    required this.address,
    required this.chainId,
    required this.version,
  });

  Network get network => availableNetworks[chainId]!;

  @override
  List<Object> get props => [id, address];

  SafeAccount copyWith({
    String? id,
    String? name,
    String? address,
    int? chainId,
    String? version,
  }) {
    return SafeAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      chainId: chainId ?? this.network.chainId,
      version: version ?? this.version,
    );
  }
}