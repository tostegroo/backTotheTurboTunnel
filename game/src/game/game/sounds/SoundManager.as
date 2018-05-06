package game.game.sounds 
{
	import flash.events.Event;
	import flash.media.AudioPlaybackMode;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;	
	import game.assets.Assets;
	import game.data.GameData;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class SoundManager 
	{	
		public static var soundOn:Boolean = true;
		private static var musicTransform:SoundTransform = new SoundTransform(0.8, 0);
		SoundMixer.soundTransform = musicTransform;
		SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
		
		public static var sfx_volume:Number = 0.5;
		public static var music_volume:Number = 0.7;
		
		private static var sounds:Vector.<SoundObject> = new Vector.<SoundObject>();
		
		public static function playSound(name:String, assetName:String = "", loops:int = 1, volume:Number = 1, type:String = "sfx"):void
		{
			var index:int = getIndexSoundByName(name);
			if (index == -1)
			{
				var snd:SoundObject = new SoundObject(name, assetName, loops, volume, type);
				snd.onComplete = oncomplete;
				sounds.push(snd);
				snd.play();
			}
		}
		
		static private function oncomplete(e:SoundObject):void 
		{
			var index:int = sounds.indexOf(e);
			if (index != -1)
				sounds.splice(index, 1);
		}
		
		static public function pauseSound(name:String = ""):void
		{
			if (name == "all")
			{
				for (var i:int = 0; i < sounds.length; i++) 
				{
					sounds[i].isplaying = (sounds[i].paused == true) ? false : true;
					sounds[i].pause();
				}
			}else
			{
				var index:int = getIndexSoundByName(name);
				if (index!=-1 && sounds[index] != null)
				{
					sounds[index].pause();
				}
			}
		}
		
		static public function resumeSound(name:String = ""):void
		{
			if (name == "all")
			{
				for (var i:int = 0; i < sounds.length; i++) 
				{
					if (sounds[i].isplaying)
					{
						sounds[i].isplaying = false;
						sounds[i].resume();
					}
				}
			}else
			{
				var index:int = getIndexSoundByName(name);
				if (index!=-1 && sounds[index] != null)
				{
					sounds[index].resume();
				}
			}
		}
		
		static public function stopSound(name:String = "", type:String = ""):void 
		{
			if (name == "all")
			{
				for (var i:int = 0; i < sounds.length; i++) 
				{
					if (type=="" || type == sounds[i].type)
					{
						sounds[i].stop();
					}
				}
				sounds = new Vector.<SoundObject>();
			}else
			{
				var index:int = getIndexSoundByName(name);
				if (index!=-1 && sounds[index] != null)
				{
					sounds[index].stop();
					sounds.splice(index, 1);
				}
			}
		}
		
		static public function setVolumeByName(name:String = "", volume:Number = 0):void 
		{
			if (name != "")
			{
				var index:int = getIndexSoundByName(name);
				if (index > 0)
				{
					sounds[index].setVolume(volume);
				}
			}
		}
		
		static public function setVolumeByType(type:String = "", volume:Number = 0):void 
		{
			if (type != "")
			{
				for (var i:int = 0; i < sounds.length; i++) 
				{
					if (sounds[i].type == type)
						sounds[i].setVolume(volume);
				}
			}
		}
		
		static public function setMasterVolumeByType(type:String = "", volume:Number = 0):void 
		{
			if (type != "")
			{
				if(type=="sfx")
					sfx_volume = volume;
				
				if(type=="music")
					music_volume = volume;
				
				for (var i:int = 0; i < sounds.length; i++) 
				{
					if (sounds[i].type == type)
						sounds[i].setVolume();
				}
			}
		}
		
		static public function getIndexSoundByName(name:String = ""):int
		{
			var index:int = -1;
			for (var i:int = 0; i < sounds.length; i++) 
			{
				if (sounds[i].name == name)
				{
					index = i;
					break;
				}
			}
			return index;
		}
		
		static public function SoundOff():void
		{
			pauseSound("all");
			musicTransform.volume = 0;
			SoundMixer.soundTransform = musicTransform;
			soundOn = false;
		}
		
		static public function SoundOn():void
		{
			resumeSound("all");
			musicTransform.volume = 0.8;
			SoundMixer.soundTransform = musicTransform;
			soundOn = true;
		}
	}
}