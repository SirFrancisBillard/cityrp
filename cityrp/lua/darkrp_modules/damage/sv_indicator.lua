util.AddNetworkString( "BDI_SendToClient" )

function BDI_ScalePlayerDamage(victim,hitgroup,dmginfo)

	local RealAttacker = dmginfo:GetAttacker()
	local Position = dmginfo:GetReportedPosition()
	local Damage = dmginfo:GetDamage()
	
	if not RealAttacker then
		RealAttacker = dmginfo:GetInflictor()
	end	
	
	if not Position then
		Position = ( RealAttacker:GetPos() + RealAttacker:OBBCenter() )
	end
	
	if not Damage then
		Damage = 1
	end
	
	net.Start("BDI_SendToClient")
		net.WriteVector(Position)
		net.WriteFloat(Damage)
	net.Send(victim)
	
end

hook.Add("ScalePlayerDamage","BDI: ScalePlayerDamage",BDI_ScalePlayerDamage)