pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--main engine functions

function _init()
	cls(0)
	player_x, player_y, xsp, ysp = 64,64,0,0
	jmp, jmpcool = false, 0
	grnd,dead = true,false
	jmpclim = 5
	t = 0
end

function _draw()
	cls(12)
	spr(1,player_x,player_y)
	--debug vars
	debug()

end

function _update60()
	move_player()
	
	if player_y >= 128 then
		dead = true
	end
	
	--debugging ground
	if player_y >= 100 then
		player_y = 100
		grnd = true
	end
	
	
	--t is my counter, dude
	t = t + 1
	if (t == 60) then
		t = 0
	end
end
-->8
--player movement code
function move_player()

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

--sprinting?
--	if btn(5) and xsp > 0 then
--		xsp = 2
--	elseif btn(5) and xsp < 0 then
--		xsp = -2
--	end
	
--move x
player_x = player_x + xsp

--gravity
if grnd then
	ysp = 0
else
	--accel limit?
	if t%2 == 0 then
		if ysp < 5 then
			ysp = ysp + 1
		end
	end
end

--jump logic
if jmpcool > 0 and grnd then
	jmpcool = jmpcool - 1
	jmp = false
elseif(btn(4)) and grnd and jmpcool == 0 then
	if jmp == false then
		jmpcool = jmpclim
	end
	ysp = - 5
	jmp = true
	grnd = false
end

--move y
player_y = player_y + ysp


end
-->8
--debug
function debug()
	print(player_x)
	print(player_y)
	print("grnd = " ..tostr(grnd))
	print("jmp = " ..tostr(jmp))
	print("jmpcool = " ..tostr(jmpcool))
end
__gfx__
00000000c9c333ccc9c333ccc9c333ccc9c333ccc9c333ccc9c333ccffccccffcccccccc55555555000000000000000000000000000000000000000000000000
06000060c89bb33cc89bb33cc89bb33cc89bb33cc89bb33cc89bb33cfccccfffcccccccc05050500000000000000000000000000000000000000000000000000
00700700c3bb7b7cc3bb7b7cc3bb7b7cc3bb7b7cc3bb7b7cc3bb7b7cccccffffcccccccc5c5c5ff5000000000000000000000000000000000000000000000000
600770063bb7373c3bb7373c3bb7373c3bb7373c3bb7373c3bb7373ccccfffffcccccccccccfffff000000000000000000000000000000000000000000000000
060770603bbb7b733bbb7b733bbb7b733bbb7b733bbb7b733bbb7b73ccfffffcccccccccccfffffc000000000000000000000000000000000000000000000000
007007003b3bb3b33b3bb3b33b3bb3b33b3bb3b33b3bb3b33b3bb3b3cfffffcccccccccccfffffcc000000000000000000000000000000000000000000000000
00000000c3bbbb3cc3bbbb3cc3bbbb3cc3bbbb3cc3bbbb3cc3bbbb3cfffffcccccccccccfffffccc000000000000000000000000000000000000000000000000
00000000663333666633336666333366663333666633336666333366ffffccccccccccccffffcccc000000000000000000000000000000000000000000000000
__gff__
0000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808080808080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080808090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808010808080808070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0707070707070707070707070707070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
86010b002b65037650306502865024650206502a6502c6502d6502f65032650156503365035650366503765037650386503865039650396500065001650036500d650076500a6503165031650306502d65000000
