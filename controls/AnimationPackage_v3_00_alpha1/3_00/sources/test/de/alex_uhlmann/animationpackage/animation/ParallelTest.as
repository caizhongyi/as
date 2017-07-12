package test.de.alex_uhlmann.animationpackage.animation {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Parallel;
	import de.alex_uhlmann.animationpackage.animation.MoveOnQuadCurve;
	import de.alex_uhlmann.animationpackage.animation.Scale;
	import de.alex_uhlmann.animationpackage.animation.Rotation;
	import de.alex_uhlmann.animationpackage.animation.Colorizer;
	
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class ParallelTest extends AnimationPackageTest {
		
		public var testInstance:Parallel;
		
		public function ParallelTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			testLong();	
			//testRemoveChild();
			//testAnimateReverse();
			//testPauseResume();
		}
				
		public function testLong():void {
			createTarget();
			
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Parallel();
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);			
			testInstance.animationStyle(duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 100, false);
			tearDownMethod = removeTarget;
		}
		
		public function testRemoveChild():void {
			createTarget();
			
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Parallel();
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);
			testInstance.removeChild(myColorizer);
			testInstance.removeChild(myScale);
			
			var children:Array = testInstance.getChildren();
			if(children.length != 2)
				throw new Error("Parallel.getChildren().length returns "+children.length+"; expected 2");
			
			testInstance.animationStyle(duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 100, false);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimateReverse():void {
			createTarget();
			
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Parallel();
			testInstance.addChild(myMoveOnQuadCurve);
			testInstance.addChild(myScale);
			testInstance.addChild(myRotation);
			testInstance.addChild(myColorizer);

			testInstance.animationStyle(duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, 100, false);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 0, false);
			tearDownMethod = removeTarget;
		}
		
		public function testPauseResume():void {
			createTarget();
			
			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(target,100,100,300,300,400,100);
			var myScale:Scale = new Scale(target,.5,.5);
			var myRotation:Rotation = new Rotation(target,360);
			var myColorizer:Colorizer = new Colorizer(target,0xff0000,.5);

			testInstance = new Parallel();
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
			listenEndEvent(testInstance, duration+500, 100, false);
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
	}
}