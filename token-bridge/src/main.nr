mod util;
mod token_interface;

// Minimal implementation of the token bridge that can move funds between L1 <> L2.
// The bridge has a corresponding Portal contract on L1 that it is attached to
// And corresponds to a Token on L2 that uses the `AuthWit` accounts pattern.
// Bridge has to be set as a minter on the token before it can be used

contract TokenBridge {
    use dep::aztec::{
        context::{Context},
        hash::{compute_secret_hash},
        state_vars::{public_state::PublicState},
        types::type_serialization::field_serialization::{
            FieldSerializationMethods, FIELD_SERIALIZED_LEN,
        },
        types::address::{AztecAddress, EthereumAddress},
        selector::compute_selector,
    };
  use crate::token_interface::Token;
  use crate::util::{get_mint_public_content_hash, get_mint_private_content_hash, get_withdraw_content_hash};
// Storage structure, containing all storage, and specifying what slots they use.
    struct Storage {
        token: PublicState<Field, 1>,
    }

    impl Storage {
        fn init(context: Context) -> pub Self {
            Storage {
                token: PublicState::new(
                    context,
                    1,
                    FieldSerializationMethods,
                ),
            }
        }
    }

    // Constructs the contract.
    #[aztec(private)]
    fn constructor(token: AztecAddress) {
        let selector = compute_selector("_initialize((Field))");
        context.call_public_function(context.this_address(), selector, [token.address]);
    }
}
