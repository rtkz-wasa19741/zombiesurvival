ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
	if self.Silent == nil then self.Silent = false end
	if self.InstantChange == nil then self.InstantChange = true end
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif name == "seton" then
		self.On = tonumber(args) == 1
		return true
	elseif name == "enable" then
		self.On = true
		return true
	elseif name == "disable" then
		self.On = false
		return true
	elseif name == "setsilent" or name == "setinstantchange" then
		self:KeyValue(string.sub(name, 4), args)
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	elseif key == "enabled" then
		self.On = tonumber(value) == 1
	elseif key == "silent" then
		self.Silent = tonumber(value) == 1
	elseif key == "instantchange" then
		self.InstantChange = tonumber(value) == 1
	end
end

function ENT:StartTouch(ent)
	if self.On and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_UNDEAD then
		if ent:GetZombieClassTable().Boss then
			self:Input("onbosstouched",ent,self,string.lower(ent:GetZombieClassTable().Name))
		else
			local prevpos = ent:GetPos()
			local prevang = ent:GetAngles()
			GAMEMODE:SpawnBossZombie(ent, self.Silent)
			if self.InstantChange then
				ent:SetPos(prevpos)
				ent:SetEyeAngles(prevang)
			end
		end
	end
end
