me = {}

me.saveData = function(key,value)
	if not value then
		return
	end
	
	local filepath = system.pathForFile(key,system.DocumentsDirectory)
	local file = io.open(filepath, "w")
	if file then
		file:write(value)
		io.close(file)
	end
end

me.loadData = function(key)
	local filepath = system.pathForFile(key, system.DocumentsDirectory)
	local file = io.open(filepath,"r")
	local value
	if file then
		 value = file:read("*a")
		io.close(file)
	end
	return value or false
end	

return me