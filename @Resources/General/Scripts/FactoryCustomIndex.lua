-- Structure of Script Measure:
---- IncFile=
---- Number=
---- SectionName=
---- OptionN=
---- ValueN=
---- where N is an ordered number from 0
-- Use %% to substitute it as the iteration number (which is specified by the Number option)
---- For example, if you specify 10, it will create 10 sections and replace the first section's %%
---- with 0, the second section's %% with 1, etc...
-- Wrap any formulas you want to parse in {} that otherwise RM would treat as a string
---- For example, [Measure{%%+1}] will have this script parse it for you

function Initialize()
	local index = SELF:GetNumberOption("Index")
	local num = SELF:GetNumberOption("Number")
	local sectionName = SELF:GetOption("SectionName")

	local file = io.open(SKIN:MakePathAbsolute(SELF:GetOption("IncFile")), "w")
	
	local t = {}
	
	for i = index, num do
		table.insert(t, "[" .. doSub(sectionName, i) .. "]")
		local j = 0
		
		while true do
			local opt = SELF:GetOption("Option" .. j)
			if opt == "" then
				break
			end
			table.insert(t, opt .. "=" .. doSub(SELF:GetOption("Value" .. j), i))
			j = j + 1
		end
		
		table.insert(t, "")
	end
	
	file:write(table.concat(t, "\n"))
	file:close()
end

-- does all the substitution!
function doSub(value, i)
	local val = value:gsub("%%%%", i)
	if string.match(val, '%[%]%b<>') then
		val = val:gsub("%[%]", "")
		val = val:gsub('<', "[")
		val = val:gsub('>', "]")
		--val = "[" .. val:gsub("%[%]", "") .. "]"
	end
	return val
end

-- sub to remove {the curly braces}, then add (parentheses), then parse it
function parseFormula(formula)
	return SKIN:ParseFormula("(" .. formula:sub(2, -2) .. ")")
end