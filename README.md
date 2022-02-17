# fxserver-input
Input utilities for FXServer

[EVENTS]
```
AddEventHandler('RequestInput', function(name,cb,x,y)
```

[HOW IT WORKS]

```
TriggerEvent('RequestInput',WhoNameNeedThisInput,function(action,text,who)
    action >> "update" || "enter"
    text >> "a" "b" "c" "d" || "abcd"
    who >> nil || "somefunc"
end,x,y)

It creates an IME input and callbacks text.
```

[EXAMPLE]

```
--[[
Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    Wait(555)
    TriggerEvent('RequestInput','game_print',function(action,text,who)
        if action then 
                if action == 'firstrun' then 

                elseif action == 'update' then 
                    print(who..':update:'..text)
                elseif action == 'enter' then 
                    print(who..':enter:'..text)
                end 
        end 
    end,100,100)
    TriggerEvent('RequestInput','game_print2',function(action,text,who)
        if action then 
                if action == 'firstrun' then 

                elseif action == 'update' then 
                    print(who..':update:'..text)
                elseif action == 'enter' then 
                    print(who..':enter:'..text)
                end 
        end 
    end,100,100)
end)
]]--
```

[![ [FiveM Script][LIB]Input with GTA5 base chat system.](https://img.youtube.com/vi/2xjQ6lSAeYU/0.jpg)](https://www.youtube.com/watch?v=2xjQ6lSAeYU)
    
[[FiveM Script][LIB]Input with GTA5 base chat system.](https://www.youtube.com/watch?v=2xjQ6lSAeYU)