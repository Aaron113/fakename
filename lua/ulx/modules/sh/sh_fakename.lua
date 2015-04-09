--------------------------- 
-- UFakename by Aaron113 -- 
--------------------------- 

local meta = FindMetaTable("Player") 

function meta:SetFakename(name) 
	if name and name != "" then 
		self:SetNWString("ufakename_name", name) 
	end 
end 

function meta:SetFakegroup(group) 
	if group and group != "" then 
		self:SetNWString("ufakename_group", group) 
	end 
end 

function meta:RemoveFakename() 
	self:SetNWString("ufakename_name", nil) 
end 

local oldGetUserGroup = meta.GetUserGroup 
function meta:GetUserGroup() 
	return self:GetNWString("ufakename_group", false) or oldGetUserGroup(self) 
end 

local oldnick = meta.Nick 
function meta:Nick() 
	return self:GetNWString("ufakename_name", false) or oldnick(self) 
end 

function ulx.fakename(calling_ply, name, group) 
	calling_ply:SetFakename(name) 
	calling_ply:SetFakegroup(group) 
end 
local fakename = ulx.command( "Utility", "ulx fakename", ulx.fakename )
fakename:addParam{ type=ULib.cmds.StringArg, hint="fake name" }
fakename:addParam{ type=ULib.cmds.StringArg, completes=ulx.group_names, hint="group", error="invalid group \"%s\" specified" }
fakename:defaultAccess( ULib.ACCESS_SUPERADMIN )
fakename:help( "Add a user to specified group." )