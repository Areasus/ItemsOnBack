# Original -->devyn-backitems
modified for qb and pepe framework 

Setup:
  in qb-spawn in client.lua edit the function PostSpawnPlayer and add ```TriggerEvent("backitems:start")``` to the last line.
  It should now look like this.
  ```  
    local function PostSpawnPlayer(ped)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent("backitems:start")
    end
```

If you use cd_spawnselect you need to edit the function "HasFullySpanwedIn" in the client_customize_me.lua and add  ```TriggerEvent("backitems:start")```

![image](https://user-images.githubusercontent.com/7463741/154318777-3c59ce86-47c6-4f11-b51e-5df52666ed10.png)


If you use qb-clothing you need to add the follow event to the openMenu function.

```TriggerEvent("backitems:displayItems", false)``` 

It should now look like this.

```
   function openMenu(allowedMenus)
    TriggerEvent("backitems:displayItems", false)
    previousSkinData = json.encode(skinData)
    creatingCharacter = true

    local PlayerData = QBCore.Functions.GetPlayerData()
    local trackerMeta = PlayerData.metadata["tracker"]

    GetMaxValues()
    SendNUIMessage({
        action = "open",
        menus = allowedMenus,
        currentClothing = skinData,
        hasTracker = trackerMeta,
    })
    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.25)

    FreezeEntityPosition(PlayerPedId(), true)

    enableCam()
end
```

Also add ```TriggerEvent("backitems:displayItems", true)``` to the close NUI callback
```
RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    creatingCharacter = false
    disableCam()
    TriggerEvent("backitems:displayItems", true)
    FreezeEntityPosition(PlayerPedId(), false)
end)
```

If you use fivem-appearance you need to add the triggers whenever you call the startPlayerCustomization export

```	
	TriggerEvent("backitems:displayItems", false)
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if appearance then
			TriggerServerEvent('fivem-appearance:save', appearance)
			print('Player Clothing Saved')
		else
			print('Canceled')
		end
		TriggerEvent("backitems:displayItems", true)
	end, config)
 ```


 Dont forget to register event weapons:client:SetCurrentWeapon in your weapons(e.g.qb-weapons) you are using
