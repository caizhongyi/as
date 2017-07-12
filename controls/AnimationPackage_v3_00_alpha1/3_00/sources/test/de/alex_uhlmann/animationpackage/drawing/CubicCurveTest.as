package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.drawing.CubicCurve;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class CubicCurveTest extends AnimationPackageTest {
		
		public var testInstance:CubicCurve;
		
		public function CubicCurveTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testStyling();
			//testLong();
			testReverse();
		}
		
		public function testStyling():void {
			createEmptyTarget();
			
			testInstance = new CubicCurve(target);
			testInstance.lineStyle(10,0xff0000,.5);
			testInstance.draw();
			
			tearDownMethod = removeTarget;
		}
		
		public function testLong():void {
			createEmptyTarget();
			
			testInstance = new CubicCurve(target,100,100,250,300,400,100,450,300);
			testInstance.animationStyle(duration,Cubic.easeInOut);
			testInstance.lineStyle(5,0xff0000,.5);
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 100);
			tearDownMethod = removeTarget;
		}
		
		public function testReverse():void {
			createEmptyTarget();
			
			testInstance = new CubicCurve(target,100,100,300,300,500,100,500,400);
			testInstance.animationStyle(duration,Cubic.easeInOut);
			testInstance.lineStyle(5,0xff0000,1);
			
			listenStartEvent(testInstance, 100);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}		

	}
}