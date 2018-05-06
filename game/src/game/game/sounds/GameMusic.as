package game.game.sounds 
{
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class GameMusic
	{
		public function GameMusic() {}
		
		public function setVolume(balance:Number = 0):void
		{
			/*SoundManager.setVolumeByName("musicGame_bass", 0.3 + (0.15 * (1-balance)));
			SoundManager.setVolumeByName("musicGame_drums", 0.2 + (0.15 * balance));*/
		}
		
		public function stop():void
		{
			SoundManager.stopSound("musicGame");
			/*SoundManager.stopSound("musicGame_bass");
			SoundManager.stopSound("musicGame_bells");
			SoundManager.stopSound("musicGame_drums");
			SoundManager.stopSound("musicGame_riff");*/
		}
		public function play():void 
		{
			SoundManager.playSound("musicGame", "musicGame", -1, 1, "music");
			/*SoundManager.playSound("musicGame_bass", "musicGame_bass", -1, 0.4, "music");
			SoundManager.playSound("musicGame_bells", "musicGame_bells", -1, 0.2, "music");
			SoundManager.playSound("musicGame_drums", "musicGame_drums", -1, 0.3, "music");*/
		}
		
		public function pause():void
		{
			SoundManager.pauseSound("musicGame");
			/*SoundManager.pauseSound("musicGame_bass");
			SoundManager.pauseSound("musicGame_bells");
			SoundManager.pauseSound("musicGame_drums");
			SoundManager.pauseSound("musicGame_riff");*/
		}
		
		public function resume():void
		{
			SoundManager.resumeSound("musicGame");
			/*SoundManager.resumeSound("musicGame_bass");
			SoundManager.resumeSound("musicGame_bells");
			SoundManager.resumeSound("musicGame_drums");*/
		}
		
		public function playRiff():void
		{
			//SoundManager.playSound("musicGame_riff", "musicGame_riff", 1, 0.8, "music");
		}
	}
}