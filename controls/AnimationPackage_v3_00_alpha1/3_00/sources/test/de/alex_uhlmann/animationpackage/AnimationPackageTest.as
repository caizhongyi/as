package test.de.alex_uhlmann.animationpackage {

	import de.alex_uhlmann.animationpackage.APCore;
	import de.alex_uhlmann.animationpackage.IAnimationPackage;
	import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class AnimationPackageTest {
		
		public var tearDownMethod:Function;
		protected var target:Sprite;
		protected var target1:Sprite;
		protected var target2:Sprite;
		protected var target3:Sprite;
		protected var targets:Array;
		public var duration:Number = 1000;		
		protected var root:Sprite;
		private var expectedStart:*;
		private var expectedEnd:*;
		protected var hasStartEventReceived:Boolean = false;
		protected var hasUpdateEventReceived:Boolean = false;
		protected var hasEndEventReceived:Boolean = false;
		
		public function AnimationPackageTest(root:Sprite) {
			this.root = root;
			APCore.initialize(root);
		}
		
		protected function createTarget():void {			
			target = drawRectangle(100, 100, 100, 100);
			root.addChild(target);
		}
		
		protected function createCenteredTarget():void {
			target = drawRectangle(125, 125, 100, 100, -50, -50);
			root.addChild(target);
		}
		
		protected function createEmptyTarget():void {			
			target = new Sprite();
			root.addChild(target);
		}		
		
		protected function createTargets():void {
			target1 = drawRectangle(50, 50, 50, 50);
			target2 = drawRectangle(100, 100, 50, 50);
			target3 = drawRectangle(150, 150, 50, 50);
			targets = new Array(target1, target2, target3);
			root.addChild(target1);
			root.addChild(target2);
			root.addChild(target3);			
		}
		
		private function drawRectangle(x:Number, y:Number, 
												w:Number, h:Number, 
												centerX:Number = 0, centerY:Number = 0):Sprite {			
			var target:Sprite = new Sprite();
			target.x = x;
			target.y = y;
			target.graphics.lineStyle(2, 0x993333, 100);
			target.graphics.beginFill(0x666699);
			target.graphics.drawRoundRectComplex(centerX, centerY, w, h, 5, 25, 0, 0);
			target.graphics.endFill();
			return target;
		}
		
		protected function removeTarget():void {
			root.removeChild(target);
			target = null;
		}
		
		protected function removeTargets():void {			
			root.removeChild(target1);
			root.removeChild(target2);
			root.removeChild(target3);
			target1 = null;
			target2 = null;
			target3 = null;
		}
						
		protected function listenStartEvent(ap:IAnimationPackage, expectedStart:* = null, doTrace:Boolean = false):void {
			hasStartEventReceived = false;
			if( doTrace )
				ap.addEventListener(AnimationEvent.START, traceEvent);			
			ap.addEventListener(AnimationEvent.START, catchStartEvent);			
			var timer:Timer = new Timer(duration * .5, 1);
			timer.addEventListener(TimerEvent.TIMER, handleStartEvent);
			timer.start();
			this.expectedStart = expectedStart;
		}
		
		protected function listenUpdateEvent(ap:IAnimationPackage, duration:Number = 1000, doTrace:Boolean = false):void {
			hasUpdateEventReceived = false;
			if( doTrace )
				ap.addEventListener(AnimationEvent.UPDATE, traceEvent);
			ap.addEventListener(AnimationEvent.UPDATE, catchUpdateEvent);
			var timer:Timer = new Timer(duration / 2, 1);
			timer.addEventListener(TimerEvent.TIMER, handleUpdateEvent);
			timer.start();
		}
			
		protected function listenEndEvent(ap:IAnimationPackage, duration:Number = 1000, expectedEnd:* = null, doTrace:Boolean = false):void {
			hasEndEventReceived = false;
			if( doTrace )
				ap.addEventListener(AnimationEvent.END, traceEvent);			
			ap.addEventListener(AnimationEvent.END, catchEndEvent);
			var timer:Timer = new Timer(duration * 1.5, 1);
			timer.addEventListener(TimerEvent.TIMER, handleEndEvent);
			timer.start();
			this.expectedEnd = expectedEnd;
		}
				
		private function handleStartEvent(event:TimerEvent):void {
			if(!hasStartEventReceived)
				throw new Error("An AnimationEvent.START event has not been received");
		}		
		
		private function catchStartEvent(event:AnimationEvent):void {
			var currentPercentage:Number = event.currentTarget.getCurrentPercentage();
			if(currentPercentage != event.currentTarget.myAnimator.startPercent)
				throw new Error("unexpected value for getCurrentPercentage at START "+currentPercentage);
			var durationElapsed:Number = event.currentTarget.getDurationElapsed();
			if(durationElapsed >= duration || isNaN(durationElapsed))
				throw new Error("unexpected value for getDurationElapsed at START "+durationElapsed);		
			var durationRemaining:Number = event.currentTarget.getDurationRemaining();
			if(durationRemaining <= durationElapsed || isNaN(durationRemaining))
				throw new Error("unexpected value for getDurationRemaining at START "+durationRemaining);		
						
			if(expectedStart == null)
				hasStartEventReceived = true;
			else
				if(expectedStart is Array && event.value is Array)
					if(isEqual(expectedStart, event.value))
						hasStartEventReceived = true;
					else
						throw new TestError(expectedStart, event.value);
				else
					if(expectedStart == event.value)
						hasStartEventReceived = true;
					else
						throw new TestError(expectedStart, event.value);
		}
		
		private function handleUpdateEvent(event:TimerEvent):void {
			if(!hasUpdateEventReceived)
				throw new Error("An AnimationEvent.UPDATE event has not been received");
		}
		
		private function catchUpdateEvent(event:AnimationEvent):void {
			var currentPercentage:Number = event.currentTarget.getCurrentPercentage();
			if(currentPercentage == event.currentTarget.myAnimator.startPercent 
				|| isNaN(currentPercentage))
				throw new Error("unexpected value for getCurrentPercentage at UPDATE "+currentPercentage);
			var durationElapsed:Number = event.currentTarget.getDurationElapsed();
			if(durationElapsed >= (duration * 1.5) || isNaN(durationElapsed))
				throw new Error("unexpected value for getDurationElapsed at UPDATE "+durationElapsed);		
			var durationRemaining:Number = event.currentTarget.getDurationRemaining();
			if(durationRemaining >= (duration * 1.5) || isNaN(durationRemaining))
				throw new Error("unexpected value for getDurationRemaining at UPDATE "+durationRemaining);		
			
			hasUpdateEventReceived = true;
		}
		
		private function handleEndEvent(event:TimerEvent):void {
			if(!hasEndEventReceived)
				throw new Error("An AnimationEvent.END event has not been received");
		}
		
		private function catchEndEvent(event:AnimationEvent):void {
			var currentPercentage:Number = event.currentTarget.getCurrentPercentage();
			if(currentPercentage != event.currentTarget.myAnimator.endPercent || isNaN(currentPercentage))
				throw new Error("unexpected value for getCurrentPercentage at END "+currentPercentage);
			var durationElapsed:Number = event.currentTarget.getDurationElapsed();
			if(durationElapsed < duration || isNaN(durationElapsed))
				throw new Error("unexpected value for getDurationElapsed at END "+durationElapsed);		
			var durationRemaining:Number = event.currentTarget.getDurationRemaining();
			if(durationRemaining != 0 || isNaN(durationRemaining))
				throw new Error("unexpected value for getDurationRemaining at END "+durationRemaining);					
			
			if(expectedEnd == null)
				hasEndEventReceived = true;
			else
				if(expectedEnd is Array && event.value is Array)
					if(isEqual(expectedEnd, event.value))
						hasEndEventReceived = true;
					else
						throw new TestError(expectedEnd, event.value);
				else
					if(expectedEnd == event.value)
						hasEndEventReceived = true;
					else
						throw new TestError(expectedEnd, event.value);
				
		}
			
		private function traceEvent(event:AnimationEvent):void {
			trace("analyseEvent event "+event+" - event.value "+event.value);			
		}	
		
		private function isEqual(arr1:Array, arr2:Array):Boolean {			
			if(arr1.length != arr2.length)
				return false;
			for(var i:int; i < arr1.length; i++) {
				if(!isAboutEqual(arr2[i], arr1[i]))
					return false;
			}
			return true;
		}
		
		protected function isAboutEqual(firstNum:Number, secNum:Number):Boolean {
			return between(firstNum, secNum-0.0001, secNum+0.0001);
		}
				
		protected function between(num:Number, min:Number, max:Number):Boolean {
			return (num > min && num < max);
		}
	}
}
