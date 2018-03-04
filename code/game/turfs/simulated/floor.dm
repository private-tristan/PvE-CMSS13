//This is so damaged or burnt tiles or platings don't get remembered as the default tile
var/list/icons_to_ignore_at_floor_init = list("damaged1", "damaged2", "damaged3", "damaged4",
											  "damaged5", "panelscorched", "floorscorched1", "floorscorched2", "platingdmg1", "platingdmg2",
											  "platingdmg3", "plating", "light_on", "light_on_flicker1", "light_on_flicker2",
											  "light_on_clicker3", "light_on_clicker4", "light_on_clicker5", "light_broken",
											  "light_on_broken", "light_off", "wall_thermite", "grass1", "grass2", "grass3", "grass4",
											  "asteroid", "asteroid_dug",
											  "asteroid0", "asteroid1", "asteroid2", "asteroid3", "asteroid4",
											  "asteroid5", "asteroid6", "asteroid7", "asteroid8", "asteroid9", "asteroid10", "asteroid11", "asteroid12",
											  "oldburning", "light-on-r", "light-on-y", "light-on-g", "light-on-b", "wood", "wood-broken", "carpet",
											  "carpetcorner", "carpetside", "carpet", "ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5",
											  "ironsand6", "ironsand7", "ironsand8", "ironsand9", "ironsand10", "ironsand11",
											  "ironsand12", "ironsand13", "ironsand14", "ironsand15")

var/list/plating_icons = list("plating", "platingdmg1", "platingdmg2", "platingdmg3", "asteroid", "asteroid_dug",
							  "ironsand1", "ironsand2", "ironsand3", "ironsand4", "ironsand5", "ironsand6", "ironsand7",
							  "ironsand8", "ironsand9", "ironsand10", "ironsand11",
							  "ironsand12", "ironsand13", "ironsand14", "ironsand15")
var/list/wood_icons = list("wood", "wood-broken")

/turf/simulated/floor
	//Note to coders, the 'intact' var can no longer be used to determine if the floor is a plating or not.
	//Use the is_plating(), is_plasteel_floor() and is_light_floor() procs instead. --Errorage
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	var/icon_regular_floor = "floor" //Used to remember what icon the tile should have by default
	var/icon_plating = "plating"
	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0
	var/broken = 0
	var/burnt = 0
	var/mineral = "metal"
	var/obj/item/stack/tile/floor_tile = new/obj/item/stack/tile/plasteel

/turf/simulated/floor/New()
	..()
	if(icon_state in icons_to_ignore_at_floor_init) //So damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

/turf/simulated/floor/ex_act(severity)
	switch(severity)
		if(1)
			break_tile_to_plating()
		if(2)
			if(prob(80))
				break_tile_to_plating()
			else
				break_tile()
			hotspot_expose(1000, CELL_VOLUME)
		if(3)
			if(prob(50))
				break_tile()
				hotspot_expose(1000, CELL_VOLUME)

/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!burnt && prob(5))
		burn_tile()
	else if(prob(1) && !is_plating())
		make_plating()
		burn_tile()

/turf/simulated/floor/proc/take_damage()
	break_tile()

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_full_window()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)

turf/simulated/floor/update_icon()
	if(lava)
		return
	else if(is_plasteel_floor())
		if(!broken && !burnt)
			icon_state = icon_regular_floor
	else if(is_plating())
		if(!broken && !burnt)
			icon_state = icon_plating //Because asteroids are 'platings' too.
	else if(is_light_floor())
		var/obj/item/stack/tile/light/T = floor_tile
		if(T.on)
			switch(T.state)
				if(0)
					icon_state = "light_on"
					SetLuminosity(5)
				if(1)
					var/num = pick("1", "2", "3", "4")
					icon_state = "light_on_flicker[num]"
					SetLuminosity(5)
				if(2)
					icon_state = "light_on_broken"
					SetLuminosity(5)
				if(3)
					icon_state = "light_off"
					SetLuminosity(0)
		else
			SetLuminosity(0)
			icon_state = "light_off"
	else if(is_grass_floor())
		if(!broken && !burnt)
			if(!(icon_state in list("grass1", "grass2", "grass3", "grass4")))
				icon_state = "grass[pick("1", "2", "3", "4")]"
	else if(is_carpet_floor())
		if(!broken && !burnt)
			if(icon_state != "carpetsymbol")
				var/connectdir = 0
				for(var/direction in cardinal)
					if(istype(get_step(src, direction), /turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src, direction)
						if(FF.is_carpet_floor())
							connectdir |= direction

				//Check the diagonal connections for corners, where you have, for example, connections both north and east
				//In this case it checks for a north-east connection to determine whether to add a corner marker or not.
				var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW

				//Northeast
				if(connectdir & NORTH && connectdir & EAST)
					if(istype(get_step(src,NORTHEAST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,NORTHEAST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 1

				//Southeast
				if(connectdir & SOUTH && connectdir & EAST)
					if(istype(get_step(src,SOUTHEAST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,SOUTHEAST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 2

				//Northwest
				if(connectdir & NORTH && connectdir & WEST)
					if(istype(get_step(src,NORTHWEST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,NORTHWEST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 4

				//Southwest
				if(connectdir & SOUTH && connectdir & WEST)
					if(istype(get_step(src,SOUTHWEST),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,SOUTHWEST)
						if(FF.is_carpet_floor())
							diagonalconnect |= 8

				icon_state = "carpet[connectdir]-[diagonalconnect]"

	else if(is_wood_floor())
		if(!broken && !burnt)
			if(!(icon_state in wood_icons))
				icon_state = "wood"

/turf/simulated/floor/return_siding_icon_state()
	..()
	if(is_grass_floor())
		var/dir_sum = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(!(T.is_grass_floor()))
				dir_sum += direction
		if(dir_sum)
			return "wood_siding[dir_sum]"
		else
			return 0

/turf/simulated/floor/attack_paw(mob/user)
	return src.attack_hand(user)

/turf/simulated/floor/attack_hand(mob/user)
	if(is_light_floor())
		var/obj/item/stack/tile/light/T = floor_tile
		T.on = !T.on
		update_icon()
	if(user.is_mob_incapacitated() || !user.pulling)
		return
	if(user.pulling == user.buckled) return //Can't move the thing you're sitting on.
	step(user.pulling, get_dir(user.pulling.loc, src))

/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/is_plasteel_floor()
	if(istype(floor_tile,/obj/item/stack/tile/plasteel))
		return 1
	else
		return 0

/turf/simulated/floor/is_light_floor()
	if(istype(floor_tile,/obj/item/stack/tile/light))
		return 1
	else
		return 0

/turf/simulated/floor/is_grass_floor()
	if(istype(floor_tile,/obj/item/stack/tile/grass))
		return 1
	else
		return 0

/turf/simulated/floor/is_wood_floor()
	if(istype(floor_tile,/obj/item/stack/tile/wood))
		return 1
	else
		return 0

/turf/simulated/floor/is_carpet_floor()
	if(istype(floor_tile,/obj/item/stack/tile/carpet))
		return 1
	else
		return 0

/turf/simulated/floor/is_plating()
	if(!floor_tile)
		return 1
	return 0

/turf/simulated/floor/proc/break_tile()
	if(istype(src, /turf/simulated/floor/engine)) return
	if(istype(src, /turf/simulated/floor/mech_bay_recharge_floor))
		ChangeTurf(/turf/simulated/floor/plating)
	if(broken) return
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
		broken = 1
	else if(is_light_floor())
		icon_state = "light_broken"
		broken = 1
	else if(is_plating())
		icon_state = "platingdmg[pick(1, 2, 3)]"
		broken = 1
	else if(is_wood_floor())
		icon_state = "wood-broken"
		broken = 1
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
		broken = 1
	else if(is_grass_floor())
		icon_state = "sand[pick("1", "2", "3")]"
		broken = 1

/turf/simulated/floor/proc/burn_tile()
	if(istype(src, /turf/simulated/floor/engine)) return
	if(broken || burnt) return
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
		burnt = 1
	else if(is_plasteel_floor())
		icon_state = "floorscorched[pick(1, 2)]"
		burnt = 1
	else if(is_plating())
		icon_state = "panelscorched"
		burnt = 1
	else if(is_wood_floor())
		icon_state = "wood-broken"
		burnt = 1
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
		burnt = 1
	else if(is_grass_floor())
		icon_state = "sand[pick("1", "2", "3")]"
		burnt = 1

//This proc will delete the floor_tile and the update_iocn() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating()
	if(istype(src,/turf/simulated/floor/engine)) return

	if(is_grass_floor())
		for(var/direction in cardinal)
			if(istype(get_step(src,direction),/turf/simulated/floor))
				var/turf/simulated/floor/FF = get_step(src,direction)
				FF.update_icon() //So siding get updated properly
	else if(is_carpet_floor())
		spawn(5)
			if(src)
				for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
					if(istype(get_step(src,direction), /turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //So siding get updated properly

	if(!floor_tile) return
	cdel(floor_tile)
	icon_plating = "plating"
	SetLuminosity(0)
	floor_tile = null
	intact = 0
	broken = 0
	burnt = 0

	update_icon()
	levelupdate()

//This proc will make the turf a plasteel floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_plasteel_floor(var/obj/item/stack/tile/plasteel/T = null)
	broken = 0
	burnt = 0
	intact = 1
	SetLuminosity(0)
	if(T)
		if(istype(T,/obj/item/stack/tile/plasteel))
			floor_tile = T
			if (icon_regular_floor)
				icon_state = icon_regular_floor
			else
				icon_state = "floor"
				icon_regular_floor = icon_state
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/plasteel
	icon_state = "floor"
	icon_regular_floor = icon_state

	update_icon()
	levelupdate()

//This proc will make the turf a light floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/simulated/floor/proc/make_light_floor(var/obj/item/stack/tile/light/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/light))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/light

	update_icon()
	levelupdate()

//This proc will make a turf into a grass patch. Fun eh? Insert the grass tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_grass_floor(var/obj/item/stack/tile/grass/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/grass))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/grass

	update_icon()
	levelupdate()

//This proc will make a turf into a wood floor. Fun eh? Insert the wood tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_wood_floor(var/obj/item/stack/tile/wood/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/wood))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/wood

	update_icon()
	levelupdate()

//This proc will make a turf into a carpet floor. Fun eh? Insert the carpet tile to be used as the argument
//If no argument is given a new one will be made.
/turf/simulated/floor/proc/make_carpet_floor(var/obj/item/stack/tile/carpet/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/carpet))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//If you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/carpet

	update_icon()
	levelupdate()

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C,/obj/item/light_bulb/bulb)) //Only for light tiles
		if(is_light_floor())
			var/obj/item/stack/tile/light/T = floor_tile
			if(T.state)
				user.drop_held_item(C)
				cdel(C)
				T.state = C //Fixing it by bashing it with a light bulb, fun eh?
				update_icon()
				user << "<span class='notice'>You replace the light bulb.</span>"
			else
				user << "<span class='notice'>The lightbulb seems fine, no need to replace it.</span>"

	if(istype(C, /obj/item/tool/crowbar) && (!(is_plating())))
		if(broken || burnt)
			user << "<span class='warning'>You remove the broken plating.</span>"
		else
			if(is_wood_floor())
				user << "<span class='warning'>You forcefully pry off the planks, destroying them in the process.</span>"
			else
				user << "<span class='warning'>You remove the [floor_tile.name].</span>"
				new floor_tile.type(src)

		make_plating()
		playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
		return

	if(istype(C, /obj/item/tool/screwdriver) && is_wood_floor())
		if(broken || burnt)
			return
		else
			if(is_wood_floor())
				user << "<span class='warning'>You unscrew the planks.</span>"
				new floor_tile.type(src)

		make_plating()
		playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(is_plating())
			if(R.get_amount() < 2)
				user << "<span class='warning'>You need more rods.</span>"
				return
			user << "<span class='notice'>Reinforcing the floor.</span>"
			if(do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD) && is_plating())
				if(!R) return
				if(R.use(2))
					ChangeTurf(/turf/simulated/floor/engine)
					playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
				return
			else
		else
			user << "<span class='warning'>You must remove the plating first.</span>"
		return

	if(istype(C, /obj/item/stack/tile))
		if(is_plating())
			if(!broken && !burnt)
				var/obj/item/stack/tile/T = C
				if(T.get_amount() < 1)
					return
				floor_tile = new T.type
				intact = 1
				if(istype(T, /obj/item/stack/tile/light))
					var/obj/item/stack/tile/light/L = T
					var/obj/item/stack/tile/light/F = floor_tile
					F.state = L.state
					F.on = L.on
				if(istype(T, /obj/item/stack/tile/grass))
					for(var/direction in cardinal)
						if(istype(get_step(src, direction), /turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				else if(istype(T, /obj/item/stack/tile/carpet))
					for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
						if(istype(get_step(src, direction), /turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				T.use(1)
				update_icon()
				levelupdate()
				playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			else
				user << "<span class='notice'>This section is too damaged to support a tile. Use a welder to fix the damage.</span>"


	if(istype(C, /obj/item/stack/cable_coil))
		if(is_plating())
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			user << "<span class='warning'>You must remove the plating first.</span>"

	if(istype(C, /obj/item/tool/shovel))
		if(is_grass_floor())
			new /obj/item/ore/glass(src)
			new /obj/item/ore/glass(src) //Make some sand if you shovel grass
			user << "<span class='notice'>You shovel the grass.</span>"
			make_plating()
		else
			user << "<span class='warning'>You cannot shovel this.</span>"

	if(istype(C, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/welder = C
		if(welder.isOn() && (is_plating()))
			if(broken || burnt)
				if(welder.remove_fuel(0, user))
					user << "<span class='warning'>You fix some dents on the broken plating.</span>"
					playsound(src, 'sound/items/Welder.ogg', 25, 1)
					icon_state = "plating"
					burnt = 0
					broken = 0
				else
					user << "<span class='warning'>You need more welding fuel to complete this task.</span>"
