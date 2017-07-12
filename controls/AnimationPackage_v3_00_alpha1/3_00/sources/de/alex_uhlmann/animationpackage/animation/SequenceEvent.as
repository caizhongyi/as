package de.alex_uhlmann.animationpackage.animation {
	
	import flash.events.Event;
		
	public class SequenceEvent extends AnimationEvent {
		
		public static const UPDATE_POSITION:String = "onUpdatePosition";
		public var childDuration:Number;
		public var lastChild:IAnimatable;
		public var nextChild:IAnimatable;
		
		public function SequenceEvent(eventType:String,
										value:* = null,
										childDuration:Number = -1, 
										lastChild:IAnimatable = null,
										nextChild:IAnimatable = null)
		{
			super(eventType, value);
			
			this.childDuration = childDuration;
			this.lastChild = lastChild;
			this.nextChild = nextChild;			
		}
	}
}