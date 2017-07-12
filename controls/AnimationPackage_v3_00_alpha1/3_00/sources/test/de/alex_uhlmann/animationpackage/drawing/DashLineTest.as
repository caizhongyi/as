package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.drawing.DashLine;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class DashLineTest extends AnimationPackageTest {
		
		public var testInstance:DashLine;
		
		public function DashLineTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testStyling();
			//testLong();
			testReverse();
		}
		
		public function testStyling():void {
			createEmptyTarget();
			
			testInstance = new DashLine(target,0,0,100,200);
			testInstance.lineStyle(2,0xff0000,.5);
			testInstance.draw();
			
			tearDownMethod = removeTarget;
		}
		
		public function testLong():void {
			createEmptyTarget();
			
			testInstance = new DashLine(target,0,0,275,200,1,8);
			testInstance.lineStyle(1,0xff0000,1);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 100);
			tearDownMethod = removeTarget;
		}
		
		public function testReverse():void {
			createEmptyTarget();
			
			testInstance = new DashLine(target,0,0,275,200,4,20);
			testInstance.animationStyle(duration,Quad.easeInOut);
			
			listenStartEvent(testInstance, 100);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}		

	}
}