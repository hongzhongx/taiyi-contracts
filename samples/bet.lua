-- very import 
YANG_ACCURACY = 1000

function init()
    assert(chainhelper:is_owner(), 'no auth')
    read_list = { public_data = {rate=true, max_bet = true} }
    chainhelper:read_chain()
    public_data.rate  = 98
    public_data.max_bet = 1000000 
	write_list = { public_data = {rate=true, max_bet=true} }
	chainhelper:write_chain()
end

function bet(num, amount)
    read_list = { public_data = {rate=true, max_bet=true} }
    chainhelper:read_chain()

    num = tonumber(num)
    amount = tonumber(amount) * YANG_ACCURACY

    assert( 1 < num and num < 97, "num must in [2,96] " )
    assert( 0 < amount and amount < public_data.max_bet * YANG_ACCURACY, "amount must in [1, max]")

    chainhelper:transfer_from_caller(contract_base_info.owner, amount, 'YANG', true)

    local result_num = chainhelper:random() % 100

    if result_num < num then
        local win_chance = num - 1
        local reward_ratio = public_data.rate * 1.0 / win_chance
        local reward = amount * reward_ratio
        chainhelper:log(string.format('reward:%f', reward)) --这里是浮点数，但是后面实际转移的token是整数
        chainhelper:transfer_from_owner(contract_base_info.caller, reward, 'YANG', true)
    end
end
