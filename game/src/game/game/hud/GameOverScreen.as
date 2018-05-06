package game.game.hud 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import game.data.AnalyticsData;
	import game.game.objects.MoreNameButton;
	import game.game.objects.TitleObject;
	import game.game.sounds.SoundManager;
	import game.inputs.gamepads.GenericGamepad;
	import game.inputs.gamepads.Xbox360Gamepad;
	import game.inputs.InputManager;
	import starling.display.Shape;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	
	import game.assets.Assets;
	import game.assets.Device;
	import game.data.GameData;
	import game.game.objects.ArcadeName;
	import game.game.objects.MenuButton;
	import game.utils.math.MathHelper;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class GameOverScreen extends Sprite 
	{
		private var background:Quad;
		private var title:TitleObject;
		private var buttonContinue:MenuButton;
		private var buttonExit:MenuButton;
		private var scoreContainer:Sprite;
		private var scoreBoxBG:Image;
		private var score:TextField;
		private var hiscore:TextField;
		private var nameLetters:ArcadeName;
		private var moreName:MoreNameButton;
		private var scoreMedalContainer:Sprite;
		private var scoreMedal:Image;
		private var scoreMedalShiny:Quad;
		private var maskedMedal:PixelMaskDisplayObject;
		private var scoreMedalSmoke:Image;
		private var totalFont:BitmapFont;
		private var textFont:BitmapFont;
		private var txt:TextField;
		
		private var nameScreen:NameScreen;
		
		public var clickFunction:Function = null;
		private var inputType:String;
		private var controlHelp:Array = [];
		
		private var controlSelected:int = -1;
		private var letterSelected:Boolean = false;
		private var easeConfig:Point = new Point(1.2, 0.8);
		private var canTouchThis:Boolean = true;
		
		public function GameOverScreen() 
		{
			controlHelp["gamepad"] = {text:"you can press start to continue"};
			controlHelp["gamepadXbox"] = {text:"you can press start to continue"};
			controlHelp["keyboard"] = {text:"you can press space to continue"};
			controlHelp["touch"] = { text:"you can tap the screen to continue" };
			
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			totalFont = Assets.getFont("textHUD");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			inputType = GameData.inputType;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			background = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			background.alpha = GameData.overlayAlpha;
			addChild(background);
			
			title = new TitleObject(Assets.getAtlas('interface', 1).getTexture('gameover_title'));
			title.x = stage.stageWidth / 2;
			title.y = -title.height + 20;
			addChild(title);
			
			scoreContainer = new Sprite();
			scoreBoxBG = new Image(Assets.getAtlas('interface_hud', 1).getTexture('score_box'));
			scoreBoxBG.x = -scoreBoxBG.width / 2;
			scoreBoxBG.y = -scoreBoxBG.height / 2;
			scoreContainer.addChild(scoreBoxBG);
			
			scoreMedalSmoke = new Image(Assets.getAtlas('interface_intro', 1).getTexture('smoke_small'));
			scoreMedalSmoke.pivotX = scoreMedalSmoke.width / 2;
			scoreMedalSmoke.pivotY = scoreMedalSmoke.height / 2;
			scoreMedalSmoke.x = -97 * Device.scale;
			scoreMedalSmoke.y = -20;
			scoreMedalSmoke.scaleX = 0.5;
			scoreMedalSmoke.scaleY = 0.8;
			scoreMedalSmoke.alpha = 0;
			scoreContainer.addChild(scoreMedalSmoke);
			
			scoreMedalContainer = new Sprite();
			
			scoreMedal = new Image(Assets.getAtlas('interface_hud', 1).getTexture('medal'));
			scoreMedal.pivotX = scoreMedal.width / 2;
			scoreMedal.pivotY = scoreMedal.height / 2;
			scoreMedalContainer.addChild(scoreMedal);
			
			scoreMedalShiny = new Quad(40, scoreMedal.width, 0xffffff);
			scoreMedalShiny.alpha = 0.3;
			scoreMedalShiny.pivotX = scoreMedalShiny.width / 2;
			scoreMedalShiny.pivotY = scoreMedalShiny.height / 2;
			scoreMedalShiny.rotation = deg2rad(-45);
			scoreMedalShiny.x = 0;
			scoreMedalShiny.y = scoreMedal.width;
			
			var msk:Image = new Image(Assets.getAtlas('interface_hud', 1).getTexture('medal'));
			
			maskedMedal = new PixelMaskDisplayObject(-1, true);
			maskedMedal.addChild(scoreMedalShiny);
			
			maskedMedal.x = - scoreMedal.width / 2;
			maskedMedal.y = - scoreMedal.width / 2;
			
			maskedMedal.mask = msk;
			scoreMedalContainer.addChild(maskedMedal);
			
			scoreMedalContainer.x = -95;
			scoreMedalContainer.y = -150;
			scoreMedalContainer.scaleX = scoreMedalContainer.scaleY = 2;
			scoreMedalContainer.alpha = 0;
			scoreContainer.addChild(scoreMedalContainer);
			
			score = new TextField(200, 100,  "0", totalFont.name, 80, 0xffffff);
			score.hAlign = HAlign.CENTER;
			score.pivotX = score.width/2;
			score.pivotY = score.height/2;
			score.x = 115 * Device.scale;
			score.y = -35 * Device.scale;
			scoreContainer.addChild(score);
			
			hiscore = new TextField(200, 80,  "0", totalFont.name, 60, 0xffffff);
			hiscore.hAlign = HAlign.CENTER;
			hiscore.pivotX = hiscore.width/2;
			hiscore.pivotY = hiscore.height/2;
			hiscore.x = 115 * Device.scale;
			hiscore.y = 85 * Device.scale;
			scoreContainer.addChild(hiscore);
			
			nameLetters = new ArcadeName();
			nameLetters.pivotX = nameLetters.width / 2;
			nameLetters.pivotY = nameLetters.height / 2;
			nameLetters.x = -62 * Device.scale;
			nameLetters.y = -10;
			scoreContainer.addChild(nameLetters);
			
			moreName = new MoreNameButton();
			moreName.x = -95 * Device.scale;
			moreName.y = 85 * Device.scale;
			moreName.overOut(false);
			scoreContainer.addChild(moreName);
			
			scoreContainer.x = stage.stageWidth / 2;
			scoreContainer.y = stage.stageHeight + scoreContainer.height;
			addChild(scoreContainer);
			
			buttonExit = new MenuButton(Assets.getAtlas('interface').getTexture('bt_p_exit'), Assets.getAtlas('interface').getTexture('bt_s_exit_over'), new Point(5, 48));
			buttonExit.x = ((stage.stageWidth - buttonExit.button.width) /2);
			buttonExit.y = stage.stageHeight + buttonExit.button.height + 80;
			buttonExit.clickFunction = submitAndExit;
			buttonExit.overOut(false);
			addChild(buttonExit);
			
			buttonContinue = new MenuButton(Assets.getAtlas('interface_hud').getTexture('bt_s_continue'), Assets.getAtlas('interface_hud').getTexture('bt_s_continue_ov'), new Point(1, 76));
			buttonContinue.offsetX = 0;
			buttonContinue.scaleY = buttonContinue.scaleX = 1;
			buttonContinue.x = ((stage.stageWidth - buttonContinue.button.width) /2);
			buttonContinue.y = stage.stageHeight + buttonContinue.button.height + 50;
			buttonContinue.clickFunction = submitAndContinue;
			buttonContinue.overOut(false);
			addChild(buttonContinue);
			
			txt = new TextField(900, 35, controlHelp[inputType].text, textFont.name, 30, 0xFFFFFF);
			txt.alpha = 0;
			txt.hAlign = HAlign.CENTER;
			txt.x = (stage.stageWidth - txt.width) / 2;
			txt.y = stage.stageHeight - (60 * Device.scale);
			addChild(txt);
			
			TweenMax.to(this, 0, { autoAlpha:0 } );
			
			nameLetters.updateName(GameData.nick);
			nameScreen = new NameScreen();
			nameScreen.clickFunction = function():void
			{
				var nm:String = (GameData.userName == "") ? "aditional name" : GameData.userName; 
				moreName.changeText(nm);
			}
			addChild(nameScreen);
			
			moreName.clickFunction = nameScreen.open;
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (canTouchThis == true && e.getTouch(this, TouchPhase.ENDED))
				close(1);
		}
		
		public function onLeft():void 
		{
			if (letterSelected==true && controlSelected == 0)
			{
				nameLetters.selectLetter(nameLetters.selected - 1);
			}
		}
		public function onRight():void 
		{
			if (letterSelected==true && controlSelected == 0)
			{
				nameLetters.selectLetter(nameLetters.selected + 1);
			}
		}
		public function onUp():void 
		{
			if (controlSelected == 0)
			{
				if (nameLetters.canEdit == true)
				{
					nameLetters.changeLetter(1);
				}else
				{
					selectControl(controlSelected - 1);
				}
			}else
			{
				selectControl(controlSelected - 1);
			}
		}
		public function onDown():void 
		{
			if (controlSelected == 0)
			{
				if (nameLetters.canEdit == true)
				{
					nameLetters.changeLetter(-1);
				}else
				{
					selectControl(controlSelected + 1);
				}
			}else
			{
				selectControl(controlSelected + 1);
			}
		}
		public function onAction():void 
		{
			if (controlSelected == 0)
			{
				if (nameLetters.canEdit == false)
				{
					nameLetters.edit();
				}else
				{
					nameLetters.unedit();
				}
			}else if (controlSelected == 3)
			{
				submitAndContinue();
			}else if (controlSelected == 2)
			{
				submitAndExit();
			}else if (controlSelected == 1)
			{
				nameScreen.open();
			}
		}
		
		public function selectControl(id:int = 0, playsound:Boolean = true, animate:Boolean = true):void
		{
			id = (id > 3) ? 0 : id;
			id = (id < 0) ? 3 : id;
			letterSelected = false;
			
			if (id == 0)
			{
				buttonContinue.unselect();
				buttonExit.unselect();
				nameLetters.select(playsound, animate);
				moreName.unselect();
				letterSelected = true;
			}
			
			if (id == 1)
			{
				moreName.select(playsound);
				buttonContinue.unselect();
				buttonExit.unselect();
				nameLetters.unselect();
				letterSelected = true;
			}
			
			if (id == 2)
			{
				buttonContinue.unselect();
				buttonExit.select();
				nameLetters.unselect();
				moreName.unselect();
			}
			
			if (id == 3)
			{
				buttonContinue.select();
				buttonExit.unselect();
				nameLetters.unselect();
				moreName.unselect();
			}
			
			controlSelected = id;
		}
		
		public function submitAndContinue():void
		{
			close(1);
		}
		public function submitAndExit():void
		{
			canTouchThis = false;
			submit(1);
			GameData.main.changeScene("startSkip");
		}
		
		public function submit(type:int = 0):void
		{
			var name:String = GameData.userName;
			var fid:String = GameData.fid;
			var uid:String = GameData.uid;
			
			GameData.updateNick(name, nameLetters.selectedName, function():void 
			{
				GameData.getNick(function(name:String = "AAA"):void
				{ 
					nameLetters.updateName(name);
				});
			});
			
			AnalyticsData.trackEvent("userData", uid + ";" + nameLetters.selectedName + ";" + name + ";" + fid , GameData.position.toString() + ";" + GameData.points);
			GameData.addUserInfo(name, nameLetters.selectedName, fid, GameData.points, GameData.position, type, function():void
			{
				GameData.updateUserInfo();
			});
		}
		
		public function winMedal():void
		{
			TweenMax.killTweensOf(scoreMedalContainer);
			TweenMax.to(scoreMedalContainer, 0.1, { autoAlpha:1 } );
			TweenMax.to(scoreMedalShiny, 1, { x:scoreMedal.width, y:0, ease:Quint.easeInOut, delay:0.2 } );
			TweenMax.to(scoreMedalContainer, 0.5, { y: -10, scaleX:1, scaleY:1, ease:Bounce.easeOut, onComplete:function():void 
			{
				TweenMax.delayedCall(1, function():void 
				{
					if (GameData.is_mobile == false && GameData.nick!="AAA")
					{
						selectControl(3, false, false);
					}else{
						selectControl(0, false, false);
						nameLetters.edit();
						nameLetters.selectLetter(0);
					}
					TweenMax.to(nameLetters, 0.2, { autoAlpha:1 } );
				});
			} } );
			TweenMax.to(scoreContainer, 0.1, { scaleX:0.95, scaleY:0.95, ease:Quint.easeOut, delay:0.23 } );
			TweenMax.to(scoreContainer, 0.8, { scaleX:1, scaleY:1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), delay:0.33 } );
			
			TweenMax.killTweensOf(scoreMedalSmoke);
			TweenMax.to(scoreMedalSmoke, 0, { autoAlpha:0.6, delay:0.25 } );
			TweenMax.to(scoreMedalSmoke, 0.8, { scaleX:0.8, scaleY:1, rotation:deg2rad(-4) ,ease:Sine.easeOut, delay:0.2 } );
			TweenMax.to(scoreMedalSmoke, 0.5, { autoAlpha:0, ease:Sine.easeIn, delay:0.25 } );
		}
		
		public function open(callback:Function = null):void
		{
			canTouchThis = true;
			TweenMax.to(scoreMedalSmoke, 0, { autoAlpha:0, scaleX:0.5, scaleY:0.8 } );
			TweenMax.to(scoreMedalContainer, 0, { autoAlpha:0, y: -150, scaleX:2, scaleY:2 } );
			TweenMax.to(scoreMedalShiny, 0, { x:0, y:scoreMedal.width} );
			TweenMax.to(nameLetters, 0, { autoAlpha:0 } );
			
			var nm:String = (GameData.userName == "") ? "aditional name" : GameData.userName; 
			moreName.changeText(nm);
			
			var skipMedal:Boolean = false;
			if (GameData.hiscore >= GameData.fullofwin)
			{
				skipMedal = true;
				TweenMax.to(scoreMedalContainer, 0, { autoAlpha:1, y: -10, scaleX:1, scaleY:1 } );
				TweenMax.to(nameLetters, 0, { autoAlpha:1 } );
			}
			
			score.text = GameData.points.toString();
			GameData.hiscore = (GameData.points > GameData.hiscore) ? GameData.points : GameData.hiscore;
			hiscore.text = GameData.hiscore.toString();
			
			if (skipMedal == false && GameData.points < GameData.fullofwin)
				TweenMax.to(nameLetters, 0, { autoAlpha:1 } );
			
			TweenMax.to(this, 0.2, { autoAlpha:1, onComplete:function():void 
			{
				SoundManager.playSound("menuIn", "", 1, 0.4);
				TweenMax.killTweensOf(title);
				TweenMax.to(txt , 0.3, { alpha:1, delay:0.5} );
				TweenMax.to(title, 0.6, { y:90 * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void
				{
					title.open();
				}} );
				TweenMax.to(scoreContainer , 0.6, { y:300 * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				TweenMax.to(buttonContinue , 0.6, { y:568 * Device.scale, delay:0.3, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{buttonContinue.open()}} );
				TweenMax.to(buttonExit , 0.6, { y:468 * Device.scale, delay:0.15, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void 
				{
					buttonExit.open();
					
					if (skipMedal == false && GameData.points >= GameData.fullofwin)
						winMedal();
					
					if (GameData.is_mobile == false && GameData.nick!="AAA")
					{
						selectControl(3, false, false);
					}else
					{
						selectControl(0, false, false);
						nameLetters.edit();
						nameLetters.selectLetter(0);
					}
					
					TweenMax.delayedCall(0, function():void 
					{
						background.addEventListener(TouchEvent.TOUCH, onTouch);
					});
					
					if (callback != null)
						callback();
				}});
			}});
		}
		
		public function close(type:int = 0):void
		{
			if (canTouchThis == true)
			{
				canTouchThis = false;
				background.removeEventListener(TouchEvent.TOUCH, onTouch);
				
				SoundManager.playSound("menuOut", "", 1, 0.4);
				submit(type);
				nameLetters.unselect();
				TweenMax.to(title, 0.3, { y: -title.height + 20, ease:Back.easeIn, onComplete:function():void
				{
					title.close();
				}} );
				
				nameLetters.selectLetter(-1, true);
				
				TweenMax.to(scoreContainer , 0.3, { y:stage.stageHeight + scoreContainer.height, delay:0.2, ease:Back.easeIn } );
				TweenMax.to(buttonContinue , 0.3, { y:stage.stageHeight + buttonContinue.button.height + 50, ease:Back.easeIn, onComplete:function():void{buttonContinue.close()}} );
				TweenMax.to(buttonExit , 0.3, { y:stage.stageHeight + buttonExit.button.height + 80, delay:0.1, ease:Back.easeIn, onComplete:function():void { buttonExit.close() }} );
				TweenMax.to(txt , 0.1, { alpha:0} );
				
				TweenMax.to(this, 0.2, { autoAlpha:0, delay:0.5, onComplete:function():void 
				{
					if (clickFunction != null)
						clickFunction();
				}});
			}
		}
		
		private function remove(e:Event):void 
		{
			background.removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}