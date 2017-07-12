package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.ColorNegative;
	import de.alex_uhlmann.animationpackage.utility.ColorFX;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class ColorNegativeTest extends AnimationPackageTest {
		
		public var testInstance:ColorNegative;		
		
		public function ColorNegativeTest(root:Sprite) {
			super(root);
		}
		
		public function run():void {
			//testLong();
			//testShort();
			//testStartEndValues();
			//testStartEndValues2();
			testMultiple();
		}
		
		public function testLong():void {
			createTarget();
			
			testInstance = new ColorNegative(target);
			testInstance.animationStyle(duration,Quad.easeOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.run(50);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 50, false);
			tearDownMethod = removeTarget;
		}
		
		public function testShort():void {
			createTarget();
			
			new ColorNegative(target).run(50,duration,Quad.easeOut);
		}

		public function testStartEndValues():void {
			createTarget();
			
			testInstance = new ColorNegative(target,[-255,0],duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, -255, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 0, false);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues2():void {
			createTarget();
			
			testInstance = new ColorNegative(target);
			testInstance.animationStyle(duration,Circ.easeInOut);
			testInstance.setStartValue(-255);
			testInstance.setEndValue(255);
			
			listenStartEvent(testInstance, -255, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 255, false);
			tearDownMethod = removeTarget;
		}

		public function testMultiple():void {
			createTargets();
			
			var myColorFX:ColorFX = new ColorFX(target1);
			myColorFX.setNegative(50);			
			
			testInstance = new ColorNegative(targets);
			testInstance.animationStyle(duration,Circ.easeInOut);
			testInstance.setEndValue(255);
			
			listenStartEvent(testInstance, null, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [255,255,255], false);
			tearDownMethod = removeTargets;
		}

	}
}