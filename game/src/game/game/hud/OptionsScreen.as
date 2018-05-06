package game.game.hud 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.assets.Device;
	import game.data.AnalyticsData;
	import game.data.GameData;
	import game.game.objects.MenuButton;
	import game.game.objects.Slide;
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
	 * @author Fabio Toste
	 */
	public class OptionsScreen extends Sprite
	{
		private var background:Quad;
		private var title:TitleObject;
		private var slideSFX:Slide;
		private var slideMusic:Slide;
		private var bt_exit:MenuButton;
		public var clickFunction:Function = null;
		private var inputType:String;
		private var controlSelected:int = 2;
		public var opened:Boolean = false;
		
		private var controlHelp:Array = [];
		private var easeConfig:Point = new Point(1.2, 0.8);
		
		public function OptionsScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			background = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			background.alpha = 0.9; //GameData.overlayAlpha;
			addChild(background);
			
			title = new TitleObject(Assets.getAtlas('interface', 1).getTexture('options_title'));
			title.x = stage.stageWidth / 2;
			title.y = -title.height + (20 * Device.scale);
			addChild(title);
			
			slideSFX = new Slide('sfx_text', 'sfx_no', 'sfx');
			slideSFX.x = ((stage.stageWidth - slideSFX.width) / 2) - (60 * Device.scale);
			slideSFX.y = stage.stageHeight + slideSFX.height + (50 * Device.scale);
			addChild(slideSFX);
			
			slideMusic = new Slide('music_text', 'music_no', 'music');
			slideMusic.x = ((stage.stageWidth - slideMusic.width) / 2) - (40 * Device.scale);
			slideMusic.y = stage.stageHeight + slideMusic.height + (70 * Device.scale);
			addChild(slideMusic);
			
			bt_exit = new MenuButton(Assets.getAtlas('interface').getTexture('bt_p_back'), Assets.getAtlas('interface').getTexture('bt_p_back_over'), new Point(6, 52));
			bt_exit.x = (stage.stageWidth - bt_exit.button.width) / 2;
			bt_exit.y = stage.stageHeight + bt_exit.button.height + (90 * Device.scale);
			bt_exit.clickFunction = close;
			addChild(bt_exit);
			bt_exit.overOut(false);
			selectControl(2, false);
			
			TweenMax.to(this, 0, { autoAlpha:0 } );
		}
		
		public function action():void
		{
			if (controlSelected == 2 && opened == true)
			{
				close();
			}
		}
		
		public function onRight():void 
		{
			if (controlSelected == 0)
			{
				slideSFX.setValue(slideSFX.value + slideSFX.step, 0.2);
			}else if (controlSelected == 1)
			{
				slideMusic.setValue(slideMusic.value + slideMusic.step, 0.2);
			}
		}
		
		public function onLeft():void
		{
			if (controlSelected == 0)
			{
				slideSFX.setValue(slideSFX.value - slideSFX.step, 0.2);
			}else if (controlSelected == 1)
			{
				slideMusic.setValue(slideMusic.value - slideMusic.step, 0.2);
			}
		}
		
		public function onUp():void
		{
			selectControl(controlSelected - 1);
		}
		
		public function onDown():void
		{
			selectControl(controlSelected + 1);
		}
		
		public function selectControl(id:int = 0, playsound:Boolean = true):void
		{
			id = (id > 2) ? 0 : id;
			id = (id < 0) ? 2 : id;
			
			if (id == 0)
			{
				slideSFX.select();
				slideMusic.unselect();
				bt_exit.unselect();
			}
			
			if (id == 1)
			{
				slideSFX.unselect();
				slideMusic.select();
				bt_exit.unselect();
			}
			
			if (id == 2)
			{
				slideSFX.unselect();
				slideMusic.unselect();
				bt_exit.select(playsound);
			}
			
			controlSelected = id;
		}
		
		public function open(callback:Function = null):void
		{
			opened = true;
			
			InputManager.keyboard.backFunction = close;
			
			AnalyticsData.trackPage("/options");
			
			TweenMax.to(this, 0.2, { autoAlpha:1, onComplete:function():void 
			{
				SoundManager.playSound("menuIn", "", 1, 0.4);
				
				var basebt:Number = 325 * Device.scale;
				TweenMax.to(slideSFX, 0.6, { y:basebt, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), delay:0, onComplete:function():void{slideSFX.open()}} );
				TweenMax.to(slideMusic, 0.6, { y:basebt + slideSFX.button.button.height + (40 * Device.scale), delay:0.1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{slideMusic.open()}} );
				
				TweenMax.to(bt_exit, 0.6, { y:stage.stageHeight - (135 * Device.scale), delay:0.2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void
				{
					bt_exit.open();
					if (callback != null)
						callback();
				}} );
				
				TweenMax.to(title, 0.6, {y:Math.floor(100 * Device.scale), ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void
				{
					title.open();
				}} );
				selectControl(2);
			}});
		}
		
		public function close():void
		{
			if (opened == true)
			{
				opened = false;
				GameData.updateVolume(SoundManager.sfx_volume, SoundManager.music_volume);
				
				SoundManager.playSound("menuOut", "", 1, 0.4);
				
				InputManager.keyboard.backFunction = null;
				
				TweenMax.to(title, 0.3, { y: -title.height + (20 * Device.scale), ease:Back.easeIn, onComplete:function():void
				{
					title.close();
				}} );
				TweenMax.to(slideSFX, 0.3, { y:stage.stageHeight + slideSFX.button.button.height + (50 * Device.scale), delay:0.2, ease:Back.easeIn, onComplete:function():void{slideSFX.close()}} );
				TweenMax.to(slideMusic, 0.3, { y:stage.stageHeight + slideMusic.button.button.height + (70 * Device.scale), delay:0.1, ease:Back.easeIn, onComplete:function():void{slideMusic.close()}} );
				TweenMax.to(bt_exit, 0.5, { y:stage.stageHeight + bt_exit.button.height + (90 * Device.scale), ease:Back.easeIn, onComplete:function():void{bt_exit.close()}} );
				
				TweenMax.to(this, 0.3, { autoAlpha:0, delay:0.3, onComplete:function():void 
				{
					AnalyticsData.trackPage("/start_screen");
					
					if (clickFunction != null)
						clickFunction();
					
				} } );
			}
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}