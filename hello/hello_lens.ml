open Lens.Infix

module Revision = Int32
module Amount = Int64
module Address = Int64
module AddressMap = Map.Make (Address)
type keypair = unit

let find_default default address map =
  match AddressMap.find_opt address map with None -> default | Some x -> x

let address_map_lens default address =
  Lens.{get= find_default default address; set= AddressMap.add address}

type account_state = {balance: Amount.t; account_revision: Revision.t} [@@deriving lens]

let default_account_state = {balance= Amount.zero; account_revision= Revision.zero}

type chain_state =
  { previous: chain_state option
  ; chain_revision: Revision.t
  ; accounts: account_state AddressMap.t }
  [@@deriving lens { prefix = true }]

(* TODO: get the submodule=true working *)

type fee_schedule =
  { deposit_fee: Amount.t; fee_per_billion: Amount.t } [@@deriving lens { submodule = false; }]

type manager_state =
  { keypair: keypair
  ; chain_state: chain_state
  ; fee_schedule: fee_schedule }
    [@@deriving lens { submodule = false; prefix = true }]

let next_revision revision = Revision.add revision Revision.one

let tweak_manager_state s =
  s
  |> Lens.modify (lens_manager_state_chain_state |-- lens_chain_state_chain_revision) next_revision
  |> (lens_manager_state_chain_state |-- lens_chain_state_accounts
      |-- address_map_lens default_account_state Address.zero
      |-- account_state_balance).set (Amount.of_int 42)
