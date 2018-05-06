package game.data 
{
	import com.google.analytics.AnalyticsTracker;
	import eu.alebianco.air.extensions.analytics.GATracker;
	import flash.display.DisplayObject;
	import org.flashdevelop.utils.FlashConnect;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class AnalyticsData 
	{
		public static var tracker:GATracker;
		public static var trackerA:AnalyticsTracker; 1
		public static var GAID:String = "UA-50133794-1";
		
		public static function initTracker(container:DisplayObject = null):void
		{
			if (GATracker.isSupported()) 
			{
				tracker = GATracker.getInstance();
				tracker.startNewSession(GAID, 20);
			}else
			{
				trackerA = new com.google.analytics.GATracker(container, GAID, "AS3", false);
			}
		}
		
		public static function debug(textfield:TextField = null):void
		{
			if (tracker && textfield != null)
			{
				textfield.text = String(tracker.version);
			}
		}
		
		public static function trackPage(page:String = ""):void
		{
			if (tracker)
			{
				tracker.trackPageView(page);
			}
			
			if (trackerA)
			{
				trackerA.trackPageview(page);
			}
		}
		
		public static function trackEvent(category:String = "", action:String = "", label:String = "", value:int = -1):void
		{
			if (tracker)
			{
				tracker.trackEvent(category, action, label, value);
			}
			
			if (trackerA)
			{
				trackerA.trackEvent(category, action, label, value);
			}
		}
	}
}