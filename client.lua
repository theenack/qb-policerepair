QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local HasAlreadyGotMessage = false
local isInMarker = false

Locations = {
	vector3(473.36, -1023.25, 28.13),	 --MissionRow behind station
	vector3(1870.43, 3704.32, 33.22),	 --SandyShores Sheriff next to station under trees
	vector3(-454.91, 5984.63, 31.31),	 --Paleto Bay behind station in corner of the heli pad
	vector3(529.98, -28.98, 70.63),	 	 --VinewoodPD - in the left garage
	vector3(832.34, -1405.19, 26.16),	 --PD on Popular behind back building by red tank
	vector3(374.74, -1610.86, 29.29),	 --Davis Sheriff Station parking lot, no parking zone
	vector3(-1113.37, -833.89, 13.34),	 --Vespucci PD in the top level garage
	vector3(-1637.77, -1013.63, 12.73),	 --Del Perro PD under the del perro sign
	vector3(-1473.99, -1013.96, 6.32),	 --Life Guard Station by the sign
	vector3(-1330.7, -1519.96, 3.99),	 --Park Office on the Beach on the right side of the main window
	vector3(-1177.05, -1774.93, 3.85),	 --The Main Life Guard Station on the end of the beach
	vector3(364.32, 792.82, 187.49),	 --Ranger Station next to outhouse
}

function First()

	QBCore.Functions.Progressbar('Repair Vehicle', 'Vehiclebeing repaired', 20000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
	}, {}, {}, function() -- Done
		SetVehicleEngineHealth(vehicle, 1000.0) 
		QBCore.Functions.Notify('We repaired the engine damage.')
		TriggerEvent('Hey:second')
	end, function() -- Cancel
		QBCore.Functions.Notify("Failed!", "error")
	
	end)



end

function Second()




	QBCore.Functions.Progressbar('Repair Vehicle', 'We are fixing all the dents', 20000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
	}, {}, {}, function() -- Done
		SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		QBCore.Functions.Notify('We fixed all the dents.')
		TriggerEvent('Hey:third')
	end, function() -- Cancel
		QBCore.Functions.Notify("Failed!", "error")
	
	end)



end

RegisterNetEvent('Hey:first', function()
	First()
end)

RegisterNetEvent('Hey:second', function()
	Second()
end)

CreateThread(function()
	while true do
		if LocalPlayer.state.isLoggedIn and QBCore.Functions.GetPlayerData().job.name == "police" then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			for k,v in ipairs(Locations) do
				local distance = #(coords.xy - v.xy)
				if distance < 8.0  then
					DrawMarker(36, v.x, v.y, v.z , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 255, 50, false, false, 2, true, nil, nil, false)
					if IsControlJustPressed(0, 38) then
						vehicle = GetVehiclePedIsIn(ped, false)
						if not IsPedInAnyVehicle(ped) then	
							TriggerEvent('chat:addMessage', 'You are not in a vehicle.')
							HasAlreadyGotMessage = true
							Citizen.Wait(5000)
						else
							TriggerEvent('Hey:first')
						end
					end
				end
			end
		end
		Wait(0)
	end
end)