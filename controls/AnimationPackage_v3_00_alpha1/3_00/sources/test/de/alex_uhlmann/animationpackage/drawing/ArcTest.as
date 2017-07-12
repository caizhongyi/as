package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.drawing.Arc;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class ArcTest extends AnimationPackageTest {
		
		public var testInstance:Arc;
		
		public function ArcTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testStyling();
			//testOPEN();
			testPIE();
			//testCHORD();
			//testReverse();
		}
		
		public function testStyling():void {
			createEmptyTarget();
			
			testInstance = new Arc(target,275,200);
			testInstance.lineStyle(2,0xff0000,.5);			
			testInstance.setEndValue(270);	
			testInstance.draw();
			
			tearDownMethod = removeTarget;
		}
		
		public function testOPEN():void {
			createEmptyTarget();
			
			testInstance = new Arc(target,275,200);
			testInstance.lineStyle(0x000000);
			testInstance.fillStyle(0xff0000);
			testInstance.setArcType("OPEN");
			testInstance.setStartValue(0);
			testInstance.setEndValue(270);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 270);
			tearDownMethod = removeTarget;
		}
		
		public function testPIE():void {
			createEmptyTarget();
			
			testInstance = new Arc(target,275,200);
			testInstance.lineStyle(0x000000);
			testInstance.fillStyle(0xff0000);
			testInstance.setArcType("PIE");
			testInstance.setStartValue(0);
			testInstance.setEndValue(270);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 270);
			tearDownMethod = removeTarget;
		}
		
		public function testCHORD():void {
			createEmptyTarget();
			
			testInstance = new Arc(target,275,200);
			testInstance.lineStyle(0x000000);
			testInstance.fillStyle(0xff0000);
			testInstance.setArcType("CHORD");
			testInstance.setStartValue(0);
			testInstance.setEndValue(270);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 270);
			tearDownMethod = removeTarget;
		}		
		
		public function testReverse():void {
			createEmptyTarget();
			
			testInstance = new Arc(target,275,200,150,0,270);
			testInstance.setArcType("PIE");
			testInstance.lineStyle(2,0xff0000,50);
			testInstance.fillStyle(0xffff00,100);			
			testInstance.animationStyle(duration,Quad.easeInOut);
			
			listenStartEvent(testInstance, 270);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}
	}
}