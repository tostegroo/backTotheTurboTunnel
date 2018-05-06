package game.game.hud 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.assets.Assets;
	import game.assets.Device;
	import game.data.GameData;
	import game.game.objects.MenuButton;
	import game.game.objects.Slide;
	import game.game.objects.TitleObject;
	import game.game.sounds.SoundManager;
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
	public class PauseScreen extends Sprite
	{
		private var background:Quad;
		private var title:TitleObject;
		private var slideSFX:Slide;
		private var slideMusic:Slide;
		private var bt_exit:MenuButton;
		private var bt_continue:MenuButton;
		public var clickFunction:Function = null;
		private var inputType:String;
		private var controlSelected:int = 2;
		public var opened:Boolean = false;
		
		private var controlHelp:Array = [];
		private var easeConfig:Point = new Point(1.2, 0.8);
		
		public function PauseScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			background = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			background.alpha = GameData.overlayAlpha;
			addChild(background);
			
			title = new TitleObject(Assets.getAtlas('interface', 1).getTexture('pause_title'));
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
			
			bt_exit = new MenuButton(Assets.getAtlas('interface').getTexture('bt_p_exit'), Assets.getAtlas('interface').getTexture('bt_s_exit_over'), new Point(5, 48));
			bt_exit.x = (stage.stageWidth - bt_exit.button.width) / 2;
			bt_exit.y = stage.stageHeight + bt_exit.button.height + (90 * Device.scale);
			bt_exit.clickFunction = exit;
			addChild(bt_exit);
			bt_exit.overOut(false);
			
			bt_continue = new MenuButton(Assets.getAtlas('interface').getTexture('bt_p_continue'), Assets.getAtlas('interface').getTexture('bt_s_exit_over'), new Point(5, 48));
			bt_continue.x = ((stage.stageWidth - bt_continue.button.width) / 2) + 3;
			bt_continue.y = stage.stageHeight + bt_continue.button.height + (120 * Device.scale);
			bt_continue.rotation = Math.PI * 0.008;
			bt_continue.clickFunction = close;
			addChild(bt_continue);
			bt_continue.overOut(false);
			
			TweenMax.to(this, 0, { autoAlpha:0 } );
		}
		
		private function exit():void
		{
			opened = false;
			GameData.main.changeScene("startSkip");
		}
		
		public function action():void
		{
			if (opened == true && controlSelected == 2)
			{
				exit();
			}
			
			if (opened == true && controlSelected == 3)
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
		
		public function selectControl(id:int = 0):void
		{
			id = (id > 3) ? 0 : id;
			id = (id < 0) ? 3 : id;
			
			if (id == 0)
			{
				slideSFX.select();
				slideMusic.unselect();
				bt_exit.unselect();
				bt_continue.unselect();
			}
			
			if (id == 1)
			{
				slideSFX.unselect();
				slideMusic.select();
				bt_exit.unselect();
				bt_continue.unselect();
			}
			
			if (id == 2)
			{
				slideSFX.unselect();
				slideMusic.unselect();
				bt_exit.select();
				bt_continue.unselect();
			}
			
			if (id == 3)
			{
				slideSFX.unselect();
				slideMusic.unselect();
				bt_exit.unselect();
				bt_continue.select();
			}
			
			controlSelected = id;
		}
		
		public function open(callback:Function = null):void
		{
			opened = true;
			selectControl(3);
			TweenMax.to(this, 0.2, { autoAlpha:1, onComplete:function():void 
			{
				SoundManager.playSound("menuIn", "", 1, 0.4);
				
				title.rotation = 0;
				
				var basebt:Number = 285 * Device.scale;
				TweenMax.to(slideSFX, 0.6, { y:basebt, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), delay:0, onComplete:function():void{slideSFX.open()}} );
				TweenMax.to(slideMusic, 0.6, { y:basebt + slideSFX.height + (40 * Device.scale), delay:0.1, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{slideMusic.open()}} );
				
				TweenMax.to(bt_exit, 0.6, { y:stage.stageHeight - (260 * Device.scale), delay:0.2, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void{bt_exit.open()}} );
				
				TweenMax.to(bt_continue, 0.6, { y:stage.stageHeight - (160 * Device.scale), delay:0.3, ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void 
				{
					bt_continue.open();
					if (callback != null)
						callback();
				}} );
				
				TweenMax.to(title, 0.5, { rotation:0, y:Math.floor(90 * Device.scale), ease:Elastic.easeOut.config(easeConfig.x, easeConfig.y), onComplete:function():void
				{
					title.open();
				}} );
			}});
		}
		
		public function close():void
		{
			if (opened == true)
			{
				opened = false;
				GameData.updateVolume(SoundManager.sfx_volume, SoundManager.music_volume);
				SoundManager.playSound("menuOut", "", 1, 0.4);
				
				TweenMax.to(title, 0.3, { y: -title.height + (20 * Device.scale), ease:Back.easeIn, onComplete:function():void
				{
					title.close();
				}} );
				TweenMax.to(slideSFX, 0.3, { y:stage.stageHeight + slideSFX.height + (50 * Device.scale), delay:0.3, ease:Back.easeIn, onComplete:function():void{slideSFX.close()}} );
				TweenMax.to(slideMusic, 0.3, { y:stage.stageHeight + slideMusic.height + (70 * Device.scale), delay:0.2, ease:Back.easeIn, onComplete:function():void{slideMusic.close()}} );
				TweenMax.to(bt_exit, 0.3, { y:stage.stageHeight + bt_exit.button.height + (90 * Device.scale), delay:0.1, ease:Back.easeIn, onComplete:function():void{bt_exit.close()}} );
				TweenMax.to(bt_continue, 0.3, { y:stage.stageHeight + bt_continue.height + (120 * Device.scale), ease:Back.easeIn, onComplete:function():void{bt_continue.close()}} );
				
				TweenMax.to(this, 0.3, { autoAlpha:0, delay:0.3, onComplete:function():void 
				{
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