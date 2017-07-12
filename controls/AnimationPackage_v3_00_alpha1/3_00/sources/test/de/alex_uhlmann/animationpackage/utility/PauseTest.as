package test.de.alex_uhlmann.animationpackage.utility {

	import com.robertpenner.easing.*;

	import de.alex_uhlmann.animationpackage.animation.AnimationCore;
	import de.alex_uhlmann.animationpackage.utility.Pause;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class PauseTest extends AnimationPackageTest {
		
		public var testInstance:Pause;
		private var isCallbackCalled:Boolean;
		
		public function PauseTest(root:Sprite) {
			super(root);
		}	
		
		public function run():void {
			//testShortMS();
			//testShortFRAMES();
			//testLongMSWithPercentage();
			//testLongMS2();
			//testLongFRAMESWithParams();
			//testLongFRAMES2();
		}
		
		public function testShortMS():void {			
			createTarget();
			duration = 500;
			
			new Pause(AnimationCore.MS, duration, onCallback).run();

			isCallbackCalled = false;
			var timer:Timer = new Timer(duration * 1.1, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();		
		}
		
		public function testShortFRAMES():void {			
			createTarget();
			
			var durationInFrames:Number = 10;
			duration = durationInFrames / root.stage.frameRate * 1000;
			
			new Pause(AnimationCore.FRAMES, durationInFrames, onCallback).run();

			isCallbackCalled = false;
			var timer:Timer = new Timer(duration * 1.1, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}		
		
		public function testLongMSWithPercentage():void {
			createTarget();
			duration = 1000;
			
			testInstance = new Pause(AnimationCore.MS, duration * 10, onCallback);
			
			//listenStartEvent(testInstance);
			
			testInstance.animate(0,10);
			
			//listenUpdateEvent(testInstance, duration * 10);
			//listenEndEvent(testInstance, duration * 10);		
			isCallbackCalled = false;
			var timer:Timer = new Timer(duration, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		public function testLongMS2():void {			
			createTarget();
			duration = 1000;
			
			testInstance = new Pause();
			
			//listenStartEvent(testInstance);
			testInstance.waitMS(duration, onCallback);
			
			//listenUpdateEvent(testInstance, duration);
			//listenEndEvent(testInstance, duration);		
			isCallbackCalled = false;
			var timer:Timer = new Timer(duration * 1.1, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
				
		public function testLongFRAMESWithParams():void {			
			createTarget();
			
			var durationInFrames:Number = 20;
			duration = durationInFrames / root.stage.frameRate * 1000;			
			testInstance = new Pause(AnimationCore.FRAMES, durationInFrames, onCallbackWithParams, ["foo", "bar"]);
			
			//listenStartEvent(testInstance);
			
			testInstance.animate(0,100);
			
			//listenUpdateEvent(testInstance, duration);
			//listenEndEvent(testInstance, duration);			
			isCallbackCalled = false;
			var timer:Timer = new Timer(duration * 1.1, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		public function testLongFRAMES2():void {			
			createTarget();
			
			var durationInFrames:Number = 20;
			duration = durationInFrames / root.stage.frameRate * 1000;			
			testInstance = new Pause();
			
			//listenStartEvent(testInstance);
			
			testInstance.waitFrames(durationInFrames, onCallback);
			
			//listenUpdateEvent(testInstance, duration);
			//listenEndEvent(testInstance, duration);			
			isCallbackCalled = false;
			var timer:Timer = new Timer(duration * 1.1, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		private function onCallback():void {
			removeTarget();
			isCallbackCalled = true;
		}
		
		private function onCallbackWithParams(foo:String, bar:String):void {
			if(foo != "foo" || bar != "bar")
				throw new Error("Pause passed not expected parameters");
			removeTarget();
			isCallbackCalled = true;
		}		
		
		private function onTimer(event:TimerEvent):void {
			if(!isCallbackCalled) 
				throw new Error("Pause did not call onCallback");
		}
		
	}
}