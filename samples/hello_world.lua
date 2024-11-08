function hello_world()
	contract_helper:log('hello world')
	contract_helper:log(date('%Y-%m-%dT%H:%M:%S', contract_helper:time()))
end