package test.de.alex_uhlmann.animationpackage.animation {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.MoveOnQuadCurve;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class MoveOnQuadCurveTest extends AnimationPackageTest {
		
		public var testInstance:MoveOnQuadCurve;
		
		public function MoveOnQuadCurveTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testShort();
			//testRun();
			//testAnimate();			
			//testOrientOnPath();
			//testOrientToPath();			
		}
		
		public function testShort():void {
			createTarget();			
			new MoveOnQuadCurve(target).run(100,100,300,300,500,100,duration,Circ.easeInOut);
		}		
				
		public function testRun():void {
			createTarget();
			
			testInstance = new MoveOnQuadCurve(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.run(100,100,300,300,500,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 100, false);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimate():void {
			createTarget();
			
			testInstance = new MoveOnQuadCurve(target, 100,100,300,300,500,100);
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
			
			testInstance = new MoveOnQuadCurve(target,100,100,200,250,300,100);
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
			
			testInstance = new MoveOnQuadCurve(target,100,100,200,250,300,100);
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