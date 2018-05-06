package game.game.sounds 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import game.assets.Assets;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class SoundObject
	{
		private var sound:Sound;
		private var channel:SoundChannel;
		
		public var paused:Boolean = false;
		public var isplaying:Boolean = false;
		
		public var name:String = "";
		public var assetName:String = "";
		public var volume:Number = 1;
		public var loops:int = 1;
		public var position:Number = 0;
		public var onComplete:Function = null;
		public var type:String = "sfx";
		
		public var loops_done:int = 0;
		public var loops_todo:int = 0;
		
		public function SoundObject(name:String ="", assetName:String = "", loops:int = 1, volume:Number = 1, type:String = "sfx") 
		{
			this.type = type;
			this.loops = loops;
			this.name = name;
			this.volume = volume;
			this.assetName = (assetName=="") ? name : assetName;
			this.loops_todo = loops;
		}
		
		private function onCompleteHandler(e:Event):void 
		{
			loops_done ++;
			if (loops != -1)
			{
				loops_todo--;
				loops_todo = (loops_todo < 0) ?  0 : loops_todo;
			}else
			{
				loops_todo = -1;
			}
			if (loops != -1 && loops_done >= loops)
			{
				if (onComplete != null)
					onComplete(this);
			}else
			{
				play();
			}
			e.target.removeEventListener(Event.SOUND_COMPLETE, onCompleteHandler);
		}
		
		public function play():void
		{
			if (assetName != "")
			{
				sound = Assets.getSound(this.assetName);
				var lps:int = (loops == -1) ? 999 : loops;
				var init:int = (loops == -1) ? 80 : 0;
				channel = sound.play(init, lps);
				if (channel!= null)
				{
					var masterVolume:Number = (type == "sfx") ? SoundManager.sfx_volume : (type == "music") ? SoundManager.music_volume : 1;
					channel.soundTransform = new SoundTransform(volume * masterVolume);
					channel.addEventListener(Event.SOUND_COMPLETE, onCompleteHandler);
				}else
				{
					trace("Warning: Channel must not be null to play. (" + this.name + ")");
				}
			}else
			{
				trace("Warning: Sound needs an asset name.");
			}
		}
		
		public function pause():void
		{
			if (channel != null)
			{
				paused = true;
				position = channel.position;
				channel.removeEventListener(Event.SOUND_COMPLETE, onCompleteHandler);
				channel.stop();
			}else
			{
				trace("Warning: Channel must not be null to pause. (" + this.name + ")");
			}
		}
		
		public function resume():void
		{
			if (channel != null)
			{
				if (assetName != "")
				{
					if (paused == true)
					{
						sound = Assets.getSound(assetName);
						var lps:int = (loops == -1) ? 999 : loops_todo;
						channel = sound.play(position, lps);
						if(channel != null)
							channel.addEventListener(Event.SOUND_COMPLETE, onCompleteHandler);
						
						paused = false;
					}
				}else
				{
					trace("Warning: Sound needs an asset name.");
				}
				
				if (channel)
				{
					var masterVolume:Number = (type == "sfx") ? SoundManager.sfx_volume : (type == "music") ? SoundManager.music_volume : 1;
					channel.soundTransform = new SoundTransform(volume * masterVolume);
				}
			}else
			{
				trace("Warning: Channel must not be null to resume. (" + this.name + ")");
			}
		}
		
		public function stop():void 
		{
			if (channel != null)
			{
				position = 0;
				channel.stop();
				if(channel != null)
					channel.removeEventListener(Event.SOUND_COMPLETE, onCompleteHandler);
				
				sound = null;
				channel = null;
			}else
			{
				trace("Warning: Channel must not be null to stop. (" + this.name + ")");
			}
		}
		
		public function setVolume(volume:Number = -1):void
		{
			var vlm:Number = (volume == -1) ? this.volume : volume;
			var masterVolume:Number = (type == "sfx") ? SoundManager.sfx_volume : (type == "music") ? SoundManager.music_volume : 1;
			
			if(channel != null)
				channel.soundTransform = new SoundTransform(vlm * masterVolume);
		}
	}
}