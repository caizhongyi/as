package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.drawing.QuadCurve;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class QuadCurveTest extends AnimationPackageTest {
		
		public var testInstance:QuadCurve;
		
		public function QuadCurveTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testStyling();
			//testLong();
			testReverse();
		}
		
		public function testStyling():void {
			createEmptyTarget();
			
			testInstance = new QuadCurve(target);
			testInstance.lineStyle(10,0xff0000,.5);
			testInstance.draw();
			
			tearDownMethod = removeTarget;
		}
		
		public function testLong():void {
			createEmptyTarget();
			
			testInstance = new QuadCurve(target,0,100,200,200,500,50);
			testInstance.animationStyle(duration,Quad.easeInOut);
			testInstance.lineStyle(5,0xff0000,.5);
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 100);
			tearDownMethod = removeTarget;
		}
		
		public function testReverse():void {
			createEmptyTarget();
			
			testInstance = new QuadCurve(target,0,100,200,200,500,50);
			testInstance.animationStyle(duration,Quad.easeInOut);
			testInstance.lineStyle(5,0xff0000,1);
			
			listenStartEvent(testInstance, 100);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}		

	}
}