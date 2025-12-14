-- xinsu management functions

function grant_xinsu(receiver_account)
    assert(contract_base_info.caller == contract_helper:zuowangdao_account_name(), 'no auth')
    return contract_helper:grant_xinsu(receiver_account)
end

function revoke_xinsu(account_name)
    assert(contract_base_info.caller == contract_helper:zuowangdao_account_name(), 'no auth')
    contract_helper:revoke_xinsu(account_name)
end
