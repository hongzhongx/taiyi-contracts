-- very import 
YANG_ACCURACY = 1000

function init()
    assert(contract_helper:is_owner(), 'no auth')
    local public_data = {rate  = 98, max_bet = 1000000}
	contract_helper:write_contract_data(public_data, {rate=true, max_bet=true})
end

function bet(num, amount)
    local public_data = contract_helper:read_contract_data({rate=true, max_bet=true})

    num = tonumber(num)
    amount = tonumber(amount) * YANG_ACCURACY

    assert( 1 < num and num < 97, "num must in [2,96] " )
    assert( 0 < amount and amount < public_data.max_bet * YANG_ACCURACY, "amount must in [1, max]")

    contract_helper:transfer_from_caller(contract_base_info.owner, amount, 'YANG', true)

    local result_num = contract_helper:random() % 100

    if result_num < num then
        local win_chance = num - 1
        local reward_ratio = public_data.rate * 1.0 / win_chance
        local reward = amount * reward_ratio
        contract_helper:log(string.format('reward:%f', reward)) --这里是浮点数，但是后面实际转移的token是整数
        contract_helper:transfer_from_owner(contract_base_info.caller, reward, 'YANG', true)
    end
end
