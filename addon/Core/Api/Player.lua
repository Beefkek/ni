local GetGlyphSocketInfo,
	GetContainerNumSlots,
	GetContainerItemID,
	GetItemSpell,
	GetInventoryItemID,
	GetItemCooldown,
	GetSpellCooldown,
	GetTime,
	IsFalling =
	GetGlyphSocketInfo,
	GetContainerNumSlots,
	GetContainerItemID,
	GetItemSpell,
	GetInventoryItemID,
	GetItemCooldown,
	GetSpellCooldown,
	GetTime,
	IsFalling

ni.player = {
	moveto = function(...) --target/x,y,z
		ni.functions.moveto(...)
	end,
	clickat = function(...) --target/x,y,z/mouse
		ni.functions.clickat(...)
	end,
	stopmoving = function()
		ni.functions.stopmoving()
	end,
	lookat = function(target, inv) --inv true to look away
		ni.functions.lookat(target, inv)
	end,
	target = function(target)
		ni.functions.settarget(target)
	end,
	runtext = function(text)
		ni.functions.runtext(text)
	end,
	useitem = function(...) --itemid/name[, target]
		ni.functions.item(...)
	end,
	useinventoryitem = function(slotid)
		ni.functions.inventoryitem(slotid)
	end,
	interact = function(target)
		ni.functions.interact(target)
	end,
	hasglyph = function(glyphid)
		for i = 1, 6 do
			if GetGlyphSocketInfo(i) then
				if select(3, GetGlyphSocketInfo(i)) == glyphid then
					return true
				end
			end
		end
		return false
	end,
	hasitem = function(itemid)
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				if GetContainerItemID(b, s) == itemid then
					return true
				end
			end
		end
		return false
	end,
	hasitemequipped = function(id)
		for i = 1, 19 do
			if GetInventoryItemID("player", i) == id then
				return true
			end
		end
		return false
	end,
	slotcd = function(slotnum)
		if GetItemSpell(GetInventoryItemID("player", slotnum)) == nil then
			return 0
		end
		local start, duration, enable = GetItemCooldown(GetInventoryItemID("player", slotnum))
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		end
		return 0
	end,
	itemcd = function(item)
		local start, duration, enable = GetItemCooldown(item)
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		end
		return 0
	end,
	petcd = function(spell)
		local start, duration, enable = GetSpellCooldown(spell, "pet")
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		else
			return 0
		end
	end,
	ismoving = function()
		if ni.unit.ismoving("player") or IsFalling() then
			return true
		end
		return false
	end
}

setmetatable(
	ni.player,
	{
		__index = function(_, k)
			return function(...)
				return ni.unit[k]("player", ...)
			end
		end
	}
)