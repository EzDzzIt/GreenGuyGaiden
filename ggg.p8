pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--main engine functions

function _init()
	cls(0)
--setup object arrays
	player={}
	star={}
	_setup_player(player)
	_setup_star(star)
--game parameters
	grav = 8
	--cooldown limit, jmp height limit
	jmpclim,jmplim  = 8,0
	--counter
	t = 0
end

function _update60()
	--you fell into a pit
	if player.y >= 128 then
		player.dead = true
	end
	--process actors
	update_player()
	update_star()
	animate_player()
	animate_star()
	
	--debugging ground
	if player.y >= 104 then
		player.y = 104
		player.grnd = true
	end
	
	--t is my counter, dude
	t = t + 1
	if (t < 0) then
		t = 0
	end
	
function _draw()
	cls(12)
	map(0,0,0,64)
	spr(player.spr,player.x,player.y,1,1,player.dir)
	if star.exists or star.charging then
		spr(star.spr,star.x,star.y)
	end
	--debug vars
	debug()
end

end
-->8
--player movement and actions
function update_player()

	if btn(1) then --➡️ wins! lol
		player.xsp = 1
	elseif btn(0) then
			player.xsp = -1
	else
			player.xsp = 0
	end

--check direction/flip sprite
	if player.xsp > 0 then
		player.dir = false
	elseif player.xsp < 0 then
		player.dir = true
	end
	
--move x
player.x = player.x + player.xsp

--gravity
if player.grnd then
	player.ysp = 0
else
	--accel limit?
	if t%grav == 0 then
		if player.ysp < 5 then
			player.ysp+=1
		end
	end
end

--jump logic
--cooldown on the ground
if player.jmpcool > 0 and player.grnd then
	player.jmpcool = player.jmpcool - 1
	player.jmp = false
end
--first time button pressed
if(btn(4)) and player.grnd and player.jmpcool == 0 then
	if player.jmp == false then
		player.jmpcool = jmpclim
		--play sound on jump?--
	end
	player.ysp=-2
	player.jmp=true
	player.grnd=false
	jmplim=0
end
--holding down the jmp button in air
if player.jmp and btn(4) and jmplim < 10 then
	player.ysp=-2
	jmplim+=1
else
--no double jumping
	jmplim=99
end

--move y
player.y+=player.ysp

end

function update_star()
--button initially pressed
	if not star.exists then
		if btn(5) then
			if star.stup <45 then
				star.stup+=1
				star.charging = true
				star.x= player.x
				star.y= player.y-8
			elseif star.stup >= 45 then
				star.stup = 0
				star.exists = true
				star.x = player.x
				star.y = player.y-8
			end
		else
			star.stup = 0
			star.charging = false
			star.xsp = 0
			star.ysp = 0
		end
--star already exists and button held
	elseif btn(5) and star.cnt==0 and star.charging then 
		star.x = player.x
		star.y = player.y-8
--star release	
	elseif star.charging and star.cnt==0 then
		star.cnt = star.lim
		if player.dir then
			star.xsp = -2
		else
			star.xsp = 2
		end
		star.ysp = 1
		star.charging = false
	elseif star.cnt > 0 then
--star physics hack
		if star.y > 104 then
			star.ysp = -1
		end
--move star x and y
		star.x+=star.xsp
		star.y+=star.ysp
		star.cnt-=1
	else
--kill star
		star.exists = false
	end
end
-->8
--animation
function animate_player()
--state 0: idle
	if player.xsp == 0 and player.ysp == 0 and player.jmpcool == 0 then
		player.spr = 1
--state 1: walking on flat grnd
	elseif player.xsp != 0 and player.grnd and player.jmpcool == 0 then
	--ani speed
		if t%8 == 0 then
			player.spr += 1
			--clamp animation
			if player.spr > 3 then
				player.spr = 1
			end
		end
--state 2: jmping up
	elseif player.jmp and player.ysp < 0 then
		player.spr = 4
--state 3: falling
	elseif player.jmp and player.ysp > 0 then
		player.spr = 5
--state 4: jmp recovery
	elseif player.grnd and player.jmpcool > 0 then
		player.spr = 6
	end
end

function animate_star()
--state 0: charging star up
	if star.charging and star.stup>0 then
	if star.stup == 1 then
		star.spr = 17
	end
	--ani speed
		if t%10 == 0 then
			star.spr += 1
			--clamp animation
			if star.spr > 18 then
				star.spr = 17
			end
		end
--state 1: ready to fire, flash
	elseif star.charging then
	--ani speed
		if t%30 == 0 then
			star.spr = 19
		elseif t%15 == 0 then
			star.spr = 16
		end
--state 2: star flying, static
	else
--ani speed
		if t%30 == 0 then
			star.spr = 20
		elseif t%15 == 0 then
			star.spr = 16
		end
	end
end
-->8
--object code
function _setup_player(player)
	--define player obj data
	player.x=10
	player.y=104
	player.xsp=0
	player.ysp=0
	player.dir=false
	player.spr=1
	player.jmp=false
	player.jmpcool=0
	player.grnd=true
	player.dead=false
end

function _setup_star(star)	
	--define star obj data
	star.x=0
	star.y=0
	star.xsp=0
	star.ysp=0
	star.dir=false
	star.spr=16
	star.exists=false
	star.lim=45
	star.cnt=0
	star.stup=0
	star.charging=false
end
-->8
--soundfx
function sound()
	sfx(0)
end
-->8
--debug
function debug()
	print("stup: " .. tostr(star.stup))
	print("cnt: " .. tostr(star.cnt))
	print("star xsp: " .. tostr(star.xsp))
	
end
__gfx__
00000000c9c333ccc9c333ccc9c333ccc9c333ccc9c333ccccccccccffccccffcccccccc55555555cccccccc0000000000000000000000000000000000000000
06000060c89bb33cc89bb33cc89bb33cc897373cc89bbb33c9c333ccfccccfffcccccccc55555555cccccccc0000000000000000000000000000000000000000
00700700c3bb7b7cc3bb7b7cc3bb7b7cc3b7777c3bb7777bc89bb3ccccccffffcccccccc5c5c5ff5cccccccc0000000000000000000000000000000000000000
600770063bb7373c3bb7373c3bb7373c3bb7777c33b7373bc3b7773ccccfffffcccccccccccfffffc5c5c55c0000000000000000000000000000000000000000
060770603bbb7b733b3b7b7b3b3b7b73bb3b33b3c3bbbbb33bb7377cccfffffcccccccccccfffffcc555555c0000000000000000000000000000000000000000
007007003b3bb3b33bb3b3b33bb3b3b3333bbbb3cc3b33b33bbbbbb3cfffffcccccccccccfffffccc557575c0000000000000000000000000000000000000000
00000000c3bbbb3cc33bbbb6633bbbbcc36bb6b3c6bbbbb63b3bb3b3fffffcccccccccccfffffcccc555555c0000000000000000000000000000000000000000
0000000066333366c663336cc633336cc663366ccc63366cc36bb63cffffccccccccccccffffcccccc5cc5cc0000000000000000000000000000000000000000
cccacccaaaccccaacaccaccaccc9ccc9ccc7ccc70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
accaccacaacaccaaaaaccaaa9cc9cc9c7cc7cc7c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cacacaccccccaccccaaccaacc9c9c9ccc7c7c7cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaaccccacccccaaacccccccc999ccccc777ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaaaaaaaccccccccccaacaaa99999999777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaacccccccccccccaacaaacc999ccccc777ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cacacaccaaacacaacaaccaacc9c9c9ccc7c7c7cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
accaccacaaccccaacacaccac9cc9cc9c7cc7cc7c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
60010000015500655006550065500655007550075500755007550095500a5500d550115501455017550195501b5501c5501c5501b550195501755014550117500e7500c7500a7500875007750067500475004750
