local speed_boost = 8

if not DISABLE_WOODEN_BOW then
	throwing_register_bow ('bow_wood', 'Wooden bow', {x=1, y=1, z=1}, 11+speed_boost, 0.8, 50, false, {
			{'', 'default:stick', ''},
			{'farming:string', '', 'default:stick'},
			{'', 'default:stick', ''},
		})
end

if not DISABLE_LONGBOW then
	throwing_register_bow ('longbow', 'Longbow', {x=1, y=2.5, z=1}, 17+speed_boost, 1.8, 100, false, {
			{'farming:string', 'group:wood', ''},
			{'farming:string', '', 'group:wood'},
			{'farming:string', 'group:wood', ''},
		})
end

if not DISABLE_COMPOSITE_BOW then
	throwing_register_bow ('bow_composite', 'Composite bow', {x=1, y=1.4, z=1}, 17+speed_boost, 1, 150, false, {
			{'farming:string', 'group:wood', ''},
			{'farming:string', '', 'default:steel_ingot'},
			{'farming:string', 'group:wood', ''},
		})
end

if not DISABLE_STEEL_BOW then
	throwing_register_bow ('bow_steel', 'Steel bow', {x=1, y=1.4, z=1}, 20+speed_boost, 1.3, 250, false, {
			{'farming:string', 'default:steel_ingot', ''},
			{'farming:string', '', 'default:steel_ingot'},
			{'farming:string', 'default:steel_ingot', ''},
		})
end

if not DISABLE_ROYAL_BOW then
	throwing_register_bow ('bow_royal', 'Royal bow', {x=1, y=1.5, z=1}, 18+speed_boost, 1.4, 750, false, {
			{'farming:string', 'group:wood', 'default:diamond'},
			{'farming:string', '', 'default:gold_ingot'},
			{'farming:string', 'group:wood', 'default:diamond'},
		})
end

if not DISABLE_CROSSBOW then
	throwing_register_bow ('crossbow', 'Crossbow', {x=1, y=1.3, z=1}, 28+speed_boost, 5, 80, true, {
			{'group:wood', 'farming:string', ''},
			{'default:steel_ingot', 'farming:string', 'group:wood'},
			{'group:wood', 'farming:string', ''},
		})
end

if not DISABLE_ARBALEST then
	throwing_register_bow ('arbalest', 'Arbalest', {x=1, y=1.3, z=1}, 35+speed_boost, 7.5, 120, true, {
			{'default:steel_ingot', 'farming:string', 'default:stick'},
			{'default:steel_ingot', 'farming:string', 'default:steel_ingot'},
			{'default:steel_ingot', 'farming:string', 'default:stick'},
		})
end

if not DISABLE_AUTOMATED_ARBALEST then
	throwing_register_bow ('arbalest_auto', 'Automated arbalest', {x=1, y=1.3, z=1}, 40+speed_boost, 3.5, 60, true, {
			{'default:steel_ingot', 'farming:string', 'default:mese_crystal'},
			{'default:steel_ingot', 'farming:string', 'default:steel_ingot'},
			{'default:steel_ingot', 'farming:string', 'default:mese_crystal'},
		})
end
