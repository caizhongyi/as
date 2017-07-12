package test.de.alex_uhlmann.animationpackage.animation {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
	import de.alex_uhlmann.animationpackage.animation.Colorizer;
	import de.alex_uhlmann.animationpackage.animation.MoveOnQuadCurve;
	import de.alex_uhlmann.animationpackage.animation.Rotation;
	import de.alex_uhlmann.animationpackage.animation.Scale;
	import de.alex_uhlmann.animationpackage.animation.Sequence;
	import de.alex_uhlmann.animationpackage.animation.SequenceEvent;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	import test.de.alex_uhlmann.animationpackage.TestError;
	
	public class SequenceTest extends AnimationPackageTest {
		
		public var testInstance:Sequence;
		
		public function SequenceTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testAnimateModeEACH();
			//testAnimateModeJOIN();
			//testRemoveChild();
			//testAnimateReverse();
			//testPauseResume();
			//testSetCurrentPercentage();
		}
				
		public function testAnimateModeEACH():void {
			createTarget();
			
			duration = 2000;
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Sequence();			
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);
			testInstance.setAnimateMode(Sequence.EACH);
			testInstance.addEventListener(AnimationEvent.END, reverse);
			testInstance.animationStyle(duration,Circ.easeInOut);
			
			//listenStartEvent(testInstance, null, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			//listenEndEvent(testInstance, duration, null, false);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimateModeJOIN():void {
			createTarget();
			
			duration = 2000;
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);
			
			testInstance = new Sequence();			
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);
			testInstance.setAnimateMode(Sequence.JOIN);
			testInstance.addEventListener(AnimationEvent.END, reverse);
			testInstance.animationStyle(duration,Circ.easeInOut);
			
			//listenStartEvent(testInstance, 0, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			//listenEndEvent(testInstance, duration, 4, false);
			tearDownMethod = removeTarget;
		}		
		
		private function reverse(event:SequenceEvent):void {			
			testInstance.removeEventListener(AnimationEvent.END, reverse);
			testInstance.animate(100,0);		
			listenUpdateEvent(testInstance, 2000, false);
		}

		public function testRemoveChild():void {
			createTarget();

			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Sequence();
			testInstance.setAnimateMode("JOIN");
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);
			testInstance.removeChild(myColorizer);
			testInstance.removeChild(myScale);
			
			var children:Array = testInstance.getChildren();
			if(children.length != 2)
				throw new Error("Sequence.getChildren().length returns "+children.length+"; expected 2");
			
			testInstance.animationStyle(duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 2, false);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimateReverse():void {
			createTarget();
			
			duration = 2000;
			
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Sequence();
			testInstance.setAnimateMode("JOIN");
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);

			testInstance.animationStyle(duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, 4, false);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 0, false);
			tearDownMethod = removeTarget;
		}
		
		public function testPauseResume():void {
			createTarget();
		
			duration = 2000;
			
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Sequence();
			testInstance.setAnimateMode("JOIN");
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);

			testInstance.animationStyle(duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.animate(0,100);
			var timer:Timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER, onPause);
			timer.start();			
			
			listenUpdateEvent(testInstance, duration+500, false);
			listenEndEvent(testInstance, duration+500, 4, false);
			tearDownMethod = removeTarget;
		}
		
		private function onPause(event:TimerEvent):void {
			testInstance.pause();
			if(testInstance.isTweening())
				throw new Error("isTweening should be false when paused");	
			var timer:Timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER, onResume);
			timer.start();
		}
		
		private function onResume(event:TimerEvent):void {
			testInstance.resume();
			if(!testInstance.isTweening())
				throw new Error("isTweening should be true when resumed");			
		}
		
		public function testSetCurrentPercentage():void {
			createTarget();
			
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Sequence();
			testInstance.setAnimateMode("JOIN");
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);
			testInstance.addEventListener(AnimationEvent.START, onStart);
			testInstance.addEventListener(AnimationEvent.UPDATE, onUpdate);
			testInstance.addEventListener(AnimationEvent.END, onEnd);
				
			hasStartEventReceived = false;			
			testInstance.setCurrentPercentage(0);			
			if(!hasStartEventReceived)
				throw new Error("An AnimationEvent.START event has not been received");
						
			hasUpdateEventReceived = false;			
			testInstance.setCurrentPercentage(40);
			if(!hasUpdateEventReceived)
				throw new Error("An AnimationEvent.UPDATE event has not been received");						
			
			hasEndEventReceived = false;
			testInstance.setCurrentPercentage(100);
			if(!hasEndEventReceived)
				throw new Error("An AnimationEvent.END event has not been received");
												
			tearDownMethod = removeTarget;
		}
		
		private function onStart(event:AnimationEvent):void {
			hasStartEventReceived = true;
			if(event.value != 0)
				throw new TestError(0, event.value);
		}
		
		private function onUpdate(event:AnimationEvent):void {
			hasUpdateEventReceived = true;
			if(event.value != 2)
				throw new TestError(2, event.value);
		}
		
		private function onEnd(event:AnimationEvent):void {
			hasEndEventReceived = true;
			if(event.value != 4)
				throw new TestError(4, event.value);
		}				
	}
}