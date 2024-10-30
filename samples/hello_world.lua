function hello_world()
	chainhelper:log('hello world')
	chainhelper:log(date('%Y-%m-%dT%H:%M:%S', chainhelper:time()))
end