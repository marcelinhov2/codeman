#<< app/config/*
#<< app/components/header/els/*	

# Conventions
# ss = spritesheets

class Header

	Background = app.components.header.els.Background
	TopStripe = app.components.header.els.TopStripe
	SplatterLogo = app.components.header.els.SplatterLogo
	Logo = app.components.header.els.Logo
	SplatterTop = app.components.header.els.SplatterTop
	Drop = app.components.header.els.Drop
	Line = app.components.header.els.Line
	Brain = app.components.header.els.Brain
	LogoLabel = app.components.header.els.LogoLabel

	config:->
		#shortcuts
		@Assets = app.config.Assets
		@image_assets = @Assets.header.images
		@animation_assets = @Assets.header.animations

		#variables
		@assets_loaded = 0
		@total_assets = Object.keys(@Assets.header).length
		@bg
		@splatter_logos
		@logo
		@splatter_top
		@top_stripe
		@brain
		@logo_label
		@drop_01 = new Drop 60, 140, 1
		@drop_02 = new Drop 43, 122, 0.6
		@drop_03 = new Drop 90, 125, 0.6
		@drop_04 = new Drop 66, 100, 0.7
		@drop_line = new Line 55, 93, 60, "#ee1d23"
		@top_line_01 = new Line 754, 0, 53, "#ee1d23"
		@top_line_02 = new Line 775, 0, 80, "#ee1d23"
		@top_line_03 = new Line 807, 0, 160, "#000", false
		@top_line_04 = new Line 823, 0, 130, "#000", false
		@label_line_01 = new Line 210, 57, 110, "#ee1d23"
		@label_line_02 = new Line 246, 75, 50, "#ee1d23"

		#events
		@loaded = new signals.Signal

	constructor:(canvas_id)->
		@canvas = document.getElementById canvas_id
		@config()

		@load_all_assets()

	add_events:->
		

	in:->
		@stage = new Stage @canvas
		Ticker.setFPS 30
		Ticker.addListener @stage

		@add_events()

		@add_el @bg
		setTimeout (=>
			@start_in_queue()
		), 300

	start_in_queue:->

		@add_child @bg
		@add_child @splatter_logo
		@add_child @splatter_top
		@add_child @top_stripe
		@label_line_01.add_at @stage
		@label_line_02.add_at @stage
		@add_child @logo_label
		@add_child @brain
		@add_child @logo
		@drop_line.add_at @stage
		@add_drops()
		@top_line_01.add_at @stage
		@top_line_02.add_at @stage
		@top_line_03.add_at @stage
		@top_line_04.add_at @stage


		@add_el @splatter_logo

		setTimeout (=>
			@add_el @splatter_top, =>
				setTimeout (=>
					@add_el @top_stripe
				), 150
		), 350

		@top_line_01.in()
		@top_line_02.in()
		@top_line_03.in()
		@top_line_04.in()
		@label_line_01.in()
		@label_line_02.in()
		@drop_line.in()

		@add_el @brain
		@add_el @logo

	add_el:(el, callback)->
		el.in(callback)

	add_drops:->
		@drop_01.add_at @stage
		@drop_02.add_at @stage
		@drop_03.add_at @stage
		@drop_04.add_at @stage


	load_all_assets:(callback)->

		#LOAD IMAGES
		@load_image @image_assets.bg, (img)=>
			@bg = new Background img

		@load_image @image_assets.top_stripe, (img)=>
			@top_stripe = new TopStripe img

		@load_image @image_assets.logo_label, (img)=>
			@logo_label = new LogoLabel img

		@load_image @image_assets.drop, (img)=>
			@drop_01.add_drop img
			@drop_02.add_drop img
			@drop_03.add_drop img
			@drop_04.add_drop img

		@load_image @image_assets.drop_bg, (img)=>
			@drop_01.add_bg img
			@drop_02.add_bg img
			@drop_03.add_bg img
			@drop_04.add_bg img

		#LOAD ANIMATIONS
		@load_animation @animation_assets.splatter_logo, (data, spritesheet)=>
			@splatter_logo = new SplatterLogo spritesheet

		@load_animation @animation_assets.logo, (data, spritesheet)=>
			@logo = new Logo spritesheet

		@load_animation @animation_assets.splatter_header, (data, spritesheet)=>
			@splatter_top = new SplatterTop spritesheet

		@load_animation @animation_assets.brain, (data, spritesheet)=>
			@brain = new Brain spritesheet

	load_image:(image_url,callback)->
		img = new Image
		img.src = image_url
		img.onload = =>
			@assets_loaded++
			callback?(img)
			@dispatch_loaded()

	load_animation:(asset_url,callback)->
		load_json asset_url, (data)=>
			@assets_loaded++
			spritesheet = new SpriteSheet data
			callback?(data,spritesheet)
			@dispatch_loaded()

	dispatch_loaded:->
		if @assets_loaded is @total_assets
			@loaded.dispatch()
			@in()

	add_child:(obj)->
		@stage.addChild obj
		@stage.update()
