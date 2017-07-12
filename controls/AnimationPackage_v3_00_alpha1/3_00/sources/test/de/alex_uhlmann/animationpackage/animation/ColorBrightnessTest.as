package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.ColorBrightness;
	import de.alex_uhlmann.animationpackage.utility.ColorFX;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class ColorBrightnessTest extends AnimationPackageTest {
		
		public var testInstance:ColorBrightness;		
		
		public function ColorBrightnessTest(root:Sprite) {
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
			
			testInstance = new ColorBrightness(target);
			testInstance.animationStyle(1000,Quad.easeOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.run(.5);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, .5, false);
			tearDownMethod = removeTarget;
		}
		
		public function testShort():void {
			createTarget();
			
			new ColorBrightness(target).run(.7,duration,Quad.easeOut);
		}

		public function testStartEndValues():void {
			createTarget();
			
			testInstance = new ColorBrightness(target,[-1,0],duration,Circ.easeInOut);
			
			listenStartEvent(testInstance, -1, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 0, false);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues2():void {
			createTarget();
			
			testInstance = new ColorBrightness(target);
			testInstance.animationStyle(duration,Circ.easeInOut);
			testInstance.setStartValue(-1);
			testInstance.setEndValue(1);
			
			listenStartEvent(testInstance, -1, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 1, false);
			tearDownMethod = removeTarget;
		}

		public function testMultiple():void {
			createTargets();
			
			var myColorFX:ColorFX = new ColorFX(target1);
			myColorFX.setBrightness(.5);			
			
			testInstance = new ColorBrightness(targets);
			testInstance.animationStyle(duration,Circ.easeInOut);
			testInstance.setEndValue(1);
			
			listenStartEvent(testInstance, null, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [1,1,1], false);
			tearDownMethod = removeTargets;
		}

	}
}