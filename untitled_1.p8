pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _init()
	create_player()
	enemies={}
 enemies_1={}
	bullets={}
	gentils={}
	score=0
	state=0
	
	

end


function _update()
 player_movement()
 check_flag(flag,x,y)
 update_camera()
 update_enemies()
 update_enemies_1()
 update_bullets()
 interact(x,y)
	if #enemies==0 then
 	spawn_enemies(ceil(rnd(4)))
 end
 if #enemies_1==0 then
 	spawn_enemies_1(ceil(rnd(5)))
 end
 
 if btnp(❎) then
 	shoot()
 end
 
 update_recommencer()
end



function _draw()
 cls()
 
 --afficher map
 draw_map()
 
 --afficher player
 draw_player()
 
--afficher les gentils
  for g in all(gentils) do 
 	spr(g.sprite,g.x,g.y)
 end
 
 --enemies
 for e in all(enemies) do
 	spr(48,e.x,e.y)

 end
 
 
 for e in all(enemies_1) do
 	spr(12,e.x,e.y)
 	
 end
 

 
 --afficher balles
 for b in all(bullets) do
 	spr(18,b.x,b.y)
 end  
 
 print("score:"..score,34*8,1*8,15)
 
 if score > 500 then
 	print("bravo,",38*8,7*8,15)
 	print("ils sont libres d'etre !",34*8,8*8,15)
 end
 
 draw_state1()
 
end


-->8
--map

function draw_map()
	map(0,0,0,0,128,32)
end

function check_flag(flag,x,y)
 local sprite=mget(x,y)
 return fget(sprite,flag)
end

--decaler camera par section
function update_camera()
 camx=flr(p.x/16)*16
 camy=flr(p.y/16)*16
 camera(camx*8,camy*8)
end
-->8
--player

function create_player()
	p={
	x=1,y=5,
	sprite=1,
	ox=0,oy=0,
	start_ox=0,start_oy=0,
	anim_t=0,
	keys=0,
	win=0,
	}
end


function player_movement()
	newx=p.x
 newy=p.y
 interact(newx,newy)
 if p.anim_t==0 then
 	newox=0
 	newoy=0
  if btn(➡️) then 
  newx+=1
  newox=-8
  p.flip=false
 elseif btn(⬅️) then
  newx-=1
  newox=8
  p.flip=true
 elseif btn(⬆️) then
  newy-=1
  newoy=8
 elseif btn(⬇️) then
  newy+=1
  newoy=-8
 end
 end

    --checker si il y a un flag
 if not check_flag(0,newx,newy)
 and (p.x!=newx or p.y!=newy) then
    --empecher le perso d'aller sur un flag ou de depasser des bords
   p.x=mid(0,newx,128)
   p.y=mid(0,newy,15)
   p.start_ox=newox
   p.start_oy=newoy
   p.anim_t=1
   end
  
   
   --animation
  p.anim_t=max(p.anim_t-0.125,0)
  p.ox=p.start_ox*p.anim_t
  p.oy=p.start_oy*p.anim_t
  
  if p.anim_t>0.5 then
  	p.sprite=1
  	else
  		p.sprite=2
			end
end

function draw_player()
	spr(p.sprite,
	p.x*8+p.ox,p.y*8+p.oy,
	1,1,p.flip)
 
 spr(id,x,y,1,1,true)
end


-- interaction pour ramasser les cles 
function interact(x,y)
 if check_flag(1,x,y) then
 pick_up_key(x,y)
 elseif check_flag(2,x,y)then
 open_door(x,y)
 end
 
 --fin
 if p.x==72 and p.y==4 then
 	state=1
 else
 	state=0
 end	
end
-->8
--enemies

--amount = montant d'ennemy
function spawn_enemies(amount)
	gap=(128-8*amount)/(amount+1)
	for i=1,amount do	
		new_enemy={
			x=250+gap*i+8*i-1,
			y=-8,
			life=2,
		}
		add(enemies,new_enemy)
		
	end
end

function spawn_enemies_1(amount)
 gap1=(128-8*amount)/(amount+1)
	for i=1,amount do

	 new_enemy_1={
	  x=15*8+gap1*i+8*(i-1),
	  y=-8,
	  life=4,

 	}
	 add(enemies_1,new_enemy_1)
 end
end

--jusqu'ou vont les enemy et quand ils arrivent en fonction de p
function update_enemies()

	for e in all(enemies)do
		if p.x>33 and score <= 500 then
			e.y+=0.5
			else
			del(enemies,e)
		end
		if e.y>128 then
			del(enemies,e)
		end
		for b in all(bullets) do
			if collision(e,b) then
				del(bullets,b)
				e.life-=1
				if e.life==0 then
					del(enemies,e)
					gentil(e.x,e.y)
					score+=50

				end
			end
		end	
	end
end
--

function update_enemies_1()
	for e in all(enemies_1) do
	--if e.y<50 and p.x>33 then code mame
	 e.y+=0.5
	if e.y > 128 then
			del(enemies_1,e)
	 end	
		--collision
		
		for b in all(bullets) do
			if collision(e,b) then
				 del(bullets,b)
				e.life-=1
				if e.life==0 then
				 del(enemies_1,e)
				end
			end
		end
	end
end
-->8
--balles

function shoot()
	new_bullet={
		x=p.x*8,
		y=p.y*8,
		speed=4,
	}
	add(bullets,new_bullet)
end

function update_bullets()
	for b in all(bullets) do
		b.y-=b.speed
	end
end



-->8
--collisions

function collision(a,b)
	if a.x>b.x+8
	or a.y>b.y+8
	or a.x+8<b.x
	or a.y+8<b.y then
		return false
	else
		return true
	end	
end
-->8
--cles

function next_tile(x,y)
 sprite=mget(x,y)
 mset(x,y,sprite+1)
end

function pick_up_key(x,y)
 next_tile(x,y)
 p.keys+=1
end

function open_door(x,y)
 next_tile(x,y)
 p.keys-=1
end
-->8
--gentils

function gentil(x,y)
	if not check_flag(0,x/8,y/8) then
		toto=x
		tata=y
		else
		toto=aleatoire(33*8,46*8)
		tata=aleatoire(8*8,15*8)
	end
	
	gentil1={
				--x=aleatoire(36,46)*8,
				--y=aleatoire(0,15)*8,
		x=toto,
		y=tata,
		sprite=aleatoire(49,53),

		}
	add(gentils,gentil1)
	


end

--aleatoire entre a et b inclus
function aleatoire(a,b)
	return flr(rnd(b+1-a)+a)
end

	


-->8
--state 1

function draw_state1()
	if state==1 then
		cls(5)
		print ("merci sanema!",70*8,8*8,15)
		spr(aleatoire(49,53),aleatoire(67*8,78*8),aleatoire(0*8,16*8))
		spr(aleatoire(18,20),aleatoire(67*8,78*8),aleatoire(0*8,16*8))
		spr(aleatoire(49,53),aleatoire(67*8,78*8),aleatoire(0*8,16*8))
		spr(aleatoire(18,20),aleatoire(67*8,78*8),aleatoire(0*8,16*8))	
		spr(aleatoire(49,53),85*8,2*8)
		spr(aleatoire(18,20),70*8,4*8)
		spr(aleatoire(49,53),85*8,3*8)
		
		spr(49,(85*8)-(15*8),3*8)
		--spr(50, (86*8)-(15*8),3*8)
		spr(51,(87*8)-(15*8),3*8)
		--spr(52, (88*8)-(15*8),3*8)
		spr(53,(89*8)-(15*8),3*8)
		
		spr(18, (91*8)-(15*8),3*8)
		--spr(19,(91*8)-(15*8),4*8)
		spr(19, (92*8)-(15*8),5*8)
		--spr(49,(93*8)-(15*8),6*8)
		
		spr(50,(93*8)-(15*8),7*8)
		--spr(51,(93*8)-(15*8),8*8)
		spr(52,(93*8)-(15*8),9*8)
		--spr(53,(93*8)-(15*8),10*8)
		
		spr(18,(92*8)-(15*8),11*8)
		spr(50,(91*8)-(15*8),12*8)
		spr(19,(85*8)-(15*8),13*8)
		--spr(49,(86*8)-(15*8),13*8)
		
		spr(50,(87*8)-(15*8),13*8)
		--spr(51,(88*8)-(15*8),13*8)
		spr(52,(89*8)-(15*8),13*8)
		--spr(53,(90*8)-(15*8),13*8)
		
		spr(18,(83*8)-(15*8),12*8)
		--spr(19,(83*8)-(15*8),11*8)
		spr(19,(82*8)-(15*8),10*8)
		--spr(49,(82*8)-(15*8),9*8)
		
		spr(50,(82*8)-(15*8),8*8)
		--spr(51,(82*8)-(15*8),7*8)
		spr(52,(82*8)-(15*8),6*8)
		spr(53,(83*8)-(15*8),4*8)
		--spr(18,(84*8)-(15*8),6*8)

	print ("❎ pour recommencer",67*8,1*8)
	end
	
	
end

function update_recommencer()
	if state==1 and btn(❎) then
		_init()
	end
end

__gfx__
000000000002e000000e200055555555000000009999999966666666666666663333377777733333dddddddd33344333080000805550f5558888888888888888
0000000000eeee0000eeee0055555555000000009999999966666666656666563337788888877333dddddddd334444338bbbbbb8555ff5558888888888888888
007007000e2222e00e2222e05555555500000000999999996666666664666646337aa888888aa733dddddddd333553330b0bb0b05552f6669999999999999999
00077000e212212ee212212e55555555000000009999999966666666654664463378aaaaaaaa8733dddddddd333553300b0bb0b05522f6659999999999999999
00077000e222222ee222222e555555550000000099999999666666666644456637888aaaaaa88873dddddddd322445300bbbbbb05ffff655aaaaaaaaaaaaaaaa
00700700e122221ee122221e555555550000000099999999666666666665466637888aaaaaa88873dddddddd2244455500b00b005f666655aaaaaaaaaaaaaaaa
00000000ee1111eeee1111ee555555550000000099999999666666666664566637888aaaaaa88873dddddddd234444330b0000b0526016553333333333333333
000000000e0000e000e00e00555555550000000099999999666666666545445633788aaaaaa88733dddddddd3343343300000000555105553333333333333333
5522255500000000000000000888888052222225577557750000000000000000337aaa8888aaa733000000000000000000000000000000001111111111111111
552225550000000002200220044444405000022577555577000000000000000033377a8888a77333000000000000000000000000000000001111111111111111
5552555500000000020220228414414851010025755775570000000000000000333337777773333300000000000000000000000000000000cccccccccccccccc
5222225500000000200000020444444050000025557557550000000000000000333333222233333300000000000000000000000000000000cccccccccccccccc
55525555000000002000000204444440000000555575575500000000000000003333332222333333000000000000000000000000000000002222222222222222
55525555000000000200002009411490000100557557755700000000000000003333332222333333000000000000000000000000000000002222222222222222
5525255500000000002002000999999050000055775555770000000000000000333333222233333300000000000000000000000000000000dddddddddddddddd
5255525500000000000220000040040055000555577557750000000000000000333333222233333335555555555555530000000000000000dddddddddddddddd
000000000000000000000000555555553b8bb8b33333333333333333333333333555445554455553355555555555555333333777777333331111111100000000
22444411224444110000000055555555bbb8bb8b3333333335353535535353533555445554455553355600000000655333337777777733331111111100000000
240505412400004100000090555555558b8bb8bb3333333335555555555555533555445554455553356605666650665333337777777733331111111100000000
45050504450000540999990955555555bbbbbb8b3333333335555555555555533555555555555553355005600650055333337777777733331111111100000000
455555544500005409000090555555553b844bb33333333335554455544555533555555555555553355555500555555333333777777333331111111100000000
4505050445000054000000005555555533b44b333333333335554455544555533555445554455553356500600600565333330377773033331111111100000000
24050541240000410000000055555555333443333333333335554455544555533555445554455553356666666666665333330033330033331111111100000000
22444411224444110000000055555555344444433333333335555555555555533555445554455553356550000005565333333030030333331111111100000000
0033330055999555551115555588855555aaa55555ccc555355555555555555335555555555555533555556006555553333330000003333300aaaa0000000000
3353353355999555551115555588855555aaa55555ccc55535554455544555533555555555555553355055600655055333333330033333330a8888a000000000
30333303555955555551555555585555555a5555555c55553555445554455553355544555445555335500566665005533333333003333333a88aa88a00000000
305555035999995551111155588888555aaaaa555ccccc553555445554455553355544555445555335555555555555533333333003333333a8aaaa8a00000000
30533503555955555551555555585555555a5555555c55553555555555555553355544555445555335555555555555533333333003333333a8aaaa8a00000000
00111100555955555551555555585555555a5555555c55553555555555555553355555555555555335555544445555533333333003333333a88aa88a00000000
0011110055959555551515555585855555a5a55555c5c55535554455544555533555555555555553355554444445555333333330033333330a8888a000000000
001111005955595551555155585558555a555a555c555c55355544555445555335555555555555533555544444455553333333300333333300aaaa0000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
50505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
__gff__
0000000000000001010101010000010101000001010100000101000000000101040002000100000000000000010101000001010101010000000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
080925250a250a250a0707070707070707070707070707070707070707070707070303030303030303030303030303070307030303030303030303030303030303070707242424242424242424242424040505050505050505050505050505040505050505050505050505050505050505050505050505050505050505050505
181925250a0a0a0a0a2525070707070707070707070707070707070707070707070303030303030303030303030303030307030303030314030303030303030303070707242424242424242424242424050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
252525250a0a0b0a0a2525252507070707070704040404040404040404070707070303030303030303030303030303070307030303030303030303030303030303070707242525252525252525242424050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
252525250a0a250a0a252525252525070707040404040404040404040404070707030303030303030303030303030307030703140315151515150303140303030307242425252524242c2d2525252424050505050504040404040405050505050505050505050505050505050505050505050505050505050505050505050505
252525252525252525252525252525070704040404040404040404040404040707030303030303030303030303030307030703030315040404150303030303030307242525252524203c3d2525252524050505050405050505050504050505050505050505050505050505050505050505050505050505050505050505050505
2525252525250809252525252507070704040404040404040404040404040404070303030303030303030303030303070303030315150404041503030303030307072424242424242526272525252524050505040505050505050505040505050505050505050505050505050505050505050505050505050505050505050505
2525252525251819252525070707070704040404040404040404040404040404070303030303030303030303030303070303030320040413041503030303030322252525252525252536372525252524050504050505050505050505050405050505050505050505050505050505050505050505050505050505050505050505
2525252525252525070707070707070704040404040403040404040404040407070303030303030303030303030303070303030315150404041503030303070707242424242424242428292525252524050504050505050505050505050405050505050505050505050505050505050505050505050505050505050505050505
2508092525252525072525070707070704040404040303030404040404040404040303030303030303030303030303070703030303150404041503030307070707242525252525252538392525252524050504050505050505050505050405050505050505050505050505050505050505050505050505050505050505050505
251819070707070707070307070707070404040403030d032204040404040407070303030303030303030303030303070707031403151515151503140307070707242425252525252528292525252524050504050505050505050505050405050505050505050505050505050505050505050505050505050505050505050505
2525250725252525070707030707070704040404040303030404040404040707070303030303030303030303030303070707030303030303030303030307070707242425252525252538392525252524050504050505050505050505050405050505050505050505050505050505050505050505050505050505050505050505
25252503030707070707030303070707040404040404030404040404040707070703030303032e0e0f0e0f03030303070707030303030303030303030303070724242425252525252528292525252524050505040505050505050505040505050505050505050505050505050505050505050505050505050505050505050505
07030707030707070707030303030707040404040404040404040404070707070703030303032e1e1f1e1f0303030307070703030303030303030303030307072424252525252525252a2b2525252424050505050405050505050504050505050505050505050505050505050505050505050505050505050505050505050505
03070707030303030303030303030304040404040404040404040407070707070703030303032e030303030303030307070703030303031403030303030307072424252525252525253a3b2525242424050505050504040404040405050505050505050505050505050505050505050505050505050505050505050505050505
07030707070703040403030304040404040404040404040404040707070707070703030303032e0310100303030303070707030303030303030303030303070724242525252525252525252524242424050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
07070303030304030404040404040404040404040404040404070707070707070703030303032e2e2e2e2e03030303070707030303030303030303030303070724242424242424242424242424242424040505050505050505050505050505040505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050507070707070707070707070707070724242424242424242424242424242424040505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050507070707070707070707070707050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050707070707050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
0305050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004600000050000500015000050000500015000b6000360004600036000460000600006000460000000000000c000000000000000700007000070000000000000000000000000000000000000000000000000000
__music__
00 01424344

