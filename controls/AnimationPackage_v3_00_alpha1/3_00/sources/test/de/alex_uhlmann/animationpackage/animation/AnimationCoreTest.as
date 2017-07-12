package test.de.alex_uhlmann.animationpackage.animation {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.AnimationCore;
	import de.alex_uhlmann.animationpackage.animation.Scale;
	import de.alex_uhlmann.animationpackage.animation.Move;
	import de.alex_uhlmann.animationpackage.animation.Rotation;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	import flash.events.TimerEvent;
	import flash.utils.Timer;	
	
	public class AnimationCoreTest extends AnimationPackageTest {
		
		public var testInstance:*;
		private var myOverwrittenScale:Scale;
		
		public function AnimationCoreTest(root:Sprite) {
			super(root);
		}
		
		public function run():void {
			//testStopOnIAnimatable();
			//testPauseOnIAnimatable();
			//testPauseAndResumeOnIAnimatable();
			//testPauseAndResumeAll();
			//testSetDefaultTweenModes();
			//testSetTweenModesToFrames();
			//testSetTweenModeWithFramesOverride();
			//testSetDurationModeWithFramesOverride();
			//testSetDurationModes();	
			//testSetOverwriteModesDefaultForSprites();
			//testSetOverwriteModesIsTrueForSprites();
		}

		public function testStopOnIAnimatable():void {
			createTarget();
			duration = 1000;
			
			testInstance = new Scale(target,0,0);
			
			listenStartEvent(testInstance, [1,1]);
			
			testInstance.animationStyle(duration, Circ.easeInOut);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration-750);
			tearDownMethod = removeTarget;
			var timer:Timer = new Timer(600,2);
			timer.addEventListener(TimerEvent.TIMER, onStop);
			timer.start();
		}
		
		private function onStop(event:TimerEvent):void {
			if(event.currentTarget.currentCount == 2 && testInstance.getCurrentValues()[0] == 0)
				throw new Error("instance still animates after being stopped");
			//else if(event.currentTarget.currentCount == 2)
				//removeTarget();
			
			testInstance.stop();
			if(testInstance.isTweening())
				throw new Error("isTweening should be false when stopped");
		}
		
		public function testPauseOnIAnimatable():void {
			createTarget();
			duration = 1000;
			
			testInstance = new Scale(target,1.5,1.5);
			
			listenStartEvent(testInstance, [1,1]);
			
			testInstance.animationStyle(duration, Circ.easeInOut);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration+500);
			listenEndEvent(testInstance, duration+500, [1.5,1.5]);
			tearDownMethod = removeTarget;
			var timer:Timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER, onPause);
			timer.start();
		}
		
		private function onPause(event:TimerEvent):void {
			testInstance.pause(500);
			if(testInstance.isTweening())
				throw new Error("isTweening should be false when paused");		
		}		
		
		public function testPauseAndResumeOnIAnimatable():void {
			createTarget();
			duration = 1000;
			
			testInstance = new Scale(target,0,0);
			
			listenStartEvent(testInstance, [1,1]);
			
			testInstance.animationStyle(duration, Circ.easeInOut);
			testInstance.animate(0,100);
			
			//listenUpdateEvent(testInstance, duration+500);
			listenEndEvent(testInstance, duration+500, [0,0]);
			tearDownMethod = removeTarget;
			var timer:Timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER, onPause2);
			timer.start();
		}
		
		private function onPause2(event:TimerEvent):void {
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
				
		public function testPauseAndResumeAll():void {
			createTargets();

			var myScale:Scale = new Scale(target1,1.5,1.5); 			
			myScale.animationStyle(duration, Circ.easeInOut); 
			myScale.animate(0,100);						
			
			var myMove:Move = new Move(target2,target2.x+100,target2.y); 
			myMove.setTweenMode(AnimationCore.FRAMES);
			myMove.animationStyle(duration / 1000 * root.stage.frameRate, Circ.easeInOut);
			myMove.animate(0,100);	

			testInstance = new Rotation(target3,360);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animationStyle(duration, Circ.easeInOut); 
			testInstance.animate(0,100);
					
			listenUpdateEvent(testInstance, duration+500);
			//listenEndEvent(testInstance, duration+500, 360);			
			tearDownMethod = removeTargets;
			var timer:Timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER, onPauseAll);
			timer.start();
		}
		
		private function onPauseAll(event:TimerEvent):void {
			AnimationCore.pauseAll();
			if(testInstance.myAnimator.myTween.isTweening)
				throw new Error("isTweening should be false when paused");			
			var timer:Timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER, onResumeAll);
			timer.start();
		}
		
		private function onResumeAll(event:TimerEvent):void {
			AnimationCore.resumeAll();
			if(!testInstance.myAnimator.myTween.isTweening)
				throw new Error("isTweening should be true when resumed");
		}

		public function testSetOverwriteModesDefaultForSprites():void {
			createTarget();
			duration = 500;

			removeTargetAndReset();
			
			myOverwrittenScale = new Scale(target,0,0);
			myOverwrittenScale.animationStyle(duration, Circ.easeIn);
			myOverwrittenScale.animate(0,100);
			
			testInstance = new Scale(target,2,2);
			
			listenStartEvent(testInstance, [1,1]);
			
			testInstance.animationStyle(duration, Circ.easeInOut);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [2,2]);
			tearDownMethod = removeTargetAndReset;
			var timer:Timer = new Timer(250,1);
			timer.addEventListener(TimerEvent.TIMER, onTestIfAnimates);
			timer.start();
		}
		
		private function onTestIfAnimates(event:TimerEvent):void {
			if(myOverwrittenScale.isTweening())
				throw new Error("myOverwrittenScale should have been stopped, overwritten.");			
		}
		
		public function testSetOverwriteModesIsTrueForSprites():void {
			createTarget();

			duration = 500;
			
			AnimationCore.setOverwriteModes(false);
			
			myOverwrittenScale = new Scale(target,0,0);
			myOverwrittenScale.animationStyle(duration, Circ.easeIn);
			myOverwrittenScale.animate(0,100);

			testInstance = new Scale(target,.2,.5);
			
			listenStartEvent(testInstance, [1,1]);
			
			testInstance.animationStyle(duration, Circ.easeInOut);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [.2,.5]);
			tearDownMethod = removeTargetAndReset;
			var timer:Timer = new Timer(250,1);
			timer.addEventListener(TimerEvent.TIMER, onTestIfAnimates2);
			timer.start();
		}
		
		private function onTestIfAnimates2(event:TimerEvent):void {
			if(!myOverwrittenScale.isTweening())
				throw new Error("myOverwrittenScale should not have been stopped, overwritten.");			
		}		
		
		public function testSetDefaultTweenModes():void {
			createTarget();
			
			testInstance = new Scale(target,1.5,1.5); 
			
			listenStartEvent(testInstance, [1,1]);
			
			testInstance.animationStyle(duration, Circ.easeInOut); 
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [1.5,1.5]);
			tearDownMethod = removeTarget;
		}
		
		public function testSetTweenModesToFrames():void {
			createTarget();

			var durationInFrames:Number = 20;
			duration = durationInFrames / root.stage.frameRate * 1000;
			AnimationCore.setTweenModes(AnimationCore.FRAMES);
			testInstance = new Scale(target,1.5,1.5); 
			
			//listenStartEvent(testInstance, [1,1]);
			
			testInstance.animationStyle(durationInFrames, Circ.easeInOut); 
			testInstance.animate(0,100);
			
			//listenUpdateEvent(testInstance, duration);
			//listenEndEvent(testInstance, duration, [1.5,1.5]);
			tearDownMethod = removeTargetAndReset;
		}
		
		public function testSetTweenModeWithFramesOverride():void {
			createTargets();
			
			AnimationCore.setTweenModes(AnimationCore.FRAMES);
			var durationInFrames:Number = 30;
			var myScale:Scale = new Scale(target1,1.5,1.5); 			
			myScale.animationStyle(durationInFrames, Circ.easeInOut); 
			myScale.animate(0,100);
			
			//override global tween mode with INTERVAL tweening on the IAnimatable instance Move.
			testInstance = new Move(target2,target2.x+100,target2.y); 
			
			duration = 1000;
			listenStartEvent(testInstance, [target2.x,target2.y]);
			
			testInstance.setTweenMode(AnimationCore.INTERVAL);
			testInstance.animationStyle(duration, Circ.easeInOut);
			testInstance.animate(0,100);	
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [target2.x+100,target2.y]);			
			tearDownMethod = removeTargetsAndReset;
		}
		
		public function testSetDurationModeWithFramesOverride():void {
			createTargets();
			
			AnimationCore.setTweenModes(AnimationCore.FRAMES);
			var durationInFrames:Number = 30;
			var myScale:Scale = new Scale(target1,1.5,1.5); 			
			myScale.animationStyle(durationInFrames, Circ.easeInOut); 
			myScale.animate(0,100);						
			//override global tween mode with INTERVAL tweening on the IAnimatable instance Move.
			var myMove:Move = new Move(target2,target2.x+100,target2.y); 
			myMove.setTweenMode(AnimationCore.INTERVAL);
			myMove.animationStyle(duration, Circ.easeInOut);
			myMove.animate(0,100);			
			
			//use the global frame based tweening with a local duration mode
			testInstance = new Rotation(target3,360);
			
			duration = 1000;
			listenStartEvent(testInstance, 0);
			
			testInstance.setDurationMode(AnimationCore.MS);
			testInstance.animationStyle(duration, Circ.easeInOut); 
			testInstance.animate(0,100);
						
			//listenUpdateEvent(testInstance, duration);
			//listenEndEvent(testInstance, duration, 360);			
			tearDownMethod = removeTargetsAndReset;
		}

		public function testSetDurationModes():void {
			createTarget();
			
			AnimationCore.setTweenModes(AnimationCore.FRAMES);
			AnimationCore.setDurationModes(AnimationCore.MS);			
			testInstance = new Rotation(target);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animationStyle(duration,Sine.easeInOut);
			testInstance.run(360);
			
			//listenUpdateEvent(testInstance, duration);
			//listenEndEvent(testInstance, duration, 360);
			tearDownMethod = removeTargetAndReset;		
		}	
		
		private function removeTargetsAndReset():void {
			removeTargets();
			AnimationCore.setTweenModes(AnimationCore.MS);
			AnimationCore.setDurationModes(AnimationCore.MS);
			AnimationCore.setOverwriteModes(true);
		}		
		
		private function removeTargetAndReset():void {
			removeTarget();
			AnimationCore.setTweenModes(AnimationCore.MS);
			AnimationCore.setDurationModes(AnimationCore.MS);
			AnimationCore.setOverwriteModes(true);
		}
	}
}