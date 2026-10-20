 
if game.PlaceId ~= 606849621 then
    local message = "This script only works in Jailbreak."
    warn("FUNSTATOV: " .. message)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "FUNSTATOV",
            Text = message,
            Duration = 6,
        })
    end)
    return
end

 
local function showKeyGate()
    local Players=game:GetService("Players")
    local Tween=game:GetService("TweenService")
    local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
    if _G.FunstatovGateCleanup then pcall(_G.FunstatovGateCleanup) end
    if _G.FunstatovCleanup then pcall(_G.FunstatovCleanup) end
    local accepted,finished=false,false
    local event=Instance.new("BindableEvent")
    local connections={}
    local function connect(signal,fn)
        local c=signal:Connect(fn);connections[#connections+1]=c;return c
    end
    local function make(kind,props,parent)
        local o=Instance.new(kind)
        for k,v in pairs(props) do o[k]=v end
        if o:IsA("GuiBase2d") then o.AutoLocalize=false end
        o.Parent=parent;return o
    end
    local green=Color3.fromRGB(0,255,114)
    local muted=Color3.fromRGB(103,164,133)
    local gui=make("ScreenGui",{Name="FunstatovKeyGate",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=20000,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},pg)
    local panel=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(680,480),
        BackgroundColor3=Color3.fromRGB(2,15,10),BorderSizePixel=0,ClipsDescendants=true,Active=false},gui)
    make("UICorner",{CornerRadius=UDim.new(0,14)},panel)
    make("UIStroke",{Color=green,Transparency=.55,Thickness=1},panel)
    local scale=make("UIScale",{Scale=1},panel)
    local function resize()
        local camera=workspace.CurrentCamera
        if camera then scale.Scale=math.min(1,(camera.ViewportSize.X-24)/680,(camera.ViewportSize.Y-24)/480) end
    end
    resize()
    connect(game:GetService("RunService").RenderStepped,resize)
     
    for x=0,680,32 do
        make("Frame",{Position=UDim2.fromOffset(x,0),Size=UDim2.fromOffset(1,480),BorderSizePixel=0,
            BackgroundColor3=green,BackgroundTransparency=.94,ZIndex=1},panel)
    end
    for y=0,480,32 do
        make("Frame",{Position=UDim2.fromOffset(0,y),Size=UDim2.fromOffset(680,1),BorderSizePixel=0,
            BackgroundColor3=green,BackgroundTransparency=.94,ZIndex=1},panel)
    end
    local function text(value,x,y,w,h,size,color)
        return make("TextLabel",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,
            Text=value,TextColor3=color or green,Font=Enum.Font.Code,TextSize=size or 14,TextWrapped=true,ZIndex=3},panel)
    end
    local title=text("FUNSTATOV",30,54,620,48,32,Color3.fromRGB(221,255,234))
    title.Font=Enum.Font.GothamBlack
    local status=text("",30,356,620,28,14,muted)
    local function hover(o)
        local stroke=make("UIStroke",{Color=green,Transparency=.65,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},o)
        make("UICorner",{CornerRadius=UDim.new(0,7)},o)
        connect(o.MouseEnter,function() Tween:Create(stroke,TweenInfo.new(.15),{Transparency=0,Thickness=2}):Play() end)
        connect(o.MouseLeave,function() Tween:Create(stroke,TweenInfo.new(.15),{Transparency=.65,Thickness=1}):Play() end)
    end
    local function button(value,x,y,w,h,fn,primary)
        local b=make("TextButton",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),Text=value,
            Font=Enum.Font.GothamBold,TextSize=15,AutoButtonColor=false,TextColor3=primary and Color3.fromRGB(0,25,12) or green,
            BackgroundColor3=primary and green or Color3.fromRGB(5,28,18),BorderSizePixel=0,ZIndex=3},panel)
        hover(b);if fn then connect(b.Activated,fn) end;return b
    end
    local box=make("TextBox",{Position=UDim2.fromOffset(30,155),Size=UDim2.fromOffset(438,66),Text="",
        PlaceholderText="ENTER KEY HERE",PlaceholderColor3=muted,ClearTextOnFocus=false,MultiLine=false,
        TextColor3=Color3.fromRGB(230,255,238),Font=Enum.Font.Code,TextSize=21,
        BackgroundColor3=Color3.fromRGB(1,12,8),BorderSizePixel=0,ZIndex=3},panel)
    hover(box)
     
    local UIS=game:GetService("UserInputService")
    local dragging=nil
    local function inside(o,p)
        local a,b=o.AbsolutePosition,o.AbsoluteSize
        return p.X>=a.X and p.X<=a.X+b.X and p.Y>=a.Y and p.Y<=a.Y+b.Y
    end
    connect(UIS.InputBegan,function(input)
        if input.UserInputType~=Enum.UserInputType.MouseButton1
            and input.UserInputType~=Enum.UserInputType.Touch then return end
        local p=Vector2.new(input.Position.X,input.Position.Y)
        if not inside(panel,p) then return end
        for _,o in ipairs(panel:GetDescendants()) do
            if o:IsA("GuiObject") and o.Visible and (o:IsA("GuiButton") or o:IsA("TextBox"))
                and inside(o,p) then return end
        end
        local a,b=panel.AbsolutePosition,panel.AbsoluteSize
        panel.Position=UDim2.fromOffset(a.X+b.X/2,a.Y+b.Y/2)
        dragging={input=input,start=p,center=Vector2.new(a.X+b.X/2,a.Y+b.Y/2)}
    end)
    connect(UIS.InputChanged,function(input)
        if not dragging then return end
        local mouse=dragging.input.UserInputType==Enum.UserInputType.MouseButton1
        if (mouse and input.UserInputType==Enum.UserInputType.MouseMovement)
            or input==dragging.input then
            local p=Vector2.new(input.Position.X,input.Position.Y)
            local nextPosition=dragging.center+(p-dragging.start)
            local view=workspace.CurrentCamera.ViewportSize
            local half=panel.AbsoluteSize*.5
            panel.Position=UDim2.fromOffset(
                math.clamp(nextPosition.X,half.X,math.max(half.X,view.X-half.X)),
                math.clamp(nextPosition.Y,half.Y,math.max(half.Y,view.Y-half.Y)))
        end
    end)
    connect(UIS.InputEnded,function(input)
        if dragging and (input==dragging.input or input.UserInputType==Enum.UserInputType.MouseButton1) then dragging=nil end
    end)
    connect(UIS.WindowFocusReleased,function() dragging=nil end)
    local close
    local function finish(ok)
        if finished then return end
        finished=true;accepted=ok
        for _,c in ipairs(connections) do c:Disconnect() end
        if _G.FunstatovGateCleanup==close then _G.FunstatovGateCleanup=nil end
        gui:Destroy();event:Fire()
    end
    close=function() finish(false) end
    _G.FunstatovGateCleanup=close
    connect(gui.Destroying,close)
    local function digest256(s)
        local b=bit32
        local band,bxor,bnot,rr,rs=b.band,b.bxor,b.bnot,b.rrotate,b.rshift
        local mod=4294967296
        local k={
            0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
            0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
            0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
            0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
            0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
            0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
            0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
            0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
        local h={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
        local bits=#s*8
        local function word(n)
            return string.char(band(rs(n,24),255),band(rs(n,16),255),band(rs(n,8),255),band(n,255))
        end
        s=s..string.char(128)..string.rep(string.char(0),(55-#s)%64)..word(math.floor(bits/mod))..word(bits%mod)
        for offset=1,#s,64 do
            local w={}
            for i=0,15 do
                local p=offset+i*4
                local a,c,d,e=s:byte(p,p+3)
                w[i]=a*16777216+c*65536+d*256+e
            end
            for i=16,63 do
                local x,y=w[i-15],w[i-2]
                w[i]=(w[i-16]+bxor(rr(x,7),rr(x,18),rs(x,3))+w[i-7]+bxor(rr(y,17),rr(y,19),rs(y,10)))%mod
            end
            local a,c,d,e,f,g,j,l=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
            for i=0,63 do
                local t1=(l+bxor(rr(f,6),rr(f,11),rr(f,25))+bxor(band(f,g),band(bnot(f),j))+k[i+1]+w[i])%mod
                local t2=(bxor(rr(a,2),rr(a,13),rr(a,22))+bxor(band(a,c),band(a,d),band(c,d)))%mod
                l,j,g,f,e,d,c,a=j,g,f,(e+t1)%mod,d,c,a,(t1+t2)%mod
            end
            local v={a,c,d,e,f,g,j,l}
            for i=1,8 do h[i]=(h[i]+v[i])%mod end
        end
        local out={}
        for i=1,8 do out[i]=string.format('%08x',h[i]) end
        return table.concat(out)
    end
    local function submit()
        if finished then return end
        local key=box.Text:match("^%s*(.-)%s*$")
        if #key<=256 and digest256(key)=="57c5be41145e8bb6b3b2db47d42e3f7c3afd6fc84acd3582ce25017899e8bea7" then
            box.Text="";finish(true)
        else
            status.Text=key=="" and "Enter your key first." or "Invalid key. Check it and try again."
            status.TextColor3=Color3.fromRGB(255,134,108)
        end
    end
    local function link(url,label)
        if finished then return end
        local copy=setclipboard or toclipboard
        if type(copy)=="function" then
            local ok,result=pcall(copy,url)
            if ok and result~=false then
                status.Text="Link copied!"
                status.TextColor3=Color3.fromRGB(130,255,170)
                return
            end
        end
        status.Text="Could not copy link."
        status.TextColor3=Color3.fromRGB(255,134,108)
    end
    button("SUBMIT KEY",480,155,170,66,submit,true)
    button("GET KEY",30,239,302,46,function()
        link("https://funstatov.github.io/funstatov-jeilbreak/","Get Key")
    end,true)
    button("HOW TO GET KEY",346,239,304,46,function()
        link("https://youtu.be/4VjjB8FVS-A?si=1u3uM9pIAGMD9vu2","How to get key")
    end,true)
    button("YOUTUBE",30,307,302,40,function() link("https://youtube.com/@funstatov?si=l95ODcgGakGt4TYG","YouTube") end)
    button("CLOSE",346,307,304,40,close)
    local footer=button("Tech support // Cooperation // @funstatjeilscript",30,405,620,42,function()
        link("https://t.me/funstatjeilscript","Support")
    end)
    footer.Font=Enum.Font.Code;footer.TextSize=14;footer.BackgroundTransparency=.55
    connect(box.FocusLost,function(enter) if enter then submit() end end)
    if not finished then event.Event:Wait() end
    event:Destroy()
    return accepted
end
if not showKeyGate() then return end

 
 
if _G.FunstatovCleanup then pcall(_G.FunstatovCleanup) end
for _,key in ipairs({"AutoArrestCleanup","PowerFlowCleanup","__CasinoFullCycle","__JewelryCycle","__OilFullCycle"}) do
    if type(_G[key])=="function" then pcall(_G[key]) end
end
local oldPG=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
for _,name in ipairs({"BenzinAutoRoute","GasAutoRoute","DonutAutoRoute"}) do
    local old=oldPG:FindFirstChild(name);if old then old:Destroy() end
end
local HUB_SOURCES = {}
HUB_SOURCES['Auto Arrest'] = [====[
local hubStart
local function hubCapture(fn) hubStart=fn end
local Players=game:GetService('Players')
local P=Players.LocalPlayer
local RS=game:GetService('RunService')
local UIS=game:GetService('UserInputService')
local VIM=game:GetService('VirtualInputManager')
local V=Vector3.new
if _G.ArrestStateCleanup then _G.ArrestStateCleanup() end
if _G.CuffsDiagnosticCleanup then _G.CuffsDiagnosticCleanup() end
if _G.AutoArrestCleanup then _G.AutoArrestCleanup() end
local gui=Instance.new('ScreenGui',P:WaitForChild('PlayerGui'))
gui.Name='AutoArrestIntercept';gui.ResetOnSpawn=false
local panel=Instance.new('Frame',gui)
panel.Size=UDim2.fromOffset(310,190)
panel.AnchorPoint=Vector2.new(1,.5)
panel.Position=UDim2.new(1,-10,.5,0)
panel.BackgroundColor3=Color3.fromRGB(25,28,35)
local function control(class,txt,x,y,w,h)
 local o=Instance.new(class,panel)
 o.Position=UDim2.fromOffset(x,y);o.Size=UDim2.fromOffset(w,h)
 o.BackgroundColor3=Color3.fromRGB(45,55,70)
 o.TextColor3=Color3.new(1,1,1);o.TextSize=14
 o.Font=Enum.Font.Gotham;o.Text=txt
 return o
end
control('TextLabel','AUTO ARREST | SHORT CHASE 200',10,8,290,26)
local status=control('TextLabel','Police + Camaro driver seat',10,40,290,65)
status.TextWrapped=true
local start=control('TextButton','Start',10,115,90,30)
local stop=control('TextButton','Stop',110,115,90,30)
local copy=control('TextButton','Copy log',210,115,90,30)
control('TextLabel','Handcuffs slot:',10,152,190,25)
local slot=control('TextBox','2',210,152,90,25)
slot.ClearTextOnFocus=false
local running,cancel,dead=false,false,false
local car,model,character,hover,cameraSave=nil,nil,nil,nil,nil
local cuffSelected=false
local blocked,history={},{}
local began=os.clock()
local held={}
local lastEnemyVehicle=nil
local foot=nil
local paidTarget=nil
local completed={}
local attempt=nil
local pursuitTarget=nil
local cuffsMode='idle'
local cuffsBusy=false
local cuffsPulse=nil
local nextCuffsCheck=0
local nextCuffsInput=0
local function releaseCuffsPulse()
 if cuffsPulse then
  VIM:SendKeyEvent(false,cuffsPulse.key,false,game)
  held[cuffsPulse.key]=nil
  cuffsPulse=nil
 end
end
local function setCuffsMode(mode,target)
 releaseCuffsPulse()
 cuffsMode=mode;pursuitTarget=target
end
local function log(s)
 history[#history+1]=string.format('%.2fs | %s',os.clock()-began,s)
 status.Text=s;print('[Arrest] '..s)
end
local function parts(p)
 local c=p.Character
 return c,c and c:FindFirstChild('HumanoidRootPart'),c and c:FindFirstChildOfClass('Humanoid')
end
local function team(p,n) return p.Team and p.Team.Name:lower()==n end
local function check()
 if cancel or dead then error('Stopped',0) end
 local c,r,h=parts(P)
 assert(c==character and r and h and h.Health>0,'Character unavailable')
 assert(team(P,'police'),'Police team required')
 assert(not UIS:GetFocusedTextBox(),'Finish editing or close chat')
end
local function waitFor(t)
 local finish=os.clock()+t
 repeat check();RS.Heartbeat:Wait() until os.clock()>=finish
end
local function key(k,duration)
 check();held[k]=true;VIM:SendKeyEvent(true,k,false,game)
 local ok,err=pcall(function() waitFor(duration) end)
 VIM:SendKeyEvent(false,k,false,game);held[k]=nil
 if not ok then error(err,0) end
end
local function restoreCamera()
 if cameraSave then
  local s=cameraSave;cameraSave=nil
  s.camera.CameraType=s.kind;s.camera.CameraSubject=s.subject;s.camera.CFrame=s.cf
 end
end
local function clearHover()
 if hover then for _,o in ipairs(hover) do o:Destroy() end;hover=nil end
end
local function stopFoot()
 local f=foot;foot=nil
 if not f then return end
 for _,o in ipairs(f.objects) do o:Destroy() end
 if f.root.Parent then f.root.AssemblyLinearVelocity=Vector3.zero end
 if f.hum.Parent then
  f.hum.PlatformStand=f.platform;f.hum.AutoRotate=f.rotate
  f.hum:SetStateEnabled(Enum.HumanoidStateType.Seated,f.seated)
 end
end
local function cleanup()
 setCuffsMode('idle',nil)
 for k in pairs(held) do pcall(function() VIM:SendKeyEvent(false,k,false,game) end) end
 held={};restoreCamera();stopFoot();clearHover()
end
local function vehicle(p)
 local c,r=parts(p)
 local a=r and r.AssemblyRootPart
 local folder=workspace:FindFirstChild('Vehicles')
 if not (a and folder and a:IsDescendantOf(folder)) then return end
 local m=a
 while m.Parent~=folder do m=m.Parent end
 return a,m
end
local function driver()
 local _,r,h=parts(P)
 if not r or not h or not h.Sit or vehicle(P)~=car then return false end
 local seat=model and model:FindFirstChild('Seat')
 if not seat or not seat:IsA('BasePart') then return false end
 local d=(r.Position-seat.Position).Magnitude
 if d>2.75 then return false end
 local passengerFound=false
 for _,o in ipairs(model:GetDescendants()) do
  if o:IsA('BasePart') and o.Name:lower():find('passenger',1,true) then
   passengerFound=true
   if (r.Position-o.Position).Magnitude<=d+.25 then return false end
  end
 end
 return passengerFound
end
local function params(extra)
 local list={}
 for _,p in ipairs(Players:GetPlayers()) do if p.Character then list[#list+1]=p.Character end end
 if model then list[#list+1]=model end
 if extra then list[#list+1]=extra end
 local r=RaycastParams.new();r.FilterType=Enum.RaycastFilterType.Exclude
 r.FilterDescendantsInstances=list;r.RespectCanCollide=true
 return r
end
local searchCache={time=-1,value=false}
local function searchVisible()
 if os.clock()-searchCache.time<.15 then return searchCache.value end
 local found=false
 for _,o in ipairs(P.PlayerGui:GetDescendants()) do
  if (o:IsA('TextLabel') or o:IsA('TextButton')) and not o:IsDescendantOf(gui) then
   local text=o.Text:gsub('<[^>]->',''):match('^%s*(.-)%s*$')
   if text=='Поиск' or text=='Обыск' or text=='Обыскать'
    or text:lower()=='search' or text:lower()=='frisk' then
    local visible=o.TextTransparency<1 and o.AbsoluteSize.X>0 and o.AbsoluteSize.Y>0
    local node=o
    while node and visible do
     if node:IsA('GuiObject') and not node.Visible then visible=false end
     if node:IsA('LayerCollector') and not node.Enabled then visible=false end
     node=node.Parent
    end
    if visible then found=true;break end
   end
  end
 end
 searchCache={time=os.clock(),value=found}
 return found
end
local function searchForTarget(p)
 if vehicle(p) or not searchVisible() then return false end
 local _,root=parts(P)
 local _,r=parts(p)
 if not root or not r or (root.Position-r.Position).Magnitude>8 then return false end
 for _,other in ipairs(Players:GetPlayers()) do
  if other~=P and other~=p then
   local _,near=parts(other)
   if near and (root.Position-near.Position).Magnitude<12 then return false end
  end
 end
 return true
end
local function criminal(p)
 local _,r,h=parts(p)
 return p~=P and p.Parent==Players and team(p,'criminal') and r and h
  and h.Health>0
end
local function outdoor(p)
 if not criminal(p) then return false end
 local _,r=parts(p);local _,m=vehicle(p)
 local filter=params(m)
 local list=filter.FilterDescendantsInstances
 local vehicles=workspace:FindFirstChild('Vehicles')
 if vehicles then list[#list+1]=vehicles end
 filter.FilterDescendantsInstances=list
 return not workspace:Raycast(r.Position+V(0,3,0),V(0,1200,0),filter)
end
local selectionSummary='Scanning targets'
local function selectTarget(maxRange)
 local _,root=parts(P);local best,d=nil,math.huge
 local counts={criminal=0,done=0,covered=0,cooldown=0}
 for _,p in ipairs(Players:GetPlayers()) do
  if criminal(p) then
   counts.criminal=counts.criminal+1
   if completed[p.UserId]==p.Character then counts.done=counts.done+1
   elseif (blocked[p.UserId] or 0)>=os.clock() then counts.cooldown=counts.cooldown+1
   elseif not outdoor(p) then counts.covered=counts.covered+1 end
  end
  if completed[p.UserId]~=p.Character and (blocked[p.UserId] or 0)<os.clock() and outdoor(p) then
   local _,r=parts(p);local distance=(r.Position-root.Position).Magnitude
   if distance<d and (not maxRange or distance<=maxRange) then best,d=p,distance end
  end
 end
 selectionSummary=string.format('Criminals %d | Completed %d | Covered %d | Retry %d',counts.criminal,counts.done,counts.covered,counts.cooldown)
 return best
end
local function groundCar(p)
 local a,m=vehicle(p)
 if not m then return false end
 local wheels=0
 for _,o in ipairs(m:GetDescendants()) do
  local n=o.Name:lower()
  if n:find('rotor',1,true) or n:find('propeller',1,true) then return false end
  if o:IsA('BasePart') and (n:find('wheel',1,true) or n:find('tire',1,true)) then
   wheels=wheels+1
  end
 end
 if wheels<4 then return false end
 local hit=workspace:Raycast(a.Position,V(0,-9,0),params(m))
 return hit~=nil and hit.Normal.Y>.6
end
local function holdVehicle()
 clearHover()
 local a=Instance.new('Attachment',car);hover={a}
 local v=Instance.new('LinearVelocity',car);hover[#hover+1]=v
 v.Attachment0=a;v.RelativeTo=Enum.ActuatorRelativeTo.World
 v.ForceLimitsEnabled=false;v.VectorVelocity=Vector3.zero
 local o=Instance.new('AlignOrientation',car);hover[#hover+1]=o
 o.Attachment0=a;o.Mode=Enum.OrientationAlignmentMode.OneAttachment
 o.RigidityEnabled=true;o.CFrame=car.CFrame.Rotation
 return v,o
end
local function rayClear(from,to,extra)
 return not workspace:Raycast(from,to-from,params(extra))
end
local function corridorClear(a,b,extra,radius)
 local offsets={V(0,0,0),V(radius,0,0),V(-radius,0,0),V(0,0,radius),V(0,0,-radius),V(0,2,0)}
 for _,offset in ipairs(offsets) do
  if not rayClear(a+offset,b+offset,extra) then return false end
 end
 return true
end
local function planOver(a,b,extra,radius)
 if corridorClear(a,b,extra,radius) then return {b} end
 local exits={V(0,0,0),V(7,0,0),V(-7,0,0),V(0,0,7),V(0,0,-7)}
 for _,lift in ipairs({8,16,28,45,70,110,170,240}) do
  local height=math.max(a.Y,b.Y)+lift
  for _,offset in ipairs(exits) do
   local side=a+offset
   local up=V(side.X,height,side.Z)
   local across=V(b.X,height,b.Z)
   if (offset.Magnitude<.1 or corridorClear(a,side,extra,radius))
    and corridorClear(side,up,extra,radius)
    and corridorClear(up,across,extra,radius)
    and corridorClear(across,b,extra,radius) then
    local route={}
    if offset.Magnitude>.1 then route[#route+1]=side end
    route[#route+1]=up;route[#route+1]=across;route[#route+1]=b
    return route
   end
  end
 end
 return nil
end
local function navigationPoint(a,b,extra,state,radius)
 if state.goal and (state.goal-b).Magnitude>12 then state.path=nil end
 if not state.path then
  state.path=planOver(a,b,extra,radius)
  state.goal=b;state.index=1
  assert(state.path,'No clear overhead route; retrying')
  if #state.path>1 then log('OVERHEAD BYPASS: '..#state.path..' legs') end
 end
 local path=state.path
 path[#path]=b
 while state.index<#path and (a-path[state.index]).Magnitude<1.5 do
  state.index=state.index+1
 end
 local nextPoint=path[state.index]
 if not corridorClear(a,nextPoint,extra,radius) then
  state.path=nil
  error('Route changed; replanning',0)
 end
 if state.index==#path and (a-b).Magnitude<=1 then state.path=nil end
 return nextPoint
end
local function intercept(p)
 assert(driver(),'Driver position required')
 local v,o=holdVehicle()
 local _,r=parts(p)
 local height=math.max(car.Position.Y,r.Position.Y)+140
 local phase=1
 local deadline=os.clock()+35
 local lastLog=''
 local contacts=0
 local rearPlaced=false
 local navigation={}
 while true do
  check();assert(driver(),'Detached from car')
  assert(outdoor(p),'Target unavailable or indoors')
  local _,r=parts(p);local enemy,enemyModel=vehicle(p)
  if enemyModel then lastEnemyVehicle=enemyModel end
  local position=r.Position
  local velocity=enemy and enemy.AssemblyLinearVelocity or r.AssemblyLinearVelocity
  local flat=V(position.X-car.Position.X,0,position.Z-car.Position.Z)
  local pit=groundCar(p)
  local goal
  if phase==1 then
   goal=V(car.Position.X,height,car.Position.Z)
   if math.abs(car.Position.Y-height)<5 then phase=2 end
  elseif phase==2 then
   local lead=V(velocity.X,0,velocity.Z)*math.min(flat.Magnitude/360,.5)
   if lead.Magnitude>60 then lead=lead.Unit*60 end
   goal=V(position.X+lead.X,math.max(height,position.Y+25),position.Z+lead.Z)
   if flat.Magnitude<22 then phase=3 end
  else
   if flat.Magnitude>90 then phase=2 end
   if pit and enemy then
    local direction=V(velocity.X,0,velocity.Z)
    if direction.Magnitude<1 then direction=enemy.CFrame.LookVector end
    goal=enemy.Position-direction.Unit*3+velocity*.08
   else
    goal=position+V(0,10,0)+velocity*.08
   end
  end
  local label=phase==1 and 'Climbing' or phase==2 and 'Intercepting' or pit and 'PIT contact attempt' or 'Close approach'
  if label~=lastLog then log(label..': '..p.Name);lastLog=label end
  if phase==3 and pit and enemy and not rearPlaced
   and (car.Position-enemy.Position).Magnitude<=24 then
   local forward=enemy.CFrame.LookVector
   forward=V(forward.X,0,forward.Z)
   if forward.Magnitude>.1 then
    local rear=enemy.Position-forward.Unit*12+V(0,.5,0)
    assert(rayClear(car.Position,rear,enemyModel),'Obstacle blocks rear positioning')
    car.CFrame=CFrame.lookAt(rear,rear+forward.Unit)
    car.AssemblyLinearVelocity=velocity
    o.CFrame=car.CFrame.Rotation
    rearPlaced=true
    log('Rear contact position applied; PIT not yet verified')
   end
  end
  local navGoal=navigationPoint(car.Position,goal,enemyModel,navigation,3)
  local delta=navGoal-car.Position
  local distance=delta.Magnitude
  if phase==3 and (car.Position-position).Magnitude<(pit and 10 or 15) then
   if pit then
    log('Contact attempt; tire damage not verified')
    v.VectorVelocity=delta.Magnitude>.1 and delta.Unit*65+velocity or velocity
    waitFor(.035)
   end
   v.VectorVelocity=Vector3.zero;car.AssemblyLinearVelocity=Vector3.zero
   if pit then log('Contact made; tire state UNKNOWN; trying eject without speed gate') end
   return
  else
  assert(os.clock()<deadline,'Intercept timeout')
  local speed=phase==2 and 360 or 170
  if distance>.1 then
   local forward=V(delta.X,0,delta.Z)
   if forward.Magnitude>1 then o.CFrame=CFrame.lookAt(Vector3.zero,forward.Unit) end
   v.VectorVelocity=delta.Unit*math.min(speed,distance*12)
  else v.VectorVelocity=Vector3.zero end
  end
  RS.Heartbeat:Wait()
 end
end
local function exitFast()
 if hover and hover[2] then hover[2].VectorVelocity=Vector3.zero end
 car.AssemblyLinearVelocity=Vector3.zero
 local beganExit=os.clock()
 log('SPACE: immediate exit request')
 held[Enum.KeyCode.Space]=true
 VIM:SendKeyEvent(true,Enum.KeyCode.Space,false,game)
 local ok,why=pcall(function()
  RS.Heartbeat:Wait();check()
  VIM:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
  held[Enum.KeyCode.Space]=nil
  while vehicle(P)==car do
   check()
   assert(os.clock()-beganExit<1.2,'Exit not confirmed; retrying')
   RS.Heartbeat:Wait()
  end
 end)
 VIM:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
 held[Enum.KeyCode.Space]=nil
 if not ok then error(why,0) end
 log(string.format('EXIT CONFIRMED: %.2fs; equipping cuffs now',os.clock()-beganExit))
end
local function aim(p)
 local camera=workspace.CurrentCamera
 local _,root=parts(P);local _,r=parts(p)
 if not cameraSave then cameraSave={camera=camera,kind=camera.CameraType,subject=camera.CameraSubject,cf=camera.CFrame} end
 local delta=r.Position-root.Position
 local back=delta.Magnitude>.1 and -delta.Unit*4 or V(0,0,4)
 camera.CameraType=Enum.CameraType.Scriptable
 camera.CFrame=CFrame.lookAt(root.Position+V(0,2,0)+back,r.Position+V(0,1,0))
end
local function beginFoot()
 if foot then return end
 local _,root,hum=parts(P)
 assert(not vehicle(P),'Still attached to vehicle')
 local f={root=root,hum=hum,objects={},platform=hum.PlatformStand,
  rotate=hum.AutoRotate,seated=hum:GetStateEnabled(Enum.HumanoidStateType.Seated)}
 foot=f
 local function make(class)
  local o=Instance.new(class);f.objects[#f.objects+1]=o;o.Parent=root;return o
 end
 local a=make('Attachment')
 local v=make('LinearVelocity')
 v.Attachment0=a;v.RelativeTo=Enum.ActuatorRelativeTo.World
 v.ForceLimitsEnabled=false;v.VectorVelocity=Vector3.zero;f.velocity=v
 local o=make('AlignOrientation')
 o.Attachment0=a;o.Mode=Enum.OrientationAlignmentMode.OneAttachment
 o.RigidityEnabled=true;o.CFrame=root.CFrame.Rotation;f.orientation=o
 hum.PlatformStand=true;hum.AutoRotate=false
 hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
end
local function footGoal(p)
 assert(outdoor(p),'Target unavailable or indoors')
 local _,root=parts(P);local _,r=parts(p)
 local enemy,m=vehicle(p)
 local offset
 if enemy then
  local side=enemy.CFrame:PointToObjectSpace(r.Position).X<0 and -1 or 1
  offset=enemy.CFrame.RightVector*(side*5)
 else
  local look=r.CFrame.LookVector
  local flat=V(look.X,0,look.Z)
  local forward=flat.Magnitude>.1 and flat.Unit or V(0,0,-1)
  local relative=root.Position-r.Position
  local right=V(-forward.Z,0,forward.X)
  if relative:Dot(forward)>-.5 and relative.Magnitude<12 then
   local side=relative:Dot(right)<0 and -1 or 1
   offset=-forward*2+right*(side*5)
  else
   offset=-forward*3.5
  end
  local velocity=r.AssemblyLinearVelocity
  offset=offset+V(velocity.X,0,velocity.Z)*.06
 end
 return r.Position+offset+V(0,.5,0),m
end
local function chaseSpeed(targetDistance,goalDistance,direct,pursuing)
 if pursuing and direct and targetDistance<=30 and goalDistance<=30 then return 200 end
 return 100
end
local function steerFoot(goal,extra,dt)
 local f=foot
 f.route=f.route or {}
 local nextPoint=navigationPoint(f.root.Position,goal,extra,f.route,1.1)
 local delta=nextPoint-f.root.Position
 local distance=delta.Magnitude
 if (goal-f.root.Position).Magnitude<=1 then
  f.velocity.VectorVelocity=Vector3.zero;f.route={};return true
 end
 if distance<.05 then f.velocity.VectorVelocity=Vector3.zero;return false end
 local flat=V(delta.X,0,delta.Z)
 if flat.Magnitude>.1 then f.orientation.CFrame=CFrame.lookAt(Vector3.zero,flat.Unit) end
 local targetDistance=math.huge
 if pursuitTarget then
  local _,targetRoot=parts(pursuitTarget)
  if targetRoot then targetDistance=(targetRoot.Position-f.root.Position).Magnitude end
 end
 local speed=chaseSpeed(targetDistance,(goal-f.root.Position).Magnitude,
  f.route.path~=nil and #f.route.path==1,cuffsMode=='pursuit')
 if f.lastSpeed~=speed then f.lastSpeed=speed;log('FOOT SPEED: '..speed) end
 f.velocity.VectorVelocity=delta.Unit*math.min(speed,distance/math.max(dt,1/240))
 return false
end
local function checkEjectDeadline(p,deadline)
 if deadline and vehicle(p) and os.clock()>=deadline then
  error('EJECT TIMEOUT: 3 seconds; returning to Camaro',0)
 end
end
local function faceTarget(p)
 if not foot then return end
 local _,r=parts(p)
 if not r then return end
 local delta=r.Position-foot.root.Position
 local flat=V(delta.X,0,delta.Z)
 if flat.Magnitude>.1 then
  foot.orientation.CFrame=CFrame.lookAt(Vector3.zero,flat.Unit)
 end
end
local function approachFoot(p,deadline)
 beginFoot()
 log('Foot flight: '..p.Name..' | 200 within 30 studs; otherwise 100')
 local progress=os.clock();local best=math.huge
 while true do
  local dt=RS.Heartbeat:Wait();check()
  if paidTarget==p or completed[p.UserId]==p.Character or not criminal(p) then return end
  checkEjectDeadline(p,deadline)
  local goal,m=footGoal(p)
  local distance=(goal-foot.root.Position).Magnitude
  if distance<best-.5 or foot.route and foot.route.path and #foot.route.path>1 then best=distance;progress=os.clock() end
  assert(os.clock()-progress<8,'Foot flight blocked; retry same target')
  local reached=steerFoot(goal,m,dt)
  faceTarget(p)
  if reached then return end
 end
end
local function cuffsButton()
 local pg=P:FindFirstChild('PlayerGui')
 local hotbar=pg and pg:FindFirstChild('HotbarGui')
 local container=hotbar and hotbar:FindFirstChild('Container')
 if not container then return end
 for _,item in ipairs(container:GetChildren()) do
  local button=item:FindFirstChild('Button')
  local icon=button and button:FindFirstChild('Icon')
  if icon and (icon:IsA('ImageLabel') or icon:IsA('ImageButton'))
   and icon.Image:match('%d+$')=='700374045' then
   local index=button:FindFirstChild('Index')
   local n=index and tonumber(index.Text)
   return button,n
  end
 end
end
local function cuffsState()
 local button,n=cuffsButton()
 assert(button and n and n>=1 and n<=9,'Handcuffs icon or slot missing')
 local alpha=button.BackgroundTransparency
 if math.abs(alpha-.6)<.035 then return true,n end
 if math.abs(alpha-.4)<.035 then return false,n end
 return nil,n
end
local function applyCuffs(wanted)
 local names={'One','Two','Three','Four','Five','Six','Seven','Eight','Nine'}
 for attempt=1,3 do
  local state,n=cuffsState()
  slot.Text=tostring(n)
  if state==wanted then
   cuffSelected=wanted
   log(wanted and 'Handcuffs EQUIPPED: UI verified' or 'Handcuffs EMPTY: UI verified')
   return
  end
  if state~=nil and os.clock()>=nextCuffsInput then
   key(Enum.KeyCode[names[n]],.018)
   nextCuffsInput=os.clock()+.25
  end
  local untilTime=os.clock()+.65
  local stable=nil
  repeat
   waitFor(.02)
   local actual=cuffsState()
   if actual==wanted then
    stable=stable or os.clock()
    if os.clock()-stable>=.015 then
     cuffSelected=wanted
     log(wanted and 'Handcuffs EQUIPPED: UI verified' or 'Handcuffs EMPTY: UI verified')
     return
    end
   else stable=nil end
  until os.clock()>untilTime
 end
 error(wanted and 'Handcuffs equip not confirmed' or 'Handcuffs removal not confirmed',0)
end
local function ensureCuffs(wanted)
 cuffsBusy=true
 releaseCuffsPulse()
 local ok,why=pcall(applyCuffs,wanted)
 cuffsBusy=false
 if not ok then error(why,0) end
end
local function maintainCuffs()
 local now=os.clock()
 if cuffsPulse and now>=cuffsPulse.releaseAt then releaseCuffsPulse() end
 if not running or cancel or dead or cuffsBusy then return end
 if cuffsMode~='pursuit' or not pursuitTarget or vehicle(P) then return end
 if now<nextCuffsCheck then return end
 nextCuffsCheck=now+.08
 local ok,state,n=pcall(cuffsState)
 if not ok or state==nil then return end
 if state==true then return end
 if held[Enum.KeyCode.E] then
  VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
  held[Enum.KeyCode.E]=nil
 end
 if now<nextCuffsInput or cuffsPulse then return end
 local names={'One','Two','Three','Four','Five','Six','Seven','Eight','Nine'}
 local k=Enum.KeyCode[names[n]]
 held[k]=true
 VIM:SendKeyEvent(true,k,false,game)
 cuffsPulse={key=k,releaseAt=now+.02}
 nextCuffsInput=now+.4
 log('CUFFS WATCH: restoring handcuffs')
end
local function equip() ensureCuffs(true) end
local function unequip() ensureCuffs(false) end
local function readCash()
 local o=P:FindFirstChild('PlayerGui')
 for _,name in ipairs({'AppUI','Buttons','Cash','Content','AmountWrap','Label'}) do
  o=o and o:FindFirstChild(name)
 end
 assert(o and (o:IsA('TextLabel') or o:IsA('TextButton')),'Cash counter missing')
 local clean=o.Text:gsub('[%s,$]','')
 local value=tonumber(clean)
 assert(value,'Unsupported cash format: '..o.Text)
 return value
end
local function checkReward()
 if not attempt or paidTarget==attempt.player then return end
 local value=readCash()
 if value-attempt.balance>=400 then
  paidTarget=attempt.player
  completed[attempt.player.UserId]=attempt.character
  if held[Enum.KeyCode.E] then
   VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
   held[Enum.KeyCode.E]=nil
  end
  if foot then foot.velocity.VectorVelocity=Vector3.zero end
  log('REWARD +'..(value-attempt.balance)..': target completed; E released')
 end
end
local function holdInteraction(p,eject,deadline)
 ensureCuffs(true)
 checkEjectDeadline(p,deadline)
 if searchForTarget(p) then
  completed[p.UserId]=p.Character
  log('SKIP: search prompt; no E sent')
  return 'search prompt: target already cuffed'
 end
 local reason=''
 local notedMoney=false
 held[Enum.KeyCode.E]=true
 VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)
 local ok,err=pcall(function()
  while true do
   check()
   checkReward()
   if paidTarget==p then reason='reward received';return end
   if not held[Enum.KeyCode.E] then reason='restoring cuffs; retry interaction';return end
   if searchForTarget(p) then
    completed[p.UserId]=p.Character
    reason='search prompt: target already cuffed';return
   end
   if team(p,'prisoner') then reason='target became Prisoner';return end
   if not criminal(p) then reason='target unavailable';return end
   if eject and not vehicle(p) then reason='eject confirmed';return end
   checkEjectDeadline(p,deadline)
   local _,root=parts(P);local _,targetRoot=parts(p)
   if (root.Position-targetRoot.Position).Magnitude>10 then
    reason='out of reach; reposition same target';return
   end
   aim(p)
   local dt=RS.Heartbeat:Wait()
   check()
   if paidTarget~=p and criminal(p) and foot then
    local goal,extra=footGoal(p)
    steerFoot(goal,extra,dt)
    faceTarget(p)
   end
  end
 end)
 VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
 held[Enum.KeyCode.E]=nil
 if not ok then error(err,0) end
 log('E released: '..reason)
 return reason
end
local function arrest(p)
 if not attempt or attempt.player~=p or attempt.character~=p.Character then
  attempt={player=p,character=p.Character,balance=readCash()}
 end
 setCuffsMode('idle',nil)
 if vehicle(P)==car then exitFast() end
 local deadline=vehicle(p) and (os.clock()+3) or nil
 beginFoot()
 equip()
 setCuffsMode('pursuit',p)
 checkEjectDeadline(p,deadline)
 while criminal(p) and paidTarget~=p and completed[p.UserId]~=p.Character do
  check()
  approachFoot(p,deadline)
  if paidTarget==p or not criminal(p) or completed[p.UserId]==p.Character then break end
  if searchForTarget(p) then
   completed[p.UserId]=p.Character
   log('SKIP: search prompt; target already cuffed')
   break
  end
  if not vehicle(p) then deadline=nil end
  aim(p)
  local eject=vehicle(p)~=nil
  log((eject and 'HOLD E: eject ' or 'HOLD E: arrest ')..p.Name)
  local reason=holdInteraction(p,eject,deadline)
  if reason=='eject confirmed' then
   deadline=nil
   log('EJECTED: staying on foot; arrest next')
  end
  if paidTarget==p or team(p,'prisoner') then break end
  if reason=='target unavailable' then break end
  waitFor(.035)
 end
 restoreCamera()
 if foot then foot.velocity.VectorVelocity=Vector3.zero end
 if completed[p.UserId]==p.Character and paidTarget~=p then
  log('ALREADY CUFFED: selecting another target')
 elseif paidTarget==p then log('CASH RECEIVED: finishing target')
 elseif team(p,'prisoner') then log('Target is now Prisoner')
 else log('Target no longer available; arrest unverified') end
end
local function carAvailable()
 return car and model and car:IsDescendantOf(workspace) and model:IsDescendantOf(workspace)
end
local function returnDriver()
 setCuffsMode('boarding',nil)
 restoreCamera()
 if driver() then stopFoot();return end
 assert(carAvailable(),'Tracked Camaro disappeared')
 local tries=0
 while true do
  check()
  if driver() then stopFoot();log('Driver confirmed');return end
  assert(carAvailable(),'Tracked Camaro disappeared')
  tries=tries+1
  local ok,why=pcall(function()
   if vehicle(P) then
    stopFoot();key(Enum.KeyCode.Space,.035);waitFor(.15)
    assert(not vehicle(P),'Leaving passenger or other vehicle')
   end
   beginFoot()
   foot.velocity.VectorVelocity=Vector3.zero;foot.route={}
   unequip()
   local seat=model:FindFirstChild('Seat')
   assert(seat and seat:IsA('BasePart'),'Driver seat missing')
   local side=car.CFrame:PointToObjectSpace(seat.Position).X<0 and -1 or 1
   local variants={{3,0},{3,2},{3,-2},{2,0},{4,0}}
   local offset=variants[(tries-1)%#variants+1]
   local untilTime=os.clock()+20
   log('AUTO BOARD: attempt '..tries)
   while true do
    check();assert(carAvailable(),'Tracked Camaro disappeared')
    local goal=seat.Position+car.CFrame.RightVector*(side*offset[1])
     +car.CFrame.LookVector*offset[2]+V(0,2,0)
    local dt=RS.Heartbeat:Wait();check()
    assert(os.clock()<untilTime,'Board approach retry')
    if steerFoot(goal,nil,dt) then break end
   end
   local camera=workspace.CurrentCamera
   cameraSave={camera=camera,kind=camera.CameraType,subject=camera.CameraSubject,cf=camera.CFrame}
   local _,root=parts(P)
   camera.CameraType=Enum.CameraType.Scriptable
   camera.CFrame=CFrame.lookAt(root.Position+V(0,2,0),seat.Position)
   stopFoot()
   key(Enum.KeyCode.E,.12)
   local deadline=os.clock()+1.2
   repeat
    check()
    if driver() then return end
    if vehicle(P) then break end
    RS.Heartbeat:Wait()
   until os.clock()>=deadline
   assert(driver(),'Seat not confirmed; repositioning automatically')
  end)
  restoreCamera()
  if ok and driver() then log('Driver confirmed');return end
  check()
  log('AUTO BOARD RETRY: '..tostring(why))
  if foot then foot.velocity.VectorVelocity=Vector3.zero;foot.route={} end
  waitFor(.25)
 end
end
local function waitCar()
 setCuffsMode('boarding',nil)
 clearHover()
 local last=''
 while true do
  check()
  local a,m=vehicle(P)
  if a and m.Name:lower()=='camaro' then
   car,model=a,m
   if driver() then stopFoot();log('Camaro confirmed');return end
  end
  if carAvailable() then
   returnDriver()
   return
  end
  if last~='missing' then
   log('No tracked Camaro: start seated in your Camaro; spawn not implemented')
   last='missing'
  end
  waitFor(.5)
 end
end
local function run()
 character=P.Character
 waitFor(.2);waitCar()
 local target=nil
 while true do
  check()
  if not target or not criminal(target) then
   target=selectTarget();attempt=nil
  end
  if not target then setCuffsMode('idle',nil);status.Text=selectionSummary;waitFor(.7)
  elseif not outdoor(target) then
   log('SKIP INDOORS: '..target.Name)
   blocked[target.UserId]=os.clock()+15
   target=nil;attempt=nil
   if foot then foot.velocity.VectorVelocity=Vector3.zero end
   restoreCamera()
   if not driver() then
    local returned,why=pcall(returnDriver)
    if not returned then check();log(tostring(why));waitCar() end
   end
   clearHover()
   waitFor(.1)
  else
   log('Selected target: '..target.Name)
   local ok,err=pcall(function()
    if driver() then intercept(target) end
    arrest(target)
   end)
   restoreCamera()
   if not ok then
    check();log('RETRY SAME TARGET: '..tostring(err))
    if foot then foot.velocity.VectorVelocity=Vector3.zero;foot.route={} end
   end
   if hover and hover[2] and hover[2].Parent then hover[2].VectorVelocity=Vector3.zero end
   if not criminal(target) or paidTarget==target or completed[target.UserId]==target.Character then
    completed[target.UserId]=target.Character
    setCuffsMode('idle',nil)
    paidTarget=nil;attempt=nil
    local nearby=selectTarget(45)
    if nearby and not vehicle(P) then
     log('NEARBY TARGET: '..nearby.Name..'; staying on foot')
     target=nearby
    else
     local returned,why=pcall(returnDriver)
     if not returned then check();log(tostring(why));waitCar() end
     clearHover();target=nil
    end
   elseif not outdoor(target) then
    log('SKIP INDOORS: '..target.Name)
    blocked[target.UserId]=os.clock()+15
    target=nil;attempt=nil
    if foot then foot.velocity.VectorVelocity=Vector3.zero end
    local returned,why=pcall(returnDriver)
    if not returned then check();log(tostring(why));waitCar() end
    clearHover()
   elseif not vehicle(target) and not vehicle(P) then
    log('CONTINUE ON FOOT: '..target.Name..'; following behind')
    if foot then foot.velocity.VectorVelocity=Vector3.zero end
    waitFor(.15)
   else
    local returned,why=pcall(returnDriver)
    if not returned then check();log(tostring(why));waitCar() end
    clearHover();waitFor(.3)
   end
  end
 end
end
local cuffsWatcher=RS.Heartbeat:Connect(function()
 local ok,why=pcall(maintainCuffs)
 if not ok and running and not cancel then
  cancel=true;cleanup();log('Cuffs monitor failed: '..tostring(why))
 end
end)
local rewardWatcher=RS.Heartbeat:Connect(function()
 if not running or cancel or dead or not attempt then return end
 local ok,err=pcall(checkReward)
 if not ok then
  cancel=true;cleanup();log('Cash monitor failed: '..tostring(err))
 end
end)
local focus=UIS.WindowFocusReleased:Connect(function() if running then cancel=true;cleanup() end end)
stop.Activated:Connect(function() cancel=true;cleanup() end)
copy.Activated:Connect(function() if setclipboard then setclipboard(table.concat(history,'\n')) end end)
hubCapture(function()
 if running or dead then return end
 running,cancel=true,false;cuffSelected=false;paidTarget=nil;attempt=nil;history={};began=os.clock();nextCuffsInput=0;nextCuffsCheck=0
 task.spawn(function()
  local ok,err=pcall(run);cleanup()
  if not ok and not dead then log('STOP: '..tostring(err)) end
  running=false
 end)
end)
_G.AutoArrestCleanup=function() dead,cancel=true,true;cleanup();cuffsWatcher:Disconnect();rewardWatcher:Disconnect();focus:Disconnect();gui:Destroy() end

gui.Enabled=false
return {Start=hubStart, Stop=function() cancel=true;cleanup() end, Busy=function() return running end, Destroy=function() if _G.AutoArrestCleanup then _G.AutoArrestCleanup() end end, Log=function() return table.concat(history,'\n') end, Status=function() return status.Text end}
]====]
HUB_SOURCES['Donut'] = [====[
local hubStart
local function hubCapture(fn) hubStart=fn end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
 
for _, name in ipairs({
    "BenzinAutoRoute", "GasAutoRoute", "DonutAutoRoute"
}) do
    local old = pg:FindFirstChild(name)
    if old then old:Destroy() end
end
local PARK = Vector3.new(102.68,18.63,-1491.86)
local INBOUND = {
    Vector3.new(95.6,19.86,-1526.37),
    Vector3.new(111.85,20.27,-1577.55),
    Vector3.new(79.86,20.27,-1588.84),
}
local OUTBOUND = {
    Vector3.new(111.99,20.27,-1575.39),
    Vector3.new(98.31,20.27,-1535.8),
    Vector3.new(102.61,19.72,-1511.15),
    Vector3.new(102.86,18.81,-1489.98),
}
local CAR_SPEED = 280
local CAR_HEIGHT = 300
local PERSON_SPEED = 100
local HOLD_SECONDS = 12
local running, cancelled, destroyed, armed = false, false, false, false
local reason = "Stopped."
local character, humanoid, root, input
local motion, savedHumanoid
local receiptConnections = {}
local gui = Instance.new("ScreenGui")
gui.Name = "BenzinAutoRoute"
gui.ResetOnSpawn = false
gui.Parent = pg
local panel = Instance.new("Frame")
panel.Position = UDim2.fromOffset(20, 100)
panel.Size = UDim2.fromOffset(330, 215)
panel.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local function label(text, y, height)
    local item = Instance.new("TextLabel")
    item.Position = UDim2.fromOffset(10, y)
    item.Size = UDim2.new(1, -20, 0, height)
    item.BackgroundTransparency = 1
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.Gotham
    item.TextSize = 14
    item.TextWrapped = true
    item.Text = text
    item.Parent = panel
    return item
end
local function button(text, x)
    local item = Instance.new("TextButton")
    item.Position = UDim2.fromOffset(x, 48)
    item.Size = UDim2.fromOffset(150, 34)
    item.BackgroundColor3 = Color3.fromRGB(48, 61, 85)
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.Gotham
    item.TextSize = 15
    item.Text = text
    item.Parent = panel
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
    return item
end
label("BENZIN — AUTO ROUTE", 8, 30)
local startButton = button("Start", 10)
local stopButton = button("Stop", 170)
local status = label("Sit in your car. One Start runs the whole trip.", 94, 110)
local function message(text)
    if not destroyed then status.Text = text end
end
local function releaseE()
    if not input then return true end
    return pcall(function()
        input:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end
local function clearMotion()
    local previous = motion
    motion = nil
    if previous then
        for _, object in ipairs(previous.objects) do object:Destroy() end
        if previous.root:IsDescendantOf(workspace) then
            previous.root.AssemblyLinearVelocity = Vector3.zero
            previous.root.AssemblyAngularVelocity = Vector3.zero
        end
    end
    local saved = savedHumanoid
    savedHumanoid = nil
    if saved and saved.humanoid.Parent then
        saved.humanoid.PlatformStand = saved.platform
        saved.humanoid.AutoRotate = saved.rotate
        saved.humanoid:SetStateEnabled(
            Enum.HumanoidStateType.Seated, saved.seated
        )
    end
end
local function clearReceipts()
    for _, connection in ipairs(receiptConnections) do
        connection:Disconnect()
    end
    receiptConnections = {}
end
local function check()
    if cancelled or destroyed then error(reason, 0) end
    if player.Character ~= character or not root
        or not root:IsDescendantOf(workspace)
        or humanoid.Health <= 0 then
        error("Stopped: character unavailable.", 0)
    end
    if UIS:GetFocusedTextBox() then
        error("Stopped: close chat or text input.", 0)
    end
end
local function pause(seconds)
    local finish = os.clock() + seconds
    repeat
        check()
        task.wait(0.03)
    until os.clock() >= finish
end
local function inVehicles(object)
    while object do
        if object.Name == "Vehicles" then return true end
        object = object.Parent
    end
    return false
end
local function attachedTo(car)
    return car and car:IsDescendantOf(workspace)
        and root.AssemblyRootPart == car
end
local function tapE()
    check()
    input:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    pause(0.15)
    if not releaseE() then error("Could not release E.", 0) end
end
local function startMotion(part, person)
    clearMotion()
    motion = {
        root = part, person = person,
        objects = {}, command = Vector3.zero,
    }
    if person then
        savedHumanoid = {
            humanoid = humanoid,
            platform = humanoid.PlatformStand,
            rotate = humanoid.AutoRotate,
            seated = humanoid:GetStateEnabled(Enum.HumanoidStateType.Seated),
        }
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
    end
    local function make(className)
        local object = Instance.new(className)
        table.insert(motion.objects, object)
        return object
    end
    local attachment = make("Attachment")
    attachment.Parent = part
    local velocity = make("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    velocity.ForceLimitsEnabled = false
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = part
    local orientation = make("AlignOrientation")
    orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    orientation.Attachment0 = attachment
    orientation.RigidityEnabled = true
    orientation.CFrame = part.CFrame.Rotation
    orientation.Parent = part
    motion.velocity = velocity
end
local function checkMotion(current)
    check()
    local part = current.root
    if motion ~= current or not part:IsDescendantOf(workspace)
        or part.Anchored or current.velocity.Parent ~= part then
        error("Stopped: movement controller changed.", 0)
    end
    if current.person then
        local assembly = root.AssemblyRootPart
        if humanoid.Sit or not assembly
            or not assembly:IsDescendantOf(character) then
            error("Stopped: unexpected seat or object attachment.", 0)
        end
    elseif not humanoid.Sit or not attachedTo(part) then
        error("Stopped: vehicle connection changed.", 0)
    end
end
local function moveCar(target, maximumSpeed, title)
    local current = motion
    local part = current.root
    local best = (target - part.Position).Magnitude
    local lastProgress, started = os.clock(), os.clock()
    local settled = 0
    while true do
        local dt = RunService.PreSimulation:Wait()
        checkMotion(current)
        local offset = target - part.Position
        local distance = offset.Magnitude
        local actualSpeed = part.AssemblyLinearVelocity.Magnitude
        if distance < 2 and actualSpeed < 4 then
            settled = settled + math.min(dt, 0.1)
            if settled >= 0.15 then
                current.command = Vector3.zero
                current.velocity.VectorVelocity = Vector3.zero
                return
            end
        else
            settled = 0
        end
        if distance < best - 0.3 then
            best, lastProgress = distance, os.clock()
        elseif os.clock() - lastProgress > 7 then
            error("Stopped: blocked or corrected at " .. title, 0)
        end
        if os.clock() - started > 120 then
            error("Stopped: vehicle flight timeout.", 0)
        end
        local targetSpeed = math.min(
            maximumSpeed,
            math.sqrt(360 * math.max(distance - 0.4, 0)),
            distance * 2.5
        )
        local desired = distance > 0.2
            and offset.Unit * targetSpeed or Vector3.zero
        local delta = desired - current.command
        local rate = desired.Magnitude < current.command.Magnitude
            and 180 or 140
        local change = rate * math.min(dt, 0.1)
        if delta.Magnitude <= change then
            current.command = desired
        elseif delta.Magnitude > 0 then
            current.command = current.command + delta.Unit * change
        end
        current.velocity.VectorVelocity = current.command
        message(string.format(
            "%s\nSpeed: %.0f | Distance: %.0f",
            title, actualSpeed, distance
        ))
    end
end
local function flyPerson(points, title)
    startMotion(root, true)
    local current = motion
    local index = 1
    local best = math.huge
    local lastProgress, started = os.clock(), os.clock()
    while index <= #points do
        local dt = RunService.PreSimulation:Wait()
        checkMotion(current)
        local target = points[index]
        local final = index == #points
        local offset = target - root.Position
        local distance = offset.Magnitude
        if distance < (final and 0.8 or 1.3) then
            index = index + 1
            best, lastProgress = math.huge, os.clock()
            if index > #points then break end
            target = points[index]
            final = index == #points
            offset = target - root.Position
            distance = offset.Magnitude
        end
        if distance < best - 0.25 then
            best, lastProgress = distance, os.clock()
        elseif os.clock() - lastProgress > 5 then
            error("Stopped: blocked at " .. title .. " point " .. index, 0)
        end
        if os.clock() - started > 45 then
            error("Stopped: character flight timeout.", 0)
        end
        local speed = math.min(
            PERSON_SPEED, distance / math.max(dt, 0.001)
        )
        if final then speed = math.min(speed, distance * 10) end
        current.velocity.VectorVelocity = distance > 0.01
            and offset.Unit * speed or Vector3.zero
        message(string.format("%s: %d/%d", title, index, #points))
    end
    clearMotion()
end
local function watchReceipt()
    local result = {}
    local watched = {}
    local function inspect(object)
        if not object.Parent or object:IsDescendantOf(gui) then return end
        local text = object.Text:gsub("<.->", "")
        local lower = text:lower()
        local matches = lower:find("gas station", 1, true)
            or lower:find("gas store", 1, true)
            or lower:find("заправ", 1, true)
        if matches then
            local amount = text:match("%$%s*([%d,]+)")
            amount = amount and tonumber((amount:gsub(",", "")))
            if amount and amount > 0 then result.text = text end
        end
    end
    local function watch(object, added)
        if watched[object] or object:IsDescendantOf(gui) then return end
        if not object:IsA("TextLabel")
            and not object:IsA("TextButton") then return end
        watched[object] = true
        table.insert(receiptConnections,
            object:GetPropertyChangedSignal("Text"):Connect(function()
                inspect(object)
            end)
        )
        if added then inspect(object) end
    end
    table.insert(receiptConnections, pg.DescendantAdded:Connect(function(object)
        watch(object, true)
    end))
    for _, object in ipairs(pg:GetDescendants()) do watch(object, false) end
    return result
end
local function runCycle()
    character = player.Character
    humanoid = character and character:FindFirstChildOfClass("Humanoid")
    root = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then error("Character unavailable.", 0) end
    check()
    local team = player.Team and player.Team.Name:lower() or ""
    if not team:find("criminal", 1, true) then
        error("Join the Criminal team first.", 0)
    end
    local car = root.AssemblyRootPart
    if not humanoid.Sit or not car or car.Anchored or not inVehicles(car) then
        error("Sit in your car first.", 0)
    end
    if humanoid.PlatformStand then error("Disable other Fly scripts.", 0) end
    input = game:GetService("VirtualInputManager")
    if (car.Position - PARK).Magnitude > 4 then
        local origin = car.Position
        local altitude = math.max(origin.Y, PARK.Y) + CAR_HEIGHT
        startMotion(car, false)
        moveCar(Vector3.new(origin.X, altitude, origin.Z), 120, "Ascending")
        moveCar(Vector3.new(PARK.X, altitude, PARK.Z), CAR_SPEED, "Flying to Donut")
        moveCar(PARK, 90, "Descending")
        clearMotion()
    end
    pause(0.5)
    message("Exiting vehicle")
    tapE()
    local deadline = os.clock() + 5
    while humanoid.Sit or attachedTo(car) do
        if os.clock() > deadline then error("Stopped: vehicle exit failed.", 0) end
        pause(0.05)
    end
    pause(0.3)
    flyPerson(INBOUND, "To cashier")
    pause(0.2)
    local receipt = watchReceipt()
    message("Robbing: holding E")
    input:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    deadline = os.clock() + HOLD_SECONDS
    repeat
        pause(0.05)
    until receipt.text or os.clock() >= deadline
    if not releaseE() then error("Could not release E.", 0) end
    if not receipt.text then pause(0.5) end
    clearReceipts()
    local result = receipt.text
        and ("Receipt detected: " .. receipt.text)
        or "No new receipt detected. Robbery NOT confirmed."
    if not car:IsDescendantOf(workspace)
        or (car.Position - PARK).Magnitude > 12 then
        error("Vehicle missing or moved.\n" .. result, 0)
    end
    local back = {}
    for _, point in ipairs(OUTBOUND) do table.insert(back, point) end
    flyPerson(back, "Returning to car")
    pause(0.3)
    local model = car
    while model.Parent and model.Parent.Name ~= "Vehicles" do
        model = model.Parent
    end
    local driver = model:FindFirstChild("Seat", true)
    if not driver or not driver:IsA("BasePart") then
        error("Driver seat not found; boarding cancelled.", 0)
    end
    local function nearestDriver()
        local distance = (root.Position-driver.Position).Magnitude
        for _,part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") and part.Name:lower():find("passenger",1,true)
                and (root.Position-part.Position).Magnitude <= distance then
                return false
            end
        end
        return true
    end
    for attempt=1,3 do
        if attempt > 1 or not nearestDriver()
            or (root.Position-driver.Position).Magnitude > 6 then
            local seatLocal = car.CFrame:PointToObjectSpace(driver.Position)
            if math.abs(seatLocal.X) < 0.3 then
                error("Driver side could not be determined.",0)
            end
            local side = seatLocal.X < 0 and -1 or 1
            local entry = car.CFrame:PointToWorldSpace(
                seatLocal+Vector3.new(side*2.5,0,0)
            )+Vector3.new(0,2,0)
            flyPerson({entry}, "Driver-side approach")
            pause(0.2)
        end
        if not nearestDriver() then error("Driver-side approach not confirmed.",0) end
        message("Entering driver seat: "..attempt.." / 3")
        tapE()
        deadline = os.clock()+5
        while not (humanoid.Sit and attachedTo(car)) and os.clock()<deadline do
            pause(0.05)
        end
        if humanoid.Sit and attachedTo(car) then
            if nearestDriver() and (root.Position-driver.Position).Magnitude <= 2.75 then
                message("Trip finished. Driver position confirmed.\n"..result)
                return
            end
            tapE()
            deadline = os.clock()+5
            while humanoid.Sit or attachedTo(car) do
                if os.clock()>deadline then error("Could not leave passenger seat.",0) end
                pause(0.05)
            end
        end
    end
    error("Returned to car, but driver entry was not confirmed.\n"..result,0)
end
local focusConnection = UIS.WindowFocusReleased:Connect(function()
    if running and armed then
        cancelled = true
        reason = "Stopped: Roblox lost focus."
        releaseE()
    end
end)
stopButton.Activated:Connect(function()
    if running then
        cancelled = true
        reason = "Stopped by user."
        releaseE()
    end
end)
hubCapture(function()
    if running or destroyed then return end
    running, cancelled, armed = true, false, false
    reason = "Stopped."
    startButton.Text = "Running..."
    task.spawn(function()
        local ok, problem = pcall(function()
            for seconds = 3, 1, -1 do
                if cancelled or destroyed then error(reason, 0) end
                message("Return to Roblox: " .. seconds)
                task.wait(1)
            end
            armed = true
            runCycle()
        end)
        armed = false
        local released = releaseE()
        clearMotion()
        clearReceipts()
        if not ok then message(tostring(problem)) end
        if not released then
            message("Release failed. Press and release E manually.")
        end
        running = false
        if not destroyed then startButton.Text = "Start" end
    end)
end)
gui.Destroying:Connect(function()
    destroyed, cancelled = true, true
    reason = "Menu closed."
    releaseE()
    clearMotion()
    clearReceipts()
    focusConnection:Disconnect()
end)
gui.Enabled=false
return {Start=hubStart, Stop=function() cancelled=true;reason='Stopped from main menu';releaseE() end, Busy=function() return running end, Destroy=function() gui:Destroy() end, Log=function() return status.Text end, Status=function() return status.Text end}
]====]
HUB_SOURCES['Market'] = [====[
local hubStart
local function hubCapture(fn) hubStart=fn end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
 
for _, name in ipairs({
    "BenzinAutoRoute", "GasAutoRoute", "DonutAutoRoute"
}) do
    local old = pg:FindFirstChild(name)
    if old then old:Destroy() end
end
local PARK = Vector3.new(1765.97,22.54,-4161.62)
local INBOUND = {
    Vector3.new(1567.77,25.30,-4168.34),
    Vector3.new(1566.82,27.86,-4208.65),
    Vector3.new(1512.01,27.10,-4228.53),
    Vector3.new(1482.72,24.76,-4222.57),
}
local OUTBOUND = {
    Vector3.new(1458.38,24.69,-4227.55),
    Vector3.new(1458.46,86.36,-4227.69),
    Vector3.new(1762.75,28.42,-4158.65),
    Vector3.new(1762.75,26.98,-4158.65),
}
local CAR_SPEED = 280
local CAR_HEIGHT = 300
local PERSON_SPEED = 100
local HOLD_SECONDS = 12
local running, cancelled, destroyed, armed = false, false, false, false
local reason = "Stopped."
local character, humanoid, root, input
local motion, savedHumanoid
local receiptConnections = {}
local gui = Instance.new("ScreenGui")
gui.Name = "BenzinAutoRoute"
gui.ResetOnSpawn = false
gui.Parent = pg
local panel = Instance.new("Frame")
panel.Position = UDim2.fromOffset(20, 100)
panel.Size = UDim2.fromOffset(330, 215)
panel.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local function label(text, y, height)
    local item = Instance.new("TextLabel")
    item.Position = UDim2.fromOffset(10, y)
    item.Size = UDim2.new(1, -20, 0, height)
    item.BackgroundTransparency = 1
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.Gotham
    item.TextSize = 14
    item.TextWrapped = true
    item.Text = text
    item.Parent = panel
    return item
end
local function button(text, x)
    local item = Instance.new("TextButton")
    item.Position = UDim2.fromOffset(x, 48)
    item.Size = UDim2.fromOffset(150, 34)
    item.BackgroundColor3 = Color3.fromRGB(48, 61, 85)
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.Gotham
    item.TextSize = 15
    item.Text = text
    item.Parent = panel
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
    return item
end
label("BENZIN — AUTO ROUTE", 8, 30)
local startButton = button("Start", 10)
local stopButton = button("Stop", 170)
local status = label("Sit in your car. One Start runs the whole trip.", 94, 110)
local function message(text)
    if not destroyed then status.Text = text end
end
local function releaseE()
    if not input then return true end
    return pcall(function()
        input:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end
local function clearMotion()
    local previous = motion
    motion = nil
    if previous then
        for _, object in ipairs(previous.objects) do object:Destroy() end
        if previous.root:IsDescendantOf(workspace) then
            previous.root.AssemblyLinearVelocity = Vector3.zero
            previous.root.AssemblyAngularVelocity = Vector3.zero
        end
    end
    local saved = savedHumanoid
    savedHumanoid = nil
    if saved and saved.humanoid.Parent then
        saved.humanoid.PlatformStand = saved.platform
        saved.humanoid.AutoRotate = saved.rotate
        saved.humanoid:SetStateEnabled(
            Enum.HumanoidStateType.Seated, saved.seated
        )
    end
end
local function clearReceipts()
    for _, connection in ipairs(receiptConnections) do
        connection:Disconnect()
    end
    receiptConnections = {}
end
local function check()
    if cancelled or destroyed then error(reason, 0) end
    if player.Character ~= character or not root
        or not root:IsDescendantOf(workspace)
        or humanoid.Health <= 0 then
        error("Stopped: character unavailable.", 0)
    end
    if UIS:GetFocusedTextBox() then
        error("Stopped: close chat or text input.", 0)
    end
end
local function pause(seconds)
    local finish = os.clock() + seconds
    repeat
        check()
        task.wait(0.03)
    until os.clock() >= finish
end
local function inVehicles(object)
    while object do
        if object.Name == "Vehicles" then return true end
        object = object.Parent
    end
    return false
end
local function attachedTo(car)
    return car and car:IsDescendantOf(workspace)
        and root.AssemblyRootPart == car
end
local function tapE()
    check()
    input:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    pause(0.15)
    if not releaseE() then error("Could not release E.", 0) end
end
local function startMotion(part, person)
    clearMotion()
    motion = {
        root = part, person = person,
        objects = {}, command = Vector3.zero,
    }
    if person then
        savedHumanoid = {
            humanoid = humanoid,
            platform = humanoid.PlatformStand,
            rotate = humanoid.AutoRotate,
            seated = humanoid:GetStateEnabled(Enum.HumanoidStateType.Seated),
        }
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
    end
    local function make(className)
        local object = Instance.new(className)
        table.insert(motion.objects, object)
        return object
    end
    local attachment = make("Attachment")
    attachment.Parent = part
    local velocity = make("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    velocity.ForceLimitsEnabled = false
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = part
    local orientation = make("AlignOrientation")
    orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    orientation.Attachment0 = attachment
    orientation.RigidityEnabled = true
    orientation.CFrame = part.CFrame.Rotation
    orientation.Parent = part
    motion.velocity = velocity
end
local function checkMotion(current)
    check()
    local part = current.root
    if motion ~= current or not part:IsDescendantOf(workspace)
        or part.Anchored or current.velocity.Parent ~= part then
        error("Stopped: movement controller changed.", 0)
    end
    if current.person then
        local assembly = root.AssemblyRootPart
        if humanoid.Sit or not assembly
            or not assembly:IsDescendantOf(character) then
            error("Stopped: unexpected seat or object attachment.", 0)
        end
    elseif not humanoid.Sit or not attachedTo(part) then
        error("Stopped: vehicle connection changed.", 0)
    end
end
local function moveCar(target, maximumSpeed, title)
    local current = motion
    local part = current.root
    local best = (target - part.Position).Magnitude
    local lastProgress, started = os.clock(), os.clock()
    local settled = 0
    while true do
        local dt = RunService.PreSimulation:Wait()
        checkMotion(current)
        local offset = target - part.Position
        local distance = offset.Magnitude
        local actualSpeed = part.AssemblyLinearVelocity.Magnitude
        if distance < 2 and actualSpeed < 4 then
            settled = settled + math.min(dt, 0.1)
            if settled >= 0.15 then
                current.command = Vector3.zero
                current.velocity.VectorVelocity = Vector3.zero
                return
            end
        else
            settled = 0
        end
        if distance < best - 0.3 then
            best, lastProgress = distance, os.clock()
        elseif os.clock() - lastProgress > 7 then
            error("Stopped: blocked or corrected at " .. title, 0)
        end
        if os.clock() - started > 120 then
            error("Stopped: vehicle flight timeout.", 0)
        end
        local targetSpeed = math.min(
            maximumSpeed,
            math.sqrt(360 * math.max(distance - 0.4, 0)),
            distance * 2.5
        )
        local desired = distance > 0.2
            and offset.Unit * targetSpeed or Vector3.zero
        local delta = desired - current.command
        local rate = desired.Magnitude < current.command.Magnitude
            and 180 or 140
        local change = rate * math.min(dt, 0.1)
        if delta.Magnitude <= change then
            current.command = desired
        elseif delta.Magnitude > 0 then
            current.command = current.command + delta.Unit * change
        end
        current.velocity.VectorVelocity = current.command
        message(string.format(
            "%s\nSpeed: %.0f | Distance: %.0f",
            title, actualSpeed, distance
        ))
    end
end
local function flyPerson(points, title)
    startMotion(root, true)
    local current = motion
    local index = 1
    local best = math.huge
    local lastProgress, started = os.clock(), os.clock()
    while index <= #points do
        local dt = RunService.PreSimulation:Wait()
        checkMotion(current)
        local target = points[index]
        local final = index == #points
        local offset = target - root.Position
        local distance = offset.Magnitude
        if distance < (final and 0.8 or 1.3) then
            index = index + 1
            best, lastProgress = math.huge, os.clock()
            if index > #points then break end
            target = points[index]
            final = index == #points
            offset = target - root.Position
            distance = offset.Magnitude
        end
        if distance < best - 0.25 then
            best, lastProgress = distance, os.clock()
        elseif os.clock() - lastProgress > 5 then
            error("Stopped: blocked at " .. title .. " point " .. index, 0)
        end
        if os.clock() - started > 45 then
            error("Stopped: character flight timeout.", 0)
        end
        local speed = math.min(
            PERSON_SPEED, distance / math.max(dt, 0.001)
        )
        if final then speed = math.min(speed, distance * 10) end
        current.velocity.VectorVelocity = distance > 0.01
            and offset.Unit * speed or Vector3.zero
        message(string.format("%s: %d/%d", title, index, #points))
    end
    clearMotion()
end
local function watchReceipt()
    local result = {}
    local watched = {}
    local function inspect(object)
        if not object.Parent or object:IsDescendantOf(gui) then return end
        local text = object.Text:gsub("<.->", "")
        local lower = text:lower()
        local matches = lower:find("gas station", 1, true)
            or lower:find("gas store", 1, true)
            or lower:find("заправ", 1, true)
        if matches then
            local amount = text:match("%$%s*([%d,]+)")
            amount = amount and tonumber((amount:gsub(",", "")))
            if amount and amount > 0 then result.text = text end
        end
    end
    local function watch(object, added)
        if watched[object] or object:IsDescendantOf(gui) then return end
        if not object:IsA("TextLabel")
            and not object:IsA("TextButton") then return end
        watched[object] = true
        table.insert(receiptConnections,
            object:GetPropertyChangedSignal("Text"):Connect(function()
                inspect(object)
            end)
        )
        if added then inspect(object) end
    end
    table.insert(receiptConnections, pg.DescendantAdded:Connect(function(object)
        watch(object, true)
    end))
    for _, object in ipairs(pg:GetDescendants()) do watch(object, false) end
    return result
end
local function runCycle()
    character = player.Character
    humanoid = character and character:FindFirstChildOfClass("Humanoid")
    root = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then error("Character unavailable.", 0) end
    check()
    local team = player.Team and player.Team.Name:lower() or ""
    if not team:find("criminal", 1, true) then
        error("Join the Criminal team first.", 0)
    end
    local car = root.AssemblyRootPart
    if not humanoid.Sit or not car or car.Anchored or not inVehicles(car) then
        error("Sit in your car first.", 0)
    end
    if humanoid.PlatformStand then error("Disable other Fly scripts.", 0) end
    input = game:GetService("VirtualInputManager")
    if (car.Position - PARK).Magnitude > 4 then
        local origin = car.Position
        local altitude = math.max(origin.Y, PARK.Y) + CAR_HEIGHT
        startMotion(car, false)
        moveCar(Vector3.new(origin.X, altitude, origin.Z), 120, "Ascending")
        moveCar(Vector3.new(PARK.X, altitude, PARK.Z), CAR_SPEED, "Flying to Market")
        moveCar(PARK, 90, "Descending")
        clearMotion()
    end
    pause(0.5)
    message("Exiting vehicle")
    tapE()
    local deadline = os.clock() + 5
    while humanoid.Sit or attachedTo(car) do
        if os.clock() > deadline then error("Stopped: vehicle exit failed.", 0) end
        pause(0.05)
    end
    pause(0.3)
    flyPerson(INBOUND, "To cashier")
    pause(0.2)
    local receipt = watchReceipt()
    message("Robbing: holding E")
    input:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    deadline = os.clock() + HOLD_SECONDS
    repeat
        pause(0.05)
    until receipt.text or os.clock() >= deadline
    if not releaseE() then error("Could not release E.", 0) end
    if not receipt.text then pause(0.5) end
    clearReceipts()
    local result = receipt.text
        and ("Receipt detected: " .. receipt.text)
        or "No new receipt detected. Robbery NOT confirmed."
    if not car:IsDescendantOf(workspace)
        or (car.Position - PARK).Magnitude > 12 then
        error("Vehicle missing or moved.\n" .. result, 0)
    end
    local back = {}
    for _, point in ipairs(OUTBOUND) do table.insert(back, point) end
    flyPerson(back, "Returning to car")
    pause(0.3)
    local model = car
    while model.Parent and model.Parent.Name ~= "Vehicles" do
        model = model.Parent
    end
    local driver = model:FindFirstChild("Seat", true)
    if not driver or not driver:IsA("BasePart") then
        error("Driver seat not found; boarding cancelled.", 0)
    end
    local function nearestDriver()
        local distance = (root.Position-driver.Position).Magnitude
        for _,part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") and part.Name:lower():find("passenger",1,true)
                and (root.Position-part.Position).Magnitude <= distance then
                return false
            end
        end
        return true
    end
    for attempt=1,3 do
        if attempt > 1 or not nearestDriver()
            or (root.Position-driver.Position).Magnitude > 6 then
            local seatLocal = car.CFrame:PointToObjectSpace(driver.Position)
            if math.abs(seatLocal.X) < 0.3 then
                error("Driver side could not be determined.",0)
            end
            local side = seatLocal.X < 0 and -1 or 1
            local entry = car.CFrame:PointToWorldSpace(
                seatLocal+Vector3.new(side*2.5,0,0)
            )+Vector3.new(0,2,0)
            flyPerson({entry}, "Driver-side approach")
            pause(0.2)
        end
        if not nearestDriver() then error("Driver-side approach not confirmed.",0) end
        message("Entering driver seat: "..attempt.." / 3")
        tapE()
        deadline = os.clock()+5
        while not (humanoid.Sit and attachedTo(car)) and os.clock()<deadline do
            pause(0.05)
        end
        if humanoid.Sit and attachedTo(car) then
            if nearestDriver() and (root.Position-driver.Position).Magnitude <= 2.75 then
                message("Trip finished. Driver position confirmed.\n"..result)
                return
            end
            tapE()
            deadline = os.clock()+5
            while humanoid.Sit or attachedTo(car) do
                if os.clock()>deadline then error("Could not leave passenger seat.",0) end
                pause(0.05)
            end
        end
    end
    error("Returned to car, but driver entry was not confirmed.\n"..result,0)
end
local focusConnection = UIS.WindowFocusReleased:Connect(function()
    if running and armed then
        cancelled = true
        reason = "Stopped: Roblox lost focus."
        releaseE()
    end
end)
stopButton.Activated:Connect(function()
    if running then
        cancelled = true
        reason = "Stopped by user."
        releaseE()
    end
end)
hubCapture(function()
    if running or destroyed then return end
    running, cancelled, armed = true, false, false
    reason = "Stopped."
    startButton.Text = "Running..."
    task.spawn(function()
        local ok, problem = pcall(function()
            for seconds = 3, 1, -1 do
                if cancelled or destroyed then error(reason, 0) end
                message("Return to Roblox: " .. seconds)
                task.wait(1)
            end
            armed = true
            runCycle()
        end)
        armed = false
        local released = releaseE()
        clearMotion()
        clearReceipts()
        if not ok then message(tostring(problem)) end
        if not released then
            message("Release failed. Press and release E manually.")
        end
        running = false
        if not destroyed then startButton.Text = "Start" end
    end)
end)
gui.Destroying:Connect(function()
    destroyed, cancelled = true, true
    reason = "Menu closed."
    releaseE()
    clearMotion()
    clearReceipts()
    focusConnection:Disconnect()
end)
gui.Enabled=false
return {Start=hubStart, Stop=function() cancelled=true;reason='Stopped from main menu';releaseE() end, Busy=function() return running end, Destroy=function() gui:Destroy() end, Log=function() return status.Text end, Status=function() return status.Text end}
]====]
HUB_SOURCES['Gas Station'] = [====[
local hubStart
local function hubCapture(fn) hubStart=fn end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
 
for _, name in ipairs({
    "BenzinAutoRoute", "GasAutoRoute", "DonutAutoRoute"
}) do
    local old = pg:FindFirstChild(name)
    if old then old:Destroy() end
end
local PARK = Vector3.new(-1560.71, 17.86, 638.7)
local INBOUND = {
    Vector3.new(-1577.7, 19.25, 705.1),
    Vector3.new(-1584.16, 20.66, 706.95),
    Vector3.new(-1586.88, 23.45, 689.63),
    Vector3.new(-1600.27, 18.95, 684.9),
}
local OUTBOUND = {
    Vector3.new(-1588.49, 21.45, 694.92),  
    Vector3.new(-1585.35, 18.51, 708.32),  
    Vector3.new(-1569.09, 18.41, 708.37),
    Vector3.new(-1553.46, 18.41, 643.88),  
}
local CAR_SPEED = 280
local CAR_HEIGHT = 300
local PERSON_SPEED = 65
local HOLD_SECONDS = 12
local running, cancelled, destroyed, armed = false, false, false, false
local reason = "Stopped."
local character, humanoid, root, input
local motion, savedHumanoid
local receiptConnections = {}
local gui = Instance.new("ScreenGui")
gui.Name = "BenzinAutoRoute"
gui.ResetOnSpawn = false
gui.Parent = pg
local panel = Instance.new("Frame")
panel.Position = UDim2.fromOffset(20, 100)
panel.Size = UDim2.fromOffset(330, 215)
panel.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local function label(text, y, height)
    local item = Instance.new("TextLabel")
    item.Position = UDim2.fromOffset(10, y)
    item.Size = UDim2.new(1, -20, 0, height)
    item.BackgroundTransparency = 1
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.Gotham
    item.TextSize = 14
    item.TextWrapped = true
    item.Text = text
    item.Parent = panel
    return item
end
local function button(text, x)
    local item = Instance.new("TextButton")
    item.Position = UDim2.fromOffset(x, 48)
    item.Size = UDim2.fromOffset(150, 34)
    item.BackgroundColor3 = Color3.fromRGB(48, 61, 85)
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.Gotham
    item.TextSize = 15
    item.Text = text
    item.Parent = panel
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
    return item
end
label("BENZIN — AUTO ROUTE", 8, 30)
local startButton = button("Start", 10)
local stopButton = button("Stop", 170)
local status = label("Sit in your car. One Start runs the whole trip.", 94, 110)
local function message(text)
    if not destroyed then status.Text = text end
end
local function releaseE()
    if not input then return true end
    return pcall(function()
        input:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end
local function clearMotion()
    local previous = motion
    motion = nil
    if previous then
        for _, object in ipairs(previous.objects) do object:Destroy() end
        if previous.root:IsDescendantOf(workspace) then
            previous.root.AssemblyLinearVelocity = Vector3.zero
            previous.root.AssemblyAngularVelocity = Vector3.zero
        end
    end
    local saved = savedHumanoid
    savedHumanoid = nil
    if saved and saved.humanoid.Parent then
        saved.humanoid.PlatformStand = saved.platform
        saved.humanoid.AutoRotate = saved.rotate
        saved.humanoid:SetStateEnabled(
            Enum.HumanoidStateType.Seated, saved.seated
        )
    end
end
local function clearReceipts()
    for _, connection in ipairs(receiptConnections) do
        connection:Disconnect()
    end
    receiptConnections = {}
end
local function check()
    if cancelled or destroyed then error(reason, 0) end
    if player.Character ~= character or not root
        or not root:IsDescendantOf(workspace)
        or humanoid.Health <= 0 then
        error("Stopped: character unavailable.", 0)
    end
    if UIS:GetFocusedTextBox() then
        error("Stopped: close chat or text input.", 0)
    end
end
local function pause(seconds)
    local finish = os.clock() + seconds
    repeat
        check()
        task.wait(0.03)
    until os.clock() >= finish
end
local function inVehicles(object)
    while object do
        if object.Name == "Vehicles" then return true end
        object = object.Parent
    end
    return false
end
local function attachedTo(car)
    return car and car:IsDescendantOf(workspace)
        and root.AssemblyRootPart == car
end
local function tapE()
    check()
    input:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    pause(0.15)
    if not releaseE() then error("Could not release E.", 0) end
end
local function startMotion(part, person)
    clearMotion()
    motion = {
        root = part, person = person,
        objects = {}, command = Vector3.zero,
    }
    if person then
        savedHumanoid = {
            humanoid = humanoid,
            platform = humanoid.PlatformStand,
            rotate = humanoid.AutoRotate,
            seated = humanoid:GetStateEnabled(Enum.HumanoidStateType.Seated),
        }
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
    end
    local function make(className)
        local object = Instance.new(className)
        table.insert(motion.objects, object)
        return object
    end
    local attachment = make("Attachment")
    attachment.Parent = part
    local velocity = make("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    velocity.ForceLimitsEnabled = false
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = part
    local orientation = make("AlignOrientation")
    orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    orientation.Attachment0 = attachment
    orientation.RigidityEnabled = true
    orientation.CFrame = part.CFrame.Rotation
    orientation.Parent = part
    motion.velocity = velocity
end
local function checkMotion(current)
    check()
    local part = current.root
    if motion ~= current or not part:IsDescendantOf(workspace)
        or part.Anchored or current.velocity.Parent ~= part then
        error("Stopped: movement controller changed.", 0)
    end
    if current.person then
        local assembly = root.AssemblyRootPart
        if humanoid.Sit or not assembly
            or not assembly:IsDescendantOf(character) then
            error("Stopped: unexpected seat or object attachment.", 0)
        end
    elseif not humanoid.Sit or not attachedTo(part) then
        error("Stopped: vehicle connection changed.", 0)
    end
end
local function moveCar(target, maximumSpeed, title)
    local current = motion
    local part = current.root
    local best = (target - part.Position).Magnitude
    local lastProgress, started = os.clock(), os.clock()
    local settled = 0
    while true do
        local dt = RunService.PreSimulation:Wait()
        checkMotion(current)
        local offset = target - part.Position
        local distance = offset.Magnitude
        local actualSpeed = part.AssemblyLinearVelocity.Magnitude
        if distance < 2 and actualSpeed < 4 then
            settled = settled + math.min(dt, 0.1)
            if settled >= 0.15 then
                current.command = Vector3.zero
                current.velocity.VectorVelocity = Vector3.zero
                return
            end
        else
            settled = 0
        end
        if distance < best - 0.3 then
            best, lastProgress = distance, os.clock()
        elseif os.clock() - lastProgress > 7 then
            error("Stopped: blocked or corrected at " .. title, 0)
        end
        if os.clock() - started > 120 then
            error("Stopped: vehicle flight timeout.", 0)
        end
        local targetSpeed = math.min(
            maximumSpeed,
            math.sqrt(360 * math.max(distance - 0.4, 0)),
            distance * 2.5
        )
        local desired = distance > 0.2
            and offset.Unit * targetSpeed or Vector3.zero
        local delta = desired - current.command
        local rate = desired.Magnitude < current.command.Magnitude
            and 180 or 140
        local change = rate * math.min(dt, 0.1)
        if delta.Magnitude <= change then
            current.command = desired
        elseif delta.Magnitude > 0 then
            current.command = current.command + delta.Unit * change
        end
        current.velocity.VectorVelocity = current.command
        message(string.format(
            "%s\nSpeed: %.0f | Distance: %.0f",
            title, actualSpeed, distance
        ))
    end
end
local function flyPerson(points, title)
    startMotion(root, true)
    local current = motion
    local index = 1
    local best = math.huge
    local lastProgress, started = os.clock(), os.clock()
    while index <= #points do
        local dt = RunService.PreSimulation:Wait()
        checkMotion(current)
        local target = points[index]
        local final = index == #points
        local offset = target - root.Position
        local distance = offset.Magnitude
        if distance < (final and 0.8 or 1.3) then
            index = index + 1
            best, lastProgress = math.huge, os.clock()
            if index > #points then break end
            target = points[index]
            final = index == #points
            offset = target - root.Position
            distance = offset.Magnitude
        end
        if distance < best - 0.25 then
            best, lastProgress = distance, os.clock()
        elseif os.clock() - lastProgress > 5 then
            error("Stopped: blocked at " .. title .. " point " .. index, 0)
        end
        if os.clock() - started > 45 then
            error("Stopped: character flight timeout.", 0)
        end
        local speed = math.min(
            PERSON_SPEED, distance / math.max(dt, 0.001)
        )
        if final then speed = math.min(speed, distance * 10) end
        current.velocity.VectorVelocity = distance > 0.01
            and offset.Unit * speed or Vector3.zero
        message(string.format("%s: %d/%d", title, index, #points))
    end
    clearMotion()
end
local function watchReceipt()
    local result = {}
    local watched = {}
    local function inspect(object)
        if not object.Parent or object:IsDescendantOf(gui) then return end
        local text = object.Text:gsub("<.->", "")
        local lower = text:lower()
        local matches = lower:find("gas station", 1, true)
            or lower:find("gas store", 1, true)
            or lower:find("заправ", 1, true)
        if matches then
            local amount = text:match("%$%s*([%d,]+)")
            amount = amount and tonumber((amount:gsub(",", "")))
            if amount and amount > 0 then result.text = text end
        end
    end
    local function watch(object, added)
        if watched[object] or object:IsDescendantOf(gui) then return end
        if not object:IsA("TextLabel")
            and not object:IsA("TextButton") then return end
        watched[object] = true
        table.insert(receiptConnections,
            object:GetPropertyChangedSignal("Text"):Connect(function()
                inspect(object)
            end)
        )
        if added then inspect(object) end
    end
    table.insert(receiptConnections, pg.DescendantAdded:Connect(function(object)
        watch(object, true)
    end))
    for _, object in ipairs(pg:GetDescendants()) do watch(object, false) end
    return result
end
local function runCycle()
    character = player.Character
    humanoid = character and character:FindFirstChildOfClass("Humanoid")
    root = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then error("Character unavailable.", 0) end
    check()
    local team = player.Team and player.Team.Name:lower() or ""
    if not team:find("criminal", 1, true) then
        error("Join the Criminal team first.", 0)
    end
    local car = root.AssemblyRootPart
    if not humanoid.Sit or not car or car.Anchored or not inVehicles(car) then
        error("Sit in your car first.", 0)
    end
    if humanoid.PlatformStand then error("Disable other Fly scripts.", 0) end
    input = game:GetService("VirtualInputManager")
    if (car.Position - PARK).Magnitude > 4 then
        local origin = car.Position
        local altitude = math.max(origin.Y, PARK.Y) + CAR_HEIGHT
        startMotion(car, false)
        moveCar(Vector3.new(origin.X, altitude, origin.Z), 120, "Ascending")
        moveCar(Vector3.new(PARK.X, altitude, PARK.Z), CAR_SPEED, "Flying to Benzin")
        moveCar(PARK, 90, "Descending")
        clearMotion()
    end
    pause(0.5)
    message("Exiting vehicle")
    tapE()
    local deadline = os.clock() + 5
    while humanoid.Sit or attachedTo(car) do
        if os.clock() > deadline then error("Stopped: vehicle exit failed.", 0) end
        pause(0.05)
    end
    pause(0.3)
    flyPerson(INBOUND, "To cashier")
    pause(0.2)
    local receipt = watchReceipt()
    message("Robbing: holding E")
    input:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    deadline = os.clock() + HOLD_SECONDS
    repeat
        pause(0.05)
    until receipt.text or os.clock() >= deadline
    if not releaseE() then error("Could not release E.", 0) end
    if not receipt.text then pause(0.5) end
    clearReceipts()
    local result = receipt.text
        and ("Receipt detected: " .. receipt.text)
        or "No new receipt detected. Robbery NOT confirmed."
    if not car:IsDescendantOf(workspace)
        or (car.Position - PARK).Magnitude > 12 then
        error("Vehicle missing or moved.\n" .. result, 0)
    end
    local back = {}
    for _, point in ipairs(OUTBOUND) do table.insert(back, point) end
    flyPerson(back, "Returning to car")
    pause(0.3)
    local model = car
    while model.Parent and model.Parent.Name ~= "Vehicles" do
        model = model.Parent
    end
    local driver = model:FindFirstChild("Seat", true)
    if not driver or not driver:IsA("BasePart") then
        error("Driver seat not found; boarding cancelled.", 0)
    end
    local function nearestDriver()
        local distance = (root.Position-driver.Position).Magnitude
        for _,part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") and part.Name:lower():find("passenger",1,true)
                and (root.Position-part.Position).Magnitude <= distance then
                return false
            end
        end
        return true
    end
    for attempt=1,3 do
        if attempt > 1 or not nearestDriver()
            or (root.Position-driver.Position).Magnitude > 6 then
            local seatLocal = car.CFrame:PointToObjectSpace(driver.Position)
            if math.abs(seatLocal.X) < 0.3 then
                error("Driver side could not be determined.",0)
            end
            local side = seatLocal.X < 0 and -1 or 1
            local entry = car.CFrame:PointToWorldSpace(
                seatLocal+Vector3.new(side*2.5,0,0)
            )+Vector3.new(0,2,0)
            flyPerson({entry}, "Driver-side approach")
            pause(0.2)
        end
        if not nearestDriver() then error("Driver-side approach not confirmed.",0) end
        message("Entering driver seat: "..attempt.." / 3")
        tapE()
        deadline = os.clock()+5
        while not (humanoid.Sit and attachedTo(car)) and os.clock()<deadline do
            pause(0.05)
        end
        if humanoid.Sit and attachedTo(car) then
            if nearestDriver() and (root.Position-driver.Position).Magnitude <= 2.75 then
                message("Trip finished. Driver position confirmed.\n"..result)
                return
            end
            tapE()
            deadline = os.clock()+5
            while humanoid.Sit or attachedTo(car) do
                if os.clock()>deadline then error("Could not leave passenger seat.",0) end
                pause(0.05)
            end
        end
    end
    error("Returned to car, but driver entry was not confirmed.\n"..result,0)
end
local focusConnection = UIS.WindowFocusReleased:Connect(function()
    if running and armed then
        cancelled = true
        reason = "Stopped: Roblox lost focus."
        releaseE()
    end
end)
stopButton.Activated:Connect(function()
    if running then
        cancelled = true
        reason = "Stopped by user."
        releaseE()
    end
end)
hubCapture(function()
    if running or destroyed then return end
    running, cancelled, armed = true, false, false
    reason = "Stopped."
    startButton.Text = "Running..."
    task.spawn(function()
        local ok, problem = pcall(function()
            for seconds = 3, 1, -1 do
                if cancelled or destroyed then error(reason, 0) end
                message("Return to Roblox: " .. seconds)
                task.wait(1)
            end
            armed = true
            runCycle()
        end)
        armed = false
        local released = releaseE()
        clearMotion()
        clearReceipts()
        if not ok then message(tostring(problem)) end
        if not released then
            message("Release failed. Press and release E manually.")
        end
        running = false
        if not destroyed then startButton.Text = "Start" end
    end)
end)
gui.Destroying:Connect(function()
    destroyed, cancelled = true, true
    reason = "Menu closed."
    releaseE()
    clearMotion()
    clearReceipts()
    focusConnection:Disconnect()
end)
gui.Enabled=false
return {Start=hubStart, Stop=function() cancelled=true;reason='Stopped from main menu';releaseE() end, Busy=function() return running end, Destroy=function() gui:Destroy() end, Log=function() return status.Text end, Status=function() return status.Text end}
]====]
HUB_SOURCES['Casino'] = [====[
local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local GuiService = game:GetService("GuiService")

local UIS = game:GetService("UserInputService")

local VIM = game:GetService("VirtualInputManager")



local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local KEY = "__CasinoFullCycle"



for _, name in ipairs({

    KEY, "__CasinoCombined", "__SecurityToVault",

    "__CasinoRouteTest", "__CasinoExitTest",

    "__CasinoDeliveryTest", "__CasinoVaultColorMenu",

    "__CasinoLaserObserver", "__CasinoCodeEntryTest",

}) do

    if type(_G[name]) == "function" then

        pcall(_G[name])

    end

end



local V = Vector3.new

local function points(rows)

    local result = {}

    for i, row in ipairs(rows) do

        result[i] = V(row[1], row[2], row[3])

    end

    return result

end



local CASINO_PARK = V(963.80, 22.96, -3823.50)

local VOLCANO_PARK = V(1722.76, 22.58, -3002.88)

local KEYPAD_POINT = V(1177.24, 25.45, -3572.16)



local EXIT_ROUTE = points({

    {1168.41, -68.23, -3648.99},

    {1179.16, -69.14, -3657.38},

    {1179.03, 29.19, -3657.32},

    {1170.35, 27.49, -3647.69},

    {1203.81, 24.25, -3604.75},

    {1181.77, 24.35, -3577.56},

    {1149.85, 28.32, -3543.87},

    {1076.35, 29.32, -3648.34},

    {1051.65, 29.91, -3753.65},

    {971.66, 28.24, -3821.59},

})



local SECURITY_APPROACH = points({

    {1173.50, 78.07, -3650.25},

    {1218.11, 88.27, -3608.97},

    {1188.68, 83.20, -3576.46},

    {1155.43, 81.42, -3548.84},

    {1135.82, 75.77, -3584.39},

})



local PC_ROUTE = points({

    {1137.52, 77.59, -3582.56},

    {1108.59, 77.64, -3611.00},

    {1007.98, 77.63, -3666.24},

    {1031.50, 77.58, -3645.08},

    {1048.31, 77.58, -3628.45},

    {1056.56, 77.60, -3619.60},

    {1073.76, 77.63, -3602.57},

    {1088.47, 77.61, -3589.01},

    {1093.43, 77.62, -3583.70},

    {1113.47, 77.64, -3564.51},

    {1131.16, 77.63, -3546.60},

    {1140.94, 77.64, -3537.89},

})



local SECURITY_ROUTE = points({

    {1172.24, 75.99, -3647.69},

    {1172.29, 79.32, -3647.68},

    {1180.22, 78.84, -3656.01},

    {1180.28, -69.08, -3655.83},

    {1168.07, -71.62, -3645.70},

    {1150.87, -73.06, -3662.83},  

    {1150.90, -71.39, -3662.82},  

    {1137.93, -69.78, -3675.70},  

    {1082.82, -71.99, -3617.21},

    {1104.64, -68.86, -3586.03},

    {1049.65, -71.25, -3516.47},

    {1045.44, -70.15, -3439.95},

    {1076.85, -70.17, -3374.50},

})



local VAULT_ROUTE = points({

    {1074.82, -71.58, -3372.77},

    {1089.74, -72.08, -3367.62},

    {1102.40, -72.40, -3320.06},

    {1105.79, -72.38, -3306.11},

    {1115.88, -72.38, -3306.09},

    {1124.58, -72.40, -3292.82},

    {1129.48, -72.43, -3319.79},

    {1180.15, -72.07, -3329.10},

    {1087.22, -67.43, -3361.55},

    {1055.91, -71.09, -3414.53},

    {1042.92, -72.52, -3478.20},

    {1071.67, -72.84, -3549.28},

    {1113.62, -70.22, -3587.16},

    {1080.71, -66.75, -3617.53},

    {1147.89, -74.55, -3670.59},

    {1151.93, -71.73, -3663.78},

    {1174.96, -73.10, -3648.11},

})



local DELIVERY_ROUTE = points({

    {1724.53, 28.62, -3003.61},

    {1732.42, 29.55, -2893.91},

    {1664.58, 41.98, -2546.16},

    {1718.20, 48.89, -2148.20},

    {1764.46, 42.57, -2033.32},

    {1702.32, 45.45, -2151.45},

    {1682.19, 43.34, -2450.58},

    {1661.42, 39.04, -2620.97},

    {1735.05, 34.10, -2878.83},

    {1726.05, 28.73, -2998.14},

})



local BEAM_CENTERS = {

    V(1146.88, 0, -3623.62),

    V(1155.77, 0, -3632.83),

    V(1164.66, 0, -3642.04),

}



 

local gui = Instance.new("ScreenGui")

gui.Name = "CasinoFullCycle"

gui.ResetOnSpawn = false

gui.DisplayOrder = 200

gui.Parent = playerGui



local panel = Instance.new("Frame")

panel.Position = UDim2.fromOffset(20, 110)

panel.Size = UDim2.fromOffset(410, 350)

panel.BackgroundColor3 = Color3.fromRGB(27, 29, 36)

panel.BorderSizePixel = 0

panel.Parent = gui



local corner = Instance.new("UICorner")

corner.CornerRadius = UDim.new(0, 10)

corner.Parent = panel



local function label(text, y, height, size)

    local item = Instance.new("TextLabel")

    item.Position = UDim2.fromOffset(12, y)

    item.Size = UDim2.new(1, -24, 0, height)

    item.BackgroundTransparency = 1

    item.Font = Enum.Font.Gotham

    item.TextSize = size

    item.TextColor3 = Color3.fromRGB(235, 238, 245)

    item.TextWrapped = true

    item.Text = text

    item.Parent = panel

    return item

end



label("Casino — Security Recovery", 8, 28, 18)

local stageLabel = label("Ready", 40, 25, 15)

local status = label(

    "Start from car, or continue beside the solved Security PC.",

    70, 65, 14

)



local function button(text, x, y, color)

    local item = Instance.new("TextButton")

    item.Position = UDim2.fromOffset(x, y)

    item.Size = UDim2.fromOffset(188, 34)

    item.BackgroundColor3 = color

    item.BorderSizePixel = 0

    item.Font = Enum.Font.GothamBold

    item.TextSize = 12

    item.TextColor3 = Color3.new(1, 1, 1)

    item.Text = text

    item.Parent = panel

    return item

end



local startButton = button(

    "Start from car", 12, 142, Color3.fromRGB(40, 140, 85)

)

local resumeButton = button(

    "Continue after Security", 210, 142, Color3.fromRGB(65, 90, 145)

)

local stopButton = button(

    "Stop", 12, 184, Color3.fromRGB(175, 60, 65)

)

local copyButton = button(

    "Copy report", 210, 184, Color3.fromRGB(65, 90, 145)

)



local logBox = Instance.new("TextBox")

logBox.Position = UDim2.fromOffset(12, 228)

logBox.Size = UDim2.fromOffset(386, 110)

logBox.BackgroundColor3 = Color3.fromRGB(18, 20, 26)

logBox.BorderSizePixel = 0

logBox.Font = Enum.Font.Code

logBox.TextSize = 11

logBox.TextColor3 = Color3.fromRGB(210, 220, 235)

logBox.TextXAlignment = Enum.TextXAlignment.Left

logBox.TextYAlignment = Enum.TextYAlignment.Top

logBox.TextWrapped = true

logBox.MultiLine = true

logBox.ClearTextOnFocus = false

logBox.TextEditable = false

logBox.Text = "No run started."

logBox.Parent = panel



local busy, destroyed = false, false

local stopReason

local keyDown, mouseDown = false, false

local lastX, lastY = 0, 0

local context, motion

local stageName = "Ready"

local records = {}

local connections = {}

local temporary = {}

local runStarted = os.clock()



local function log(text)

    records[#records + 1] = string.format(

        "%.2fs | %s", os.clock() - runStarted, text

    )

    local report = table.concat(records, "\n")

    _G.__CasinoLastReport = report



    if not destroyed then

        local recent = {}

        for i = math.max(1, #records - 4), #records do

            recent[#recent + 1] = records[i]

        end

        logBox.Text = table.concat(recent, "\n")

    end

end



local function setStatus(text)

    if not destroyed then status.Text = text end

end



local function stage(text)

    stageName = text

    log("STAGE: " .. text)

    if not destroyed then stageLabel.Text = text end

end



local function disconnectTemporary()

    for connection in pairs(temporary) do

        connection:Disconnect()

    end

    temporary = {}

end



local function releaseInputs()

    if keyDown then

        pcall(function()

            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        end)

        keyDown = false

    end

    if mouseDown then

        pcall(function()

            VIM:SendMouseButtonEvent(lastX, lastY, 0, false, game, 0)

        end)

        mouseDown = false

    end

end



local function endMotion()

    local s = motion

    motion = nil

    if not s then return end



    if s.physics then s.physics:Disconnect() end

    if s.added then s.added:Disconnect() end

    if s.velocity then s.velocity:Destroy() end

    if s.orientation then s.orientation:Destroy() end

    if s.attachment then s.attachment:Destroy() end



    if s.root.Parent then

        s.root.AssemblyLinearVelocity = Vector3.zero

        s.root.AssemblyAngularVelocity = Vector3.zero

    end



    if s.foot then

        for part, original in pairs(s.collisions) do

            if part.Parent then

                pcall(function() part.CanCollide = original end)

            end

        end

        if s.humanoid.Parent then

            s.humanoid.PlatformStand = s.platformStand

            s.humanoid.AutoRotate = s.autoRotate

            s.humanoid:SetStateEnabled(

                Enum.HumanoidStateType.Seated, s.seated

            )

        end

    end

end



local function requestStop(reason)

     

    if not busy or stopReason then return end



    stopReason = reason

    log("STOP REQUEST: " .. reason .. " | " .. stageName)

    releaseInputs()

    disconnectTemporary()

    endMotion()

    setStatus("Stopped at " .. stageName .. "\n" .. reason)

end



local function check()

    if destroyed then error("Script replaced or closed.", 0) end

    if stopReason then error(stopReason, 0) end



    if not context

        or player.Character ~= context.character

        or not context.root.Parent

        or context.humanoid.Health <= 0 then

        error("Character changed or died.", 0)

    end



    if UIS:GetFocusedTextBox() then

        error("Text input is focused.", 0)

    end

end



local function holdPosition(target)

    if not motion then error("Movement controller missing.", 0) end



    local delta = target - motion.root.Position

    if delta.Magnitude > 4 then

        error("Moved away from waiting point.", 0)

    end



    local velocity = delta * 8

    if velocity.Magnitude > 12 then velocity = velocity.Unit * 12 end

    motion.velocity.VectorVelocity = velocity

end



local function waitChecked(seconds, target)

    local started = os.clock()

    repeat

        RunService.Heartbeat:Wait()

        check()

        if target then holdPosition(target) end

    until os.clock() - started >= seconds

end



local function holdE(seconds, target)

    check()

    keyDown = true

    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)

    waitChecked(seconds, target)

    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)

    keyDown = false

end



local function attachedVehicle()

    if not context then return nil end

    local root = context.root.AssemblyRootPart

    local vehicles = workspace:FindFirstChild("Vehicles")



    if root and vehicles

        and not root:IsDescendantOf(context.character)

        and root:IsDescendantOf(vehicles) then

        return root

    end

end



local function beginMotion(root, foot, noclip)

    if motion and motion.root == root

        and motion.foot == foot and motion.noclip == noclip then

        return motion

    end



    endMotion()

    local s = {

        root = root, foot = foot, noclip = noclip,

        humanoid = context.humanoid, collisions = {},

    }

    motion = s



    if foot then

        local h = context.humanoid

        s.platformStand = h.PlatformStand

        s.autoRotate = h.AutoRotate

        s.seated = h:GetStateEnabled(Enum.HumanoidStateType.Seated)



        if noclip then

            local function track(part)

                if not part:IsA("BasePart") then return end

                if s.collisions[part] == nil then

                    s.collisions[part] = part.CanCollide

                end

                part.CanCollide = false

            end



            for _, part in ipairs(context.character:GetDescendants()) do

                track(part)

            end

            s.added = context.character.DescendantAdded:Connect(track)

            s.physics = RunService.Stepped:Connect(function()

                if motion ~= s then return end

                for part in pairs(s.collisions) do

                    if part:IsDescendantOf(context.character) then

                        part.CanCollide = false

                    end

                end

            end)

        end



        h:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        h.AutoRotate = false

        h.PlatformStand = true

    end



    local attachment = Instance.new("Attachment")

    s.attachment = attachment

    attachment.Parent = root



    local velocity = Instance.new("LinearVelocity")

    s.velocity = velocity

    velocity.Attachment0 = attachment

    velocity.RelativeTo = Enum.ActuatorRelativeTo.World

    velocity.ForceLimitsEnabled = false

    velocity.VectorVelocity = Vector3.zero

    velocity.Parent = root



    local orientation = Instance.new("AlignOrientation")

    s.orientation = orientation

    orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment

    orientation.Attachment0 = attachment

    orientation.RigidityEnabled = true

    orientation.CFrame = root.CFrame.Rotation

    orientation.Parent = root



    return s

end



local function moveTo(target, speed)

    local s = motion

    if not s then error("Movement controller missing.", 0) end



    local elapsed, stalled, settled = 0, 0, 0

    local best = (target - s.root.Position).Magnitude

    local commanded = Vector3.zero



    while true do

        local dt = RunService.Heartbeat:Wait()

        check()



        if not s.root:IsDescendantOf(workspace) then

            error("Movement root disappeared.", 0)

        end

        if not s.foot and attachedVehicle() ~= s.root then

            error("Character detached from vehicle.", 0)

        end



        local delta = target - s.root.Position

        local distance = delta.Magnitude



        if s.foot and distance <= 0.8 then

            s.velocity.VectorVelocity = Vector3.zero

            s.root.AssemblyLinearVelocity = Vector3.zero

            return

        end



        if not s.foot and distance <= 1.5

            and s.root.AssemblyLinearVelocity.Magnitude <= 4 then

            settled = settled + dt

            if settled >= 0.15 then

                s.velocity.VectorVelocity = Vector3.zero

                s.root.AssemblyLinearVelocity = Vector3.zero

                return

            end

        else

            settled = 0

        end



        elapsed = elapsed + dt

        if distance < best - 0.4 then

            best = distance

            stalled = 0

        else

            stalled = stalled + dt

        end



        if stalled >= (s.foot and 5 or 7) then

            error(string.format(

                "Movement blocked. Remaining distance: %.2f", distance

            ), 0)

        end

        if elapsed >= (s.foot and 25 or 45) then

            error("Movement timeout.", 0)

        end



        local wanted = Vector3.zero

        if distance > 0.01 then

            if s.foot then

                wanted = delta.Unit * math.min(

                    speed, distance * 10,

                    distance / math.max(dt, 1 / 240)

                )

            else

                wanted = delta.Unit * math.min(

                    speed,

                    math.sqrt(360 * math.max(0, distance - 0.4)),

                    distance * 2.5

                )

            end

        end



        if s.foot then

            commanded = wanted

        else

            local change = wanted - commanded

            local limit = 140 * math.min(dt, 0.1)

            if change.Magnitude > limit then

                change = change.Unit * limit

            end

            commanded = commanded + change

        end

        s.velocity.VectorVelocity = commanded

    end

end



local function footMove(target, speed, noclip, keep)

    check()

    beginMotion(context.root, true, noclip)

    moveTo(target, speed)

    if not keep then endMotion() end

end



local function casino()

    return workspace:FindFirstChild("Casino")

        or workspace:FindFirstChild("Casino", true)

end



local function visible(object)

    local current = object

    while current and current ~= game do

        if current:IsA("GuiObject") and not current.Visible then

            return false

        end

        if current:IsA("LayerCollector") and not current.Enabled then

            return false

        end

        current = current.Parent

    end

    return true

end



local function clean(text)

    return text:gsub("<[^>]->", ""):gsub("^%s+", ""):gsub("%s+$", "")

end



local function readCode()

    local c = casino()

    local door = c and c:FindFirstChild("RobberyDoor")

    local codes = door and door:FindFirstChild("Codes")

    if not codes then error("Codes folder not loaded.", 0) end



    local groups = {}

    for _, group in ipairs(codes:GetChildren()) do

        if group.Name == "Code" then

            local digits, used = {}, {}



            for _, object in ipairs(group:GetDescendants()) do

                if object:IsA("TextLabel") and visible(object)

                    and object.TextTransparency < 1 then



                    local text = clean(object.Text):gsub("%s+", "")

                    if text:match("^%d$") then

                        local surface =

                            object:FindFirstAncestorWhichIsA("SurfaceGui")

                        local part = surface

                            and (surface.Adornee or surface.Parent)



                        if not part or not part:IsA("BasePart") then

                            error("Digit surface missing.", 0)

                        end

                        if surface.Face ~= Enum.NormalId.Front then

                            error("Unverified code surface face.", 0)

                        end

                        if used[part] then error("Duplicate digits.", 0) end



                        local current = object

                        while current and current ~= surface do

                            if current:IsA("GuiObject") then

                                local angle = (current.Rotation + 180) % 360 - 180

                                if math.abs(angle) > 0.1 then

                                    error("Unverified digit GUI rotation.", 0)

                                end

                            end

                            current = current.Parent

                        end



                        used[part] = true

                        digits[#digits + 1] = {

                            text = text, position = part.Position,

                            right = part.CFrame.RightVector,

                            up = part.CFrame.UpVector,

                        }

                    end

                end

            end



            if #digits > 0 then

                if #digits ~= 4 then error("Incomplete four-digit code.", 0) end

                groups[#groups + 1] = {group = group, digits = digits}

            end

        end

    end



    if #groups ~= 1 then

        error("Expected one active code group; found " .. #groups .. ".", 0)

    end



    local selected = groups[1]

    local digits = selected.digits

    local reference = digits[1]

    local center, total = Vector3.zero, Vector3.zero



    for _, digit in ipairs(digits) do

        if digit.right:Dot(reference.right) < 0.98

            or digit.up:Dot(reference.up) < 0.98 then

            error("Digit orientations do not agree.", 0)

        end

        center = center + digit.position

        total = total + digit.right

    end



    center = center / 4

    local axis = -total.Unit



    for _, digit in ipairs(digits) do

        local delta = digit.position - center

        if (delta - axis * delta:Dot(axis)).Magnitude > 0.6 then

            error("Unexpected code layout.", 0)

        end

    end



    table.sort(digits, function(a, b)

        return (a.position - center):Dot(axis)

            < (b.position - center):Dot(axis)

    end)



    local code = ""

    for i, digit in ipairs(digits) do

        if i > 1 and

            (digit.position - digits[i - 1].position):Dot(axis) < 0.2 then

            error("Ambiguous digit order.", 0)

        end

        code = code .. digit.text

    end



    return code, selected.group

end



local CLEAR = {

    ["Clear"] = true, ["CLEAR"] = true,

    ["Очистить"] = true, ["ОЧИСТИТЬ"] = true,

    ["Сброс"] = true, ["Сбросить"] = true,

}

local ENTER = {

    ["Enter"] = true, ["ENTER"] = true,

    ["Ввод"] = true, ["ВВОД"] = true,

    ["Ввести"] = true, ["ВВЕСТИ"] = true,

    ["Подтвердить"] = true, ["OK"] = true,

}



local function keypadButtons()

    local app = playerGui:FindFirstChild("AppUI")

    local keypad = app and app:FindFirstChild("CasinoKeypad")

    local buttons = keypad and keypad:FindFirstChild("Buttons")

    if buttons and visible(keypad) then return buttons end

end



local function matchesAction(target, action)

    local function matches(object)

        if not (object:IsA("TextLabel") or object:IsA("TextButton"))

            or not visible(object) or object.TextTransparency >= 1 then

            return false

        end

        local text = clean(object.Text)

        if action == "clear" then return CLEAR[text] == true end

        if action == "enter" then return ENTER[text] == true end

        return text == action

    end



    if matches(target) then return true end

    for _, object in ipairs(target:GetDescendants()) do

        if matches(object) then return true end

    end

    return false

end



local function clickAction(action)

    check()

    local buttons = keypadButtons()

    if not buttons then error("Game keypad not open.", 0) end



    local matches = {}

    for _, object in ipairs(buttons:GetDescendants()) do

        if object:IsA("GuiButton") and visible(object)

            and object.Active and matchesAction(object, action) then

            matches[#matches + 1] = object

        end

    end



    if #matches ~= 1 then

        error("Button '" .. action .. "' has " .. #matches .. " matches.", 0)

    end



    local target = matches[1]

    if target.AbsoluteSize.X <= 0 or target.AbsoluteSize.Y <= 0 then

        error("Button has no visible size.", 0)

    end



    local hovered = false

    local enter = target.MouseEnter:Connect(function() hovered = true end)

    local leave = target.MouseLeave:Connect(function() hovered = false end)

    temporary[enter], temporary[leave] = true, true



    local center = target.AbsolutePosition + target.AbsoluteSize / 2

    local inset = GuiService:GetGuiInset()

    local found = false



    for _, position in ipairs({center + inset, center}) do

        VIM:SendMouseMoveEvent(1, 1, game)

        waitChecked(0.1)

        hovered = false

        lastX = math.floor(position.X + 0.5)

        lastY = math.floor(position.Y + 0.5)

        VIM:SendMouseMoveEvent(lastX, lastY, game)

        waitChecked(0.2)

        if hovered then found = true break end

    end



    if not found then error("Hover not confirmed: " .. action, 0) end

    if not target:IsDescendantOf(playerGui)

        or not visible(target) or not matchesAction(target, action) then

        error("Button changed before click.", 0)

    end



    mouseDown = true

    VIM:SendMouseButtonEvent(lastX, lastY, 0, true, game, 0)

    waitChecked(0.06)

    releaseInputs()



    enter:Disconnect()

    leave:Disconnect()

    temporary[enter], temporary[leave] = nil, nil

    waitChecked(0.3)

end



local function enterCode()

    stage("Reading casino code")

    local code, group = readCode()

    log("Code read: " .. code)



    if not keypadButtons() then

        setStatus("Opening keypad with E...")

        holdE(0.15)

        local t = os.clock()

        while not keypadButtons() and os.clock() - t < 4 do

            waitChecked(0.1)

        end

        if not keypadButtons() then error("E did not open the keypad.", 0) end

    end



    stage("Entering casino code")

    clickAction("clear")

    for i = 1, #code do

        setStatus("Code: " .. code .. "\nEntering digit " .. i)

        clickAction(code:sub(i, i))

    end



    local latest, latestGroup = readCode()

    if latest ~= code or latestGroup ~= group then

        error("Code changed during input.", 0)

    end



    clickAction("enter")

    local t = os.clock()

    while keypadButtons() and os.clock() - t < 5 do

        waitChecked(0.1)

    end

    if keypadButtons() then error("Keypad remained open after Enter.", 0) end

    waitChecked(0.6)

end



local function red(c)

    return c.R > 0.8 and c.G < 0.25 and c.B < 0.25

end



local function white(c)

    return c.R > 0.85 and c.G > 0.85 and c.B > 0.85

end



local function securitySolvedColor(c)
    if white(c) then return true end
    return math.abs(c.R*255-142) <= 8
        and math.abs(c.G*255-145) <= 8
        and math.abs(c.B*255-161) <= 8
end

local function rgb(c)

    return string.format(

        "%d,%d,%d",

        math.floor(c.R * 255 + 0.5),

        math.floor(c.G * 255 + 0.5),

        math.floor(c.B * 255 + 0.5)

    )

end



local function findDisplay(position)

    local c = casino()

    local computers = c and c:FindFirstChild("Computers")

    if not computers then error("Security computers not found.", 0) end



    local result, best = nil, 14

    for _, part in ipairs(computers:GetDescendants()) do

        if part:IsA("BasePart") and part.Name == "Display" then

            local d = (part.Position - position).Magnitude

            if d < best then result, best = part, d end

        end

    end

    if not result then error("Computer display not found nearby.", 0) end

    return result

end



local function solveRedComputer(display, index)
    log("Red PC " .. index .. " | initial RGB " .. rgb(display.Color))
    local lastRGB = rgb(display.Color)
    local watcher = display:GetPropertyChangedSignal("Color"):Connect(function()
        if not display:IsDescendantOf(workspace) then return end
        local value = rgb(display.Color)
        if value ~= lastRGB then
            lastRGB = value
            log("PC " .. index .. " RGB " .. value)
        end
    end)
    temporary[watcher] = true
    local ok, err = pcall(function()
        setStatus("Red PC " .. index .. ": holding E for 2.5 seconds...")
        holdE(2.5)
        local deadline = os.clock()+5
        local stableSince = nil
        while os.clock() < deadline do
            waitChecked(0.05)
            if not display:IsDescendantOf(workspace) then
                error("Red computer display disappeared.",0)
            end
            if securitySolvedColor(display.Color) then
                stableSince = stableSince or os.clock()
                if os.clock()-stableSince >= 0.35 then
                    log("SECURITY CONFIRMED: stable solved color " .. rgb(display.Color))
                    return
                end
            else
                stableSince = nil
            end
        end
        error("Security solved color not stable after E. Last RGB: "
            .. rgb(display.Color),0)
    end)
    watcher:Disconnect()
    temporary[watcher] = nil
    if not ok then error(err,0) end
    setStatus("Security confirmed. Returning along recorded route...")
end

local function runSecurity()

    local visited = {}

    for index, target in ipairs(PC_ROUTE) do

        stage("Security PC " .. index .. " / 12")

        setStatus("Following PC route. Noclip OFF.")

        footMove(target, 65, false, false)

        waitChecked(0.15)



        local display = findDisplay(context.root.Position)

        log("PC " .. index .. " initial RGB " .. rgb(display.Color))



        if not visited[display] then

            visited[display] = true



            if not red(display.Color) and not securitySolvedColor(display.Color) then

                holdE(0.12)

                local started = os.clock()

                while display:IsDescendantOf(workspace)

                    and not red(display.Color) and not securitySolvedColor(display.Color)

                    and os.clock() - started < 3 do

                    waitChecked(0.1)

                end

            end



            if not display:IsDescendantOf(workspace) then

                error("Computer display disappeared.", 0)

            end



            if red(display.Color) then

                solveRedComputer(display, index)

                return index

            end



            if not securitySolvedColor(display.Color) then

                error("PC did not turn red or solved. RGB: " .. rgb(display.Color), 0)

            end

        end

    end

    error("No red computer confirmed. Security state is unknown.", 0)

end



local function returnFromSecurity(lastPC)

    beginMotion(context.root, true, false)



    for index = lastPC, 1, -1 do

        stage("Security return: PC " .. index)

        setStatus("Returning via recorded PC points. Noclip OFF.")

        moveTo(PC_ROUTE[index], 65)

    end



    for index = #SECURITY_APPROACH, 1, -1 do

        stage("Wall bypass return " .. index .. " / 5")

        setStatus("Following recorded bypass. Noclip OFF.")

        moveTo(SECURITY_APPROACH[index], 65)

    end



    endMotion()

end



local function findBeams()

    local c = casino()

    local moving = c and c:FindFirstChild("LasersMoving")

    if not moving then error("LasersMoving not found.", 0) end



    local candidates = {}

    for _, part in ipairs(moving:GetDescendants()) do

        if part:IsA("BasePart") and part.Name == "Part"

            and math.abs(part.Size.X - 93.55) < 1

            and part.Size.Y < 0.6 and part.Size.Z < 0.6 then

            candidates[#candidates + 1] = part

        end

    end



    local beams, used = {}, {}

    for i, expected in ipairs(BEAM_CENTERS) do

        local nearest, best = nil, 3

        for _, part in ipairs(candidates) do

            if not used[part] then

                local d = (V(part.Position.X, 0, part.Position.Z) - expected).Magnitude

                if d < best then nearest, best = part, d end

            end

        end

        if not nearest then error("Recorded laser " .. i .. " not found.", 0) end

        beams[i], used[nearest] = nearest, true

    end

    return beams

end



local function waitForLasers(waitingPosition, destination)

    local beams = findBeams()

    local minimum = math.max(-58.75, math.max(waitingPosition.Y, destination.Y) + 8)

    local previous = {}

    for i, beam in ipairs(beams) do previous[i] = beam.Position.Y end



    local started = os.clock()

    local previousTime = started

    local good = 0



    while true do

        RunService.Heartbeat:Wait()

        check()

        holdPosition(waitingPosition)

        local now = os.clock()



        if now - started >= 20 then error("No laser window detected.", 0) end



        if now - previousTime >= 0.12 then

            local dt, ready = now - previousTime, true

            for i, beam in ipairs(beams) do

                if not beam:IsDescendantOf(workspace) then

                    error("Laser disappeared.", 0)

                end

                local y = beam.Position.Y

                local speedY = (y - previous[i]) / dt

                previous[i] = y

                if y < minimum or speedY < 0.5 then ready = false end

            end



            previousTime = now

            good = ready and (good + 1) or 0

            setStatus("Waiting for rising lasers...\nClearance: " .. good .. " / 3")



            if good >= 3 then

                motion.velocity.VectorVelocity = Vector3.zero

                log("Laser window confirmed")

                return

            end

        end

    end

end



local function crackVault()

    local c = casino()

    local vaults = c and c:FindFirstChild("HackableVaults")

    local door = vaults and vaults:FindFirstChild("VaultDoorMain")

    local inner = door and door:FindFirstChild("InnerModel")

    local model = inner and inner:FindFirstChild("Model")

    local led = model and model:FindFirstChild("UnlockedLED")

    local body = model and model:FindFirstChild("Body")



    if not led or not led:IsA("BasePart")

        or not body or not body:IsA("BasePart") then

        error("Vault indicator or body not found.", 0)

    end



    local function signal()

        local color = led.Color

        return math.abs(color.R - 142/255) <= 10/255

            and math.abs(color.G - 145/255) <= 10/255

            and math.abs(color.B - 161/255) <= 10/255

    end



    local original = body.CFrame

    local first, wasWhite = false, signal()

    local started, openingSince = os.clock(), nil

    local taps = 0

    stage("Cracking vault")



    while true do

        RunService.Heartbeat:Wait()

        check()



        if not led:IsDescendantOf(workspace)

            or not body:IsDescendantOf(workspace) then

            error("Vault objects disappeared.", 0)

        end



        local relative = original:ToObjectSpace(body.CFrame)

        local _, angle = relative:ToAxisAngle()

        if math.abs(angle) >= math.rad(55) or relative.Position.Magnitude >= 6 then

            openingSince = openingSince or os.clock()

            if os.clock() - openingSince >= 0.2 then

                log("Vault opening movement detected")

                waitChecked(0.35)

                return

            end

        else

            openingSince = nil

        end



        if os.clock() - started >= 60 then error("Vault opening timeout.", 0) end

        local nowWhite = signal()

        if not first then

            wasWhite = nowWhite

            if not nowWhite then

                holdE(0.06)

                first = true

                setStatus("Waiting for white signal...")

            end

        else

            local flash = nowWhite and not wasWhite

            wasWhite = nowWhite

            if flash then

                holdE(0.06)

                taps = taps + 1

                setStatus("White signal: E tap " .. taps)

            end

        end

    end

end



local function securityToVault()

    for i = 1, 2 do

        stage("Security shaft approach " .. i)

        footMove(SECURITY_ROUTE[i], 65, false, true)

    end



    beginMotion(context.root, true, true)

    for i = 3, 5 do

        stage("Shaft descent: point " .. i)

        moveTo(SECURITY_ROUTE[i], 100)

    end



    beginMotion(context.root, true, false)

    for i = 6, #SECURITY_ROUTE do

        if i == 9 then

            stage("Waiting before underground lasers")

            waitForLasers(SECURITY_ROUTE[8], SECURITY_ROUTE[9])

        end



        stage("Vault approach " .. i .. " / 13")

        local health = context.humanoid.Health

        moveTo(SECURITY_ROUTE[i], i == 9 and 55 or 100)



        if i == 9 and context.humanoid.Health < health then

            error("Damage detected on underground laser crossing.", 0)

        end

        if i == 6 then

            setStatus("Holding E for 2 seconds...")

            waitChecked(0.15, SECURITY_ROUTE[i])

            holdE(2, SECURITY_ROUTE[i])

            waitChecked(0.25, SECURITY_ROUTE[i])

        end

    end



    stage("Joining vault lock point")

    moveTo(VAULT_ROUTE[1], 55)

    endMotion()

    waitChecked(0.15)

end



local function vaultAndExit()

    crackVault()



    for i = 2, #VAULT_ROUTE do

        if i == 15 then

            stage("Waiting before exit lasers")

            beginMotion(context.root, true, false)

            waitForLasers(VAULT_ROUTE[14], VAULT_ROUTE[15])

        end



        stage("Vault route " .. i .. " / 17")

        local health = context.humanoid.Health

        footMove(VAULT_ROUTE[i], 55, false, i == 14)



        if i == 15 and context.humanoid.Health < health then

            error("Damage detected on exit laser crossing.", 0)

        end

        if i >= 3 and i <= 8 then

            setStatus("Collecting: holding E for 1 second...")

            waitChecked(0.15)

            holdE(1)

            waitChecked(0.1)

        end

    end



    beginMotion(context.root, true, true)

    for i, target in ipairs(EXIT_ROUTE) do

        stage("Casino exit " .. i .. " / 10")

        moveTo(target, 100)

    end

    endMotion()

end



local function waitForAttachment(wanted, car)

    local started = os.clock()

    repeat

        waitChecked(0.1)

        local attached = attachedVehicle()

        if wanted then

            if attached and attached == car then return true end

        elseif not attached and not context.humanoid.Sit then

            return true

        end

    until os.clock() - started >= 5

    return false

end



local function flyVehicle(car, target)

    if attachedVehicle() ~= car then error("Not attached to selected vehicle.", 0) end

    local origin = car.Position



    if (origin - target).Magnitude > 3 then

        local height = math.max(origin.Y, target.Y) + 300

        beginMotion(car, false, false)

        setStatus("Vehicle: climbing...")

        moveTo(V(origin.X, height, origin.Z), 120)

        setStatus("Vehicle: cruising...")

        moveTo(V(target.X, height, target.Z), 280)

        setStatus("Vehicle: descending...")

        moveTo(target, 90)

        endMotion()

    end

    waitChecked(0.4)

end



local function leaveVehicle(car)

    holdE(0.15)

    if not waitForAttachment(false) then error("Could not exit vehicle.", 0) end

    waitChecked(0.35)

    if not car:IsDescendantOf(workspace) then error("Vehicle disappeared.", 0) end

    return car.CFrame:PointToObjectSpace(context.root.Position)

end



local function findParkedCar()

    local vehicles = workspace:FindFirstChild("Vehicles")

    if not vehicles then error("Vehicles folder missing.", 0) end



    local selected, best = nil, 40

    for _, part in ipairs(vehicles:GetDescendants()) do

        if part:IsA("BasePart") and part.Name == "Engine" then

            local root = part.AssemblyRootPart or part

            if root:IsDescendantOf(vehicles) then

                local d = (root.Position - CASINO_PARK).Magnitude

                if d < best then selected, best = root, d end

            end

        end

    end



    if not selected then error("No vehicle near casino parking.", 0) end

    log("Recovery selected nearest vehicle at casino parking")

    return selected

end



local function boardAtCasino(car)

    stage("Entering casino vehicle")

    if not car:IsDescendantOf(workspace) then error("Parked vehicle disappeared.", 0) end



    local delta = context.root.Position - car.Position

    local horizontal = V(delta.X, 0, delta.Z)

    if horizontal.Magnitude < 0.1 then horizontal = V(1, 0, 0) end



    footMove(car.Position + horizontal.Unit * 5 + V(0, 3, 0), 100, true, false)

    waitChecked(0.4)

    holdE(0.15)

    if not waitForAttachment(true, car) then

        error("Casino vehicle entry not confirmed.", 0)

    end

end



local function enterAndReachSecurity()

    beginMotion(context.root, true, true)

    for i = #EXIT_ROUTE, 6, -1 do

        stage("Casino outside approach " .. i)

        moveTo(EXIT_ROUTE[i], 100)

    end

    endMotion()



    stage("Outside keypad approach")

    footMove(KEYPAD_POINT, 55, false, false)

    waitChecked(0.3)

    enterCode()



    stage("Entering casino interior")

    beginMotion(context.root, true, false)

    moveTo(EXIT_ROUTE[5], 100)

    moveTo(EXIT_ROUTE[4], 100)



    stage("Ascending through shaft")

    beginMotion(context.root, true, true)

    moveTo(EXIT_ROUTE[3], 100)

    moveTo(SECURITY_ROUTE[3], 100)

    moveTo(SECURITY_ROUTE[2], 100)

    moveTo(SECURITY_APPROACH[1], 65)

    endMotion()



    beginMotion(context.root, true, false)

    for i, target in ipairs(SECURITY_APPROACH) do

        stage("Security wall bypass " .. i .. " / 5")

        setStatus("Following recorded bypass. Noclip OFF.")

        moveTo(target, 65)

    end



    moveTo(PC_ROUTE[1], 65)

    endMotion()

end



local function deliver(car)

    stage("Leaving vehicle at volcano")

    local returnOffset = leaveVehicle(car)

    beginMotion(context.root, true, true)



    for i, target in ipairs(DELIVERY_ROUTE) do

        stage("Volcano route " .. (i + 2))

        moveTo(target, 100)

        if i == 5 then

            setStatus("Delivery position: waiting 3 seconds...")

            waitChecked(3)

        end

    end



    if not car:IsDescendantOf(workspace) then

        error("Vehicle disappeared before return.", 0)

    end



    stage("Returning to vehicle")

    moveTo(car.CFrame:PointToWorldSpace(returnOffset), 100)

    endMotion()

    waitChecked(0.3)

    holdE(0.15)



    if not waitForAttachment(true, car) then

        error("Delivery route finished; vehicle entry not confirmed.", 0)

    end

end



local function recoveryPC()

    local index, best = nil, 14

    for i, position in ipairs(PC_ROUTE) do

        local distance = (context.root.Position - position).Magnitude

        if distance < best then index, best = i, distance end

    end

    if not index then

        error("Stand beside the Security PC you already solved.", 0)

    end



    local display = findDisplay(context.root.Position)

    if not securitySolvedColor(display.Color) then

        error("Nearby screen has no recognized solved color. Recovery cancelled.", 0)

    end



    log("USER RECOVERY: continue after Security from PC " .. index)

    log("Solved screen color observed; prior red-PC completion is user-confirmed")

    return index

end



local function startRun(recovery)

    if busy or destroyed then return end



    local character = player.Character

    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    local root = character and character:FindFirstChild("HumanoidRootPart")



    if not root or not humanoid or humanoid.Health <= 0 then

        setStatus("Character not ready.")

        return

    end

    if UIS:GetFocusedTextBox() then

        setStatus("Close chat first.")

        return

    end



    context = {character = character, humanoid = humanoid, root = root}

    local car



    if recovery then

        if humanoid.Sit then

            setStatus("Stand beside the solved Security computer.")

            context = nil

            return

        end

    else

        car = attachedVehicle()

        if not car then

            setStatus("Sit in the driver's seat before Start from car.")

            context = nil

            return

        end

    end



    busy = true

    stopReason = nil

    records = {}

    runStarted = os.clock()

    startButton.Text = "Running..."

    log(recovery and "MODE: continue after Security" or "MODE: full cycle")



    task.spawn(function()

        local ok, err = pcall(function()

            local lastPC



            if recovery then

                stage("Checking recovery position")

                lastPC = recoveryPC()

            else

                stage("Flying to casino")

                flyVehicle(car, CASINO_PARK)

                stage("Leaving vehicle at casino")

                leaveVehicle(car)

                enterAndReachSecurity()

                lastPC = runSecurity()

            end



            returnFromSecurity(lastPC)

            securityToVault()

            vaultAndExit()



            if not car then car = findParkedCar() end

            boardAtCasino(car)



            stage("Flying to volcano")

            flyVehicle(car, VOLCANO_PARK)

            deliver(car)

        end)



        releaseInputs()

        disconnectTemporary()

        endMotion()



        if ok then

            log("FINISHED: payout not automatically verified")

            if not destroyed then

                stageLabel.Text = "Finished"

                setStatus("Returned to vehicle.\nCheck your money and bag.")

            end

        else

            local message = tostring(err)

            log("FINAL STOP | " .. stageName .. " | " .. message)

            if not destroyed then

                stageLabel.Text = stopReason and "Stopped" or "Error"

                setStatus(stageName .. "\n" .. message)

            end

        end



        busy = false

        context = nil

        if not destroyed then startButton.Text = "Start from car" end

    end)

end



connections[#connections + 1] = startButton.Activated:Connect(function()

    startRun(false)

end)



connections[#connections + 1] = resumeButton.Activated:Connect(function()

    startRun(true)

end)



connections[#connections + 1] = stopButton.Activated:Connect(function()

    requestStop("Stop button activated")

end)



connections[#connections + 1] = copyButton.Activated:Connect(function()

    local report = table.concat(records, "\n")

    if report == "" then report = _G.__CasinoLastReport or "No report." end



    local ok = pcall(function() setclipboard(report) end)

    if not ok and not busy then

        logBox.TextEditable = true

        logBox.Text = report

        logBox:CaptureFocus()

        logBox.SelectionStart = 1

        logBox.CursorPosition = #logBox.Text + 1

    end

end)



connections[#connections + 1] = UIS.WindowFocusReleased:Connect(function()

    requestStop("Roblox window lost focus")

end)



local function cleanup()

    if destroyed then return end

    requestStop("Script replaced or closed")

    destroyed = true

    releaseInputs()

    disconnectTemporary()

    endMotion()



    for _, connection in ipairs(connections) do

        connection:Disconnect()

    end



    if _G[KEY] == cleanup then _G[KEY] = nil end

    gui:Destroy()

end



_G[KEY] = cleanup

connections[#connections + 1] = gui.Destroying:Connect(cleanup)
gui.Enabled=false
return {Start=function() startRun(false) end, Stop=function() requestStop('Stopped from main menu') end, Busy=function() return busy end, Destroy=cleanup, Log=function() return table.concat(records,'\n') end, Status=function() return status.Text end}
]====]
HUB_SOURCES['Jewelry'] = [====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local KEY = "__JewelryCycle"
local CAMERA_BIND = "JewelryCycleCamera"
for _,name in ipairs({
    KEY,
    "__OilFullCycle",
    "__CasinoFullCycle",
    "__OilDeliveryTest",
    "__OilNextRouteTest",
    "__OilCardRouteTest",
    "__OilSecondGuardTest",
    "__OilLeverRouteTest",
    "__OilFixedFireTest",
}) do
    if type(_G[name]) == "function" then
        pcall(_G[name])
    end
end
local V = Vector3.new
local function points(rows)
    local result = {}
    for i,row in ipairs(rows) do
        result[i] = V(row[1],row[2],row[3])
    end
    return result
end
local PARK = V(85.87,18.03,1412.87)
local ROUTE = points({
    {85.24,23.50,1415.35},
    {140.33,21.53,1359.75},
    {143.49,18.01,1347.28},
    {142.47,18.50,1339.18},
    {142.47,25.17,1339.16},
    {140.35,21.23,1318.15},
    {146.11,18.19,1316.74},
    {146.86,18.17,1321.33},
    {145.01,18.17,1309.81},
    {134.65,18.31,1319.93},
    {128.05,18.31,1320.79},
    {126.34,16.38,1312.62},
    {131.24,16.38,1311.67},
    {131.24,29.71,1311.67},
    {102.30,23.78,1287.27},
    {99.93,23.10,1284.94},
    {99.93,36.43,1284.94},
    {99.91,113.10,1284.95},
    {100.09,113.10,1284.97},
    {158.40,114.51,1332.32},
    {158.43,172.85,1332.36},
    {-90.44,94.41,1473.27},
    {-284.33,37.14,1582.79},
})
local RETURN_ROUTE = points({
    {-286.67,36.95,1583.57},
    {-286.67,58.62,1583.57},
    {-49.14,104.18,1442.52},
    {-35.76,73.09,1388.99},
    {106.00,23.91,1409.16},
})
local FOOT_SPEED = 100
 
local gui = Instance.new("ScreenGui")
gui.Name = "JewelryCycle"
gui.ResetOnSpawn = false
gui.DisplayOrder = 300
gui.Parent = playerGui
local panel = Instance.new("Frame")
panel.Position = UDim2.fromOffset(20,120)
panel.Size = UDim2.fromOffset(390,245)
panel.BackgroundColor3 = Color3.fromRGB(25,28,35)
panel.BorderSizePixel = 0
panel.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,9)
corner.Parent = panel
local function label(text,y,height,size)
    local object = Instance.new("TextLabel")
    object.Position = UDim2.fromOffset(10,y)
    object.Size = UDim2.fromOffset(370,height)
    object.BackgroundTransparency = 1
    object.TextColor3 = Color3.new(1,1,1)
    object.Font = Enum.Font.Gotham
    object.TextSize = size or 13
    object.TextWrapped = true
    object.Text = text
    object.Parent = panel
    return object
end
label("Jewelry - Return Car",8,26,18)
local stageLabel = label("Ready",39,25)
local status = label(
    "Sit in your car, then press Start.",
    67,40
)
local function button(text,x,color)
    local object = Instance.new("TextButton")
    object.Position = UDim2.fromOffset(x,115)
    object.Size = UDim2.fromOffset(116,34)
    object.BackgroundColor3 = color
    object.TextColor3 = Color3.new(1,1,1)
    object.Font = Enum.Font.GothamBold
    object.TextSize = 13
    object.Text = text
    object.Parent = panel
    return object
end
local startButton = button("Start",10,Color3.fromRGB(40,140,85))
local stopButton = button("Stop",137,Color3.fromRGB(160,55,60))
local copyButton = button("Copy report",264,Color3.fromRGB(50,95,145))
local output = Instance.new("TextBox")
output.Position = UDim2.fromOffset(10,160)
output.Size = UDim2.fromOffset(370,75)
output.BackgroundColor3 = Color3.fromRGB(15,18,24)
output.TextColor3 = Color3.new(1,1,1)
output.Font = Enum.Font.Code
output.TextSize = 11
output.TextWrapped = true
output.MultiLine = true
output.ClearTextOnFocus = false
output.TextEditable = false
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Text = ""
output.Parent = panel
local busy,destroyed = false,false
local stopReason,context,motion,savedCamera
local stageName = "Ready"
local records,connections,temporary = {},{},{}
local started = os.clock()
local heldKeys = {}
local mouseDown = false
local mouseX,mouseY = 0,0
local bagLabel
local function log(text)
    records[#records+1] = string.format(
        "%.2fs | %s",os.clock()-started,text
    )
    _G.__JewelryReport = table.concat(records,"\n")
    if not destroyed then
        local recent = {}
        for i=math.max(1,#records-3),#records do
            recent[#recent+1] = records[i]
        end
        output.Text = table.concat(recent,"\n")
    end
end
local function setStatus(text)
    if not destroyed then status.Text = text end
end
local function stage(text)
    stageName = text
    log("STAGE: "..text)
    if not destroyed then stageLabel.Text = text end
    setStatus("Running automatically...")
end
local function watch(connection)
    temporary[connection] = true
    return connection
end
local function unwatch(connection)
    if connection then
        connection:Disconnect()
        temporary[connection] = nil
    end
end
local function releaseInputs()
    for key in pairs(heldKeys) do
        pcall(function()
            VIM:SendKeyEvent(false,key,false,game)
        end)
    end
    heldKeys = {}
    if mouseDown then
        pcall(function()
            VIM:SendMouseButtonEvent(mouseX,mouseY,0,false,game,0)
        end)
        mouseDown = false
    end
end
local function restoreCamera()
    RunService:UnbindFromRenderStep(CAMERA_BIND)
    if savedCamera then
        local saved = savedCamera
        savedCamera = nil
        pcall(function()
            saved.camera.CFrame = saved.cf
            saved.camera.Focus = saved.focus
            saved.camera.FieldOfView = saved.fov
            saved.camera.CameraSubject = saved.subject
            saved.camera.CameraType = saved.kind
        end)
    end
end
local function endMotion()
    local saved = motion
    motion = nil
    if not saved then return end
    if saved.physics then saved.physics:Disconnect() end
    if saved.added then saved.added:Disconnect() end
    saved.velocity:Destroy()
    saved.orientation:Destroy()
    saved.attachment:Destroy()
    if saved.root.Parent then
        saved.root.AssemblyLinearVelocity = Vector3.zero
        saved.root.AssemblyAngularVelocity = Vector3.zero
    end
    if saved.foot then
        for part,original in pairs(saved.collisions) do
            if part.Parent then
                pcall(function() part.CanCollide = original end)
            end
        end
        if saved.humanoid.Parent then
            saved.humanoid.PlatformStand = saved.platform
            saved.humanoid.AutoRotate = saved.rotate
            saved.humanoid:SetStateEnabled(
                Enum.HumanoidStateType.Seated,saved.seated
            )
        end
    end
end
local function restoreAll()
    releaseInputs()
    restoreCamera()
    for connection in pairs(temporary) do
        connection:Disconnect()
    end
    temporary = {}
    endMotion()
end
local function stop(reason)
    if not busy or stopReason then return end
    stopReason = reason
    log("STOP: "..reason)
    restoreAll()
    setStatus(reason)
end
local function check()
    if destroyed then error("Script closed.",0) end
    if stopReason then error(stopReason,0) end
    if not context
        or player.Character ~= context.character
        or not context.root.Parent
        or context.humanoid.Health <= 0 then
        error("Character changed or died.",0)
    end
    if UIS:GetFocusedTextBox() then
        error("Close chat or text input.",0)
    end
end
local function holdPosition(target)
    if not motion then error("Flight controller missing.",0) end
    local delta = target-motion.root.Position
    if delta.Magnitude > 5 then
        error("Moved away from interaction or firing point.",0)
    end
    local correction = delta*8
    if correction.Magnitude > 12 then
        correction = correction.Unit*12
    end
    motion.velocity.VectorVelocity = correction
end
local function waitChecked(seconds,target,done)
    local t = os.clock()
    repeat
        RunService.Heartbeat:Wait()
        check()
        if target then holdPosition(target) end
        if done and done() then return true end
    until os.clock()-t >= seconds
    return false
end
local function keyPress(key,seconds,target,done)
    check()
    heldKeys[key] = true
    VIM:SendKeyEvent(true,key,false,game)
    local completed = waitChecked(seconds,target,done)
    VIM:SendKeyEvent(false,key,false,game)
    heldKeys[key] = nil
    return completed
end
local function tapE()
    keyPress(Enum.KeyCode.E,0.15)
end
local function rig()
    return workspace:FindFirstChild("OilRig")
        or workspace:FindFirstChild("OilRig",true)
end
local function visible(object)
    local current = object
    while current and current ~= playerGui do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        end
        if current:IsA("LayerCollector") and not current.Enabled then
            return false
        end
        current = current.Parent
    end
    return current == playerGui
end
 
local function attachedVehicle()
    if not context then return nil end
    local root = context.root.AssemblyRootPart
    local vehicles = workspace:FindFirstChild("Vehicles")
    if root and vehicles
        and not root:IsDescendantOf(context.character)
        and root:IsDescendantOf(vehicles) then
        return root
    end
end
local function vehicleModel(car)
    local vehicles = workspace:FindFirstChild("Vehicles")
    if not vehicles or not car or not car:IsDescendantOf(vehicles) then
        error("Vehicle disappeared.",0)
    end
    local model = car
    while model.Parent and model.Parent ~= vehicles do
        model = model.Parent
    end
    return model
end
local function seatParts(car)
    local model = vehicleModel(car)
    local driver = model:FindFirstChild("Seat")
    if not driver or not driver:IsA("BasePart") then
        error("Supported driver Seat part not found.",0)
    end
    local passengers = {}
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart")
            and part.Name:lower():find("passenger",1,true) then
            passengers[#passengers+1] = part
        end
    end
    if #passengers == 0 then
        error("Passenger seat reference not found.",0)
    end
    return driver,passengers
end
local function driverState(car)
    if attachedVehicle() ~= car or not context.humanoid.Sit then
        return false,"Not seated in selected vehicle"
    end
    local driver,passengers = seatParts(car)
    local d = (context.root.Position-driver.Position).Magnitude
    local p = math.huge
    for _,part in ipairs(passengers) do
        p = math.min(p,(context.root.Position-part.Position).Magnitude)
    end
    return d <= 2.75 and d+0.25 < p,
        string.format("Seat %.2f | Passenger %.2f",d,p)
end
 
local function beginMotion(root,foot,noclip,rotation)
    if motion and motion.root == root
        and motion.foot == foot and motion.noclip == noclip then
        if rotation then motion.orientation.CFrame = rotation end
        return
    end
    endMotion()
    local attachment = Instance.new("Attachment")
    attachment.Parent = root
    local velocity = Instance.new("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.ForceLimitsEnabled = false
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = root
    local orientation = Instance.new("AlignOrientation")
    orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    orientation.Attachment0 = attachment
    orientation.RigidityEnabled = true
    orientation.CFrame = rotation or root.CFrame.Rotation
    orientation.Parent = root
    local saved = {
        root=root,foot=foot,noclip=noclip,
        humanoid=context.humanoid,
        attachment=attachment,velocity=velocity,
        orientation=orientation,collisions={},
    }
    motion = saved
    if foot then
        local h = context.humanoid
        saved.platform = h.PlatformStand
        saved.rotate = h.AutoRotate
        saved.seated = h:GetStateEnabled(Enum.HumanoidStateType.Seated)
        if noclip then
            local function track(part)
                if not part:IsA("BasePart") then return end
                if saved.collisions[part] == nil then
                    saved.collisions[part] = part.CanCollide
                end
                part.CanCollide = false
            end
            for _,part in ipairs(context.character:GetDescendants()) do
                track(part)
            end
            saved.added = context.character.DescendantAdded:Connect(track)
            saved.physics = RunService.Stepped:Connect(function()
                if motion ~= saved then return end
                for part in pairs(saved.collisions) do
                    if part:IsDescendantOf(context.character) then
                        part.CanCollide = false
                    end
                end
            end)
        end
        h.PlatformStand = true
        h.AutoRotate = false
        h:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
    end
end
local function halt()
    if motion then
        motion.velocity.VectorVelocity = Vector3.zero
        motion.root.AssemblyLinearVelocity = Vector3.zero
    end
end
local function steerFoot(target,speed,dt)
    local delta = target-context.root.Position
    local distance = delta.Magnitude
    if distance > 0.03 then
        motion.velocity.VectorVelocity = delta.Unit*math.min(
            speed,distance*10,distance/math.max(dt,1/240)
        )
    else
        motion.velocity.VectorVelocity = Vector3.zero
    end
    return distance
end
local function moveFootConstant(target,speed)
    local root = context.root
    local best = (target-root.Position).Magnitude
    local progress = os.clock()
    local startedMove = os.clock()
    while true do
        local dt = RunService.Heartbeat:Wait()
        check()
        local delta = target-root.Position
        local distance = delta.Magnitude
         
        if distance <= math.max(0.15,speed*math.min(dt,0.05)) then
            root.CFrame = CFrame.new(target)*root.CFrame.Rotation
            halt()
            return
        end
        if distance < best-0.4 then
            best,progress = distance,os.clock()
        end
        if os.clock()-progress > 7 or os.clock()-startedMove > 60 then
            error("Movement blocked: "..stageName,0)
        end
        context.humanoid.PlatformStand = true
        context.humanoid.AutoRotate = false
        motion.velocity.VectorVelocity = delta.Unit*speed
    end
end
local function moveTo(target,speed)
    if motion and motion.foot then return moveFootConstant(target,speed) end
    local saved = motion
    if not saved then error("Movement controller missing.",0) end
    local elapsed,stalled,settled = 0,0,0
    local best = (target-saved.root.Position).Magnitude
    local commanded = Vector3.zero
    while true do
        local dt = RunService.Heartbeat:Wait()
        check()
        if not saved.root:IsDescendantOf(workspace) then
            error("Movement root disappeared.",0)
        end
        if not saved.foot and attachedVehicle() ~= saved.root then
            error("Character detached from vehicle.",0)
        end
        local delta = target-saved.root.Position
        local distance = delta.Magnitude
        if saved.foot and distance <= 0.5 then
            halt()
            return
        end
        if not saved.foot and distance <= 1.5
            and saved.root.AssemblyLinearVelocity.Magnitude <= 4 then
            settled = settled+dt
            if settled >= 0.15 then
                halt()
                return
            end
        else
            settled = 0
        end
        elapsed = elapsed+dt
        if distance < best-0.4 then
            best,stalled = distance,0
        else
            stalled = stalled+dt
        end
        if stalled >= (saved.foot and 7 or 10) then
            error(string.format(
                "Movement blocked at %s. Distance %.2f",
                stageName,distance
            ),0)
        end
        if elapsed >= 60 then
            error("Movement timeout at "..stageName,0)
        end
        local wanted = Vector3.zero
        if distance > 0.01 then
            if saved.foot then
                wanted = delta.Unit*math.min(
                    speed,distance*10,distance/math.max(dt,1/240)
                )
            else
                wanted = delta.Unit*math.min(
                    speed,
                    math.sqrt(360*math.max(0,distance-0.4)),
                    distance*2.5
                )
            end
        end
        if saved.foot then
            commanded = wanted
        else
            local change = wanted-commanded
            local limit = 140*math.min(dt,0.1)
            if change.Magnitude > limit then change = change.Unit*limit end
            commanded = commanded+change
        end
        saved.velocity.VectorVelocity = commanded
    end
end
local function footRoute(route,speed,noclip,name)
    beginMotion(context.root,true,noclip)
    for i,target in ipairs(route) do
        stage(name.." "..i.." / "..#route)
        moveTo(target,speed)
    end
end
local function waitOutside()
    local t = os.clock()
    repeat
        waitChecked(0.1)
        if not attachedVehicle() and not context.humanoid.Sit then
            return true
        end
    until os.clock()-t >= 5
    return false
end
local function leaveVehicle(car)
    if attachedVehicle() ~= car then
        error("Not attached to selected vehicle before exit.",0)
    end
    tapE()
    if not waitOutside() then error("Could not exit vehicle.",0) end
    waitChecked(0.35)
end
local function boardDriver(car)
    seatParts(car)
    local attached = attachedVehicle()
    if attached == car then
        local correct,detail = driverState(car)
        if correct then
            log("DRIVER POSITION CONFIRMED: "..detail)
            return
        end
        leaveVehicle(car)
    elseif attached or context.humanoid.Sit then
        error("Unexpected seat or vehicle attachment.",0)
    end
    for attempt=1,3 do
        stage("Driver seat entry "..attempt.." / 3")
        local driver = seatParts(car)
        local localSeat = car.CFrame:PointToObjectSpace(driver.Position)
        if math.abs(localSeat.X) < 0.3 then
            error("Driver seat side is ambiguous.",0)
        end
        local offsets = {3,2.3,3.5}
        local side = localSeat.X < 0 and -1 or 1
        local target = car.CFrame:PointToWorldSpace(
            localSeat+V(side*offsets[attempt],0,0)
        )+V(0,3,0)
        beginMotion(context.root,true,true)
        moveTo(target,65)
        endMotion()
        waitChecked(0.4)
        local currentDriver,passengers = seatParts(car)
        local d = (context.root.Position-currentDriver.Position).Magnitude
        for _,passenger in ipairs(passengers) do
            if (context.root.Position-passenger.Position).Magnitude <= d then
                error("Driver-side approach not confirmed.",0)
            end
        end
        tapE()
        local t,stableSince = os.clock(),nil
        while os.clock()-t < 5 do
            waitChecked(0.1)
            local good,detail = driverState(car)
            if good then
                stableSince = stableSince or os.clock()
                if os.clock()-stableSince >= 0.3 then
                    log("DRIVER POSITION CONFIRMED: "..detail)
                    return
                end
            else
                stableSince = nil
            end
        end
        local current = attachedVehicle()
        if current == car then
            log("Wrong or unverified seat; exiting")
            leaveVehicle(car)
        elseif current or context.humanoid.Sit then
            error("Unexpected attachment during boarding.",0)
        end
    end
    error("Driver seat not confirmed after 3 attempts.",0)
end
local function flyVehicle(car,target)
    local good,detail = driverState(car)
    if not good then error("Driver check failed: "..detail,0) end
    local origin = car.Position
    if (origin-target).Magnitude > 3 then
        local height = math.max(origin.Y,target.Y)+300
        beginMotion(car,false,false)
        setStatus("Vehicle: climbing...")
        moveTo(V(origin.X,height,origin.Z),120)
        setStatus("Vehicle: cruising...")
        moveTo(V(target.X,height,target.Z),280)
        setStatus("Vehicle: descending...")
        moveTo(target,90)
        endMotion()
    end
    waitChecked(0.4)
end

 
local function parseAmount(o)
    if not (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox"))
        or o:IsDescendantOf(gui) or not visible(o)
        or o.TextTransparency >= 1 then return nil end
    local text = o.Text:gsub("<[^>]->", ""):gsub("%$", "")
        :gsub(",", ""):gsub("%s+", "")
    local current,capacity = text:match("^(%d+)/(%d+)$")
    current,capacity = tonumber(current),tonumber(capacity)
    if current and capacity and capacity >= 1000
        and current >= 0 and current <= capacity then
        return current,capacity
    end
end
local function readAmount()
    if bagLabel and bagLabel:IsDescendantOf(playerGui) then
        local value,capacity = parseAmount(bagLabel)
        if value ~= nil then return value,capacity end
    end
    bagLabel = nil
    local selected,value,limit
    local robbery = playerGui:FindFirstChild("RobberyMoneyGui")
    local searchRoot = robbery or playerGui
    for _,o in ipairs(searchRoot:GetDescendants()) do
        local amount,capacity = parseAmount(o)
        if amount ~= nil then
            if selected and (amount ~= value or capacity ~= limit) then
                error("Multiple different money counters found.",0)
            end
            selected,value,limit = o,amount,capacity
        end
    end
    if selected then
        bagLabel = selected
        log("Bag counter: "..selected:GetFullName())
    end
    return value,limit
end
 
local function faceNearestGlass()
    local jewelrys = workspace:FindFirstChild("Jewelrys")
        or workspace:FindFirstChild("Jewelrys",true)
    if not jewelrys then error("Jewelrys not loaded.",0) end
    local position = context.root.Position
    local selected,best = nil,math.huge
    for _,boxes in ipairs(jewelrys:GetDescendants()) do
        if boxes.Name == "Boxes" then
            for _,part in ipairs(boxes:GetChildren()) do
                if part:IsA("BasePart") and part.Name == "Part"
                    and part.Transparency < 0.95 then
                    local delta = part.Position-position
                    local flat = Vector3.new(delta.X,0,delta.Z)
                    if flat.Magnitude <= 9 and math.abs(delta.Y) <= 6 then
                        local localPoint = part.CFrame:PointToObjectSpace(position)
                        local half = part.Size*0.5
                        local nearest = part.CFrame:PointToWorldSpace(Vector3.new(
                            math.clamp(localPoint.X,-half.X,half.X),
                            math.clamp(localPoint.Y,-half.Y,half.Y),
                            math.clamp(localPoint.Z,-half.Z,half.Z)
                        ))
                        local score = (nearest-position).Magnitude+flat.Magnitude*0.1
                        if score < best then selected,best = part,score end
                    end
                end
            end
        end
    end
    if not selected then error("No nearby glass found in Jewelry.Boxes.",0) end
    local delta = selected.Position-position
    local flat = Vector3.new(delta.X,0,delta.Z)
    if flat.Magnitude < 0.05 then
        error("Standing at glass center; facing direction is ambiguous.",0)
    end
    local rotation = CFrame.lookAt(Vector3.zero,flat.Unit).Rotation
    motion.orientation.CFrame = rotation
    context.humanoid.AutoRotate = false
    context.root.CFrame = CFrame.new(position)*rotation
    log(string.format("FACE GLASS: %.2f, %.2f, %.2f | look %.3f, %.3f",
        selected.Position.X,selected.Position.Y,selected.Position.Z,
        flat.Unit.X,flat.Unit.Z))
    return rotation
end
local function collectAt(position,index)
    local baseline,capacity = readAmount()
    if baseline ~= nil and capacity ~= nil and baseline >= capacity then
        releaseInputs()
        log("BAG FULL: "..baseline.." / "..capacity.."; skipping F at point "..index)
        return
    end
    stage("Cash point "..index..": face glass and press F")
    local rotation = faceNearestGlass()
    waitChecked(0.12,position)
    if baseline == nil then
        baseline,capacity = readAmount()
    end
    if baseline == nil then
        log("Bag not visible yet; waiting for first positive amount")
    else
        log("Amount before F: "..baseline.." / "..capacity)
    end
    local current = baseline
    local lastRead = -math.huge
    local full = false
    local function collectedOrFull()
        if os.clock()-lastRead >= 0.1 then
            lastRead = os.clock()
            current,capacity = readAmount()
        end
        if current == nil then return false end
        full = capacity ~= nil and current >= capacity
        if full then return true end
        if baseline ~= nil and current < baseline then
            error("Bag amount decreased during collection.",0)
        end
        return current > (baseline or 0)
    end
    local startedCash = os.clock()
    while not collectedOrFull() do
        check()
        if os.clock()-startedCash > 30 then
            error("No bag increase at point "..index.." after 30 seconds.",0)
        end
        motion.orientation.CFrame = rotation
        context.humanoid.AutoRotate = false
        keyPress(Enum.KeyCode.F,0.08,position,collectedOrFull)
        waitChecked(0.22,position,collectedOrFull)
    end
    releaseInputs()
    if full then
        log("BAG FULL: "..current.." / "..capacity.."; F released; continuing route")
    else
        log("CASH POINT "..index..": amount increased to "..current)
    end
end
local function run(car)
    stage("Checking driver seat")
    boardDriver(car)
    stage("Flying to jewelry parking")
    flyVehicle(car,PARK)
    stage("Leaving vehicle")
    leaveVehicle(car)
    beginMotion(context.root,true,true)
    log("Noclip ON; foot speed 100; no approach slowdown")
    for i,position in ipairs(ROUTE) do
        local index = i+1
        stage("Point "..index.." / 24")
        moveTo(position,FOOT_SPEED)
        if index >= 8 and index <= 14 then
            collectAt(position,index)
        elseif index == 20 then
            stage("Point 20: hold E for 2 seconds")
            local beforeTeleport = context.root.Position
            halt()
             
            keyPress(Enum.KeyCode.E,2)
            log(string.format("E held for 2 seconds; displacement %.2f; continuing to point 21",
                (context.root.Position-beforeTeleport).Magnitude))
        end
    end
    stage("Delivery: point 24")
    endMotion()
    waitChecked(3)
    log("Delivery point reached; payout not automatically verified")
    beginMotion(context.root,true,true)
    for i,position in ipairs(RETURN_ROUTE) do
        stage("Return point "..(i+4).." / 9")
        moveTo(position,FOOT_SPEED)
    end
    endMotion()
    if not car:IsDescendantOf(workspace) then
        error("Original vehicle disappeared before return.",0)
    end
    stage("Return point 9: press E to enter vehicle")
    tapE()
    local startedBoarding = os.clock()
    local stableSince
    local seated = false
    while os.clock()-startedBoarding < 4 do
        waitChecked(0.1)
        local attached = attachedVehicle()
        if attached and attached ~= car then
            error("Entered a different vehicle; original vehicle required.",0)
        end
        local good,detail = driverState(car)
        if good then
            stableSince = stableSince or os.clock()
            if os.clock()-stableSince >= 0.3 then
                log("DRIVER POSITION CONFIRMED: "..detail)
                seated = true
                break
            end
        else
            stableSince = nil
        end
    end
    if not seated then
        log("Point 9 E did not confirm driver seat; using driver-side approach")
        boardDriver(car)
    end
    log("FINISHED: returned to original vehicle driver seat; payout not automatically verified")
end
local function start()
    if busy or destroyed then return end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then
        setStatus("Character not ready.")
        return
    end
    if UIS:GetFocusedTextBox() then
        setStatus("Close chat or text input first.")
        return
    end
    context = {character=character,root=root,humanoid=humanoid}
    local car = attachedVehicle()
    if not car then
        context = nil
        setStatus("Sit in your car before pressing Start.")
        return
    end
    busy = true
    stopReason = nil
    bagLabel = nil
    records = {}
    started = os.clock()
    startButton.Text = "Running..."
    output.TextEditable = false
    log("VERSION: Jewelry Return Car v5")
    log("Actual bag capacity; face glass at 8-14; E at 20")
    task.spawn(function()
        local ok,err = pcall(function() run(car) end)
        restoreAll()
        busy = false
        context = nil
        if not destroyed then
            startButton.Text = "Start"
            if ok then
                stageLabel.Text = "Finished"
                setStatus("Returned to driver seat. Check payout in game.")
            else
                stageLabel.Text = stopReason and "Stopped" or "Error"
                setStatus(tostring(err))
            end
        end
        if not ok then log("FINAL STOP | "..stageName.." | "..tostring(err)) end
    end)
end
connections[#connections+1] = startButton.Activated:Connect(start)
connections[#connections+1] = stopButton.Activated:Connect(function()
    stop("Stop button activated")
end)
connections[#connections+1] = copyButton.Activated:Connect(function()
    local report = table.concat(records,"\n")
    if report == "" then report = "No run recorded." end
    local ok = pcall(function() setclipboard(report) end)
    if not ok and not busy then
        output.TextEditable = true
        output.Text = report
        output:CaptureFocus()
        output.SelectionStart = 1
        output.CursorPosition = #output.Text+1
    end
end)
connections[#connections+1] = UIS.WindowFocusReleased:Connect(function()
    stop("Roblox window lost focus")
end)
local function cleanup()
    if destroyed then return end
    stop("Script replaced or closed")
    destroyed = true
    restoreAll()
    for _,connection in ipairs(connections) do connection:Disconnect() end
    if _G[KEY] == cleanup then _G[KEY] = nil end
    gui:Destroy()
end
_G[KEY] = cleanup
connections[#connections+1] = gui.Destroying:Connect(cleanup)

gui.Enabled=false
return {Start=start, Stop=function() stop('Stopped from main menu') end, Busy=function() return busy end, Destroy=cleanup, Log=function() return table.concat(records,'\n') end, Status=function() return status.Text end}
]====]
HUB_SOURCES['Oil Rig'] = [====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local KEY = "__OilFullCycle"
local CAMERA_BIND = "OilFullCycleCamera"
for _,name in ipairs({
    KEY,
    "__CasinoFullCycle",
    "__OilDeliveryTest",
    "__OilNextRouteTest",
    "__OilCardRouteTest",
    "__OilSecondGuardTest",
    "__OilLeverRouteTest",
    "__OilFixedFireTest",
}) do
    if type(_G[name]) == "function" then
        pcall(_G[name])
    end
end
local V = Vector3.new
local function points(rows)
    local result = {}
    for i,row in ipairs(rows) do
        result[i] = V(row[1],row[2],row[3])
    end
    return result
end
local OIL_PARK = V(-1018.65,35.32,-3217.25)
local DELIVERY_PARK = V(1684.75,36.46,-1098.68)
local ENTRY = points({
    {-1016.82,46.30,-3217.10},
    {-1063.29,34.62,-3401.23},
    {-1063.42,18.37,-3401.44},
    {-1157.42,17.63,-4210.36},
    {-1157.46,109.30,-4210.51},
    {-1161.50,119.25,-4214.82},
    {-1161.51,153.00,-4214.64},
    {-1182.68,150.66,-4201.57},
    {-1261.20,135.10,-4223.17},
})
local FIRE1 = V(-1256.62,153.56,-4226.58)
local LEVER = points({
    {-1256.68,148.01,-4226.58},
    {-1312.45,133.84,-4161.82},
    {-1317.37,133.59,-4163.14},
    {-1317.95,133.38,-4176.40},
})
local CARD_APPROACH = points({
    {-1299.49,135.32,-4195.19},
    {-1308.85,137.93,-4204.24},
    {-1297.48,159.38,-4235.79},
    {-1305.21,170.02,-4214.70},
    {-1291.73,167.32,-4208.88},
    {-1302.45,165.75,-4179.47},
})
local CARD_POINT = V(-1326.68,163.62,-4187.27)
local ROOM = points({
    {-1309.99,165.15,-4176.66},
    {-1290.00,163.60,-4210.45},
    {-1308.36,165.67,-4213.03},
    {-1303.94,167.92,-4225.41},
    {-1299.38,153.01,-4245.43},
    {-1294.50,153.61,-4257.21},
})
local COLLECTION = points({
    {-1298.45,155.26,-4259.51},
    {-1299.21,153.27,-4242.99},
    {-1301.33,157.89,-4234.38},
    {-1304.43,138.42,-4197.35},
    {-1229.09,133.46,-4166.73},
    {-1280.46,166.68,-4140.28},
    {-1284.86,164.87,-4147.04},
    {-1287.02,164.37,-4148.67},
})
local EXIT = points({
    {-1291.22,162.50,-4136.91},
    {-1207.47,19.44,-4144.72},
    {-1098.78,15.82,-4027.94},
    {-1123.53,18.42,-3302.23},
    {-1025.49,38.26,-3219.43},
})
local DELIVERY = points({
    {1686.76,42.06,-1097.36},
    {2085.20,37.85,-1216.95},
    {2358.77,40.98,-1054.58},
    {2508.46,33.30,-841.21},
    {2371.42,33.49,-569.37},
})
local COLLECTION_ROTATION = CFrame.lookAt(
    Vector3.zero,V(-0.8899,0,-0.4562).Unit
)
local CAMERA1 = {
    cf=CFrame.new(
        -1237.59912109375,161.96409606933595,-4244.9765625,
        -0.711286723613739,-0.21620196104049684,0.6688257455825806,
        0.000000014901161193847657,0.9515206813812256,0.30758482217788699,
        -0.7029019594192505,0.2187810093164444,-0.6768040060997009
    ),
    focus=CFrame.new(
        -1257.49267578125,152.81529235839845,-4224.845703125
    ),
    x=960/1920,
    y=(473-58)/1057,
}
local CAMERA2 = {
    cf=CFrame.new(
        -1310.689208984375,137.8332977294922,-4154.5107421875,
        0.9759054780006409,0.015487773343920708,-0.21764375269412995,
        0.000035385590308578688,0.9974664449691773,0.07113949209451676,
        0.2181941270828247,-0.06943312287330628,0.9734323024749756
    ),
    focus=CFrame.new(
        -1309.4639892578126,137.4324188232422,-4159.9912109375
    ),
    x=960/1920,
    y=(528.5-58)/1057,
}
local COUNTER_POSITION = V(
    -1313.808837890625,140.45001220703126,-4161.43603515625
)
 
local gui = Instance.new("ScreenGui")
gui.Name = "OilFullCycle"
gui.ResetOnSpawn = false
gui.DisplayOrder = 300
gui.Parent = playerGui
local panel = Instance.new("Frame")
panel.Position = UDim2.fromOffset(20,120)
panel.Size = UDim2.fromOffset(390,245)
panel.BackgroundColor3 = Color3.fromRGB(25,28,35)
panel.BorderSizePixel = 0
panel.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,9)
corner.Parent = panel
local function label(text,y,height,size)
    local object = Instance.new("TextLabel")
    object.Position = UDim2.fromOffset(10,y)
    object.Size = UDim2.fromOffset(370,height)
    object.BackgroundTransparency = 1
    object.TextColor3 = Color3.new(1,1,1)
    object.Font = Enum.Font.Gotham
    object.TextSize = size or 13
    object.TextWrapped = true
    object.Text = text
    object.Parent = panel
    return object
end
label("Oil Rig - Full Cycle",8,26,18)
local stageLabel = label("Ready",39,25)
local status = label(
    "Sit in your car. Keep the pistol in slot 1.",
    67,40
)
local function button(text,x,color)
    local object = Instance.new("TextButton")
    object.Position = UDim2.fromOffset(x,115)
    object.Size = UDim2.fromOffset(116,34)
    object.BackgroundColor3 = color
    object.TextColor3 = Color3.new(1,1,1)
    object.Font = Enum.Font.GothamBold
    object.TextSize = 13
    object.Text = text
    object.Parent = panel
    return object
end
local startButton = button("Start",10,Color3.fromRGB(40,140,85))
local stopButton = button("Stop",137,Color3.fromRGB(160,55,60))
local copyButton = button("Copy report",264,Color3.fromRGB(50,95,145))
local output = Instance.new("TextBox")
output.Position = UDim2.fromOffset(10,160)
output.Size = UDim2.fromOffset(370,75)
output.BackgroundColor3 = Color3.fromRGB(15,18,24)
output.TextColor3 = Color3.new(1,1,1)
output.Font = Enum.Font.Code
output.TextSize = 11
output.TextWrapped = true
output.MultiLine = true
output.ClearTextOnFocus = false
output.TextEditable = false
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Text = ""
output.Parent = panel
local busy,destroyed = false,false
local stopReason,context,motion,savedCamera
local stageName = "Ready"
local records,connections,temporary = {},{},{}
local started = os.clock()
local heldKeys = {}
local mouseDown = false
local mouseX,mouseY = 0,0
local bagLabel
local function log(text)
    records[#records+1] = string.format(
        "%.2fs | %s",os.clock()-started,text
    )
    _G.__OilFullReport = table.concat(records,"\n")
    if not destroyed then
        local recent = {}
        for i=math.max(1,#records-3),#records do
            recent[#recent+1] = records[i]
        end
        output.Text = table.concat(recent,"\n")
    end
end
local function setStatus(text)
    if not destroyed then status.Text = text end
end
local function stage(text)
    stageName = text
    log("STAGE: "..text)
    if not destroyed then stageLabel.Text = text end
    setStatus("Running automatically...")
end
local function watch(connection)
    temporary[connection] = true
    return connection
end
local function unwatch(connection)
    if connection then
        connection:Disconnect()
        temporary[connection] = nil
    end
end
local function releaseInputs()
    for key in pairs(heldKeys) do
        pcall(function()
            VIM:SendKeyEvent(false,key,false,game)
        end)
    end
    heldKeys = {}
    if mouseDown then
        pcall(function()
            VIM:SendMouseButtonEvent(mouseX,mouseY,0,false,game,0)
        end)
        mouseDown = false
    end
end
local function restoreCamera()
    RunService:UnbindFromRenderStep(CAMERA_BIND)
    if savedCamera then
        local saved = savedCamera
        savedCamera = nil
        pcall(function()
            saved.camera.CFrame = saved.cf
            saved.camera.Focus = saved.focus
            saved.camera.FieldOfView = saved.fov
            saved.camera.CameraSubject = saved.subject
            saved.camera.CameraType = saved.kind
        end)
    end
end
local function endMotion()
    local saved = motion
    motion = nil
    if not saved then return end
    if saved.physics then saved.physics:Disconnect() end
    if saved.added then saved.added:Disconnect() end
    saved.velocity:Destroy()
    saved.orientation:Destroy()
    saved.attachment:Destroy()
    if saved.root.Parent then
        saved.root.AssemblyLinearVelocity = Vector3.zero
        saved.root.AssemblyAngularVelocity = Vector3.zero
    end
    if saved.foot then
        for part,original in pairs(saved.collisions) do
            if part.Parent then
                pcall(function() part.CanCollide = original end)
            end
        end
        if saved.humanoid.Parent then
            saved.humanoid.PlatformStand = saved.platform
            saved.humanoid.AutoRotate = saved.rotate
            saved.humanoid:SetStateEnabled(
                Enum.HumanoidStateType.Seated,saved.seated
            )
        end
    end
end
local function restoreAll()
    releaseInputs()
    restoreCamera()
    for connection in pairs(temporary) do
        connection:Disconnect()
    end
    temporary = {}
    endMotion()
end
local function stop(reason)
    if not busy or stopReason then return end
    stopReason = reason
    log("STOP: "..reason)
    restoreAll()
    setStatus(reason)
end
local function check()
    if destroyed then error("Script closed.",0) end
    if stopReason then error(stopReason,0) end
    if not context
        or player.Character ~= context.character
        or not context.root.Parent
        or context.humanoid.Health <= 0 then
        error("Character changed or died.",0)
    end
    if UIS:GetFocusedTextBox() then
        error("Close chat or text input.",0)
    end
end
local function holdPosition(target)
    if not motion then error("Flight controller missing.",0) end
    local delta = target-motion.root.Position
    if delta.Magnitude > 5 then
        error("Moved away from interaction or firing point.",0)
    end
    local correction = delta*8
    if correction.Magnitude > 12 then
        correction = correction.Unit*12
    end
    motion.velocity.VectorVelocity = correction
end
local function waitChecked(seconds,target,done)
    local t = os.clock()
    repeat
        RunService.Heartbeat:Wait()
        check()
        if target then holdPosition(target) end
        if done and done() then return true end
    until os.clock()-t >= seconds
    return false
end
local function keyPress(key,seconds,target,done)
    check()
    heldKeys[key] = true
    VIM:SendKeyEvent(true,key,false,game)
    local completed = waitChecked(seconds,target,done)
    VIM:SendKeyEvent(false,key,false,game)
    heldKeys[key] = nil
    return completed
end
local function tapE()
    keyPress(Enum.KeyCode.E,0.15)
end
local function rig()
    return workspace:FindFirstChild("OilRig")
        or workspace:FindFirstChild("OilRig",true)
end
local function visible(object)
    local current = object
    while current and current ~= playerGui do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        end
        if current:IsA("LayerCollector") and not current.Enabled then
            return false
        end
        current = current.Parent
    end
    return current == playerGui
end
 
local function attachedVehicle()
    if not context then return nil end
    local root = context.root.AssemblyRootPart
    local vehicles = workspace:FindFirstChild("Vehicles")
    if root and vehicles
        and not root:IsDescendantOf(context.character)
        and root:IsDescendantOf(vehicles) then
        return root
    end
end
local function vehicleModel(car)
    local vehicles = workspace:FindFirstChild("Vehicles")
    if not vehicles or not car or not car:IsDescendantOf(vehicles) then
        error("Vehicle disappeared.",0)
    end
    local model = car
    while model.Parent and model.Parent ~= vehicles do
        model = model.Parent
    end
    return model
end
local function seatParts(car)
    local model = vehicleModel(car)
    local driver = model:FindFirstChild("Seat")
    if not driver or not driver:IsA("BasePart") then
        error("Supported driver Seat part not found.",0)
    end
    local passengers = {}
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart")
            and part.Name:lower():find("passenger",1,true) then
            passengers[#passengers+1] = part
        end
    end
    if #passengers == 0 then
        error("Passenger seat reference not found.",0)
    end
    return driver,passengers
end
local function driverState(car)
    if attachedVehicle() ~= car or not context.humanoid.Sit then
        return false,"Not seated in selected vehicle"
    end
    local driver,passengers = seatParts(car)
    local d = (context.root.Position-driver.Position).Magnitude
    local p = math.huge
    for _,part in ipairs(passengers) do
        p = math.min(p,(context.root.Position-part.Position).Magnitude)
    end
    return d <= 2.75 and d+0.25 < p,
        string.format("Seat %.2f | Passenger %.2f",d,p)
end
 
local function beginMotion(root,foot,noclip,rotation)
    if motion and motion.root == root
        and motion.foot == foot and motion.noclip == noclip then
        if rotation then motion.orientation.CFrame = rotation end
        return
    end
    endMotion()
    local attachment = Instance.new("Attachment")
    attachment.Parent = root
    local velocity = Instance.new("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.ForceLimitsEnabled = false
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = root
    local orientation = Instance.new("AlignOrientation")
    orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    orientation.Attachment0 = attachment
    orientation.RigidityEnabled = true
    orientation.CFrame = rotation or root.CFrame.Rotation
    orientation.Parent = root
    local saved = {
        root=root,foot=foot,noclip=noclip,
        humanoid=context.humanoid,
        attachment=attachment,velocity=velocity,
        orientation=orientation,collisions={},
    }
    motion = saved
    if foot then
        local h = context.humanoid
        saved.platform = h.PlatformStand
        saved.rotate = h.AutoRotate
        saved.seated = h:GetStateEnabled(Enum.HumanoidStateType.Seated)
        if noclip then
            local function track(part)
                if not part:IsA("BasePart") then return end
                if saved.collisions[part] == nil then
                    saved.collisions[part] = part.CanCollide
                end
                part.CanCollide = false
            end
            for _,part in ipairs(context.character:GetDescendants()) do
                track(part)
            end
            saved.added = context.character.DescendantAdded:Connect(track)
            saved.physics = RunService.Stepped:Connect(function()
                if motion ~= saved then return end
                for part in pairs(saved.collisions) do
                    if part:IsDescendantOf(context.character) then
                        part.CanCollide = false
                    end
                end
            end)
        end
        h.PlatformStand = true
        h.AutoRotate = false
        h:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
    end
end
local function halt()
    if motion then
        motion.velocity.VectorVelocity = Vector3.zero
        motion.root.AssemblyLinearVelocity = Vector3.zero
    end
end
local function steerFoot(target,speed,dt)
    local delta = target-context.root.Position
    local distance = delta.Magnitude
    if distance > 0.03 then
        motion.velocity.VectorVelocity = delta.Unit*math.min(
            speed,distance*10,distance/math.max(dt,1/240)
        )
    else
        motion.velocity.VectorVelocity = Vector3.zero
    end
    return distance
end
local function moveTo(target,speed)
    local saved = motion
    if not saved then error("Movement controller missing.",0) end
    local elapsed,stalled,settled = 0,0,0
    local best = (target-saved.root.Position).Magnitude
    local commanded = Vector3.zero
    while true do
        local dt = RunService.Heartbeat:Wait()
        check()
        if not saved.root:IsDescendantOf(workspace) then
            error("Movement root disappeared.",0)
        end
        if not saved.foot and attachedVehicle() ~= saved.root then
            error("Character detached from vehicle.",0)
        end
        local delta = target-saved.root.Position
        local distance = delta.Magnitude
        if saved.foot and distance <= 0.5 then
            halt()
            return
        end
        if not saved.foot and distance <= 1.5
            and saved.root.AssemblyLinearVelocity.Magnitude <= 4 then
            settled = settled+dt
            if settled >= 0.15 then
                halt()
                return
            end
        else
            settled = 0
        end
        elapsed = elapsed+dt
        if distance < best-0.4 then
            best,stalled = distance,0
        else
            stalled = stalled+dt
        end
        if stalled >= (saved.foot and 7 or 10) then
            error(string.format(
                "Movement blocked at %s. Distance %.2f",
                stageName,distance
            ),0)
        end
        if elapsed >= 60 then
            error("Movement timeout at "..stageName,0)
        end
        local wanted = Vector3.zero
        if distance > 0.01 then
            if saved.foot then
                wanted = delta.Unit*math.min(
                    speed,distance*10,distance/math.max(dt,1/240)
                )
            else
                wanted = delta.Unit*math.min(
                    speed,
                    math.sqrt(360*math.max(0,distance-0.4)),
                    distance*2.5
                )
            end
        end
        if saved.foot then
            commanded = wanted
        else
            local change = wanted-commanded
            local limit = 140*math.min(dt,0.1)
            if change.Magnitude > limit then change = change.Unit*limit end
            commanded = commanded+change
        end
        saved.velocity.VectorVelocity = commanded
    end
end
local function footRoute(route,speed,noclip,name)
    beginMotion(context.root,true,noclip)
    for i,target in ipairs(route) do
        stage(name.." "..i.." / "..#route)
        moveTo(target,speed)
    end
end
local function waitOutside()
    local t = os.clock()
    repeat
        waitChecked(0.1)
        if not attachedVehicle() and not context.humanoid.Sit then
            return true
        end
    until os.clock()-t >= 5
    return false
end
local function leaveVehicle(car)
    if attachedVehicle() ~= car then
        error("Not attached to selected vehicle before exit.",0)
    end
    tapE()
    if not waitOutside() then error("Could not exit vehicle.",0) end
    waitChecked(0.35)
end
local function boardDriver(car)
    seatParts(car)
    local attached = attachedVehicle()
    if attached == car then
        local correct,detail = driverState(car)
        if correct then
            log("DRIVER POSITION CONFIRMED: "..detail)
            return
        end
        leaveVehicle(car)
    elseif attached or context.humanoid.Sit then
        error("Unexpected seat or vehicle attachment.",0)
    end
    for attempt=1,3 do
        stage("Driver seat entry "..attempt.." / 3")
        local driver = seatParts(car)
        local localSeat = car.CFrame:PointToObjectSpace(driver.Position)
        if math.abs(localSeat.X) < 0.3 then
            error("Driver seat side is ambiguous.",0)
        end
        local offsets = {3,2.3,3.5}
        local side = localSeat.X < 0 and -1 or 1
        local target = car.CFrame:PointToWorldSpace(
            localSeat+V(side*offsets[attempt],0,0)
        )+V(0,3,0)
        beginMotion(context.root,true,true)
        moveTo(target,65)
        endMotion()
        waitChecked(0.4)
        local currentDriver,passengers = seatParts(car)
        local d = (context.root.Position-currentDriver.Position).Magnitude
        for _,passenger in ipairs(passengers) do
            if (context.root.Position-passenger.Position).Magnitude <= d then
                error("Driver-side approach not confirmed.",0)
            end
        end
        tapE()
        local t,stableSince = os.clock(),nil
        while os.clock()-t < 5 do
            waitChecked(0.1)
            local good,detail = driverState(car)
            if good then
                stableSince = stableSince or os.clock()
                if os.clock()-stableSince >= 0.3 then
                    log("DRIVER POSITION CONFIRMED: "..detail)
                    return
                end
            else
                stableSince = nil
            end
        end
        local current = attachedVehicle()
        if current == car then
            log("Wrong or unverified seat; exiting")
            leaveVehicle(car)
        elseif current or context.humanoid.Sit then
            error("Unexpected attachment during boarding.",0)
        end
    end
    error("Driver seat not confirmed after 3 attempts.",0)
end
local function flyVehicle(car,target)
    local good,detail = driverState(car)
    if not good then error("Driver check failed: "..detail,0) end
    local origin = car.Position
    if (origin-target).Magnitude > 3 then
        local height = math.max(origin.Y,target.Y)+300
        beginMotion(car,false,false)
        setStatus("Vehicle: climbing...")
        moveTo(V(origin.X,height,origin.Z),120)
        setStatus("Vehicle: cruising...")
        moveTo(V(target.X,height,target.Z),280)
        setStatus("Vehicle: descending...")
        moveTo(target,90)
        endMotion()
    end
    waitChecked(0.4)
end
 
local function pistolVisible()
    for _,object in ipairs(playerGui:GetDescendants()) do
        if not object:IsDescendantOf(gui)
            and (object:IsA("TextLabel") or object:IsA("TextButton"))
            and visible(object) and object.TextTransparency < 1 then
            local text = object.Text:gsub("<[^>]->","")
            if text:find("Пистолет",1,true)
                or text:lower():find("pistol",1,true) then
                return true
            end
        end
    end
    return false
end
local function selectPistol(position)
    if pistolVisible() then
        log("Pistol label already visible")
        return
    end
    log("Selecting weapon slot 1")
    keyPress(Enum.KeyCode.One,0.08,position)
    waitChecked(0.5,position)
    if pistolVisible() then
        log("Pistol label visible after slot selection")
    else
        log("Slot 1 input sent; weapon label not independently verified")
    end
end
local function lockCamera(config,position)
    local camera = workspace.CurrentCamera
    if not camera then error("Camera unavailable.",0) end
    restoreCamera()
    savedCamera = {
        camera=camera,kind=camera.CameraType,
        subject=camera.CameraSubject,
        cf=camera.CFrame,focus=camera.Focus,fov=camera.FieldOfView,
    }
    RunService:BindToRenderStep(
        CAMERA_BIND,
        Enum.RenderPriority.Camera.Value+1,
        function()
            if not busy or destroyed or stopReason then return end
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = config.cf
            camera.Focus = config.focus
            camera.FieldOfView = 70
        end
    )
    waitChecked(0.2,position)
    local inset = GuiService:GetGuiInset()
    mouseX = math.floor(camera.ViewportSize.X*config.x+inset.X+0.5)
    mouseY = math.floor(camera.ViewportSize.Y*config.y+inset.Y+0.5)
    VIM:SendMouseMoveEvent(mouseX,mouseY,game)
end
local function shoot(position,done)
    if done() then return end
    VIM:SendMouseMoveEvent(mouseX,mouseY,game)
    mouseDown = true
    VIM:SendMouseButtonEvent(mouseX,mouseY,0,true,game,0)
    waitChecked(0.06,position,done)
    VIM:SendMouseButtonEvent(mouseX,mouseY,0,false,game,0)
    mouseDown = false
    waitChecked(0.29,position,done)
end
local function reload(position,done)
    if done() then return end
    setStatus("Reloading...")
    keyPress(Enum.KeyCode.R,0.08,position,done)
    waitChecked(2,position,done)
end
 
local function findCounter()
    local oil = rig()
    local folder = oil and oil:FindFirstChild("GuardCounters")
    if not folder then error("GuardCounters not loaded.",0) end
    local matches = {}
    for _,part in ipairs(folder:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "GuardCounter"
            and (part.Position-COUNTER_POSITION).Magnitude < 3 then
            for _,object in ipairs(part:GetDescendants()) do
                if object:IsA("TextLabel") then
                    matches[#matches+1] = object
                end
            end
        end
    end
    if #matches ~= 1 then
        error("Expected one guard counter; found "..#matches,0)
    end
    return matches[1]
end
local function prepareCounter()
    local labelObject = findCounter()
    local state = {
        label=labelObject,
        positive=false,
        zeroSince=nil,
        count=nil,
        best=nil,
        progress=os.clock(),
    }
    local function observe()
        if not labelObject:IsDescendantOf(workspace) then return end
        local text = labelObject.Text:gsub("<[^>]->",""):gsub("%s+","")
        local value = text:match("^%d+$") and tonumber(text) or nil
        if value == nil then
            state.zeroSince = nil
            return
        end
        if value ~= state.count then
            log("First guard counter: "..value)
            state.count = value
        end
        if value > 0 then
            state.positive = true
            state.zeroSince = nil
            if not state.best or value < state.best then
                state.best = value
                state.progress = os.clock()
            end
        elseif state.positive then
            state.zeroSince = state.zeroSince or os.clock()
        end
    end
    state.observe = observe
    state.connection = watch(
        labelObject:GetPropertyChangedSignal("Text"):Connect(observe)
    )
    observe()
    return state
end
local function fightFirst(state)
    stage("First guard group")
    beginMotion(context.root,true,false)
    moveTo(FIRE1,100)
    selectPistol(FIRE1)
    lockCamera(CAMERA1,FIRE1)
    local function done()
        if not state.label:IsDescendantOf(workspace) then
            error("First guard counter disappeared.",0)
        end
        state.observe()
        return state.positive and state.zeroSince ~= nil
            and os.clock()-state.zeroSince >= 0.75
    end
    local waiting = os.clock()
    while not state.positive do
        waitChecked(0.1,FIRE1)
        state.observe()
        if os.clock()-waiting >= 30 then
            error("No positive guard count after TNT placement.",0)
        end
    end
    local t = os.clock()
    local shots = 0
    state.progress = os.clock()
    while not done() do
        check()
        if os.clock()-t >= 90 then
            error("First guard fight timeout.",0)
        end
        if os.clock()-state.progress >= 20 then
            error("First guard count did not decrease for 20 seconds.",0)
        end
        setStatus("First guards: "..tostring(state.count))
        shoot(FIRE1,done)
        shots = shots+1
        if shots >= 8 then
            reload(FIRE1,done)
            shots = 0
        end
    end
    log("FIRST GUARDS CLEARED: counter reached stable 00")
    unwatch(state.connection)
    releaseInputs()
    restoreCamera()
    endMotion()
end
 
local function fightSecond()
    stage("Second guard: fixed-direction fire")
    local position = LEVER[2]
    beginMotion(context.root,true,false)
    moveTo(position,55)
    selectPistol(position)
    lockCamera(CAMERA2,position)
    local target
    local deathObserved = false
    local tracked = {}
    local trackerConnections = {}
    local lastScan = -math.huge
    local deadline = os.clock()+180
    local function keep(connection)
        trackerConnections[#trackerConnections+1] = watch(connection)
    end
    local function eligible(h,record)
        local model = h.Parent
        if not model or not model:IsA("Model")
            or Players:GetPlayerFromCharacter(model) then return false end
        local root = model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChild("Head")
            or model.PrimaryPart
        if not root or not root:IsA("BasePart") then
            return record and record.nearAim == true
        end
        local delta = root.Position-CAMERA2.cf.Position
        local distance = delta.Magnitude
        local near = distance<=180 and distance>.01
            and delta.Unit:Dot(CAMERA2.cf.LookVector)>.25
        if record then record.nearAim=near end
        return near
    end
    local function choose(h,why)
        if target~=h then
            target=h
            log("SECOND TARGET: "..h:GetFullName().." | "..why)
        end
    end
    local function confirmDeath(h,record,why)
        if deathObserved or not record.sawAlive then return end
        if target~=h and not (record.damaged and eligible(h,record)) then return end
        target=h
        deathObserved=true
        releaseInputs()
        log("SECOND GUARD DEATH CONFIRMED: "..why)
    end
    local function track(h)
        if not h:IsA("Humanoid") or tracked[h] or h.Health<=0 then return end
        local record={lastHealth=h.Health,sawAlive=true,damaged=false}
        tracked[h]=record
        eligible(h,record)
        keep(h.HealthChanged:Connect(function(hp)
            if hp<record.lastHealth and eligible(h,record) then
                record.damaged=true
                choose(h,"HP decreased in firing direction")
                log("Second guard HP: "..hp)
            end
            record.lastHealth=hp
            if hp<=0 then confirmDeath(h,record,"HP reached 0") end
        end))
        keep(h.Died:Connect(function()
            confirmDeath(h,record,"Humanoid.Died")
        end))
    end
    local oil = rig()
    local guards = oil and oil:FindFirstChild("GuardsFolder")
    if not guards then error("OilRig.GuardsFolder not found.",0) end
    keep(guards.DescendantAdded:Connect(track))
    for _,object in ipairs(guards:GetDescendants()) do track(object) end
    local function acquire()
        if os.clock()-lastScan<0.05 then return end
        lastScan=os.clock()
        local best,score=nil,math.huge
        for h,record in pairs(tracked) do
            if h:IsDescendantOf(guards) and h.Health>0 and eligible(h,record) then
                local model=h.Parent
                local root=model:FindFirstChild("HumanoidRootPart")
                    or model:FindFirstChild("Head") or model.PrimaryPart
                if root then
                    local delta=root.Position-CAMERA2.cf.Position
                    local value=(1-delta.Unit:Dot(CAMERA2.cf.LookVector))*200
                        +delta.Magnitude*.1
                    if value<score then best,score=h,value end
                end
            end
        end
        if not target and best then choose(best,"live guard in firing direction") end
    end
    local function done()
        check()
        acquire()
        if deathObserved then return true end
        if target then
            if target.Health<=0 then
                confirmDeath(target,tracked[target],"HP poll reached 0")
                return deathObserved
            end
            if not target:IsDescendantOf(workspace) then
                releaseInputs()
                error("Tracked guard disappeared; death not confirmed. Fire stopped.",0)
            end
        end
        if os.clock()>=deadline then
            error("Guard death not confirmed within 180 seconds.",0)
        end
        return false
    end
     
     
    local function readAmmo()
        local result
        for _,o in ipairs(playerGui:GetDescendants()) do
            if not o:IsDescendantOf(gui)
                and (o:IsA("TextLabel") or o:IsA("TextButton"))
                and visible(o) and o.TextTransparency < 1 then
                local named = false
                local ancestor = o
                for _=1,3 do
                    if not ancestor or ancestor == playerGui then break end
                    local name = ancestor.Name:lower()
                    if name:find("ammo",1,true)
                        or name:find("magazine",1,true)
                        or name == "clip" then named = true end
                    ancestor = ancestor.Parent
                end
                if named then
                    local text = o.Text:gsub("<[^>]->", ""):gsub("%s+", "")
                    local current = text:match("^(%d+)/8$")
                     
                     
                    local name = o.Name:lower()
                    if not current and (name == "ammo" or name == "currentammo"
                        or name == "ammocount" or name == "clip") then
                        current = text:match("^(%d+)$")
                    end
                    local n = tonumber(current)
                    if n and n >= 0 and n <= 8 then
                        if result ~= nil and result ~= n then return nil end
                        result = n
                    end
                end
            end
        end
        return result
    end
    local estimatedAmmo = 8
    local unknownLogged = false
    local function refill()
        if done() then return end
        log("SECOND GUARD: pressing R; waiting for reload")
        reload(position,done)
        if done() then return end
         
        local untilTime = os.clock()+1
        local ammo = readAmmo()
        while ammo ~= nil and ammo < 8 and os.clock() < untilTime do
            if waitChecked(0.1,position,done) then return end
            ammo = readAmmo()
        end
        if ammo ~= nil and ammo < 8 then
            error("Reload did not restore 8 rounds. Ammo: "..ammo,0)
        end
        estimatedAmmo = 8
        if ammo == 8 then
            log("SECOND GUARD: magazine 8 confirmed by UI")
        elseif not unknownLogged then
            unknownLogged = true
            log("Ammo UI unavailable; R sent, using an 8-shot estimate")
        end
    end
    local initialAmmo = readAmmo()
    if initialAmmo ~= nil then
        estimatedAmmo = initialAmmo
    else
        log("Ammo UI unavailable; starting fire with an 8-shot estimate")
    end
    stage("Second guard: continuous fixed-direction fire")
    log("Firing immediately; no crosshair or target-appearance gate")
    while not done() do
        local ammo = readAmmo()
        if estimatedAmmo <= 0 or ammo == 0 then
            refill()
        else
            if target then
                setStatus("Fixed-direction fire | HP: "..math.floor(target.Health))
            else
                setStatus("Fixed-direction fire | guard not detected yet")
            end
            shoot(position,done)
            estimatedAmmo = estimatedAmmo-1
        end
    end
    log("SECOND GUARD DEATH CONFIRMED")
    for _,connection in ipairs(trackerConnections) do unwatch(connection) end
    releaseInputs()
    restoreCamera()
    endMotion()
end
 
local function cardAndRoom()
    footRoute(CARD_APPROACH,55,true,"Card approach")
    stage("Card point 7")
    log("Repeated E for 3 seconds; then direct room transition")
    local t = os.clock()
    local nextChange = 0
    local eDown = false
    local taps = 0
    while os.clock()-t < 3 do
        local dt = RunService.Heartbeat:Wait()
        check()
        steerFoot(CARD_POINT,55,dt)
        local now = os.clock()
        if now >= nextChange then
            if eDown then
                VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
                heldKeys[Enum.KeyCode.E] = nil
                eDown = false
                nextChange = now+0.14
            else
                heldKeys[Enum.KeyCode.E] = true
                VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)
                eDown = true
                taps = taps+1
                nextChange = now+0.06
            end
        end
    end
    releaseInputs()
    halt()
    log("Card stage ended; taps "..taps.."; pickup not independently verified")
    footRoute(ROOM,55,true,"Collection room")
    endMotion()
end
 
local function parseBag(object)
    if not object:IsDescendantOf(playerGui)
        or object:IsDescendantOf(gui)
        or not visible(object) then
        return nil
    end
    if not (
        object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox")
    ) then
        return nil
    end
    if object.TextTransparency >= 1 then return nil end
    local text = object.Text
        :gsub("<[^>]->","")
        :gsub("%$","")
        :gsub(",","")
        :gsub("%s+","")
    local amount,capacity = text:match("^(%d+)/(%d+)$")
    amount,capacity = tonumber(amount),tonumber(capacity)
    if amount and capacity == 4000
        and amount >= 0 and amount <= capacity then
        return amount
    end
end
local function readBag()
    if bagLabel then
        local value = parseBag(bagLabel)
        if value ~= nil then return value end
        bagLabel = nil
    end
    local selected,value
    for _,object in ipairs(playerGui:GetDescendants()) do
        local amount = parseBag(object)
        if amount ~= nil then
            if selected and value ~= amount then
                error("Conflicting bag amounts are visible.",0)
            end
            selected,value = object,amount
        end
    end
    if selected then
        bagLabel = selected
        log("Bag label: "..selected:GetFullName())
    end
    return value
end
local function waitFor1350()
    stage("Collecting to $1,350")
    local t = os.clock()
    local lastAmount,missingSince,fullSince
    while os.clock()-t < 180 do
        check()
        local amount = readBag()
        if amount ~= nil then
            missingSince = nil
            if amount ~= lastAmount then
                lastAmount = amount
                log("Bag: $"..amount.." / $4,000")
            end
            setStatus("Bag: $"..amount.." | Target: $1,350")
            if amount >= 1350 then
                fullSince = fullSince or os.clock()
                if os.clock()-fullSince >= 0.5 then return end
            else
                fullSince = nil
            end
        else
            fullSince = nil
            missingSince = missingSince or os.clock()
            if os.clock()-missingSince >= 15 then
                error("Bag amount could not be read in the first room.",0)
            end
        end
        waitChecked(0.25)
    end
    error("Bag did not reach $1,350 within 180 seconds.",0)
end
local function collectTo4000()
    stage("Collecting to $4,000")
    beginMotion(context.root,true,true,COLLECTION_ROTATION)
    local index = 1
    local routeFinished = false
    local shifted = false
    local shiftReached = false
    local shiftPoint = V(-1287.99,164.63,-4149.15)
    local lastRead = 0
    local amount
    local missingSince,fullSince
    local lastAmount
    local lastIncrease = os.clock()
    local lastWaitNotice = os.clock()
    local best = math.huge
    local progress = os.clock()
    local notice = os.clock()
    log("Second tank: approach points 1-7, then precise hold; flight and noclip stay ON")
    while true do
        local dt = RunService.Heartbeat:Wait()
        check()
        if not motion.velocity.Parent
            or not motion.orientation.Parent
            or not motion.attachment.Parent then
            error("Collection flight controller was removed.",0)
        end
        context.humanoid.PlatformStand = true
        context.humanoid.AutoRotate = false
        motion.orientation.CFrame = COLLECTION_ROTATION
        local now = os.clock()
        if now-lastRead >= 0.2 then
            lastRead = now
            amount = readBag()
            if amount ~= nil then
                missingSince = nil
                if amount ~= lastAmount then
                    log("Bag: $"..amount.." / $4,000")
                    if lastAmount == nil or amount > lastAmount then
                        lastIncrease = now
                    end
                    lastAmount = amount
                end
                if amount >= 4000 then
                    fullSince = fullSince or now
                else
                    fullSince = nil
                end
            else
                fullSince = nil
                missingSince = missingSince or now
                 
                 
                if now-missingSince >= 15 and now-lastWaitNotice >= 15 then
                    log("Bag unreadable; continuing position hold, waiting for confirmed 4000")
                    lastWaitNotice = now
                end
            end
        end
        if fullSince then
            halt()
            if now-fullSince >= 0.2 then
                log("BAG FULL: switching directly to delivery")
                return
            end
        else
            local target = COLLECTION[index]
            local distance = (target-context.root.Position).Magnitude
            if not routeFinished and distance <= (index == #COLLECTION and 0.08 or 0.5) then
                log("COLLECTION POINT REACHED: "..index)
                if index < #COLLECTION then
                    index = index+1
                    target = COLLECTION[index]
                    distance = (target-context.root.Position).Magnitude
                    best,progress,notice = distance,now,now
                else
                    routeFinished = true
                    lastIncrease = now
                    log("Collection route complete; holding for $4,000")
                end
            end
            if routeFinished then
                if not shifted and amount and amount < 4000
                    and now-lastIncrease >= 5 then
                    shifted = true
                    log("COLLECTION STALLED: slowly shifting to alternate tank position")
                end
                if shifted then
                    target = shiftPoint
                    if not shiftReached and (target-context.root.Position).Magnitude <= 0.08 then
                        shiftReached = true
                        lastIncrease = now
                        log("ALTERNATE POSITION REACHED: holding here until confirmed 4000")
                    end
                end
                distance = (target-context.root.Position).Magnitude
            end
            if distance < best-0.3 then
                best,progress = distance,now
            end
            if not routeFinished and now-progress >= 3 and now-notice >= 5 then
                log(string.format(
                    "RETRY collection point %d: distance %.2f; bag %d; flight ON",
                    index,distance,amount or lastAmount or 0
                ))
                notice = now
            end
            if index == #COLLECTION then
                 
                 
                local delta = target-context.root.Position
                local d = delta.Magnitude
                context.root.AssemblyAngularVelocity = Vector3.zero
                if d > 0.02 then
                    motion.velocity.VectorVelocity = delta.Unit*math.min(
                        (shifted and 3 or 6),d*3,d/math.max(dt,1/240)
                    )
                else
                    halt()
                end
            else
                steerFoot(target,55,dt)
            end
            if routeFinished and amount and amount < 4000
                and now-lastIncrease >= 20 and now-lastWaitNotice >= 20 then
                log("HOLD ACTIVE: bag "..amount.." / 4000; waiting for server collection; flight and noclip ON")
                lastWaitNotice = now
            end
            setStatus(
                "Bag: "..(amount and ("$"..amount) or "reading...").." / $4,000\n"
                ..(shifted and (shiftReached and "Holding alternate position" or "Slow shift to alternate position")
                    or routeFinished and "Holding at final point"
                    or "Collection point "..index.." / "..#COLLECTION)
            )
        end
    end
end
 
local function run(car)
    stage("Checking driver seat")
    boardDriver(car)
    stage("Flying to oil rig parking")
    flyVehicle(car,OIL_PARK)
    stage("Leaving vehicle")
    leaveVehicle(car)
    footRoute(ENTRY,100,false,"TNT approach")
     
    local firstCounter = prepareCounter()
    stage("Planting TNT")
    waitChecked(0.2,ENTRY[#ENTRY])
    keyPress(Enum.KeyCode.E,3,ENTRY[#ENTRY])
    waitChecked(0.2,ENTRY[#ENTRY])
    log("TNT interaction: E held for 3 seconds")
    fightFirst(firstCounter)
    footRoute(LEVER,55,false,"Lever route")
    stage("Using lever")
    waitChecked(0.2,LEVER[4])
    keyPress(Enum.KeyCode.E,2,LEVER[4])
    waitChecked(0.3,LEVER[4])
    stage("Returning from lever: point 3")
    moveTo(LEVER[3],55)
    stage("Returning from lever: point 2")
    moveTo(LEVER[2],55)
    fightSecond()
    cardAndRoom()
    waitFor1350()
    collectTo4000()
     
    footRoute(EXIT,100,true,"Oil rig exit")
    endMotion()
    stage("Returning to original vehicle")
    if not car:IsDescendantOf(workspace) then
        error("The original vehicle disappeared.",0)
    end
    if (car.Position-OIL_PARK).Magnitude > 50 then
        error("The original vehicle moved away from its parking point.",0)
    end
    boardDriver(car)
    stage("Flying to delivery parking")
    flyVehicle(car,DELIVERY_PARK)
    stage("Leaving vehicle at delivery parking")
    leaveVehicle(car)
    footRoute(DELIVERY,100,true,"Delivery route")
    endMotion()
    stage("Waiting at delivery point")
    waitChecked(3)
    local returnRoute = {}
    for i=#DELIVERY-1,1,-1 do
        returnRoute[#returnRoute+1] = DELIVERY[i]
    end
    stage("Returning from delivery to vehicle")
    footRoute(returnRoute,100,true,"Return to delivery vehicle")
    endMotion()
    if not car:IsDescendantOf(workspace) then
        error("The original vehicle disappeared after delivery.",0)
    end
    stage("Boarding original driver seat after delivery")
    boardDriver(car)
    local correct,detail = driverState(car)
    if not correct then
        error("Final driver check failed: "..tostring(detail),0)
    end
    log("FINISHED: returned to original driver seat; payout not automatically verified")
end
local function start()
    if busy or destroyed then return end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then
        setStatus("Character not ready.")
        return
    end
    if UIS:GetFocusedTextBox() then
        setStatus("Close chat or text input first.")
        return
    end
    context = {character=character,root=root,humanoid=humanoid}
    local car = attachedVehicle()
    if not car then
        context = nil
        setStatus("Sit in your car before pressing Start.")
        return
    end
    busy = true
    stopReason = nil
    bagLabel = nil
    records = {}
    started = os.clock()
    startButton.Text = "Running..."
    output.TextEditable = false
    log("VERSION: Oil Rig Full Cycle - Alternate Tank Position v10")
    log("Vehicle: "..car:GetFullName())
    task.spawn(function()
        local ok,err = pcall(function()
            run(car)
        end)
        restoreAll()
        busy = false
        context = nil
        if ok then
            if not destroyed then
                stageLabel.Text = "Finished"
                setStatus(
                    "Returned to original driver seat.\n"
                    .."Check that the bag disappeared and money was credited."
                )
            end
        else
            log("FINAL STOP | "..stageName.." | "..tostring(err))
            if not destroyed then
                stageLabel.Text = stopReason and "Stopped" or "Error"
                setStatus(tostring(err))
            end
        end
        if not destroyed then startButton.Text = "Start" end
    end)
end
connections[#connections+1] = startButton.Activated:Connect(start)
connections[#connections+1] = stopButton.Activated:Connect(function()
    stop("Stop button activated")
end)
connections[#connections+1] = copyButton.Activated:Connect(function()
    local report = table.concat(records,"\n")
    if report == "" then report = "No run recorded." end
    local ok = pcall(function() setclipboard(report) end)
    if not ok and not busy then
        output.TextEditable = true
        output.Text = report
        output:CaptureFocus()
        output.SelectionStart = 1
        output.CursorPosition = #output.Text+1
    end
end)
connections[#connections+1] = UIS.WindowFocusReleased:Connect(function()
    stop("Roblox window lost focus")
end)
local function cleanup()
    if destroyed then return end
    stop("Script replaced or closed")
    destroyed = true
    restoreAll()
    for _,connection in ipairs(connections) do
        connection:Disconnect()
    end
    if _G[KEY] == cleanup then _G[KEY] = nil end
    gui:Destroy()
end
_G[KEY] = cleanup
connections[#connections+1] = gui.Destroying:Connect(cleanup)

gui.Enabled=false
return {Start=start, Stop=function() stop('Stopped from main menu') end, Busy=function() return busy end, Destroy=cleanup, Log=function() return table.concat(records,'\n') end, Status=function() return status.Text end}
]====]
HUB_SOURCES['Factory'] = [====[
local hubStart
local function hubCapture(fn) hubStart=fn end
local function solveFlow(w,h,pairs,tick)
    local n=w*h
    local adj,occ,done,paths={},{},{},{}
    local free=n-2*#pairs
    for v=1,n do
        local x=(v-1)%w+1
        local y=math.floor((v-1)/w)+1
        local a={}
        if x>1 then a[#a+1]=v-1 end
        if x<w then a[#a+1]=v+1 end
        if y>1 then a[#a+1]=v-w end
        if y<h then a[#a+1]=v+w end
        adj[v]=a
    end
    for i,p in ipairs(pairs) do occ[p.a]=i;occ[p.b]=i end
    local nodes=0
    local function pulse()
        nodes=nodes+1
        if nodes%256==0 then tick(nodes) end
    end
    local function distance(a,b)
        return math.abs((a-1)%w-(b-1)%w)
            +math.abs(math.floor((a-1)/w)-math.floor((b-1)/w))
    end
    local function viable(active,head)
        local ends={}
        for i,p in ipairs(pairs) do
            if not done[i] then
                ends[i==active and head or p.a]=true
                ends[p.b]=true
            end
        end
        for v=1,n do
            if not occ[v] or ends[v] then
                local degree=0
                for _,u in ipairs(adj[v]) do
                    if not occ[u] or ends[u] then degree=degree+1 end
                end
                if degree<(ends[v] and 1 or 2) then return false end
            end
        end
        for i,p in ipairs(pairs) do
            if not done[i] then
                local start=i==active and head or p.a
                local goal=p.b
                local queue,seen={start},{[start]=true}
                local front=1
                while front<=#queue and not seen[goal] do
                    local v=queue[front];front=front+1
                    for _,u in ipairs(adj[v]) do
                        if not seen[u] and (not occ[u] or u==goal) then
                            seen[u]=true;queue[#queue+1]=u
                        end
                    end
                end
                if not seen[goal] then return false end
            end
        end
        return true
    end
    local search
    search=function()
        pulse()
        local chosen,best=nil,math.huge
        for i,p in ipairs(pairs) do
            if not done[i] then
                local degree=0
                for _,u in ipairs(adj[p.a]) do
                    if not occ[u] or u==p.b then degree=degree+1 end
                end
                local score=degree*100+distance(p.a,p.b)
                if score<best then chosen,best=i,score end
            end
        end
        if not chosen then return free==0 end
        local p=pairs[chosen]
        local path={p.a}
        local function grow(head)
            pulse()
            if head==p.b then
                done[chosen]=true
                local saved={}
                for j,v in ipairs(path) do saved[j]=v end
                paths[chosen]=saved
                if viable(nil,nil) and search() then return true end
                paths[chosen]=nil;done[chosen]=nil
                return false
            end
            if not viable(chosen,head) then return false end
            local options={}
            for _,u in ipairs(adj[head]) do
                if not occ[u] or u==p.b then options[#options+1]=u end
            end
            table.sort(options,function(a,b)
                return distance(a,p.b)<distance(b,p.b)
            end)
            for _,u in ipairs(options) do
                local empty=not occ[u]
                if empty then occ[u]=chosen;free=free-1 end
                path[#path+1]=u
                if grow(u) then return true end
                path[#path]=nil
                if empty then occ[u]=nil;free=free+1 end
            end
            return false
        end
        return grow(p.a)
    end
    if search() then return paths,nodes end
    return nil,nodes
end

local P=game:GetService("Players").LocalPlayer
local PG=P:WaitForChild("PlayerGui")
local RS=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local GS=game:GetService("GuiService")
local VIM=game:GetService("VirtualInputManager")
local SPEED=100
local NOCLIP=true
if _G.PowerFlowCleanup then _G.PowerFlowCleanup() end
local gui=Instance.new("ScreenGui",PG)
gui.Name="PowerPlantFullCycle"
gui.ResetOnSpawn=false
gui.DisplayOrder=10000
local panel=Instance.new("Frame",gui)
panel.Size=UDim2.fromOffset(300,175)
panel.Position=UDim2.new(1,-315,0,25)
panel.BackgroundColor3=Color3.fromRGB(25,28,35)
Instance.new("UICorner",panel)
local function text(s,y,h)
    local o=Instance.new("TextLabel",panel)
    o.Position=UDim2.fromOffset(10,y)
    o.Size=UDim2.new(1,-20,0,h)
    o.BackgroundTransparency=1
    o.TextColor3=Color3.new(1,1,1)
    o.Font=Enum.Font.Gotham
    o.TextSize=14
    o.TextWrapped=true
    o.Text=s
    return o
end
text("POWER PLANT | FULL CYCLE",8,28)
local status=text("Sit in the driver seat, then press Start",40,65)
local function button(s,x)
    local b=Instance.new("TextButton",panel)
    b.Position=UDim2.fromOffset(x,115)
    b.Size=UDim2.fromOffset(86,35)
    b.BackgroundColor3=Color3.fromRGB(48,65,88)
    b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold
    b.TextSize=14
    b.Text=s
    Instance.new("UICorner",b)
    return b
end
local start=button("Start",10)
local stop=button("Stop",107)
local copy=button("Copy log",204)
local busy,cancel,dead=false,false,false
local held,mx,my=false,0,0
local history,t0={},os.clock()
local flight=nil
local selectedCar=nil
local cycleCharacter=nil
local keyHeld=false
local function log(s)
    history[#history+1]=string.format("%.2fs | %s",os.clock()-t0,s)
    status.Text=s
    print("[Power Plant] "..s)
end
local function release()
    if keyHeld then
        keyHeld=false
        pcall(function() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) end)
    end
    if held then
        held=false
        pcall(function() VIM:SendMouseButtonEvent(mx,my,0,false,game,0) end)
    end
end
local function endFlight()
    local f=flight
    flight=nil
    if not f then return end
    if f.connection then f.connection:Disconnect() end
    for _,o in ipairs(f.objects) do o:Destroy() end
    for part,value in pairs(f.collisions) do
        if part.Parent then part.CanCollide=value end
    end
    if f.root.Parent then f.root.AssemblyLinearVelocity=Vector3.zero end
    if f.foot and f.hum.Parent then
        f.hum.PlatformStand=f.platform
        f.hum.AutoRotate=f.rotate
        f.hum:SetStateEnabled(Enum.HumanoidStateType.Seated,f.seated)
    end
end
local function check()
    if cancel or dead then error("Stopped",0) end
    if UIS:GetFocusedTextBox() then error("Close chat",0) end
    local h=P.Character and P.Character:FindFirstChildOfClass("Humanoid")
    if not h or h.Health<=0 then error("Character unavailable",0) end
    if cycleCharacter and P.Character~=cycleCharacter then error("Character changed",0) end
end
local function waitFor(seconds)
    local untilTime=os.clock()+seconds
    repeat check();RS.Heartbeat:Wait() until os.clock()>=untilTime
end
local function visible(o)
    if not o or not o:IsDescendantOf(PG) then return false end
    while o and o~=PG do
        if o:IsA("GuiObject") and not o.Visible then return false end
        if o:IsA("ScreenGui") and not o.Enabled then return false end
        o=o.Parent
    end
    return true
end
local function getBoard()
    local f=PG:FindFirstChild("FlowGui")
    local b=f and f:FindFirstChild("Board")
    local i=b and b:FindFirstChild("Inner")
    if visible(i) then return b,i end
end
local function center(o)
    local g=o:FindFirstAncestorOfClass("ScreenGui")
    local inset=Vector2.zero
    if g and not g.IgnoreGuiInset then inset=GS:GetGuiInset() end
    return o.AbsolutePosition+o.AbsoluteSize/2+inset
end
local function mouse(p)
    mx,my=math.floor(p.X+0.5),math.floor(p.Y+0.5)
    VIM:SendMouseMoveEvent(mx,my,game)
end
local function down()
    held=true
    VIM:SendMouseButtonEvent(mx,my,0,true,game,0)
end
local function read(inner)
    local w,h,raw=0,0,{}
    for _,o in ipairs(inner:GetChildren()) do
        local x,y=o.Name:match("^(%d+)%.(%d+)$")
        if x and o:IsA("TextLabel") then
            x,y=tonumber(x),tonumber(y)
            assert(x>=1 and y>=1,"Unsupported cell numbering")
            w,h=math.max(w,x),math.max(h,y)
            raw[#raw+1]={x=x,y=y,o=o}
        end
    end
    assert(w>=2 and h>=2 and w*h<=100 and #raw==w*h,"Incomplete board")
    local cells,groups={},{}
    for _,r in ipairs(raw) do
        local v=(r.y-1)*w+r.x
        assert(not cells[v],"Duplicate cell")
        cells[v]=r.o
        local s=r.o.Text:match("^%s*(.-)%s*$")
        if s~="" then
            assert(s:match("^%d+$"),"Unexpected cell text")
            groups[s]=groups[s] or {}
            table.insert(groups[s],v)
        end
    end
    local ps={}
    for s,ends in pairs(groups) do
        assert(#ends==2,"Reset did not clear paths: "..s)
        ps[#ps+1]={label=s,a=ends[1],b=ends[2]}
    end
    table.sort(ps,function(a,b) return tonumber(a.label)<tonumber(b.label) end)
    assert(#ps>0,"No pairs found")
    return w,h,cells,ps
end
local function solveBoard()
    local board,inner=getBoard()
    assert(inner,"Open the puzzle first")
    local reset=board:FindFirstChild("Reset")
    assert(reset and visible(reset),"Reset button missing")
    log("Resetting paths")
    mouse(center(reset));waitFor(.08);down();waitFor(.08);release();waitFor(.4)
    assert(visible(inner),"Puzzle closed during reset")
    local w,h,cells,ps=read(inner)
    log("Solving "..w.."x"..h.." | "..#ps.." pairs")
    local original={}
    for v,o in ipairs(cells) do original[v]=o.Text end
    local deadline=os.clock()+40
    local paths,nodes=solveFlow(w,h,ps,function(n)
        check()
        assert(os.clock()<deadline,"Search timeout; nothing drawn")
        status.Text="Searching: "..n.." states"
        RS.Heartbeat:Wait()
    end)
    assert(paths,"No full solution found")
    local used={}
    for i,path in ipairs(paths) do
        assert(path[1]==ps[i].a and path[#path]==ps[i].b,"Invalid endpoints")
        for j,v in ipairs(path) do
            assert(not used[v] and v>=1 and v<=w*h,"Invalid path")
            used[v]=true
            if j>1 then
                local u=path[j-1]
                assert(math.abs((u-1)%w-(v-1)%w)+math.abs(math.floor((u-1)/w)-math.floor((v-1)/w))==1,"Invalid step")
            end
        end
    end
    for v=1,w*h do assert(used[v],"Unfilled cell") end
    assert(visible(inner),"Puzzle closed during search")
    for v,o in ipairs(cells) do assert(o.Parent==inner and o.Text==original[v],"Board changed; restart") end
    log("Solution verified | "..nodes.." states")
    local function closed()
        if visible(inner) then return false end
        release()
        waitFor(.3)
        assert(not visible(inner),"Puzzle changed while drawing; restart")
        log("Puzzle closed after connection; continuing")
        return true
    end
    for i,p in ipairs(ps) do
        check()
        if closed() then return w,h end
        log("Connecting "..p.label.." | "..i.." / "..#ps)
        local path=paths[i]
        mouse(center(cells[path[1]]));waitFor(.08);down();waitFor(.08)
        for j=2,#path do
            local a,b=center(cells[path[j-1]]),center(cells[path[j]])
            local steps=math.max(1,math.ceil((b-a).Magnitude/12))
            for k=1,steps do
                check()
                if closed() then return w,h end
                mouse(a:Lerp(b,k/steps))
                RS.RenderStepped:Wait()
            end
            waitFor(.035)
        end
        waitFor(.08);release();waitFor(.15)
        if closed() then return w,h end
    end
    local timeout=os.clock()+4
    repeat
        if closed() then return w,h end
        waitFor(.1)
    until os.clock()>timeout
    error("Paths drawn but puzzle still open; copy log",0)
end
local route={
    Vector3.new(558.58,36.91,2667.77),
    Vector3.new(551.24,43.58,2674.55),
    Vector3.new(558.67,39.52,2682.59),
    Vector3.new(583.37,38.21,2707.14),
    Vector3.new(583.19,-13.46,2707.18),
    Vector3.new(528.59,-14.29,2653.56),
    Vector3.new(529.29,-25.57,2652.93),
    Vector3.new(570.82,-26.49,2607.18),
    Vector3.new(565.32,-29.54,2567.99)
}
local V=Vector3.new
local parking=V(385.07,43.44,2588.6)
local deliveryParking=V(1878.36,37.76,-1676.21)
local approach={
    V(383.83,49.44,2588.59), V(383.98,119.83,2588.69),
    V(528.42,71.91,2627.63), V(558.69,37.78,2667.77)
}
local exitRoute={
    V(565.5,-27.64,2568.13), V(634.81,-4.95,2596.7),
    V(655.29,13.84,2607.37), V(612.22,31.62,2668.19),
    V(607.42,40.19,2643.16),
     
    V(604.03,36.57,2636.39),
    V(593.28,36.03,2618.90),
    V(593.27,36.37,2627.38),
    V(587.06,66.67,2621.76),
    V(388.87,44.52,2585.34)  
}
local deliveryRoute={
    V(1880.23,42.94,-1678.8), V(1741.06,54.12,-1587.83),
    V(1687.28,47.85,-1725.43), V(1656.55,45.92,-1806.45),
    V(1673.01,43.79,-1914.78), V(1689.68,44.15,-1983.86),
    V(1766.27,41.43,-2036.69)
}
local function characterParts()
    local c=P.Character
    return c,c and c:FindFirstChild("HumanoidRootPart"),
        c and c:FindFirstChildOfClass("Humanoid")
end
local function attachedCar()
    local c,r=characterParts()
    local vehicles=workspace:FindFirstChild("Vehicles")
    local a=r and r.AssemblyRootPart
    if a and vehicles and a:IsDescendantOf(vehicles)
        and not a:IsDescendantOf(c) then return a end
end
local function seats(car)
    local vehicles=workspace:FindFirstChild("Vehicles")
    assert(car and vehicles and car:IsDescendantOf(vehicles),"Vehicle disappeared")
    local model=car
    while model.Parent~=vehicles do model=model.Parent end
    local driver=model:FindFirstChild("Seat")
    assert(driver and driver:IsA("BasePart"),"Driver Seat part not found")
    local passengers={}
    for _,o in ipairs(model:GetDescendants()) do
        if o:IsA("BasePart") and o.Name:lower():find("passenger",1,true) then
            passengers[#passengers+1]=o
        end
    end
    assert(#passengers>0,"Passenger seat reference missing")
    return driver,passengers
end
local function driverState(car)
    local _,root,hum=characterParts()
    if attachedCar()~=car or not hum or not hum.Sit then return false end
    local driver,passengers=seats(car)
    local d=(root.Position-driver.Position).Magnitude
    local p=math.huge
    for _,o in ipairs(passengers) do p=math.min(p,(root.Position-o.Position).Magnitude) end
    return d<=2.75 and d+.25<p
end
local function tapE()
    check()
    keyHeld=true
    VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)
    waitFor(.15)
    VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
    keyHeld=false
end
local function leaveCar(car)
    endFlight()
    assert(attachedCar()==car,"Not attached to selected car")
    log("Leaving vehicle")
    tapE()
    local deadline=os.clock()+5
    while true do
        check()
        local _,_,h=characterParts()
        if not attachedCar() and not h.Sit then break end
        assert(os.clock()<deadline,"Could not leave vehicle")
        waitFor(.1)
    end
    waitFor(.35)
end
local function beginFlight(car)
    check()
    local c,root,hum=characterParts()
    assert(root and hum,"Character missing")
    if flight and flight.root==(car or root) then return end
    endFlight()
    root=car or root
    local f={character=c,root=root,hum=hum,foot=not car,objects={},collisions={},
        platform=hum.PlatformStand,rotate=hum.AutoRotate,
        seated=hum:GetStateEnabled(Enum.HumanoidStateType.Seated)}
    flight=f
    local function make(class)
        local o=Instance.new(class)
        f.objects[#f.objects+1]=o
        o.Parent=root
        return o
    end
    local a=make("Attachment")
    local velocity=make("LinearVelocity")
    velocity.Attachment0=a
    velocity.RelativeTo=Enum.ActuatorRelativeTo.World
    velocity.ForceLimitsEnabled=false
    velocity.VectorVelocity=Vector3.zero
    f.velocity=velocity
    local orientation=make("AlignOrientation")
    orientation.Mode=Enum.OrientationAlignmentMode.OneAttachment
    orientation.Attachment0=a
    orientation.RigidityEnabled=true
    orientation.CFrame=root.CFrame.Rotation
    f.orientation=orientation
    if f.foot then
        hum.Sit=false
        hum.AutoRotate=false
        hum.PlatformStand=true
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        f.connection=RS.Stepped:Connect(function()
            if not NOCLIP then return end
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    if f.collisions[p]==nil then f.collisions[p]=p.CanCollide end
                    p.CanCollide=false
                end
            end
        end)
    end
end
local function halt()
    if flight then
        flight.velocity.VectorVelocity=Vector3.zero
        flight.root.AssemblyLinearVelocity=Vector3.zero
    end
end
local function moveTo(target,speed)
    local f=flight
    assert(f,"Flight controller missing")
    local deadline=os.clock()+60
    local best=(target-f.root.Position).Magnitude
    local progress=os.clock()
    local command=Vector3.zero
    local stable=0
    while true do
        local dt=RS.Heartbeat:Wait()
        check()
        assert(flight==f and f.root.Parent,"Movement interrupted")
        if not f.foot then assert(attachedCar()==f.root,"Detached from vehicle") end
        local delta=target-f.root.Position
        local distance=delta.Magnitude
        if f.foot and distance<=.7 then halt();return end
        if not f.foot and distance<=1.5 and f.root.AssemblyLinearVelocity.Magnitude<=4 then
            stable=stable+dt
            if stable>=.15 then halt();return end
        else stable=0 end
        if distance<best-.4 then best=distance;progress=os.clock() end
        assert(os.clock()-progress<12,"Movement blocked; distance "..math.floor(distance))
        assert(os.clock()<deadline,"Movement timeout")
        if f.foot then
            local flat=V(delta.X,0,delta.Z)
            if flat.Magnitude>.1 then
                f.orientation.CFrame=CFrame.lookAt(Vector3.zero,flat.Unit)
            end
            if distance<=speed*math.min(dt,.05) then
                f.root.CFrame=CFrame.new(target)*f.root.CFrame.Rotation
                halt()
            else
                f.velocity.VectorVelocity=delta.Unit*speed
            end
        else
            local wanted=Vector3.zero
            if distance>.01 then
                wanted=delta.Unit*math.min(speed,math.sqrt(360*math.max(0,distance-.4)),distance*2.5)
            end
            local change=wanted-command
            local limit=140*math.min(dt,.1)
            if change.Magnitude>limit then change=change.Unit*limit end
            command=command+change
            f.velocity.VectorVelocity=command
        end
    end
end
local function walk(points,name,reverse)
    beginFlight()
    if reverse then
        for i=#points-1,1,-1 do
            log(name.." "..(i+10))
            moveTo(points[i],SPEED)
        end
    else
        for i,p in ipairs(points) do
            log(name.." "..i.." / "..#points)
            moveTo(p,SPEED)
        end
    end
end
local function boardDriver(car)
    endFlight()
    if attachedCar()==car then
        if driverState(car) then log("Driver position confirmed");return end
        leaveCar(car)
    end
    assert(not attachedCar(),"Attached to another vehicle")
    local offsets={3,2.3,3.5}
    for attempt=1,3 do
        log("Driver seat entry "..attempt.." / 3")
        local driver=seats(car)
        local localSeat=car.CFrame:PointToObjectSpace(driver.Position)
        assert(math.abs(localSeat.X)>.3,"Driver side ambiguous")
        local side=localSeat.X<0 and -1 or 1
        local target=car.CFrame:PointToWorldSpace(localSeat+V(side*offsets[attempt],0,0))+V(0,3,0)
        beginFlight()
        moveTo(target,65)
        endFlight()
        waitFor(.4)
        local _,root=characterParts()
        local d,passengers=seats(car)
        for _,p in ipairs(passengers) do
            assert((root.Position-d.Position).Magnitude<(root.Position-p.Position).Magnitude,
                "Driver-side approach not confirmed")
        end
        tapE()
        local deadline=os.clock()+5
        local stable=nil
        repeat
            waitFor(.1)
            if driverState(car) then
                stable=stable or os.clock()
                if os.clock()-stable>=.3 then log("Driver position confirmed");return end
            else stable=nil end
        until os.clock()>deadline
        if attachedCar()==car then leaveCar(car)
        else
            local _,_,h=characterParts()
            assert(not attachedCar() and not h.Sit,"Unexpected seat")
        end
    end
    error("Driver seat not confirmed",0)
end
local function flyCar(car,target)
    assert(driverState(car),"Sit in the driver seat")
    local origin=car.Position
    if (origin-target).Magnitude>3 then
        local height=math.max(origin.Y,target.Y)+300
        beginFlight(car)
        log("Vehicle: climbing")
        moveTo(V(origin.X,height,origin.Z),120)
        log("Vehicle: cruising")
        moveTo(V(target.X,height,target.Z),280)
        log("Vehicle: descending")
        moveTo(target,90)
        endFlight()
    end
    waitFor(.4)
end
local function awaitPuzzle(name)
    halt()
    log("Waiting for "..name)
    local deadline=os.clock()+20
    while not getBoard() do
        waitFor(.1)
        assert(os.clock()<deadline,name.." did not open")
    end
    waitFor(.2)
end
local function run()
    cycleCharacter=P.Character
    waitFor(.3)
    selectedCar=attachedCar()
    assert(selectedCar and driverState(selectedCar),"Start while seated in the driver seat")
    log("Flying to plant")
    flyCar(selectedCar,parking)
    leaveCar(selectedCar)
    walk(approach,"Plant approach")
    awaitPuzzle("first puzzle")
    solveBoard()
    walk(route,"Underground route")
    awaitPuzzle("second puzzle")
    solveBoard()
    log("Updated exit route: 5 new points; final point is driver entry")
    walk(exitRoute,"Plant exit")
    boardDriver(selectedCar)
    log("Flying to delivery parking")
    flyCar(selectedCar,deliveryParking)
    leaveCar(selectedCar)
    walk(deliveryRoute,"Delivery route")
    log("Delivery point: waiting 3 seconds")
    halt()
    waitFor(3)
    walk(deliveryRoute,"Return point",true)
    boardDriver(selectedCar)
    log("FINISHED: driver confirmed; payout not automatically verified")
end
local focus=UIS.WindowFocusReleased:Connect(function()
    if busy then cancel=true;release();endFlight() end
end)
stop.Activated:Connect(function()
    if busy then cancel=true;release();endFlight() end
end)
copy.Activated:Connect(function()
    if setclipboard then setclipboard(table.concat(history,"\n"));status.Text="Log copied" end
end)
hubCapture(function()
    if busy or dead then return end
    busy,cancel=true,false
    history,t0={},os.clock()
    task.spawn(function()
        local ok,err=pcall(run)
        release();endFlight()
        if not ok and not dead then log("STOP: "..tostring(err)) end
        busy=false
    end)
end)
_G.PowerFlowCleanup=function()
    dead,cancel=true,true
    release();endFlight();focus:Disconnect();gui:Destroy()
end

gui.Enabled=false
return {Start=hubStart, Stop=function() cancel=true;release();endFlight() end, Busy=function() return busy end, Destroy=function() if _G.PowerFlowCleanup then _G.PowerFlowCleanup() end end, Log=function() return table.concat(history,'\n') end, Status=function() return status.Text end}
]====]
local BACKGROUND_PNG = "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"
 
local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local me = Players.LocalPlayer
assert(me, "Run this script on the client")
local playerGui = me:WaitForChild("PlayerGui")
local NAME = "UnifiedControlsV1"
for _, name in ipairs({NAME, "CameraAimPrototype", "MovementControlsPrototype", "ArrestPrototype"}) do
    local old = playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local S = {aim=false, esp=false, speed=false, auto=false}
local hubActive, hubEngine, hubStopping = nil,nil,false
local toggleJob, setNoclip
local noclipOn=false
local savedCollisions={}
local farmRows={}
local farmOpen=false
local radius, flySpeed, runSpeed = 280, 100, 60
local bindType, bindCode = "Keyboard", Enum.KeyCode.LeftAlt
local focused, stopped, capturing, waitRelease = true, false, false, false
local menuOpen, busy, ticket = true, false, 0
local target, flight, speedRoot, activePrompt, activeTool
local connections, overlays, seats, prompts, cooldowns = {}, {}, {}, {}, {}
local switches = {}
local refresh, seatFor
local drag = nil

local function connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(connections, c)
    return c
end
local function make(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props) do o[k] = v end
    if o:IsA("GuiBase2d") then o.AutoLocalize=false end
    o.Parent = parent
    return o
end
local gui = make("ScreenGui", {Name=NAME, ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=120}, playerGui)
local icon = make("TextButton", {
    Position=UDim2.fromOffset(16,60), Size=UDim2.fromOffset(54,54),
    BackgroundColor3=Color3.fromRGB(30,65,0),
    Text="F", Font=Enum.Font.GothamBlack, TextSize=46, TextColor3=Color3.fromRGB(162,255,44),
    TextStrokeColor3=Color3.fromRGB(20,80,0), TextStrokeTransparency=0,
}, gui)
make("UICorner", {CornerRadius=UDim.new(0,10)}, icon)
local panel = make("ScrollingFrame", {
    Position=UDim2.fromOffset(16,122), Size=UDim2.fromOffset(310,570),
    BackgroundColor3=Color3.fromRGB(24,27,34), BorderSizePixel=0,
    ScrollBarThickness=4, CanvasSize=UDim2.fromOffset(0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
}, gui)
make("UICorner", {CornerRadius=UDim.new(0,8)}, panel)
make("UIPadding", {PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10),
    PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10)}, panel)
make("UIListLayout", {Padding=UDim.new(0,7), SortOrder=Enum.SortOrder.LayoutOrder}, panel)
local Tween=game:GetService("TweenService")
local PURPLE=Color3.fromRGB(185,86,255)
local function glow(object)
    local outline=make("UIStroke",{Color=PURPLE,Thickness=1,Transparency=0.78,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},object)
    make("UICorner",{CornerRadius=UDim.new(0,7)},object)
    local function light(on)
        Tween:Create(outline,TweenInfo.new(.16),{Transparency=on and 0 or .78,Thickness=on and 2.5 or 1}):Play()
    end
    connect(object.MouseEnter,function() light(true) end)
    connect(object.MouseLeave,function() light(false) end)
end
glow(icon)
make("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(68,166,18)),ColorSequenceKeypoint.new(1,Color3.fromRGB(201,255,117))}),Rotation=90},icon)
panel.BackgroundTransparency=.35
panel.ScrollBarImageColor3=PURPLE
local background=make("ImageLabel",{Name="OriginalBackground",BackgroundColor3=Color3.fromRGB(27,62,0),BorderSizePixel=0,
    ScaleType=Enum.ScaleType.Tile,TileSize=UDim2.fromOffset(300,540),ZIndex=0},gui)
local function decode64(data)
    local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local map={};for i=1,#alphabet do map[alphabet:sub(i,i)]=i-1 end
    local output={}
    for i=1,#data,4 do
        local a,b=map[data:sub(i,i)] or 0,map[data:sub(i+1,i+1)] or 0
        local c,d=map[data:sub(i+2,i+2)] or 0,map[data:sub(i+3,i+3)] or 0
        local n=a*262144+b*4096+c*64+d
        output[#output+1]=string.char(math.floor(n/65536)%256)
        if data:sub(i+2,i+2)~="=" then output[#output+1]=string.char(math.floor(n/256)%256) end
        if data:sub(i+3,i+3)~="=" then output[#output+1]=string.char(n%256) end
    end
    return table.concat(output)
end
local assetNotice
local okAsset,assetError=pcall(function()
    local asset=getcustomasset or getsynasset
    assert(type(writefile)=="function" and type(asset)=="function","Local image functions unavailable")
    local filename="funstatov-menu-background.png"
    writefile(filename,decode64(BACKGROUND_PNG))
    background.Image=asset(filename)
end)
if not okAsset then
    assetNotice="Original background unavailable: this executor needs writefile and getcustomasset."
    local fallback=make("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=string.rep("funstatov  funstatov\n",25),
        TextColor3=Color3.fromRGB(81,190,14),TextSize=22,TextWrapped=true,ZIndex=0},background)
end
local infoOpen=false
local infoButton=make("TextButton",{Size=UDim2.fromOffset(25,25),Text="i",Font=Enum.Font.GothamBold,TextSize=18,
    TextColor3=PURPLE,BackgroundColor3=Color3.fromRGB(30,19,42),ZIndex=8},gui)
glow(infoButton)
make("UICorner",{CornerRadius=UDim.new(1,0)},infoButton)
local infoPanel=make("Frame",{Size=UDim2.fromOffset(310,350),BackgroundColor3=Color3.fromRGB(22,17,30),Visible=false,ZIndex=15},gui)
make("UICorner",{CornerRadius=UDim.new(0,12)},infoPanel)
make("UIStroke",{Color=PURPLE,Thickness=2},infoPanel)
make("TextLabel",{Position=UDim2.fromOffset(16,10),Size=UDim2.fromOffset(278,30),Text="EARLY ACCESS",Font=Enum.Font.GothamBold,
    TextSize=17,TextColor3=PURPLE,BackgroundTransparency=1,ZIndex=16},infoPanel)
make("TextLabel",{Position=UDim2.fromOffset(16,46),Size=UDim2.fromOffset(278,286),Text=[=[This script is in development. This is an early version and bugs may occur.

Auto Arrest requires the Police team. Auto Farm requires the Criminal team. If a robbery needs a keycard, keep it in slot 2.

Always sit in the driver's seat of a Camaro. Other vehicles are not supported. Always lock your car. If it disappears, the script will stop.

We recommend low-population or VIP servers.]=],TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
    Font=Enum.Font.Gotham,TextSize=14,TextColor3=Color3.fromRGB(236,225,245),BackgroundTransparency=1,ZIndex=16},infoPanel)
connect(infoButton.Activated,function() infoOpen=not infoOpen end)

local order = 0
local function row(class, props)
    order = order + 1
    props.LayoutOrder = order
    props.Size = props.Size or UDim2.new(1,-4,0,34)
    local object=make(class, props, panel)
    if object:IsA("GuiButton") then glow(object) end
    return object
end
local function label(text, height)
    return row("TextLabel", {Size=UDim2.new(1,-4,0,height or 32),
        BackgroundTransparency=1, Text=text, TextWrapped=true,
        TextColor3=Color3.new(1,1,1), TextSize=13})
end
label("FUNSTATOV", 24)
local bindButton = row("TextButton", {Text="Aim Bind", TextSize=14,
    TextColor3=Color3.new(1,1,1), BackgroundColor3=Color3.fromRGB(114,45,196)})
local function addSwitch(text, getter, action)
    local b = row("TextButton", {Text="", BackgroundColor3=Color3.fromRGB(39,44,54)})
    make("TextLabel", {Position=UDim2.fromOffset(8,0), Size=UDim2.new(1,-70,1,0),
        BackgroundTransparency=1, Text=text, TextXAlignment=Enum.TextXAlignment.Left,
        TextColor3=Color3.new(1,1,1), TextSize=14}, b)
    local track = make("Frame", {AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-8,0.5,0), Size=UDim2.fromOffset(44,22)}, b)
    make("UICorner", {CornerRadius=UDim.new(1,0)}, track)
    local knob = make("Frame", {AnchorPoint=Vector2.new(0,0.5),
        Size=UDim2.fromOffset(18,18), BackgroundColor3=Color3.new(1,1,1)}, track)
    make("UICorner", {CornerRadius=UDim.new(1,0)}, knob)
    table.insert(switches, {get=getter, track=track, knob=knob})
    connect(b.Activated, action)
    return b
end
local function field(text, initial, setter)
    local frame = row("Frame", {BackgroundTransparency=1})
    make("TextLabel", {Size=UDim2.new(0.57,0,1,0), BackgroundTransparency=1,
        Text=text, TextColor3=Color3.new(1,1,1), TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left}, frame)
    local box = make("TextBox", {Position=UDim2.new(0.6,0,0,0),
        Size=UDim2.new(0.4,0,1,0), BackgroundColor3=Color3.fromRGB(45,52,65),
        Text=tostring(initial), TextColor3=Color3.new(1,1,1), TextSize=14,
        ClearTextOnFocus=false}, frame)
    glow(box)
    connect(box.FocusLost, function()
        local n = tonumber(box.Text)
        if not n or n ~= n then n = initial end
        box.Text = tostring(setter(n))
    end)
end
local aimStatus, arrestStatus
local circle = make("Frame", {AnchorPoint=Vector2.new(0.5,0.5),
    Size=UDim2.fromOffset(radius*2,radius*2), BackgroundTransparency=1}, gui)
make("UICorner", {CornerRadius=UDim.new(1,0)}, circle)
local stroke = make("UIStroke", {Thickness=1.5, Color=Color3.new(1,1,1)}, circle)

local function team(player)
    return player.Team and not player.Neutral and string.lower(player.Team.Name) or ""
end
local function police() return team(me) == "police" end
local function criminal(player)
    local t = team(player)
    return player ~= me and player.Parent == Players and (t == "criminal" or t == "criminals")
end
local function info(player)
    local c = player.Character
    if not c or not c:IsDescendantOf(workspace) then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    local b = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or r
    if h and h.Health > 0 and r and r:IsA("BasePart") and b and b:IsA("BasePart") then
        return c,h,r,b
    end
end
local function enemy(player)
    if player == me or player.Parent ~= Players then return false end
    if me.Team and me.Team == player.Team and not me.Neutral and not player.Neutral then return false end
    local a,b = team(me),team(player)
    return not ((a == "criminal" or a == "criminals") and (b == "prisoner" or b == "prisoners"))
end
local function bindName()
    local names = {MouseButton1="Mouse 1", MouseButton2="Mouse 2", MouseButton3="Mouse 3",
        LeftAlt="Left Alt", RightAlt="Right Alt", LeftControl="Left Ctrl", RightControl="Right Ctrl",
        LeftShift="Left Shift", RightShift="Right Shift", CapsLock="Caps Lock"}
    return names[bindCode.Name] or bindCode.Name
end
local function held()
    if bindType == "Keyboard" then return Input:IsKeyDown(bindCode) end
    return Input:IsMouseButtonPressed(bindCode)
end
local function stopSpeed()
    local r = speedRoot
    speedRoot = nil
    if r and r.Parent then
        local h = r.Parent:FindFirstChildOfClass("Humanoid")
        if h and not h.Sit and not h.SeatPart then
            r.AssemblyLinearVelocity=Vector3.new(0,r.AssemblyLinearVelocity.Y,0)
        end
    end
end
local function stopFly()
    local f = flight
    flight = nil
    if f then
        f.v:Destroy(); f.o:Destroy(); f.a:Destroy()
        if f.h.Parent then f.h.AutoRotate=f.rotate; f.h.PlatformStand=f.platform end
        if f.r.Parent and not f.h.Sit and not f.h.SeatPart then
            f.r.AssemblyLinearVelocity=Vector3.zero
            f.r.AssemblyAngularVelocity=Vector3.zero
        end
    end
end
local function startFly()
    local c,h,r = info(me)
    local camera = workspace.CurrentCamera
    if not c or not camera or h.Sit or h.SeatPart or r.Anchored then
        aimStatus.Text="Fly unavailable: leave your seat first."; return
    end
    stopSpeed(); target=nil
    local a=make("Attachment", {}, r)
    local v=make("LinearVelocity", {Attachment0=a, RelativeTo=Enum.ActuatorRelativeTo.World,
        VelocityConstraintMode=Enum.VelocityConstraintMode.Vector, ForceLimitsEnabled=false,
        VectorVelocity=Vector3.zero}, r)
    local o=make("AlignOrientation", {Attachment0=a, Mode=Enum.OrientationAlignmentMode.OneAttachment,
        RigidityEnabled=true, CFrame=r.CFrame.Rotation}, r)
    flight={c=c,h=h,r=r,a=a,v=v,o=o,rotate=h.AutoRotate,platform=h.PlatformStand,heading=camera.CFrame.Rotation}
    h.AutoRotate=false; h.PlatformStand=true
end
local function releaseInteraction()
    local p,t = activePrompt,activeTool
    activePrompt=nil; activeTool=nil
    if p then pcall(function() p:InputHoldEnd() end) end
    if t then pcall(function() t:Deactivate() end) end
end
local function espVisibility()
    for _,e in pairs(overlays) do
        e.h.Enabled=S.esp
        e.gui.Enabled=S.esp
    end
end
local function toggleFeature(key)
    if hubActive and (key=="speed" or key=="fly" or key=="aim") then
        aimStatus.Text="Stop the active automation before changing movement or Aim."; return
    end
    if key=="fly" then
        if flight then stopFly() else startFly() end
    else
        S[key]=not S[key]
        if key=="speed" and not S.speed then stopSpeed() end
        if key=="esp" then espVisibility() end
    end
    refresh()
end
addSwitch("Aim", function() return S.aim end, function() toggleFeature("aim") end)
addSwitch("ESP / WH", function() return S.esp end, function() toggleFeature("esp") end)
addSwitch("Fly", function() return flight~=nil end, function() toggleFeature("fly") end)
addSwitch("Speed", function() return S.speed end, function() toggleFeature("speed") end)
addSwitch("Noclip", function() return noclipOn end, function()
    if hubActive then arrestStatus.Text="Stop automation before changing Noclip.";return end
    setNoclip(not noclipOn);refresh()
end)
addSwitch("Auto Arrest", function() return hubActive=="Auto Arrest" end, function() toggleJob("Auto Arrest") end)
local farmHeader=row("TextButton", {Text="Auto Farm     ∨",TextXAlignment=Enum.TextXAlignment.Left,
    TextColor3=Color3.new(1,1,1),TextSize=14,BackgroundColor3=Color3.fromRGB(39,28,55)})
connect(farmHeader.Activated,function()
    farmOpen=not farmOpen
    farmHeader.Text=farmOpen and "Auto Farm     ∧" or "Auto Farm     ∨"
    for _,r in ipairs(farmRows) do r.Visible=farmOpen end
end)
for _,name in ipairs({"Donut","Market","Gas Station","Casino","Jewelry","Oil Rig","Factory"}) do
    local job=name
    local r=addSwitch("  "..job,function() return hubActive==job end,function() toggleJob(job) end)
    r.Visible=false;farmRows[#farmRows+1]=r
end
field("Fly Speed", flySpeed, function(n) flySpeed=math.clamp(n,10,300); return flySpeed end)
field("Ground Speed", runSpeed, function(n) runSpeed=math.clamp(n,10,200); return runSpeed end)
aimStatus=label("", 46)
aimStatus.Visible=false
arrestStatus=label("", 92)
arrestStatus.Visible=false
connect(arrestStatus:GetPropertyChangedSignal("Text"),function() arrestStatus.Visible=arrestStatus.Text~="" end)


refresh=function()
    bindButton.Text=capturing and "Press a button... Esc cancels" or ("Aim Bind: "..bindName())
    for _,s in ipairs(switches) do
        local on=s.get()
        s.track.BackgroundColor3=on and Color3.fromRGB(170,70,255) or Color3.fromRGB(64,42,82)
        s.knob.Position=UDim2.new(0,on and 24 or 2,0.5,0)
    end
end
 
local lastHubLog=""
setNoclip=function(on)
    noclipOn=on
    if not on then
        for part,value in pairs(savedCollisions) do
            if part.Parent then part.CanCollide=value end
        end
        savedCollisions={}
    end
end
connect(Run.Stepped,function()
    if not noclipOn or hubActive then return end
    local c=me.Character
    if c then
        for _,p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                if savedCollisions[p]==nil then savedCollisions[p]=p.CanCollide end
                p.CanCollide=false
            end
        end
    end
end)
local function camaroDriver()
    local c,h,r=info(me)
    if not c then return nil,"Wait for your character to spawn." end
    local assembly=r.AssemblyRootPart
    local vehicles=workspace:FindFirstChild("Vehicles")
    if not h.Sit or not assembly or not vehicles or not assembly:IsDescendantOf(vehicles) then
        return nil,"First sit in your Camaro driver's seat."
    end
    local model=assembly
    while model.Parent and model.Parent~=vehicles do model=model.Parent end
    if model.Name:lower()~="camaro" then return nil,"Only Camaro is supported. Sit in your Camaro driver's seat." end
    local seat=model:FindFirstChild("Seat",true)
    if not seat or not seat:IsA("BasePart") or (r.Position-seat.Position).Magnitude>2.75 then
        return nil,"Sit in the driver's seat, not a passenger seat."
    end
    for _,p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") and p.Name:lower():find("passenger",1,true)
            and (r.Position-p.Position).Magnitude<=(r.Position-seat.Position).Magnitude then
            return nil,"Sit in the driver's seat, not a passenger seat."
        end
    end
    return model
end
local hubCar
local function stopJob(reason)
    if not hubEngine then return end
    hubStopping=true
    local ok,err=pcall(hubEngine.Stop)
    arrestStatus.Text=reason or "Stopping..."
    if not ok then arrestStatus.Text="Stop error: "..tostring(err) end
end
toggleJob=function(name)
    if hubActive==name then stopJob("Stopping "..name.."...");return end
    if hubActive then arrestStatus.Text="Stop "..hubActive.." before starting another automation.";return end
    local t=team(me)
    if name=="Auto Arrest" then
        if t~="police" then arrestStatus.Text="Join the Police team first.";return end
    elseif t~="criminal" and t~="criminals" then
        arrestStatus.Text="Join the Criminal team first.";return
    end
    local car,why=camaroDriver()
    if not car then arrestStatus.Text=why;return end
    if not focused or Input:GetFocusedTextBox() then arrestStatus.Text="Return to Roblox and close chat first.";return end
    local source=HUB_SOURCES[name]
    if not source then arrestStatus.Text="Module unavailable: "..name;return end
     
    stopFly();stopSpeed();setNoclip(false);S.speed=false;target=nil
    hubActive=name;hubCar=car;hubStopping=false
    refresh()
    local ok,err=pcall(function()
        assert(type(loadstring)=="function","This executor does not provide loadstring")
        local fn,compileError=loadstring(source,"Funstatov/"..name)
        assert(fn,compileError)
        hubEngine=fn()
        assert(type(hubEngine)=="table" and hubEngine.Start,"Invalid module")
        hubEngine.Start()
    end)
    if not ok then
        if hubEngine then pcall(hubEngine.Stop);pcall(hubEngine.Destroy) end
        hubEngine=nil;hubActive=nil;hubCar=nil;hubStopping=false
        arrestStatus.Text="Start failed: "..tostring(err)
        lastHubLog=arrestStatus.Text
    else arrestStatus.Text=name..": starting..." end
    refresh()
end
local hubPoll=0
connect(Run.Heartbeat,function(dt)
    hubPoll=hubPoll+dt;if hubPoll<.2 then return end;hubPoll=0
    local engine=hubEngine
    if not engine then return end
    local t=team(me)
    if not hubStopping and ((hubActive=="Auto Arrest" and t~="police")
        or (hubActive~="Auto Arrest" and t~="criminal" and t~="criminals")) then
        stopJob("Stopped: team changed.")
    end
    if not hubStopping and (not hubCar or not hubCar:IsDescendantOf(workspace)) then
        stopJob("Stopped: your Camaro is missing.")
    end
    local ok,running=pcall(engine.Busy)
    if not ok or not running then
        local statusOK,statusText=pcall(engine.Status)
        local logOK,logText=pcall(engine.Log)
        if logOK then lastHubLog=logText end
        if not hubStopping then arrestStatus.Text=statusOK and tostring(statusText) or "Automation finished." end
        pcall(engine.Destroy)
        hubEngine=nil;hubCar=nil;hubActive=nil;hubStopping=false
        refresh()
    elseif not hubStopping then
        local statusOK,statusText=pcall(engine.Status)
        if statusOK then arrestStatus.Text=hubActive.."\n"..tostring(statusText) end
    end
end)
connect(me.CharacterRemoving,function() setNoclip(false);stopJob("Stopped: character removed.") end)
if assetNotice then arrestStatus.Text=assetNotice end

local function layoutMenu()
    local camera=workspace.CurrentCamera
    if not camera then return end
    local view=camera.ViewportSize
    local x=math.clamp(icon.Position.X.Offset,8,math.max(8,view.X-62))
    local y=math.clamp(icon.Position.Y.Offset,8,math.max(8,view.Y-62))
    icon.Position=UDim2.fromOffset(x,y)
    local below=math.max(0,view.Y-y-70)
    local above=math.max(0,y-16)
    local desired=math.min(620,math.max(80,view.Y-90))
    local openAbove=below<desired and above>below
    local available=openAbove and above or below
    local height=math.min(desired,math.max(0,available))
    local width=math.min(310,math.max(1,view.X-16))
    local px=math.clamp(x,8,math.max(8,view.X-width-8))
    local py=openAbove and (y-8-height) or (y+62)
    panel.Size=UDim2.fromOffset(width,height)
    panel.Position=UDim2.fromOffset(px,py)
    background.Position=panel.Position;background.Size=panel.Size;background.Visible=menuOpen
    infoButton.Position=UDim2.fromOffset(px+width-33,py+5);infoButton.Visible=menuOpen
    infoPanel.Position=UDim2.fromOffset(math.clamp(px+width+8,8,math.max(8,view.X-320)),math.clamp(py,8,math.max(8,view.Y-360)))
    infoPanel.Visible=menuOpen and infoOpen
end
connect(icon.InputBegan,function(input)
    if capturing then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        drag={input=input,start=Vector2.new(input.Position.X,input.Position.Y),
            origin=Vector2.new(icon.Position.X.Offset,icon.Position.Y.Offset),moved=false}
        target=nil
    end
end)
connect(Input.InputChanged,function(input)
    if not drag then return end
    local mouse=drag.input.UserInputType==Enum.UserInputType.MouseButton1
    if (mouse and input.UserInputType==Enum.UserInputType.MouseMovement)
        or (not mouse and input==drag.input) then
        local delta=Vector2.new(input.Position.X,input.Position.Y)-drag.start
        if delta.Magnitude>=6 then drag.moved=true end
        if drag.moved then
            local pos=drag.origin+delta
            icon.Position=UDim2.fromOffset(pos.X,pos.Y)
            layoutMenu()
        end
    end
end)
connect(Input.InputEnded,function(input)
    if not drag then return end
    local mouse=drag.input.UserInputType==Enum.UserInputType.MouseButton1
    if (mouse and input.UserInputType==Enum.UserInputType.MouseButton1) or input==drag.input then
        local delta=Vector2.new(input.Position.X,input.Position.Y)-drag.start
        local wasDrag=drag.moved or delta.Magnitude>=6
        drag=nil
        if not wasDrag then menuOpen=not menuOpen; panel.Visible=menuOpen end
    end
end)
local capturedClick=false
connect(bindButton.MouseButton1Click, function()
    if capturedClick then capturedClick=false; return end
    capturing=true; target=nil; waitRelease=false
    aimStatus.Text="Press an aim key or mouse button. Esc cancels."
    refresh()
end)
local function register(o)
    if o:IsA("Seat") or o:IsA("VehicleSeat") then seats[o]=true end
    if o:IsA("ProximityPrompt") then prompts[o]=true end
end
for _,o in ipairs(workspace:GetDescendants()) do register(o) end
connect(workspace.DescendantAdded,register)
connect(workspace.DescendantRemoving,function(o) seats[o]=nil; prompts[o]=nil end)
seatFor=function(c,h)
    if h.SeatPart then return h.SeatPart end
    for seat in pairs(seats) do
        if seat.Occupant==h then return seat end
        local w=seat:FindFirstChild("SeatWeld")
        if w and w:IsA("JointInstance") and
            ((w.Part0 and w.Part0:IsDescendantOf(c)) or (w.Part1 and w.Part1:IsDescendantOf(c))) then return seat end
    end
end
local function attachedOutside(c,r)
    for _,part in ipairs(r:GetConnectedParts(true)) do
        if not part:IsDescendantOf(c) then return true end
    end
    return false
end
local function chooseAim(camera,anchor)
    local best,rankBest,distanceBest=nil,math.huge,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if enemy(p) then
            local c,h,_,b=info(p)
            if c then
                local point,onScreen=camera:WorldToViewportPoint(b.Position)
                local d=(Vector2.new(point.X,point.Y)-anchor).Magnitude
                if onScreen and point.Z>0 and d<=radius then
                    local seat=seatFor(c,h)
                    local rank=seat and (seat:IsA("VehicleSeat") and 1 or 2) or 3
                    if rank<rankBest or (rank==rankBest and d<distanceBest) then
                        best={p=p,c=c}; rankBest=rank; distanceBest=d
                    end
                end
            end
        end
    end
    return best
end
local function removeESP(p)
    local e=overlays[p]
    if e then e.h:Destroy(); e.gui:Destroy(); overlays[p]=nil end
end
local function updateESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=me then
            local c,h,r=info(p)
            local e=overlays[p]
            if e and (e.c~=c or not e.h.Parent or not e.gui.Parent) then removeESP(p); e=nil end
            if c then
                local anchor=c:FindFirstChild("Head") or r
                if not e then
                    local hi=make("Highlight", {Adornee=c, DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,
                        FillTransparency=0.75, OutlineTransparency=0}, c)
                    local bg=make("BillboardGui", {Adornee=anchor, AlwaysOnTop=true,
                        Size=UDim2.fromOffset(230,56), StudsOffsetWorldSpace=Vector3.new(0,3,0)}, playerGui)
                    local text=make("TextLabel", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
                        TextSize=14, TextStrokeTransparency=0.15, TextWrapped=true}, bg)
                    e={c=c,h=hi,gui=bg,text=text}; overlays[p]=e
                end
                local color=p.Team and not p.Neutral and p.TeamColor.Color or Color3.new(1,1,1)
                e.h.Enabled=S.esp; e.gui.Enabled=S.esp
                e.h.FillColor=color; e.h.OutlineColor=color; e.text.TextColor3=color; e.gui.Adornee=anchor
                e.text.Text=string.format("%s | %s\nHP: %d / %d",p.DisplayName,
                    p.Team and not p.Neutral and p.Team.Name or "No Team",
                    math.ceil(math.max(0,h.Health)),math.ceil(math.max(0,h.MaxHealth)))
            end
        end
    end
end

 
local function alive(t)
    return not stopped and S.auto and ticket==t and police() and focused and info(me)~=nil
end
local function pause(seconds,t)
    local finish=os.clock()+seconds
    repeat
        if not alive(t) then return false end
        task.wait(0.05)
    until os.clock()>=finish
    return alive(t)
end
local function cuffsFor(c)
    local containers={c}
    local backpack=me:FindFirstChildOfClass("Backpack")
    if backpack then table.insert(containers,backpack) end
    for _,container in ipairs(containers) do
        for _,o in ipairs(container:GetChildren()) do
            if o:IsA("Tool") and string.find(string.lower(o.Name),"cuff",1,true) then return o end
        end
    end
end
local function findPrompt(scope,action,root)
    if not scope then return end
    local best,dist=nil,math.huge
    for p in pairs(prompts) do
        if p.Enabled and p:IsDescendantOf(scope)
            and string.find(string.lower(p.ActionText.." "..p.Name),action,1,true) then
            local parent=p.Parent
            local pos
            if parent:IsA("Attachment") then pos=parent.WorldPosition
            elseif parent:IsA("BasePart") then pos=parent.Position
            elseif parent:IsA("Model") then pos=parent:GetPivot().Position end
            if pos then
                local d=(pos-root.Position).Magnitude
                if d<=p.MaxActivationDistance and d<dist then best=p; dist=d end
            end
        end
    end
    return best
end
local function usePrompt(p,t)
    if not alive(t) or not p.Parent or p.HoldDuration>5 then return false end
    activePrompt=p; p:InputHoldBegin()
    local ok=pause(p.HoldDuration+0.2,t)
    releaseInteraction()
    return ok
end
local function attempt(p,t)
    local own,h,r=info(me)
    local c,th,tr=info(p)
    if not own or not c or not criminal(p) or not alive(t) then return end
    if h.Sit or seatFor(own,h) or attachedOutside(own,r) then
        arrestStatus.Text="Paused: exit your vehicle manually."; return
    end
    if r.Anchored then arrestStatus.Text="Paused: your character is anchored."; return end
    local cuffs=cuffsFor(own)
    if not cuffs then arrestStatus.Text="No standard Handcuffs Tool found. Adapter needed."; return end
    h:EquipTool(cuffs)
    if not alive(t) then return end
    arrestStatus.Text="Moving near: "..p.DisplayName
    own:PivotTo(tr.CFrame*CFrame.new(3,1,0)); r.AssemblyLinearVelocity=Vector3.zero
    if not pause(0.4,t) then return end
    local current,_,root=info(p)
    if current~=c or not criminal(p) then arrestStatus.Text="Target changed. Moving on."; return end
    if (root.Position-r.Position).Magnitude>12 then
        arrestStatus.Text="Could not stay near target. Movement may be corrected."; return
    end
    local seat=seatFor(c,th)
    if seat or th.Sit then
        local vehicle=seat and seat:FindFirstAncestorOfClass("Model")
        local eject=findPrompt(c,"eject",r) or findPrompt(vehicle,"eject",r)
        if not eject then arrestStatus.Text="No standard Eject prompt found. Skipping vehicle."; return end
        arrestStatus.Text="Trying Eject: "..p.DisplayName
        if not usePrompt(eject,t) or not pause(0.4,t) then return end
        if seatFor(c,th) or th.Sit then arrestStatus.Text="Eject not confirmed. Skipping."; return end
    end
    for _=1,3 do
        if not alive(t) then return end
        if not criminal(p) then arrestStatus.Text="Target is no longer Criminal. Cause unverified."; return end
        local current,_,root=info(p)
        if current~=c or (root.Position-r.Position).Magnitude>12 then
            arrestStatus.Text="Target unavailable or out of range."; return
        end
        arrestStatus.Text="Trying arrest: "..p.DisplayName
        local prompt=findPrompt(c,"arrest",r)
        if prompt then
            if not usePrompt(prompt,t) then return end
        else
            if cuffs.Parent~=own then arrestStatus.Text="Handcuffs are not equipped."; return end
            local camera=workspace.CurrentCamera
            if camera and (root.Position-camera.CFrame.Position).Magnitude>0.01 then
                camera.CFrame=CFrame.lookAt(camera.CFrame.Position,root.Position)
            end
            activeTool=cuffs; cuffs:Activate()
            if not pause(0.2,t) then releaseInteraction(); return end
            releaseInteraction()
        end
        if not pause(0.7,t) then return end
    end
    arrestStatus.Text=criminal(p) and "Arrest not confirmed. Game-specific adapter needed."
        or "Target is no longer Criminal. Cause unverified."
end
local function nextCriminal()
    local best,oldest=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        local last=cooldowns[p] or -math.huge
        if criminal(p) and info(p) and last+15<=os.clock() and (not best or last<oldest) then
            best=p; oldest=last
        end
    end
    return best
end
task.spawn(function()
    while not stopped do
        if S.auto then
            local t=ticket
            local ok,err=pcall(function()
                local c,h,r=info(me)
                if not police() then arrestStatus.Text="Paused: join the Police team."; return end
                if not c then arrestStatus.Text="Paused: waiting for your character."; return end
                if not focused then arrestStatus.Text="Paused: return to the game window."; return end
                if capturing or Input:GetFocusedTextBox() or GuiService.MenuIsOpen then return end
                busy=true; target=nil
                if h.Sit or seatFor(c,h) or attachedOutside(c,r) then
                    arrestStatus.Text="Paused: exit your vehicle manually. No jump attempts."
                    return
                end
                if h.PlatformStand or r.Anchored then arrestStatus.Text="Paused: character movement is restricted."; return end
                local p=nextCriminal()
                if p then
                    cooldowns[p]=os.clock()
                    attempt(p,t)
                    pause(3,t)
                else arrestStatus.Text="Waiting for an available Criminal..." end
            end)
            busy=false; releaseInteraction()
            if not ok then
                warn("[Auto Arrest] "..tostring(err))
                arrestStatus.Text="Attempt error: "..string.sub(tostring(err),1,130)
                task.wait(2)
            end
        end
        task.wait(0.5)
    end
end)

connect(Input.InputBegan,function(input,processed)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then capturedClick=false end
    local key=input.KeyCode
    if capturing then
        if key==Enum.KeyCode.Escape then capturing=false; refresh(); return end
        local kind,code
        if input.UserInputType==Enum.UserInputType.Keyboard and key~=Enum.KeyCode.Unknown then
            kind,code="Keyboard",key
        elseif input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.MouseButton2
            or input.UserInputType==Enum.UserInputType.MouseButton3 then kind,code="Mouse",input.UserInputType end
        if kind then
            bindType,bindCode=kind,code; capturing=false; waitRelease=true; target=nil
            capturedClick=input.UserInputType==Enum.UserInputType.MouseButton1; refresh()
        end
        return
    end

end)
connect(Input.InputEnded,function(input)
    if (bindType=="Keyboard" and input.KeyCode==bindCode)
        or (bindType=="Mouse" and input.UserInputType==bindCode) then target=nil; waitRelease=false end
end)
connect(Input.WindowFocusReleased,function()
    focused=false; ticket=ticket+1; target=nil; capturing=false; drag=nil
    releaseInteraction(); stopFly(); stopSpeed(); refresh()
end)
connect(Input.WindowFocused,function() focused=true end)
connect(me.CharacterRemoving,function()
    ticket=ticket+1; target=nil; releaseInteraction(); stopFly(); stopSpeed(); refresh()
end)
connect(me:GetPropertyChangedSignal("Team"),function() ticket=ticket+1; releaseInteraction() end)
connect(Players.PlayerRemoving,function(p)
    removeESP(p); cooldowns[p]=nil
end)
local function down(k) return Input:IsKeyDown(k) and 1 or 0 end
connect(Run.PreSimulation,function()
    if stopped then return end
    local c,h,r=info(me)
    if not c then if flight then stopFly(); refresh() end; stopSpeed(); return end
    local canMove=focused and not hubActive and not S.auto and not capturing and not drag
        and not Input:GetFocusedTextBox() and not GuiService.MenuIsOpen
    if flight then
        local f=flight
        if f.c~=c or h.Sit or h.SeatPart or r.Anchored or not f.v.Parent or not f.o.Parent then
            stopFly(); refresh(); return
        end
        local camera=workspace.CurrentCamera
        if camera and not target then f.heading=camera.CFrame.Rotation end
        local move=Vector3.zero
        if canMove then
            move=f.heading.LookVector*(down(Enum.KeyCode.W)-down(Enum.KeyCode.S))
                +f.heading.RightVector*(down(Enum.KeyCode.D)-down(Enum.KeyCode.A))
                +Vector3.yAxis*(down(Enum.KeyCode.Space)-down(Enum.KeyCode.LeftControl))
        end
        if move.Magnitude>1 then move=move.Unit end
        f.v.VectorVelocity=move*flySpeed
        local look=f.heading.LookVector
        local flat=Vector3.new(look.X,0,look.Z)
        if flat.Magnitude>0.001 then f.o.CFrame=CFrame.lookAt(Vector3.zero,flat.Unit) end
        return
    end
    if canMove and S.speed and h.FloorMaterial~=Enum.Material.Air
        and not h.Sit and not h.SeatPart and not h.PlatformStand and not r.Anchored then
        local d=Vector3.new(h.MoveDirection.X,0,h.MoveDirection.Z)
        if d.Magnitude>0.01 then
            local v=d.Unit*runSpeed
            r.AssemblyLinearVelocity=Vector3.new(v.X,r.AssemblyLinearVelocity.Y,v.Z); speedRoot=r
        else stopSpeed() end
    elseif h.FloorMaterial==Enum.Material.Air then speedRoot=nil
    else stopSpeed() end
end)
local timer=0
connect(Run.Heartbeat,function(dt)
    timer=timer+dt
    if timer>=0.1 then timer=0; if S.esp then updateESP() end end
end)
local function overMenu()
    local p=Input:GetMouseLocation()
    local function inside(o)
        local a,s=o.AbsolutePosition,o.AbsoluteSize
        return p.X>=a.X and p.X<=a.X+s.X and p.Y>=a.Y and p.Y<=a.Y+s.Y
    end
    return inside(icon) or (menuOpen and inside(panel))
end
Run:BindToRenderStep(NAME,Enum.RenderPriority.Last.Value+1,function()
    local camera=workspace.CurrentCamera
    if stopped or not camera then return end
    layoutMenu()
    local c,h=info(me)
    local special=flight~=nil
    if h then
        local state=h:GetState()
        special=special or h.Sit or h.SeatPart~=nil or state==Enum.HumanoidStateType.Freefall
            or state==Enum.HumanoidStateType.Flying
    end
    local anchor=camera.ViewportSize*0.5
    if special then
        local p=Input:GetMouseLocation()
        anchor=Vector2.new(math.clamp(p.X,0,camera.ViewportSize.X),math.clamp(p.Y,0,camera.ViewportSize.Y))
    end
    circle.Visible=S.aim
    circle.Position=UDim2.fromOffset(anchor.X,anchor.Y); stroke.Color=Color3.new(1,1,1)
    if capturing then target=nil; return end
    if waitRelease then target=nil; if not held() then waitRelease=false end; return end
    if hubActive or not S.aim or not focused or busy or drag or not c or Input:GetFocusedTextBox()
        or GuiService.MenuIsOpen or not held() or (bindType=="Mouse" and overMenu()) then
        target=nil; aimStatus.Text="Hold "..bindName().." to aim.\n"..(special and "Cursor Mode" or "Center Mode"); return
    end
    if target and (not enemy(target.p) or info(target.p)~=target.c) then target=nil end
    if not target then target=chooseAim(camera,anchor) end
    if not target then aimStatus.Text="No valid target inside the circle."; return end
    local _,_,_,body=info(target.p)
    if not body then target=nil; return end
    local pos=camera.CFrame.Position
    if (body.Position-pos).Magnitude>0.01 then
        local goal=CFrame.lookAt(pos,body.Position)
        if special then
            local ray=camera:ViewportPointToRay(anchor.X,anchor.Y)
            local direction=camera.CFrame:VectorToObjectSpace(ray.Direction)
            goal=goal*CFrame.lookAt(Vector3.zero,direction).Rotation:Inverse()
        end
        camera.CFrame=goal; stroke.Color=Color3.fromRGB(90,255,140)
        aimStatus.Text="Body: "..target.p.DisplayName.."\nRelease "..bindName().." to change target."
    end
end)
connect(gui.Destroying,function()
    stopped=true; ticket=ticket+1; releaseInteraction()
    setNoclip(false)
    if hubEngine then pcall(hubEngine.Stop);pcall(hubEngine.Destroy) end
    _G.FunstatovCleanup=nil
    Run:UnbindFromRenderStep(NAME)
    for _,c in ipairs(connections) do c:Disconnect() end
    stopFly(); stopSpeed()
    for _,e in pairs(overlays) do e.h:Destroy(); e.gui:Destroy() end
end)
refresh()

_G.FunstatovCleanup=function() gui:Destroy() end
