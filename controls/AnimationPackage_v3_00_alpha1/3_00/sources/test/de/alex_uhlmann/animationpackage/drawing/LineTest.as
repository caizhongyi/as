package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.drawing.Line;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class LineTest extends AnimationPackageTest {
		
		public var testInstance:Line;
		
		public function LineTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			testStyling();
			//testLong();
			//testReverse();
		}
		
		public function testStyling():void {
			createEmptyTarget();
			
			testInstance = new Line(target);
			testInstance.lineStyle(20,0xff0000,.5);
			testInstance.setX1(0);
			testInstance.setY1(0);
			testInstance.setX2(275);
			testInstance.setY2(200);
			testInstance.draw();
			
			tearDownMethod = removeTarget;
		}
		
		public function testLong():void {
			createEmptyTarget();
			
			testInstance = new Line(target,0,0,275,200);
			testInstance.animationStyle(duration,Quad.easeInOut);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 100);
			tearDownMethod = removeTarget;
		}
		
		public function testReverse():void {
			createEmptyTarget();
			
			testInstance = new Line(target,0,0,275,200);
			testInstance.animationStyle(duration,Quad.easeInOut);
			
			listenStartEvent(testInstance, 100);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}		

	}
}