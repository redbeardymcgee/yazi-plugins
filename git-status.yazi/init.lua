local function string_split(input,delimiter)

	local result = {}

	for match in (input..delimiter):gmatch("(.-)"..delimiter) do
	        table.insert(result, match)
	end
	return result
end

local function set_status_color(status)
	if status == nil then
		return "#6cc749"
	elseif status == "M" then
		return "#ec613f"
	elseif status == "A" then
		return "#ec613f"
	elseif status == "I" then
		return "#ae96ee"
	elseif status == "U" then
		return "#D4BB91"
	elseif status == "R" then
		return "#ec613f"
	else
		return "#ec613f"
	end
	
end

local function fix_str_ch(str)
    local chinese_chars, num_replacements = str:gsub("\\(%d%d%d)", function (s)
        return string.char(tonumber(s, 8))
    end)
    return num_replacements > 0 and chinese_chars:sub(2,-2) or chinese_chars
end

local function make_git_table(git_status_str)
	local file_table = {}
	local git_status
	local is_dirty = false
	local filename
	local multi_path
	local is_ignore_dir = false
	local convert_name
	local split_table = string_split(git_status_str:sub(1,-2),"\n")
	for _, value in ipairs(split_table) do
		split_value = string_split(value," ")
		if split_value[#split_value - 1] == "" then
			split_value = string_split(value,"  ")
		end

		if split_value[#split_value - 1] == "??" then 
			git_status = "U"
			is_dirty = true
		elseif split_value[#split_value - 1] == "!!" then
			git_status = "I"
		elseif split_value[#split_value - 1] == "->" then
			git_status = "R"
		else
			git_status = split_value[#split_value - 1]
			is_dirty = true
		end
		if split_value[#split_value]:sub(-2,-1) == "./" and git_status == "I" then
			is_ignore_dir = true
			return file_table,is_dirty,is_ignore_dir
		end
		multi_path = string_split(split_value[#split_value],"/")
		if (multi_path[#multi_path] == "" and #multi_path == 2) or git_status ~= "I" then
			filename = multi_path[1]
		else 
			filename = split_value[#split_value]
		end
		
		convert_name = fix_str_ch(filename)
		file_table[convert_name] = git_status
	end

	return file_table,is_dirty,is_ignore_dir
end

local save = ya.sync(function(st, cwd, git_branch,git_file_status,git_is_dirty,git_status_str,is_ignore_dir)
	if cx.active.current.cwd == Url(cwd) then
		st.git_branch = git_branch
		st.git_file_status = git_file_status
		st.git_is_dirty = git_is_dirty
		st.git_status_str = git_status_str
		st.is_ignore_dir = is_ignore_dir
		ya.render()
	end
end)

local clear_state = ya.sync(function(st)
	st.git_branch = ""
	st.git_file_status = ""
	st.git_is_dirty = ""
	ya.render()
end)

local set_opts_default = ya.sync(function(state)
	if (state.opt_style == nil) then
		state.opt_style = "linemode"
	end
end)

local function update_git_status(files)
	local filemane = tostring((files[1]).url)
	local str = filemane:sub(-1,-1) == "/" and filemane:sub(1,-2) or filemane
	local pattern = "(.+)/[^/]+$"
	local pwd = string.match(str, pattern)
	ya.manager_emit("plugin", { "git-status", args = ya.quote(tostring(pwd))})	
end

local is_in_git_dir = ya.sync(function(st)
	return (st.git_branch ~= nil and st.git_branch ~= "") and true or false
end)


local M = {
	setup = function(st,opts)

		set_opts_default()
		if (opts ~= nil and opts.style ~= nil ) then
			st.opt_style  = opts.style
		end		

		if st.opt_style == "beside" then
			function File:symlink(file)
				local git_span = {}
				if st.git_status_str ~= nil and st.git_status_str ~= "" then
					local name = file.name:gsub("\r", "?", 1)
					local git_status = st.is_ignore_dir and "I" or st.git_file_status[name]
					local color = set_status_color(git_status)
					if file:is_hovered() then
						git_span = git_status and {ui.Span(" ["),ui.Span(git_status),ui.Span("]")}				
					else
						git_span = git_status and {ui.Span(" ["):fg(color),ui.Span(git_status):fg(color),ui.Span("]"):fg(color)}
					end
				end

				if not MANAGER.show_symlink and (st.git_status_str == nil or st.git_status_str == "") then
					return {}
				elseif not MANAGER.show_symlink and st.git_status_str ~= nil and st.git_status_str ~= "" then
					return git_span
				elseif MANAGER.show_symlink and st.git_status_str ~= nil and st.git_status_str ~= "" then
					local to = file.link_to
					return to and {git_span, ui.Span(" -> " .. tostring(to)):italic() } or {git_span}
				else
					local to = file.link_to
					return to and { ui.Span(" -> " .. tostring(to)):italic() } or {}
				end
			end
		else
			function Folder:linemode(area, files)
				local mode = cx.active.conf.linemode
			
				local lines = {}
				local git_span = {}
				for _, f in ipairs(files) do
					local spans = { ui.Span(" ") }
					if st.git_branch ~= nil and st.git_branch ~= "" then
						local name = f.name:gsub("\r", "?", 1)
						local git_status = st.is_ignore_dir and "I" or (st.git_file_status and st.git_file_status[name] or nil)
						local color = set_status_color(git_status)
						if f:is_hovered() then
							git_span = (git_status) and ui.Span(git_status) or ui.Span("✓")	
						else
							git_span = (git_status) and ui.Span(git_status):fg(color) or ui.Span("✓"):fg(color)		
						end
					end
					if mode == "size" then
						local size = f:size()
						spans[#spans + 1] = ui.Span(size and ya.readable_size(size) or "")
					elseif mode == "mtime" then
						local time = f.cha.modified
						spans[#spans + 1] = ui.Span(time and os.date("%y-%m-%d %H:%M", time // 1) or "")
					elseif mode == "permissions" then
						spans[#spans + 1] = ui.Span(f.cha:permissions() or "")
					end

					spans[#spans + 1] = ui.Span(" ")
					spans[#spans + 1] = git_span
					spans[#spans + 1] = ui.Span(" ")
					lines[#lines + 1] = ui.Line(spans)
				end
				return ui.Paragraph(area, lines):align(ui.Paragraph.RIGHT)
			end
		end
		function Header:cwd(max)
			local git_line = ui.Line {}
			local cwd = cx.active.current.cwd

			if st.cwd ~= cwd then
				st.cwd = cwd
				clear_state()
				ya.manager_emit("plugin", { st._name, args = ya.quote(tostring(cwd))})
			else
				local git_is_dirty = st.git_is_dirty  and "*" or ""
				git_line = (st.git_branch and st.git_branch ~= "") and ui.Line {ui.Span(" <".. st.git_branch .. git_is_dirty .. ">"):fg("#c6ca4a")} or ui.Line {}				
			end

			local s = ya.readable_path(tostring(cx.active.current.cwd)) .. self:flags()
			return ui.Line{ui.Span(ya.truncate(s, { max = math.max(0,max - git_line:width()), rtl = true }) ):style(THEME.manager.cwd),git_line}
		end
	end,

	entry = function(_, args)
		local output
		local git_is_dirty

		local git_branch  = ""
		local command = "git symbolic-ref HEAD 2> /dev/null" 
		local file = io.popen(command, "r")
		output = file:read("*a") 
		file:close()

		if output ~= nil and  output ~= "" then
			local split_output = string_split(output:sub(1,-2),"/")
			
			git_branch = split_output[3]
		else
			return
		end
		
		local git_status_str = ""
		local git_file_status = nil
		local command = "git status --ignored -s --ignore-submodules=dirty 2> /dev/null" 
		local file = io.popen(command, "r")
		output = file:read("*a") 
		file:close()

		if output ~= nil and  output ~= "" then
			git_status_str = output
			git_file_status,git_is_dirty,is_ignore_dir = make_git_table(git_status_str)
		end
		save(args[1], git_branch,git_file_status,git_is_dirty,git_status_str,is_ignore_dir)
	end,
}

function M:fetch()
	if is_in_git_dir() then
		update_git_status(self.files)	
	end
	return 3	
end

return M