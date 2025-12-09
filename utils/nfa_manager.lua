-- NFA basic functions

function create_nfa_symbol(symbol, describe, contract, max_count, min_equivalent_qi, is_sbt)
    contract_helper:create_nfa_symbol(symbol, describe, contract, max_count, min_equivalent_qi, is_sbt)
end

function change_nfa_symbol_authority(symbol, authority_account)
    contract_helper:change_nfa_symbol_authority(symbol, authority_account)
end

function change_nfa_symbol_authority_nfa_symbol(symbol, authority_symbol_name)
    contract_helper:change_nfa_symbol_authority_nfa_symbol(symbol, authority_symbol_name)
end

function create_nfa_to_me(symbol)
    contract_helper:create_nfa_to_account(contract_base_info.caller, symbol, {})
end

function transfer_nfa_to_account(to_account, nfa_id)
    contract_helper:transfer_nfa_from_caller(to_account, nfa_id, true)
end

function change_nfa_active_operator(nfa_id, account_name)
    contract_helper:change_nfa_active_operator(nfa_id, account_name)
end

-- Zone basic functions
function create_zone(zone_name, zone_type)
    local id = contract_helper:create_zone(zone_name, zone_type)
    local zone_info = contract_helper:get_zone_info_by_name(zone_name)
    local chinese_types = import_contract("contract.utils.types")
    contract_helper:narrate(string.format('名为%s的%s区域（nfa#%d）被创建', zone_name, chinese_types.zone_type_strings[zone_info.type_id+1], id), true)
end

-- Actor basic functions
function create_actor_talent_rule(contract_name)
    local id = contract_helper:create_actor_talent_rule(contract_name)
    contract_helper:narrate(string.format('角色天赋（#%d）被创建', id), true)
end

function create_actor(family_name, last_name)
    local id = contract_helper:create_actor(family_name, last_name)
    contract_helper:narrate(string.format('角色%s%s（nfa#%d）被创建', family_name, last_name, id), true)
end