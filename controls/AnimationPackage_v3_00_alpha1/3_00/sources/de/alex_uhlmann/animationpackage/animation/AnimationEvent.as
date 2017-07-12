package de.alex_uhlmann.animationpackage.animation {
	
	import flash.events.Event;
		
	public class AnimationEvent extends Event {
		
		public static const START:String = "onStart";
		public static const UPDATE:String = "onUpdate";
		public static const END:String = "onEnd";
		public var value:*;		
		
		public function AnimationEvent(eventType:String,
										value:* = null)
		{
			super(eventType, false, false);
	
			this.value = value;
		}
	}
}