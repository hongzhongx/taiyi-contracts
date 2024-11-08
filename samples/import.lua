function test_import() 
	local temp = import_contract('contract.test') 
	-- temp.contract_helper = contract_helper 
	temp.hello_world() 
end
