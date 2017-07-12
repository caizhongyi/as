package test.de.alex_uhlmann.animationpackage.animation {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.MoveOnCubicCurve;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class MoveOnCubicCurveTest extends AnimationPackageTest {
		
		public var testInstance:MoveOnCubicCurve;
		
		public function MoveOnCubicCurveTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testShort();
			testRun();
			//testAnimate();			
			//testOrientOnPath();
			//testOrientToPath();			
		}
		
		public function testShort():void {
			createTarget();			
			new MoveOnCubicCurve(target).run(100,50,200,250,300,50,400,250,duration,Circ.easeInOut);
		}		
				
		public function testRun():void {
			createTarget();
			
			testInstance = new MoveOnCubicCurve(target);
			testInstance.animationStyle(duration,Sine.easeInOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.run(100,50,200,250,300,50,400,250);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 100, false);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimate():void {
			createTarget();
			
			testInstance = new MoveOnCubicCurve(target,100,50,200,250,300,50,400,250);
			testInstance.animationStyle(duration,Quad.easeIn);
			
			listenStartEvent(testInstance, 100, false);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 0, false);
			tearDownMethod = removeTarget;
		}
		
		public function testOrientOnPath():void {
			createCenteredTarget();
			//createTarget();
			
			testInstance = new MoveOnCubicCurve(target,100,50,200,250,300,50,400,250);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.orientOnPath(true);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 100, false);
			tearDownMethod = removeTarget;
		}
		
		public function testOrientToPath():void {
			createCenteredTarget();
			//createTarget();
			
			testInstance = new MoveOnCubicCurve(target,100,50,200,250,300,50,400,250);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.orientToPath(true);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 100, false);
			tearDownMethod = removeTarget;
		}		
	
	}
}