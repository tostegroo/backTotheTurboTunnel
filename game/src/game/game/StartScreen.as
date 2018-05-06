package game.game 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.accessibility.Accessibility;
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.ui.Keyboard;
	import mx.utils.URLUtil;
	import game.core.Notification;
	import game.data.AnalyticsData;
	import game.game.hud.InfoScreen;
	import game.game.hud.OptionsScreen;
	import game.game.objects.ButtonObject;
	import game.game.objects.ExitButton;
	import game.game.objects.Logo;
	import game.game.objects.Slide;
	import game.game.sounds.SoundManager;
	import starling.core.Starling;
	import starling.display.Quad;
	
	import game.assets.Assets;
	import game.assets.Device;
	import game.data.GameData;
	import game.game.objects.MenuButton;
	import game.game.objects.Planet;
	import game.game.objects.Stars;
	import game.inputs.gamepads.GenericGamepad;
	import game.inputs.gamepads.Xbox360Gamepad;
	import game.inputs.InputManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class StartScreen extends Sprite 
	{
		public var loadedFunction:Function = null;
		private var starField:Stars;
		
		private var introScreen:Sprite;
		private var txt:TextField;
		private var skiptxt:TextField;
		private var introStrings:Array = [
			{text:"since 1991 turbo tunnel killed countless toads", width:820, delay:0 },
			{text:"but it will happen no more", width:450, delay:5.5},
			{text:"because now", width:220, delay:4.5 },
			{text:"we are counting", width:270, delay:3.5 }
		];
		public static var introStatus:Vector.<TextField> = new Vector.<TextField>();
		
		private var startScreen:Sprite;
		private var textFont:BitmapFont;
		private var sitetxt:TextField;
		private var logo:Logo;
		private var bt_play:MenuButton;
		private var bt_info:MenuButton;
		private var bt_config:MenuButton;
		private var bt_ranking:MenuButton;
		private var bt_exit:ExitButton;
		private var buttons:Vector.<ButtonObject> = new Vector.<ButtonObject>();
		private var currButton:int = 0;
		private var webviewRect:Rectangle = new Rectangle(0, 0, 100, 100);
		
		private var options:OptionsScreen;
		
		private var overlay:InfoScreen;
		public var webView:StageWebView;
		
		private var skipIntro:Boolean = false;
		
		private var canUseButton:Boolean = false;
		private var ranking:Sprite;
		private var info:Sprite;
		private var inputType:String;
		private var controlHelp:Array = [];
		private var webviewOffset:Number = 260;
		private var webViewOpen:Boolean = false;
		
		private var touchArea:Quad;
		
		private var easeConfig:Point = new Point(1.2, 0.8);
		private var easeConfigw:Point = new Point(1, 1.2);
		private var canTouchThis:Boolean = true;
		
		public function StartScreen(skipIntro:Boolean = false, callback:Function = null) 
		{
			inputType = GameData.inputType;
			
			controlHelp["gamepad"] = {text:"any button to skip"};
			controlHelp["gamepadXbox"] = {text:"any button to skip"};
			controlHelp["keyboard"] = {text:"any key to skip"};
			controlHelp["touch"] = { text:"tap to skip" };
			
			this.skipIntro = skipIntro;
			
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			bt_play = new MenuButton(Assets.getAtlas('interface').getTexture('bt_play'), Assets.getAtlas('interface').getTexture('bt_play_over'), new Point(1, 10));
			bt_ranking = new MenuButton(Assets.getAtlas('interface').getTexture('bt_ranking'), Assets.getAtlas('interface').getTexture('bt_ranking_over'), new Point( -1, 8));
			bt_info = new MenuButton(Assets.getAtlas('interface').getTexture('bt_info'), null, null, 1, -1);
			bt_config = new MenuButton(Assets.getAtlas('interface').getTexture('bt_config'), null, null, 1, 1);
			if (GameData.can_exit == true)
				bt_exit = new ExitButton();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			if (callback != null)
				callback();
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			starField = new Stars();
			addChild(starField);
			
			skiptxt = new TextField(300, 30, controlHelp[inputType].text, textFont.name, 26, 0xFFFFFF);
			skiptxt.hAlign = HAlign.RIGHT;
			skiptxt.alpha = 0;
			skiptxt.x = stage.stageWidth - skiptxt.width - 40;
			skiptxt.y = stage.stageHeight - skiptxt.height - 25;
			addChild(skiptxt);
			
			if(loadedFunction!=null)
				loadedFunction(this);
			
			createIntro();
			touchArea = new Quad(stage.stageWidth, stage.stageHeight, 0x00ff00);
			touchArea.alpha = 0;
			addChild(touchArea);
			
			createStart();
			
			if (skipIntro==true)
			{
				if (touchArea)
				{
					touchArea.visible = false;
					touchArea.removeEventListener(TouchEvent.TOUCH, onTouch);
				}
				
				skiptxt.visible = false;
				introScreen.visible = false;
				InputManager.removeAllInputs();
				
				starField.transitionToStop(0, function():void 
				{
					initStart();
				});
			}else
			{
				animateIntro();
			}
		}
		
		private function createIntro():void
		{
			introScreen = new Sprite();
			for (var i:int = 0; i < introStrings.length; i++) 
			{
				txt = new TextField(introStrings[i].width, 45,  "", textFont.name, 36, 0xFFFFFF);
				txt.hAlign = HAlign.LEFT;
				txt.visible = false;
				txt.x = - (introStrings[i].width / 2) + 10;
				txt.y = 0;
				introStatus.push(txt);
				introScreen.addChild(txt);
			}
			introScreen.x = stage.stageWidth / 2;
			introScreen.y = ((stage.stageHeight - 30) / 2) - (20 * Device.scale);
			
			introScreen.alpha = 0;
			addChild(introScreen);
			
			if (SoundManager.getIndexSoundByName("musicMenu") == -1)
				SoundManager.playSound("musicMenu", "musicMenu", -1, 0.5, "music");
		}
		
		private function changeGamepadState(index:int = 0):void
		{
			inputType = GameData.inputType;
			skiptxt.text = String(controlHelp[inputType].text);
		}
		
		private function animateIntro():void
		{
			InputManager.removeAllInputs();
			
			if (GameData.is_mobile == false)
			{
				InputManager.addInput("skip", { keyboard:"all", gamepad:"all" }, 0, skip, null, null, true);
				
				if (InputManager.gamepads)
				{
					InputManager.gamepads.onConnect = changeGamepadState;
					InputManager.gamepads.onDisconnect = changeGamepadState;
				}
			}
			
			if(touchArea)
				touchArea.addEventListener(TouchEvent.TOUCH, onTouch);
			
			TweenMax.to(skiptxt, 0.2, { alpha:1, yoyo:true, repeat: -1, ease:Linear} );
			TweenMax.to(introScreen, 0.1, { alpha:1, delay:0.5, onComplete:function():void 
			{
				var delay:Number = 0;
				var pdelay:Number = 0;
				for (var i:int = 0; i < introStatus.length; i++) 
				{
					introStatus[i].visible = true;
					var str:String = "";
					var cstr:String = introStrings[i].text;
					delay += introStrings[i].delay;
					pdelay += (i == introStatus.length-1) ? 5 : introStrings[i + 1].delay;
					
					for (var j:int = 0; j < introStrings[i].text.length; j++) 
					{
						str += introStrings[i].text.charAt(j);
						var time:Number = (j * 0.04) + (Math.random() * 0.04);
						TweenMax.to(introStatus[i], time, { delay:delay, onComplete:function(i:int = 0, str:String = ""):void 
						{
							SoundManager.playSound("keydown");
							introStatus[i].text = str;
						}, onCompleteParams:[i, str] } );
						
						cstr = introStrings[i].text.substr(0, ((introStrings[i].text.length-1) - j));
						TweenMax.to(introStatus[i], j * 0.01, { delay:pdelay - 1, onComplete:function(i:int = 0, str:String = ""):void 
						{
							introStatus[i].text = str;
						}, onCompleteParams:[i, cstr] } );
					}
				}
				
				TweenMax.to(introScreen, 0, { alpha:0, delay:pdelay, onComplete:function():void 
				{
					skip();
				}});
			}});
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (canTouchThis==true && e.getTouch(this, TouchPhase.ENDED))
				skip();
		}
		
		public function skip():void
		{
			canTouchThis = false;
			touchArea.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			if (InputManager.gamepads)
			{
				InputManager.gamepads.onConnect = null;
				InputManager.gamepads.onDisconnect = null;
			}
			
			TweenMax.killTweensOf(skiptxt);
			TweenMax.killTweensOf(introScreen);
			for (var i:int = 0; i < introStatus.length; i++) 
			{
				for (var j:int = 0; j < introStrings[i].text.length; j++) 
				{
					TweenMax.killTweensOf(introStatus[i]);
				}
			}
			
			skiptxt.visible = false;
			introScreen.visible = false;
			InputManager.removeAllInputs();
			
			starField.transitionToStop(1, function():void 
			{
				initStart();
			});
		}
		
		private function createStart():void
		{
			startScreen = new Sprite();
			startScreen.visible = false;
			addChild(startScreen);
			
			logo = new Logo();
			logo.x = stage.stageWidth / 2;
			logo.y = 40 * Device.scale;
			startScreen.addChild(logo);
			
			// botoes
			bt_play.scaleX = bt_play.scaleY = 1;
			bt_play.offsetX = 3;
			bt_play.x = (stage.stageWidth / 2) - bt_play.button.width - (60 * Device.scale);
			bt_play.y = stage.stageHeight + 100;
			bt_play.clickFunction = closeStart;
			startScreen.addChild(bt_play);
			buttons.push(bt_play);
			bt_play.overOut(false);
			
			bt_ranking.scaleX = bt_ranking.scaleY = 1;
			bt_ranking.offsetX = -1;
			bt_ranking.x = (stage.stageWidth / 2) + (60 * Device.scale);
			bt_ranking.y = bt_play.y;
			bt_ranking.clickFunction = openRanking;
			startScreen.addChild(bt_ranking);
			buttons.push(bt_ranking);
			bt_ranking.overOut(false);
			
			bt_info.x = stage.stageWidth + bt_info.button.width  + (10 * Device.scale);
			bt_info.y = 60 * Device.scale;
			bt_info.scaleX = bt_info.scaleY = 1;
			bt_info.clickFunction = openInfo;
			startScreen.addChild(bt_info);
			buttons.push(bt_info);
			bt_info.overOut(false);
			
			bt_config.x = - (bt_config.button.width  + (50 * Device.scale));
			bt_config.y = 60 * Device.scale;
			bt_config.scaleX = bt_config.scaleY = 1;
			startScreen.addChild(bt_config);
			buttons.push(bt_config);
			bt_config.overOut(false);
			
			if (bt_exit)
			{
				bt_exit.x = (bt_exit.width/2) + 40 * Device.scale;
				bt_exit.y = stage.stageHeight + 150;
				buttons.push(bt_exit);
				startScreen.addChild(bt_exit);
				bt_exit.overOut(false);
				bt_exit.clickFunction = closeApplication;
			}
			
			sitetxt = new TextField(900, 30,  "See how many toads died at bogdoggames.com/turbotunnel", textFont.name, 24, 0xFFFFFF);
			sitetxt.hAlign = HAlign.CENTER;
			sitetxt.alpha = 0;
			sitetxt.x = (stage.stageWidth - sitetxt.width) / 2;
			sitetxt.y = stage.stageHeight - (50 * Device.scale);
			startScreen.addChild(sitetxt);
			
			options = new OptionsScreen();
			addChild(options);
			
			bt_config.clickFunction = options.open;
			
			overlay = new InfoScreen();
			addChild(overlay);
			overlay.bt_exit.clickFunction = closeWebView;
		}
		
		private function initStart():void
		{
			startScreen.visible = true;
			animateButtons();
			
			AnalyticsData.trackPage("/start_screen");
			
			TweenMax.delayedCall(1, function():void
			{
				selectButton(0, false);
				canUseButton = true;
				
				if (GameData.is_mobile == false)
				{
					var bt_a_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.A : GenericGamepad.BUTTON0;
					InputManager.addInput("left", { keyboard:[Keyboard.LEFT, Keyboard.A], gamepad:[GenericGamepad.AXIS0_NEGATIVE, GenericGamepad.POV_LEFT ] }, 0, onLeft, null, null, true);
					InputManager.addInput("right", { keyboard:[Keyboard.RIGHT, Keyboard.D], gamepad:[GenericGamepad.AXIS0_POSITIVE, GenericGamepad.POV_RIGHT ] }, 0, onRight, null, null, true);
					InputManager.addInput("up", { keyboard:[Keyboard.UP, Keyboard.W], gamepad:[GenericGamepad.AXIS1_NEGATIVE, GenericGamepad.POV_FORWARD ] }, 0, onUp, null, null, true);
					InputManager.addInput("down", { keyboard:[Keyboard.DOWN, Keyboard.S], gamepad:[GenericGamepad.AXIS1_POSITIVE, GenericGamepad.POV_BACKWARD ] }, 0, onDown, null, null, true);
					InputManager.addInput("action", { keyboard:[Keyboard.SPACE, Keyboard.ENTER], gamepad:[bt_a_pad] }, 0, action, releaseAction, null, true);
				}
			});
		}
		
		private function animateButtons():void
		{
			canTouchThis = true;
			var basey:Number = 545 * Device.scale;
			var basex:Number = (stage.stageWidth / 2);
			
			if (URLUtil.isHttpURL(GameData.infoURLLink) || URLUtil.isHttpsURL(GameData.infoURLLink))
			{
				TweenMax.to(bt_info, 0.6, { x:stage.stageWidth - (bt_info.button.width / 1.7), y:70 * Device.scale, delay:0.6, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_info.open()}} );
			}
			
			if (bt_exit)
				TweenMax.to(bt_exit, 0.6, { y: stage.stageHeight - ((bt_exit.height/2) + 40 * Device.scale), delay:0.6, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_exit.open()}} );
			
			TweenMax.to(bt_config, 0.6, { x: - bt_config.button.width / 2.5, y:70 * Device.scale, delay:0.6, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_config.open()}} );
			TweenMax.to(bt_play, 0.6, { x:basex - bt_play.button.width - (-10 * Device.scale), y:basey - 25, delay:0.5, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_play.open()}} );
			TweenMax.to(bt_ranking, 0.6, { x:basex + (20 * Device.scale), y:basey - 14, delay:0.7, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_ranking.open()}} );
			
			logo.open();
			
			TweenMax.to(sitetxt, 1, { alpha:1});
		}
		
		private function closeStart():void
		{
			if (canTouchThis == true)
			{
				SoundManager.playSound("init");
				
				var basey:Number = stage.stageHeight + 100;
				var basex:Number = (stage.stageWidth / 2);
				
				if (bt_exit)
					TweenMax.to(bt_exit, 0.8, { y: stage.stageHeight + 150, delay:0, ease:Back.easeIn, onComplete:function():void{bt_exit.close()}} );
				
				TweenMax.to(logo, 0.5, { y:-(logo.height + 50), delay:0, ease:Back.easeIn} );
				TweenMax.to(bt_play, 0.5, { x:basex - bt_play.button.width - 50, y:basey, delay:0.05, ease:Back.easeIn, onComplete:function():void{bt_play.close()}} );
				TweenMax.to(bt_ranking, 0.5, { x:basex + 50, y:basey, delay:0.1, ease:Back.easeIn, onComplete:function():void{bt_ranking.close()}} );
				TweenMax.to(bt_info, 0.5, { x:stage.stageWidth + bt_info.button.width + (10 * Device.scale), delay:0, ease:Back.easeIn, onComplete:function():void{bt_info.close()}} );
				TweenMax.to(bt_config, 0.5, { x:- (bt_config.button.width + (50 * Device.scale)), delay:0, ease:Back.easeIn, onComplete:function():void{bt_config.close()}} );
				TweenMax.to(sitetxt, 0.5, { alpha:0 } );
				
				starField.close();
				
				InputManager.removeAllInputs();
				
				closeWebView(0);
				TweenMax.to(this, 0.5, { alpha:0, delay:0.6, onComplete:function():void 
				{
					starField.stop();
					SoundManager.stopSound("musicMenu");
					GameData.main.changeScene("game", false);
				}});
				canTouchThis = false;
			}
		}
		
		private function releaseAction():void 
		{
			if (canUseButton == true)
				buttons[currButton].upState();
		}
		
		private function openRanking():void
		{
			if (Notification.getNetWorkStatus() == true)
			{
				if (URLUtil.isHttpURL(GameData.rankingURLSite) || URLUtil.isHttpsURL(GameData.rankingURLSite))
				{
					GameData.getNID(function(id:String = ""):void 
					{
						setupWebView(GameData.rankingURLSite + "?uid="+id+"&fid="+GameData.fid+"&nm="+GameData.userName+"&nk="+GameData.nick);
						overlay.openOverlay(function():void 
						{
							AnalyticsData.trackPage("/ranking");
						});
					});
					
				}
			}else 
			{
				overlay.openMessage();
			}
		}
		
		private function openInfo():void
		{
			if (Notification.getNetWorkStatus() == true)
			{
				if (URLUtil.isHttpURL(GameData.infoURLLink) || URLUtil.isHttpsURL(GameData.infoURLLink))
				{
					setupWebView(GameData.infoURLLink);
					overlay.openOverlay(function():void 
					{
						AnalyticsData.trackPage("/info");
					});
				}
			}else
			{
				overlay.openMessage();
			}
		}
		
		private function onWebLoaded(e:flash.events.Event):void 
		{
			if (webViewOpen == true)
			{
				TweenMax.to(webviewRect, 1, { x:Device.width * Device.relativeScale , onComplete:function():void
				{
					overlay.closeLoader();
					var xx:Number = (webviewOffset * Device.relativeScale) + ((Starling.current.nativeStage.stageWidth - (Device.width * Device.relativeScale)) / 2);
					TweenMax.to(webviewRect, 0.5, { x:xx, ease:Elastic.easeOut.config(easeConfigw.x, easeConfigw.y), onUpdate:function():void 
					{
						webView.viewPort = webviewRect;
					}} );
				}} );
				
				if (webView)
					webView.removeEventListener(Event.COMPLETE, onWebLoaded);
			}
		}
		private function onWebViewError(e:ErrorEvent):void
		{
			closeWebView(0, null, false);
			webViewOpen = false;
			overlay.errorConnect();
			
			if (webView)
				webView.removeEventListener(ErrorEvent.ERROR, onWebViewError);
		}
		
		private function setupWebView(url:String = ""):void
		{
			webViewOpen = true;
			canTouchThis = true;
			var w:Number = (Device.width - webviewOffset) * Device.relativeScale;
			var h:Number = Device.height * Device.relativeScale;
			var xx:Number = Starling.current.nativeStage.stageWidth;
			var yy:Number = (Starling.current.nativeStage.stageHeight - h) / 2;
			
			webviewRect = new Rectangle(xx, yy, w, h);
			if (webView) webView.dispose();
			webView = new StageWebView();
			webView.stage = Starling.current.nativeStage;
			webView.viewPort = webviewRect;
			webView.loadURL(url);
			webView.addEventListener(flash.events.Event.COMPLETE, onWebLoaded);
			webView.addEventListener(ErrorEvent.ERROR, onWebViewError);
			webView.assignFocus();
			
			if (options.opened == true) 
				options.close();
		}
		
		public function closeWebView(time:Number = 0.3, callback:Function = null, closeOverlay:Boolean = true):void
		{
			if (canTouchThis == true)
			{
				webViewOpen = false;
				canTouchThis = false;
				
				if (closeOverlay==true)
				{
					AnalyticsData.trackPage("/start_screen");
					overlay.close();
				}
				
				if (webView)
				{
					var h:Number = Device.height * Device.relativeScale;
					var yy:Number = (Starling.current.nativeStage.stageHeight - h) / 2;
					
					webviewRect.y = yy;
					TweenMax.to(webviewRect, time, { x:Starling.current.nativeStage.stageWidth, ease:Quint.easeIn, onUpdate:function():void 
					{
						webView.viewPort = webviewRect;
					}, onComplete:function():void 
					{
						webView.stop();
						if (webView) webView.dispose();
						webView = null;
						if (callback != null)
							callback();
						
						canTouchThis = true;
					}} );
				}
			}
		}
		
		public function closeApplication():void
		{
			NativeApplication.nativeApplication.exit(); 
		}
		
		public function onResize():void
		{
			if (webView)
			{
				var w:Number = (Device.width - webviewOffset) * Device.relativeScale;
				var h:Number = Device.height * Device.relativeScale;
				var yy:Number = (Starling.current.nativeStage.stageHeight - h) / 2;
				var xx:Number = (webviewOffset * Device.relativeScale) + ((Starling.current.nativeStage.stageWidth - (Device.width * Device.relativeScale)) / 2);
				
				webviewRect.x = xx;
				webviewRect.width = w;
				webviewRect.height = h;
				webviewRect.y = yy;
				
				webView.viewPort = webviewRect;
			}
		}
		
		private function action():void
		{
			if (options.opened == true) 
			{
				options.action();
			}else if (overlay.opened == true)
			{
				if (overlay.bt_exit.selected == true)
				{
					closeWebView();
					/*}else {
					if (webView)
						webView.assignFocus();*/
				}
			}else
			{
				if (canUseButton==true)
				{
					buttons[currButton].downState();
					if (currButton == 0)
					{
						closeStart();
					}else if(currButton==1)
					{
						openRanking();
					}else if(currButton==2)
					{
						openInfo();
					}else if(currButton==3)
					{
						options.open();
					}else if (currButton == 4)
					{
						closeApplication();
					}
				}
			}
		}
		
		private	function onRight():void 
		{
			if (options.opened == true) 
			{
				options.onRight();
			}else
			{
				if (currButton == 4)
				{
					selectButton(0);
				}else if (currButton == 0)
				{
					selectButton(1);
				}else if (currButton == 3)
				{
					selectButton(2);
				}
			}
		}
		
		private function onLeft():void
		{
			if (options.opened == true) 
			{
				options.onLeft();
			}else
			{
				if (currButton == 0)
				{
					selectButton(4);
				}else if (currButton == 1)
				{
					selectButton(0);
				}else if (currButton == 2)
				{
					selectButton(3);
				}
			}
		}
		
		private function onUp():void
		{
			if (options.opened == true) 
			{
				options.onUp();
			}else if (overlay.opened == true)
			{
				//overlay.bt_exit.unselect();
			}else
			{
				if (currButton == 0)
				{
					selectButton(3);
				}else if (currButton == 1)
				{
					selectButton(2);
				}
			}
		}
		
		private function onDown():void
		{
			if (options.opened == true) 
			{
				options.onDown();
			}else if (overlay.opened == true)
			{
				//overlay.bt_exit.select();
			}else
			{
				if (currButton == 2)
				{
					selectButton(1);
				}else if (currButton == 3)
				{
					selectButton(0);
				}
			}
		}
		
		private function selectButton(index:int = 0, playsound:Boolean = true):void
		{
			for (var i:int = 0; i < buttons.length; i++) 
			{
				if (i == index)
				{
					buttons[i].select(playsound);
				}else
				{
					buttons[i].unselect();
				}
			}
			currButton = index;
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			InputManager.removeAllInputs();
		}
		
		public function stop():void
		{
			this.visible = false;
		}
		
		public function start():void
		{
			this.visible = true;
		}
	}
}