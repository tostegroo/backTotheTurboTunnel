package game.game.hud 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.assets.Device;
	import game.data.GameData;
	import game.game.objects.MenuButton;
	import game.game.objects.TitleObject;
	import game.game.sounds.SoundManager;
	import game.inputs.InputManager;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author FAbio Toste
	 */
	public class InfoScreen extends Sprite
	{
		private var background:Quad;
		public var loader:Image;
		public var loading:TitleObject;
		private var title:TitleObject;
		private var subtitle:TitleObject;
		private var image:Image;
		private var textFont:BitmapFont;
		private var txt:TextField;
		public var bt_exit:MenuButton;
		public var clickFunction:Function = null;
		private var inputType:String;
		private var isMessage:Boolean = false;
		public var opened:Boolean = false;
		public var overlay:Boolean = false;
		private var canTouchThis:Boolean = true;
		
		private var controlHelp:Array = [];
		private var easeConfig:Point = new Point(1.2, 0.8);
		private var canOpenLoader:Boolean = true;
		
		public function InfoScreen() 
		{
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			controlHelp["gamepad"] = {text:"click to close"};
			controlHelp["gamepadXbox"] = {text:"click to close"};
			controlHelp["keyboard"] = {text:"click to close"};
			controlHelp["touch"] = {text:"tap to close"};
			
			inputType = GameData.inputType;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			background = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			background.alpha = 0.9;
			addChild(background);
			
			loading = new TitleObject(Assets.getAtlas('preloader', 1).getTexture('text'));
			loading.x = ((stage.stageWidth - loading.width) / 2) + 180;
			loading.y = (stage.stageHeight - loading.height) / 2;
			loading.alpha = 0;
			addChild(loading);
			
			loader = new Image(Assets.getAtlas('preloader', 1).getTexture('loader'));
			loader.pivotX = loader.width / 2;
			loader.pivotY = loader.height / 2;
			loader.x = stage.stageWidth + loader.width + (20 * Device.scale);
			loader.y = 50 * Device.scale;
			loader.alpha = 0;
			addChild(loader);
			
			title = new TitleObject(Assets.getAtlas('interface_intro', 1).getTexture('internet_title'));
			title.x = stage.stageWidth / 2;
			title.y = -(title.height + 20);
			addChild(title);
			
			subtitle = new TitleObject(Assets.getAtlas('interface_intro', 1).getTexture('no_title'));
			subtitle.x = stage.stageWidth / 2;
			subtitle.y = -(subtitle.height + 20);
			addChild(subtitle);
			
			image = new Image(Assets.getAtlas('interface_intro', 1).getTexture('internet_ico'));
			image.x = ((stage.stageWidth - image.width) / 2);
			image.y = stage.stageHeight + image.height + 20;
			addChild(image);
			
			txt = new TextField(900, 180, "", textFont.name, 40, 0xFFFFFF);
			txt.hAlign = HAlign.CENTER;
			txt.x = (stage.stageWidth - txt.width) / 2;
			txt.y = stage.stageHeight + txt.height + 40;
			addChild(txt);
			
			bt_exit = new MenuButton(Assets.getAtlas('interface').getTexture('bt_p_back'), Assets.getAtlas('interface').getTexture('bt_p_back_over'), new Point(6, 52));
			bt_exit.x = 40 * Device.scale;
			bt_exit.y = stage.stageHeight + bt_exit.button.height + (90 * Device.scale);
			addChild(bt_exit);
			bt_exit.overOut(false);
			
			background.addEventListener(TouchEvent.TOUCH, onTouch);
			TweenMax.to(this, 0, { autoAlpha:0 } );
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (isMessage == true && canTouchThis == true)
			{
				if (e.getTouch(this, TouchPhase.ENDED))
					close();
			}
		}
		
		public function action():void
		{
			close();
		}
		
		public function openOverlay(callback:Function = null):void
		{
			overlay = true
			opened = true;
			bt_exit.select();
			canTouchThis = true;
			TweenMax.to(this, 0.2, { autoAlpha:1, onComplete:function():void 
			{
				SoundManager.playSound("menuIn", "", 1, 0.4);
				
				TweenMax.to(bt_exit, 0.6, { y:stage.stageHeight - (135 * Device.scale), ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_exit.open()}} );
				
				openLoader();
				
				InputManager.keyboard.backFunction = GameData.main.startScreen.closeWebView;
				
				if (callback!= null)
					callback();
			}});
			isMessage = false;
		}
		
		public function openLoader():void 
		{
			if (canOpenLoader==true)
			{
				TweenMax.to(loading, 0.2, { autoAlpha:1, onComplete:function():void { loading.open() }} );
				TweenMax.to(loader, 0, { rotation:deg2rad(0) } );
				TweenMax.to(loader, 0.2, { x:(stage.stageWidth - (loader.width/2)) - (30 * Device.scale), autoAlpha:1, ease:Sine.easeOut } );
				TweenMax.to(loader, 1, { rotation:deg2rad(360), repeat: -1, ease:Linear.easeNone } );
			}
		}
		
		public function closeLoader():void
		{
			TweenMax.killTweensOf(loader);
			TweenMax.to(loader, 0.2, { x:stage.stageWidth + loader.width + (20 * Device.scale), autoAlpha:0, ease:Sine.easeOut } );
			TweenMax.to(loading, 0.2, { autoAlpha:0, onComplete:function():void { loading.close() }} );
		}
		
		public function errorConnect():void
		{
			canOpenLoader = false;
			closeLoader();
			txt.y = stage.stageHeight + txt.height + 40;
			txt.text = "There is something wrong \n with content loading. \n \n try again later.";
			txt.x = ((stage.stageWidth - txt.width) / 2)+ 30;
			TweenMax.to(txt, 0.6, { y:270 * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
		}
		
		public function openMessage(callback:Function = null):void
		{
			overlay = false;
			opened = true;
			canTouchThis = true;
			TweenMax.to(this, 0.2, { autoAlpha:1, onComplete:function():void 
			{
				SoundManager.playSound("noConnection");
				txt.y = stage.stageHeight + txt.height + 40;
				txt.text = "You need internet connection \n to access this content";
				TweenMax.to(subtitle, 0.6, {y:110 * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void
				{
					subtitle.open();
				}} );
				TweenMax.to(title, 0.6, { y:210 * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), delay:0.1, onComplete:function():void
				{
					title.open();
				}} );
				TweenMax.to(image, 0.6, { y:360 * Device.scale, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				
				txt.x = ((stage.stageWidth - txt.width) / 2);
				TweenMax.to(txt, 0.6, { y:590 * Device.scale, delay:0.25, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y) } );
				
				InputManager.keyboard.backFunction = close;
				
				if (callback!= null)
					callback();
			}});
			isMessage = true;
		}
		
		public function close():void
		{
			if (opened == true && canTouchThis == true)
			{
				canOpenLoader = true;
				canTouchThis = false;
				InputManager.keyboard.backFunction = null;
				
				opened = false;
				SoundManager.playSound("menuOut", "", 1, 0.4);
				var txtPos:Number = stage.stageHeight + txt.height + 40;
				if (overlay)
				{
					//txtPos = -(txt.height + 40);
					TweenMax.to(bt_exit, 0.3, { y:stage.stageHeight + bt_exit.button.height + (90 * Device.scale), ease:Back.easeIn, onComplete:function():void { bt_exit.close() }} );
					TweenMax.to(txt, 0.3, { y:txtPos,  ease:Back.easeIn } );
				}else
				{
					TweenMax.to(txt, 0.3, { y:txtPos,  ease:Back.easeIn } );
				}
				
				closeLoader();
				
				TweenMax.to(title, 0.3, { y: -title.height + 20, ease:Back.easeIn, delay:0.15, onComplete:function():void
				{
					title.close();
				}} );
				TweenMax.to(subtitle, 0.3, { y: -title.height + 20, ease:Back.easeIn, onComplete:function():void
				{
					subtitle.close();
				}} );
				TweenMax.to(image, 0.3, { y:stage.stageHeight + image.height + 20, delay:0.1, ease:Back.easeIn} );
				TweenMax.to(this, 0.3, { autoAlpha:0, delay:0.3, onComplete:function():void {} } );
				
				if (clickFunction != null)
					clickFunction();
				
				isMessage = false;
			}
		}
		
		private function remove(e:Event):void 
		{
			background.removeEventListener(TouchEvent.TOUCH, onTouch);
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}