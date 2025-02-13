use starknet::ContractAddress;
use starknet::ClassHash;


#[starknet::interface]
pub trait ICounter<TContractState> {
    fn increment_value(ref self: TContractState);
}