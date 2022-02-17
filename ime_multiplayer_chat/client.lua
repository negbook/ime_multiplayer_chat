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
RequestInput = function(namespace,cb,x,y)
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

RegisterNetEvent('RequestInput')
AddEventHandler('RequestInput', RequestInput)
function AddTypingText( text)
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "ADD_TEXT");
    BeginTextCommandScaleformString( "STRING");
    AddTextComponentSubstringPlayerName( text);
    EndTextCommandScaleformString();
    EndScaleformMovieMethod();
end 
function DeleteTypingText( )
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "DELETE_TEXT");
    EndScaleformMovieMethod();
end 
function ClearTypingText( )
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "ABORT_TEXT");
    EndScaleformMovieMethod();
end 
function  SetTypingDone( addMessage)
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "SET_TYPING_DONE");
    EndScaleformMovieMethod();
    if (addMessage) then
        AddFeedMessage(username, textBuffer);
    end
    textBuffer = "";
end
function  AddFeedMessage( name,  message)
    BeginScaleformMovieMethod(multiplayer_chat_scaleformhandle, "ADD_MESSAGE");
    ScaleformMovieMethodAddParamTextureNameString( name);
    ScaleformMovieMethodAddParamTextureNameString( message);
    EndScaleformMovieMethod();
end
local ChatActive = false 
CreateThread(function()
	while true do Wait(0)
		if (IsMultiplayerChatActive()) then 
			if not ChatActive then 
				ChatActive = true 
				RequestInput('game_print',function(input)
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
						SetTypingDone(text)
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