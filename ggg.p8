pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--main engine functions

function _init()
	cls(0)
	_player()
	_star()
	--game parameters
	grav = 8
	--cooldown set, height set, starting cd
	jmpclim,jmplim  = 8,0
	--counter
	t = 0
end

function _update60()
	--you fell into a pit
	if player_y >= 128 then
		dead = true
	end
	--process actors
	update_player()
	update_star()
	animate_player()
	animate_star()
	
	--debugging ground
	if player_y >= 104 then
		player_y = 104
		grnd = true
	end
	
	--t is my counter, dude
	t = t + 1
	if (t < 0) then
		t = 0
	end
	
function _draw()
	cls(12)
	map(0,0,0,64)
	spr(player_spr,player_x,player_y,1,1,player_dir)
	if star_exists or star_charging then
		spr(star_spr,star_x,star_y)
	end
	--debug vars
	debug()
end

end
-->8
--player movement and actions
function update_player()

	if btn(1) then --➡️ wins!
		xsp = 1
	--	if btn(1) then
	--		xsp = 0
	--	end
	elseif btn(0) then
			xsp = -1
	else
			xsp = 0
	end

--check direction/flip sprite
	if xsp > 0 then
		player_dir = false
	elseif xsp < 0 then
		player_dir = true
	end
	
--move x
player_x = player_x + xsp

--gravity
if grnd then
	ysp = 0
else
	--accel limit?
	if t%grav == 0 then
		if ysp < 5 then
			ysp = ysp + 1
		end
	end
end

--jump logic
--cooldown on the ground
if jmpcool > 0 and grnd then
	jmpcool = jmpcool - 1
	jmp = false
end
--first time button pressed
if(btn(4)) and grnd and jmpcool == 0 then
	if jmp == false then
		jmpcool = jmpclim
		--play sound on jump?--
	end
	ysp = -2
	jmp = true
	grnd = false
	jmplim = 0
end
--holding down the jmp button in air
if jmp and btn(4) and jmplim < 10 then
	ysp = -2
	jmplim += 1
else
--no double jumping
	jmplim = 99
end

--move y
player_y = player_y + ysp

end

function update_star()
--button initially pressed
	if not star_exists then
		if btn(5) then
			if star_stup < 45 then
				star_stup += 1
				star_charging = true
				star_x = player_x
				star_y = player_y-8
			elseif star_stup >= 45 then
				star_stup = 0
				star_exists = true
				star_x = player_x
				star_y = player_y-8
			end
		else
			star_stup = 0
			star_charging = false
			stxsp = 0
			stysp = 0
		end
--star already exists and button held
	elseif btn(5) and star_cnt==0 and star_charging then 
		star_x = player_x
		star_y = player_y-8
--star release	
	elseif star_charging and star_cnt==0 then
		star_cnt = starlim
		if player_dir then
			stxsp = -2
		else
			stxsp = 2
		end
		stysp = 1
		star_charging = false
	elseif star_cnt > 0 then
--star physics hack
		if star_y > 104 then
			stysp = -1
		end
--move star x and y
		star_x += stxsp
		star_y += stysp
		star_cnt -= 1
	else
--kill star
		star_exists = false
	end
end
-->8
--animation
function animate_player()
--state 0: idle
	if xsp == 0 and ysp == 0 and jmpcool == 0 then
		player_spr = 1
--state 1: walking on flat grnd
	elseif xsp != 0 and grnd and jmpcool == 0 then
	--ani speed
		if t%8 == 0 then
			player_spr += 1
			--clamp animation
			if player_spr > 3 then
				player_spr = 1
			end
		end
--state 2: jmping up
	elseif jmp and ysp < 0 then
		player_spr = 4
--state 3: falling
	elseif jmp and ysp > 0 then
		player_spr = 5
--state 4: jmp recovery
	elseif grnd and jmpcool > 0 then
		player_spr = 6
	end
end

function animate_star()
--state 0: charging star up
	if star_charging and star_stup>0 then
	--ani speed
		if t%10 == 0 then
			star_spr += 1
			--clamp animation
			if star_spr > 18 then
				star_spr = 17
			end
		end
--state 1: ready to fire, flash
	elseif star_charging then
	--ani speed
		if t%30 == 0 then
			star_spr = 19
		elseif t%15 == 0 then
			star_spr = 16
		end
--state 2: star flying, static
	else
		star_spr = 16
	end
end
-->8
--object code
function _player()
	--define player obj data
	player_x, player_y, xsp, ysp = 10,104,0,0
	player_spr, player_dir = 1,false
	jmp, jmpcool = false,0
	grnd, dead = true,false
end

function _star()
	--define star obj data
	star_x, star_y, stxsp, stysp = 0,0,0,0
	star_spr, star_exists = 16, false
	starlim, star_cnt, star_stup = 120,0,0
	star_charging = false
end
-->8
--soundfx
function sound()
	sfx(0)
end
-->8
--debug
function debug()
	print(player_x)
	print(player_y)
	print("grnd = " ..tostr(grnd))
	print("jmp = " ..tostr(jmp))
	print("ysp " ..tostr(ysp))
	print("star " ..tostr(star_exists))
	print("stup " ..tostr(star_stup))
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
cccacccaaaccccaacaccaccaccc9ccc9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
accaccacaacaccaaaaaccaaa9cc9cc9c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cacacaccccccaccccaaccaacc9c9c9cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaaccccacccccaaacccccccc999ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaaaaaaaccccccccccaacaaa99999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccaaacccccccccccccaacaaacc999ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cacacaccaaacacaacaaccaacc9c9c9cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
accaccacaaccccaacacaccac9cc9cc9c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
