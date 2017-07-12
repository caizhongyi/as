package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.drawing.Spiral;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class SpiralTest extends AnimationPackageTest {
		
		public var testInstance:Spiral;
		
		public function SpiralTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testStyling();
			//testLong();
			testReverse();
		}
		
		public function testStyling():void {
			createEmptyTarget();
						
			testInstance = new Spiral(target,100,100);
			testInstance.lineStyle(2,0xff0000,.5);			
			testInstance.setEndValue(3);	
			testInstance.draw();
			
			tearDownMethod = removeTarget;
		}
		
		public function testLong():void {
			createEmptyTarget();
			
			testInstance = new Spiral(target,275,200,0,0,10,10);
			testInstance.setStartValue(0);
			testInstance.setEndValue(10);
			testInstance.lineStyle(1,0xff0000,1);
			testInstance.animationStyle(1000,Cubic.easeInOut);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 10);
			tearDownMethod = removeTarget;
		}
		
		public function testReverse():void {
			createEmptyTarget();
			
			testInstance = new Spiral(target,275,200,0,0,10,10);
			testInstance.setStartValue(0);
			testInstance.setEndValue(10);
			testInstance.lineStyle(1,0xff0000,1);
			testInstance.animationStyle(1000,Cubic.easeInOut);
			
			listenStartEvent(testInstance, 10);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}
	}
}