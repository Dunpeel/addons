require "no_interruptions"
send_command('input //lua unload aecho')
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
	state.SkillchainPending = M(false, 'Skillchain Pending')
	lockstyleset = 100
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'CP Back Lock', 'PDT')-- f9
    state.HybridMode:options('Normal', 'PDT', 'Reraise')-- crtl + F9
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	state.IdleMode:options('Town','Field','Weak')
	
	send_command('bind  gs c cycle RangedMode')
	send_command('bind  gs c cycle Weapons')
	send_command('bind  gs c cycle Weaponskillmode')
	send_command('bind f9 gs c cycle OffenseMode')
	send_command('bind f12 gs c cycle IdleMode')
	    
    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')
	send_command('bind !f11 gs c toggle SkillchainPending')
	
	gear.WS_back_STR = {name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%'}}
	
	gear.TP_back = {name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%'}}
	
	gear.WS_feet = { name="Valorous Greaves", augments={'STR+5','Crit.hit rate+2','Weapon skill damage +5%','Mag. Acc.+2 "Mag.Atk.Bns."+2'}}
	
	gear.SC_feet = { name="Valorous Greaves", augments={'Attack+22','Sklchn.dmg.+4%','STR+9','Accuracy+12'}}
	
	gear.default.weaponskill_neck = "Fotia Gorget"
	
	gear.default.weaponskill_waist = "Fotia Belt"
	
	gear.default.obi_waist = "Hachirin-no-obi"

    select_default_macro_book()
	
	set_lockstyle()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
	send_command('unbind !f11')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {
		head="Wakido Kabuto +1",
		hands="Sakonji Kote +1"
	}
	
    sets.precast.JA['Warding Circle'] = {
		head="Wakido Kabuto +1"
	}
	
    sets.precast.JA['Blade Bash'] = {
		hands="Sakonji Kote +1"
	}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
		ammo="Sonia's Plectrum",
        head="Yaoyotl Helm",
        body="Otronif Harness +1",
		hands="Buremte Gloves",
		ring1="Spiral Ring",
        back="Iximulew Cape",
		waist="Caudata Belt",
		legs="Karieyh Brayettes +1",
		feet="Otronif Boots +1"
	}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined --Sakonji Domaru +1   Hizamaru haramaki +2   Nzingha Cuirass
    sets.precast.WS = {
		ammo="Knobkierrie",
    head={ name="Valorous Mask", augments={'"Mag.Atk.Bns."+15','Weapon skill damage +5%','Accuracy+15',}},
    body={ name="Valorous Mail", augments={'Accuracy+21','Weapon skill damage +5%','DEX+3',}},
    hands={ name="Valorous Mitts", augments={'Weapon skill damage +5%','Attack+4',}},
    legs="Hiza. Hizayoroi +2",
    feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','AGI+7','Attack+8',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Karieyh Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
	
	sets.precast.WS['Impulse Drive'] = {
	ammo="Knobkierrie",
    head="Flam. Zucchetto +2",
    body="Flamma Korazin +2",
    hands={ name="Ryuo Tekko +1", augments={'STR+12','DEX+12','Accuracy+20',}},
    legs="Hiza. Hizayoroi +2",
    feet="Flam. Gambieras +2",
    neck="Fotia Gorget",
    waist="Grunfeld Rope",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	}
		
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {
	ammo="Knobkierrie",
    head={ name="Valorous Mask", augments={'"Mag.Atk.Bns."+15','Weapon skill damage +5%','Accuracy+15',}},
    body={ name="Valorous Mail", augments={'Accuracy+21','Weapon skill damage +5%','DEX+3',}},
    hands={ name="Valorous Mitts", augments={'Weapon skill damage +5%','Attack+4',}},
    legs="Hiza. Hizayoroi +2",
    feet={ name="Founder's Greaves", augments={'VIT+10','Accuracy+15','"Mag.Atk.Bns."+15','Mag. Evasion+15',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Karieyh Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
	})
	
	sets.precast.Skillchain = {feet=gear.SC_feet, legs="Ryuo hakama"}


    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Yaoyotl Helm",
        body="Otronif Harness +1",
		hands="Otronif Gloves",
        legs="Phorcys Dirs",
		feet="Otronif Boots +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {
		neck="Wiglen Gorget",
		ring1="Sheltered Ring",
		ring2="Paguroidea Ring"
	}
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle.Town = {
		ammo="Staunch Tathlum +1",
    head={ name="Valorous Mask", augments={'Accuracy+6','Weapon skill damage +4%','STR+2',}},
    body="Hiza. Haramaki +2",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Etiolation Earring",
    left_ring="Karieyh Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}
    
    sets.idle.Field = {
		ammo="Staunch Tathlum +1",
    head={ name="Valorous Mask", augments={'Accuracy+6','Weapon skill damage +4%','STR+2',}},
    body="Hiza. Haramaki +2",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Etiolation Earring",
    left_ring="Karieyh Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}

    sets.idle.Weak = {
		ammo="Staunch Tathlum +1",
    head={ name="Valorous Mask", augments={'Accuracy+6','Weapon skill damage +4%','STR+2',}},
    body="Hiza. Haramaki +2",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Etiolation Earring",
    left_ring="Karieyh Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}
    
    -- Defense sets
    sets.defense.PDT = {
		ammo="Staunch Tathlum +1",
    head={ name="Valorous Mask", augments={'Accuracy+6','Weapon skill damage +4%','STR+2',}},
    body="Hiza. Haramaki +2",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Etiolation Earring",
    left_ring="Karieyh Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}

    sets.defense.Reraise = {
		ammo="Staunch Tathlum +1",
    head="Twilight Helm",
	body="Twilight Mail",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Etiolation Earring",
    left_ring="Karieyh Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}

    sets.defense.MDT = {
		ammo="Staunch Tathlum +1",
    head={ name="Valorous Mask", augments={'Accuracy+6','Weapon skill damage +4%','STR+2',}},
    body="Hiza. Haramaki +2",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Etiolation Earring",
    left_ring="Karieyh Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}

    sets.Kiting = {
		feet="Danzo Sune-ate"
	}

    sets.Reraise = {
		head="Twilight Helm",
		body="Twilight Mail"
	}

    -- Engaged setss

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    -- Delay 450 GK, 25 Save TP => 65 Store TP for a 5-hit (25 Store TP in gear) Moonbeam nodowa
    sets.engaged = {
		ammo="Ginsen",
    head="Flam. Zucchetto +2",
    body="Kasuga Domaru +1",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
    neck="Sam. Nodowa +2",
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Flamma Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}
	
    sets.engaged.Acc = {
		ammo="Ginsen",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet="Flam. Gambieras +2",
    neck="Sam. Nodowa +2",
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Cessance Earring",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}
	
    sets.engaged.PDT = {
		ammo="Ginsen",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Dark Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}
	
    sets.engaged.Acc.PDT = {
		ammo="Ginsen",
    head="Flam. Zucchetto +2",
    body="Flamma Korazin +2",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Dark Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}
	
    sets.engaged.Reraise = {
		ammo="Staunch Tathlum +1",
    head="Twilight Helm",
	body="Twilight Mail",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Dark Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}
	
    sets.engaged.Acc.Reraise = {
		ammo="Staunch Tathlum +1",
    head="Twilight Helm",
	body="Twilight Mail",
    hands="Wakido Kote +3",
    legs={ name="Ryuo Hakama +1", augments={'Accuracy+25','"Store TP"+5','Phys. dmg. taken -4',}},
    feet={ name="Amm Greaves", augments={'HP+50','VIT+10','Accuracy+15','Damage taken-2%',}},
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Etiolation Earring",
    left_ring="Dark Ring",
    right_ring="Defending Ring",
    back={ name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+8','"Store TP"+10','Damage taken-5%',}},
	}

    sets.buff.Sekkanoki = {
		hands="Unkai Kote +2"
	}
	
    sets.buff.Sengikori = {
		feet="Unkai Sune-ate +2"
	}
	
    sets.buff['Meikyo Shisui'] = {
		feet="Sakonji Sune-ate +1"
	}
	
	sets.buff.Doom = {
		ring1="Purity Ring", 
		ring2="Saida Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet)
    end
	if player.Tp < 2000 and not buffactive["Weakness"] then
		if state.HybridMode.value == 'Reraise' or state.DefenseMode.value == 'Physical' or state.DefenseMode.value == 'Magical' then
			idleSet = set_combine(idleSet, {ring1 = "Karieyh Ring"})
		
			else
			idleSet = set_combine(idleSet, {head="Valorous Mask",ring1 = "Karieyh Ring"})
		
		end        
    end
	
	if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
	    
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
	
	if buffactive["Weakness"] then
		meleeSet = set_combine(meleeSet, sets.Reraise)
	end
	
    return meleeSet
end

function job_precast(spell, action, spellMap, eventArgs)
	custom_aftermath_timers_precast(spell)
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
		if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
        if state.Buff.Sekkanoki then
            equip(sets.buff.Sekkanoki)
        end
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Effectively lock these items in place.
    if state.HybridMode.value == 'Reraise' or
        (state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
        equip(sets.Reraise)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	handle_equipping_gear(player.status)
end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)  
	
	if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            disable('ring1','ring2')
			send_command('@input /p DOOMED!!!! <call18>')
        else
            enable('ring1','ring2')
            handle_equipping_gear(player.status)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

--function job_aftercast(spell, action, spellMap, eventArgs)--
  --  if not spell.interrupted then
    --    if spell.english == "Konzen-ittai" then
      --      state.SkillchainPending:set()
        --    send_command('wait 6;gs c unset SkillchainPending')
       -- elseif spell.type:lower() == "weaponskill" then
         --   state.SkillchainPending:toggle()
		--	send_command('wait 8;gs c unset SkillchainPending')
        -- end
    -- end
	-- custom_aftermath_timers_aftercast(spell)
--end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(2, 3)
    elseif player.sub_job == 'DNC' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 3)
	elseif player.sub_job == 'RUN' then
        set_macro_page(1, 3)
    else
        set_macro_page(1, 3)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 100 ' .. lockstyleset)
end
