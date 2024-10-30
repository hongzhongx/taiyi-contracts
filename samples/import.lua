function test_import() 
	local temp = import_contract('contract.test') 
	-- temp.chainhelper = chainhelper 
	temp.hello_world() 
end
