package game.game.objects 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonObject extends Sprite
	{
		public function ButtonObject() { }
		
		public function downState():void{}
		public function upState():void{}
		public function over(playsound:Boolean = true):void{}
		public function overOut(playsound:Boolean = true):void{}
		public function select(playsound:Boolean = true):void{}
		public function unselect():void{}
	}
}