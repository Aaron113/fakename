-------------------------- 
-- Fakename by Aaron113 -- 
-------------------------- 

local meta = FindMetaTable("Player") 

oldGetUserGroup = meta.GetUserGroup 
function meta:GetUserGroup() 
	return self:GetNWString("fakename_group", false) or oldGetUserGroup(self) 
end 
newGetUserGroup = meta.GetUserGroup 
meta.GetUserGroup = oldGetUserGroup

local oldnick = meta.Nick 
function meta:Nick() 
	return self:GetNWString("fakename_name", false) or oldnick(self) 
end 

function meta:RealNick() 
	return oldnick(self) 
end 

function meta:SetFakename(name) 
	self:SetNWString("fakename_name", name) 
end 

function meta:SetFakegroup(group) 
	meta.GetUserGroup = newGetUserGroup 
	self:SetNWString("fakename_group", group) 
	if ulx.teams then 
		hook.GetTable().PlayerSpawn.UTeamSpawnAuth(self) 
	end 
	meta.GetUserGroup = oldGetUserGroup 
end 

function meta:RemoveFakename() 
	self:SetNWString("fakename_name", false) 
end 

function meta:RemoveFakegroup() 
	self:SetNWString("fakename_group", false) 
	if ulx.teams then 
		hook.GetTable().PlayerSpawn.UTeamSpawnAuth(self) 
	end 
end 

function meta:ClearFakename() 
	self:RemoveFakename() 
	self:RemoveFakegroup() 
end 

function meta:IsFakenamed() 
	return self:GetNWString("fakename_name", false) or self:GetNWString("fakename_group", false) 
end 

function ulx.fakename(calling_ply, name, group) 
	ulx.fancyLogAdmin(calling_ply, true, "#A fakenamed themselves #s in group #s", name, group) 
	calling_ply:SetFakename(name) 
	calling_ply:SetFakegroup(group) 
end 
local fakename = ulx.command( "Utility", "ulx fakename", ulx.fakename )
fakename:addParam{ type=ULib.cmds.StringArg, hint="fake name" }
fakename:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names, hint="group", error="invalid group \"%s\" specified" }
fakename:defaultAccess( ULib.ACCESS_SUPERADMIN )
fakename:help( "Add a user to specified group." )

function ulx.unfakename(calling_ply) 
	if calling_ply:IsFakenamed() then 
		calling_ply:RemoveFakename() 
		ulx.fancyLogAdmin(calling_ply, true, "#A unfakenamed") 
	end 
end 
local unfakename = ulx.command( "Utility", "ulx unfakename", ulx.unfakename )
unfakename:defaultAccess( ULib.ACCESS_SUPERADMIN )
unfakename:help( "Add a user to specified group." )