// keccak256("EIP712Domain(uint256 chainId,address verifyingContract)")
const String DOMAIN_SEPARATOR_TYPEHASH = "0x47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a79469218";
// keccak256("EIP712Domain(address verifyingContract)")
const String DOMAIN_SEPARATOR_TYPEHASH_OLD = "0x035aff83d86937d35b32e04f0ddc6ff469290eef2f1b692d8a815c89404d4749";
//
// keccak256("SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 baseGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)")
const String SAFE_TX_TYPEHASH = "0xbb8310d486368db6bd6f849402fdd73ad53d316b5a4b2644ad6efe0f941286d8";
// keccak256("SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 dataGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)")
const String SAFE_TX_TYPEHASH_OLD = "0x14d461bc7412367e924637b363c7bf29b8f47e2f84869f4426e5633d8af47b20";
// keccak256("SafeMessage(bytes message)")
const String SAFE_MSG_TYPEHASH = "0x60b3cbf8b4a223d68d641b3b6ddf9a298e7f33710cf3d3a9d1146b5a6150fbca";