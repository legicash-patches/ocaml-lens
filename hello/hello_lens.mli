module Revision = Int32

module Amount = Int64

module Address = Int64

module AddressMap : Map.S with type key = Address.t

type keypair = unit

val find_default: 'a -> Address.t -> 'a AddressMap.t -> 'a

val address_map_lens: 'a -> Address.t -> ('a AddressMap.t, 'a) Lens.t

type account_state = {balance: Amount.t; account_revision: Revision.t} [@@deriving lens]

type chain_state =
  { previous: chain_state option
  ; chain_revision: Revision.t
  ; accounts: account_state AddressMap.t }
  [@@deriving lens { prefix = true }]

type fee_schedule =
  { deposit_fee: Amount.t; fee_per_billion: Amount.t } [@@deriving lens { submodule = false; }]

type manager_state =
  { keypair: keypair
  ; chain_state: chain_state
  ; fee_schedule: fee_schedule }
    [@@deriving lens { submodule = false; prefix = true}]

