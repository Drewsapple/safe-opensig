use std::str::FromStr;

use crate::trace::{
    block::{create_block_env_from_block_details, BlockDetails},
    database::AccountDetails,
    trace::trace_transaction,
};
use revm::{
    context::BlockEnv,
    primitives::{Address, Bytes, HashMap},
};
use crate::trace::trace::op_trace_transaction;

#[flutter_rust_bridge::frb(sync)]
pub fn revm_trace_transaction(
    chain_id: u64,
    from: &str,
    from_nonce: u64,
    to: &str,
    data: &str,
    gas_limit: u64,
    gas_price: u128,
    gas_priority_fee: u128,
    latest_block_env: &str,
    prestate_tracer_result: &str,
    is_op_stack: bool,
) -> String {
    let latest_block: BlockDetails = serde_json::from_str(latest_block_env).unwrap();
    let latest_block_env: BlockEnv = create_block_env_from_block_details(latest_block).unwrap();

    let prestate_tracer_result: HashMap<Address, AccountDetails> =
        serde_json::from_str(prestate_tracer_result).unwrap();

    if (!is_op_stack){
        let result = trace_transaction(
            chain_id,
            from.parse().unwrap(),
            from_nonce,
            to.parse().unwrap(),
            Bytes::from_str(data).unwrap(),
            gas_limit,
            gas_price,
            gas_priority_fee,
            latest_block_env,
            prestate_tracer_result,
        ).unwrap();
        serde_json::to_string_pretty(&result).unwrap()
    } else {
        let result = op_trace_transaction(
            chain_id,
            from.parse().unwrap(),
            from_nonce,
            to.parse().unwrap(),
            Bytes::from_str(data).unwrap(),
            gas_limit,
            gas_price,
            gas_priority_fee,
            latest_block_env,
            prestate_tracer_result,
        ).unwrap();
        serde_json::to_string_pretty(&result).unwrap()
    }

}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
