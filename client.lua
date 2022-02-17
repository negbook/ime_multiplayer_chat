local cbs = {} 
RegisterNUICallback("update", function(data, cb)
    for namespace,fn in pairs(cbs) do 
        if(fn) then 
			local action = {}
			fn(action)
			if action["on".."Update"] then action["on".."Update"](data.string,namespace) end 
        end 
    end 
    cb()
	SetNuiFocus(true, false)
	
end)
RegisterNUICallback("delete", function(data, cb)
    for namespace,fn in pairs(cbs) do 
        if(fn) then 
			local action = {}
			fn(action)
			if action["on".."Delete"] then action["on".."Delete"](data.string,namespace) end 
        end 
    end 
    cb()
	SetNuiFocus(true, false)
	
end)
RegisterNUICallback("clear", function(data, cb)
	
    for namespace,fn in pairs(cbs) do 
		local action = {}
		fn(action)
		if action["on".."Clear"] then action["on".."Clear"](data.string,namespace) end 
    end 
    cb()
	SetNuiFocus(true, false)

end)
RegisterNUICallback("enter", function(data, cb)
    SendNUIMessage({
        action    = 'closeInput'
        })
        for namespace,fn in pairs(cbs) do 
            if(fn) then 
				local action = {}
				fn(action)
				if action["on".."Enter"] then action["on".."Enter"](data.string,namespace) end 
				cbs[namespace] = nil 
            end 
        end 
    cb()
	SetNuiFocus(false, false)
	
end)
RequestMultiplayerChatInput = function(cb,x,y)
	local namespace = 'MultiplayerChat'
	SendNUIMessage({
        action    = 'displayInput',
		debug = false
    })
    if x and y then 
        SendNUIMessage({
            action    = 'setIMEPos',
            x    = x,
            y    = y
        })
    end 
    if cbs and not cbs[namespace] then 
        cbs[namespace] = cb 
		local action = {}
        cbs[namespace](action)
		if action["on".."Open"] then action["on".."Open"](namespace) end 
    end     
	SetNuiFocus(true, false)
end
--[[
RegisterNetEvent('RequestInput')
AddEventHandler('RequestInput', RequestInput)
--]]
local nowChars = 0
function AddTypingText(text)
	if nowChars > 50 then return end 
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "ADD_TEXT");
    BeginTextCommandScaleformString( "STRING");
    AddTextComponentSubstringPlayerName( text);
	nowChars = nowChars + #text
    EndTextCommandScaleformString();
    EndScaleformMovieMethod();
end 
function DeleteTypingText( )
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "DELETE_TEXT");
    EndScaleformMovieMethod();
	if nowChars > 0 then 
		nowChars = nowChars - 1
	end 
end 
function ClearTypingText( )
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "ABORT_TEXT");
    EndScaleformMovieMethod();
	nowChars = 0
end 
function SetTypingDone()
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "SET_TYPING_DONE");
    EndScaleformMovieMethod();
	nowChars = 0
end

local ChatActive = false 
CreateThread(function()
	while true do Wait(0)
		if (IsMultiplayerChatActive()) then 
			if not ChatActive then 
				ChatActive = true 
				RequestMultiplayerChatInput(function(input)
					input.onOpen = function() 
						CreateThread(function()
							while ChatActive do Wait(50)
								SendNUIMessage({
									action    = 'updateFocus'
								})
							end 
						end)
					end 
					input.onUpdate = function(text) 
						if (IsMultiplayerChatActive()) then 
							AddTypingText(text)
						end 
					end 
					input.onClear = function() 
						ClearTypingText( )
					end 
					input.onDelete = function() 
						DeleteTypingText()
					end 
					input.onEnter = function(text)
						SetTypingDone()
						CloseMultiplayerChat()
					end 
					
				end,1.0,1.0)
			end 
			
		else 
			if ChatActive then ChatActive = false end 
			if not multiplayer_chat_scaleformhandle then 
				multiplayer_chat_scaleformhandle = RequestScaleformMovie('multiplayer_chat')
			end 
			DrawScaleformMovieFullscreen(multiplayer_chat_scaleformhandle,255,255,255,255)
		end 
	end 
end)