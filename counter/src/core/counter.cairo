#[starknet::contract]
mod  Counter{
    use starknet::storage::StoragePointerReadAccess;
    use starknet::{ContractAddress,get_caller_address};
    use starknet::storage::StoragePointerWriteAccess;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePathEntry};

    // Store contract address & increment value
    #[storage]
    struct Storage {
        pub map:Map::<ContractAddress,u256>
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        IncrementEvent:IncrementEvent
    }

    #[derive(Drop, starknet::Event)]
    struct IncrementEvent{
        #[key]
        value:u256,
        #[key]
        message:felt252
    }

    #[abi(embed_v0)]
    impl CounterImpl of counter::interfaces::counter::ICounter<ContractState>{
        fn increment_value(ref self: ContractState){
            let caller = get_caller_address();
            let value = self.map.entry(caller).read() + 1;
            self.map.entry(caller).write(value);
            self.emit(IncrementEvent {value:value,message:'IncrementEvent'.into()}); 
        }
    }

    fn get_value(ref self: ContractState, address:ContractAddress) -> u256{
        self.map.entry(address).read()
    }

}