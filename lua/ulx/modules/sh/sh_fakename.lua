-------------------------- 
-- Fakename by Aaron113 -- 
-------------------------- 

HOOK_MONITOR_LOW = HOOK_MONITOR_LOW or 2 -- (Ensure we don't break on older ULibs) 

local meta = FindMetaTable("Player") 

-- Just in case some gamemodes overwrite name functions too (DarkRP) 
hook.Add("Initialize", "SetupFakename", function() 

	oldGetUserGroup = meta.GetUserGroup 
	function meta:GetUserGroup( b_realgroup ) 
		if b_realgroup then 
			return oldGetUserGroup(self) 
		else  
			return self:GetNWString("fake_group", false) or oldGetUserGroup(self)
		end 
	end 
	newGetUserGroup = meta.GetUserGroup 
	meta.GetUserGroup = oldGetUserGroup

	local oldnick = meta.Nick 
	function meta:Nick( b_realnick ) 
		if b_realnick then 
			return oldnick(self) 
		else 
			return self:GetNWString("fake_name", false) or oldnick(self)
		end  
	end 
	meta.Name = meta.Nick 
	meta.GetName = meta.Nick 

end, HOOK_MONITOR_LOW)

function meta:RealNick() 
	return self:Nick(true) 
end 

function meta:SetFakename( name ) 
	self:SetNWString("fake_name", name) 
	hook.Call("OnFakeNameChanged") 
end 

function meta:SetFakegroup( group ) 
	meta.GetUserGroup = newGetUserGroup 
	self:SetNWString("fake_group", group) 

	-- set uteam to new group 
	if hook.GetTable().PlayerSpawn.UTeamSpawnAuth then 
		hook.GetTable().PlayerSpawn.UTeamSpawnAuth(self) 
	end 

	hook.Call("OnFakeGroupChanged")

	meta.GetUserGroup = oldGetUserGroup 
end 

function meta:GetFakename() 
	return self:GetNWString("fake_name", self:Nick()) 
end 

function meta:GetFakegroup() 
	return self:GetNWString("fake_group", self:GetUserGroup()) 
end 

function meta:RemoveFakename() 
	self:SetFakename() 
end 

function meta:RemoveFakegroup() 
	self:SetFakegroup() 
end 

function meta:ClearFakename() 
	self:RemoveFakename() 
	self:RemoveFakegroup() 
end 

function meta:IsFakenamed() 
	return (self:GetNWString("fake_name", false) or self:GetNWString("fake_group", false))
end 

function ulx.fakename( calling_ply, name, group ) 
	if !group or group == "" then 
		group = calling_ply:GetUserGroup() 
	end 

	ulx.fancyLogAdmin(calling_ply, true, "#A fakenamed themselves #s in group #s", name, group) 
	calling_ply:SetFakename(name) 
	calling_ply:SetFakegroup(group) 
end 
local fakename = ulx.command( "Utility", "ulx fakename", ulx.fakename )
fakename:addParam{ type=ULib.cmds.StringArg, hint="fake name" }
fakename:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names, hint="group", error="invalid group \"%s\" specified", ULib.cmds.optional }
fakename:defaultAccess( ULib.ACCESS_SUPERADMIN )
fakename:help( "Changes your in-game name and group." )

function ulx.unfakename( calling_ply ) 
	if calling_ply:IsFakenamed() then 
		calling_ply:ClearFakename() 
		ulx.fancyLogAdmin(calling_ply, true, "#A unfakenamed") 
	end 
end 
local unfakename = ulx.command( "Utility", "ulx unfakename", ulx.unfakename )
unfakename:defaultAccess( ULib.ACCESS_SUPERADMIN )
unfakename:help( "Removes any fake names or groups" )