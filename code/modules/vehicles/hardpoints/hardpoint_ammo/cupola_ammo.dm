/obj/item/ammo_magazine/hardpoint/m56_cupola
	name = "M56 Cupola Magazine"
	desc = "A secondary armament MG magazine"
	caliber = "10x28mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "cupola_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/rifle/heavy/tracer
	max_rounds = 500
	gun_type = /obj/item/hardpoint/secondary/m56cupola

/obj/item/ammo_magazine/hardpoint/m56_cupola/update_icon()
	icon_state = "cupola_[current_rounds <= 0 ? "0" : "1"]"

/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon
	name = "RE-RE700 Frontal Cannon magazine"
	desc = "A big box of bullets that looks suspiciously similar to the box you would use to refill a M56 Cupola. The Bleihagel logo sticker has peeled slightly and it looks like there's another logo underneath..."
	gun_type = /obj/item/hardpoint/secondary/frontalcannon
	icon_state = "frontal_1"

/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon/update_icon()
	icon_state = "frontal_[current_rounds <= 0 ? "0" : "1"]"

/obj/item/ammo_magazine/hardpoint/m56_cupola/quad_cannon
	name = "RE-RE965 Aerial-Defence System ammunition box"
	desc = "A crate of belted caseless munitions for the ever-hungry RE-RE965 Aerial-Defence System. Comes loaded with a mix of HEI-T and AP rounds for combating aerial threats of all shapes and sizes. Lacks propellants, as it's to be used with the binary hypergolic principle."
	default_ammo = /datum/ammo/bullet/smartgun/aa
	gun_type = /obj/item/hardpoint/primary/aa_quadcannon
	max_rounds = 2000
	icon_state = "quad_1"

/obj/item/ammo_magazine/hardpoint/m56_cupola/quad_cannon/update_icon()
	icon_state = "quad_[current_rounds <= 0 ? "0" : "1"]"
