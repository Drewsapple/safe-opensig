import 'dart:convert';
import 'dart:typed_data';

import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

Uint8List encodeAbi(List<String> types, List<dynamic> values){
  List<AbiType> abiTypes = [];
  LengthTrackingByteSink result = LengthTrackingByteSink();
  for (String type in types){
    var abiType = parseAbiType(type);
    abiTypes.add(abiType);
  }
  TupleType(abiTypes).encode(values, result);
  var resultBytes = result.asBytes();
  result.close();
  return resultBytes;
}

List<dynamic> decodeAbi(List<String> types, Uint8List value){
  List<AbiType> abiTypes = [];
  for (String type in types){
    var abiType = parseAbiType(type);
    abiTypes.add(abiType);
  }
  final parsedData = TupleType(abiTypes).decode(value.buffer, 0);
  return parsedData.data;
}

Uint8List solidityPack(List<String> types, List<dynamic> values){
  if (values.length != types.length){
    throw ArgumentError("wrong number of values; expected ${ types.length }");
  }

  LengthTrackingByteSink sink = LengthTrackingByteSink();

  for (int i=0; i<values.length; i++){
    var x = _pack(types[i], values[i]);
    sink.add(x);
  }

  var sinkBytes = sink.asBytes();
  sink.close();
  return sinkBytes;
}

var _regexBytes = RegExp(r"^(bytes)([0-9]+)$");
var _regexNumber = RegExp(r"^(u?int)([0-9]*)$");
Uint8List _pack(String type, dynamic value){
  if (type == "address"){
    if (value is EthereumAddress){
      return value.value;
    }
  }
  if (type == "string"){
    return Uint8List.fromList(utf8.encode(value));
  }
  //
  var numMatch = _regexNumber.allMatches(type);
  if (numMatch.isNotEmpty) {
    var size = int.parse(numMatch.length > 1 ? numMatch.elementAt(2).input : "256");
    if ((size % 8 != 0) || size == 0 || size > 256) {
      throw ArgumentError("invalid number type");
    }

    BigInt _value = BigInt.from(value).toUnsigned(size);
    Uint8List result = Uint8List(size~/8);
    Uint8List list = intToBytes(_value);
    result.setAll(size~/8 - list.length, list);

    return result;
  }

  if (value is Uint8List){
    return value;
  }

  if (value is String){
    return hexToBytes(value);
  }

  return Uint8List(0);
}