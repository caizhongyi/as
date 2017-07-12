package test.de.alex_uhlmann.animationpackage.animation {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.MoveOnCurve;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	import flash.geom.Point;
	
	public class MoveOnCurveTest extends AnimationPackageTest {
		
		public var testInstance:MoveOnCurve;
		
		public function MoveOnCurveTest(root:Sprite) {			
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
			var points:Array = new Array();
			points.push(new Point(100,100));
			points.push(new Point(200,200));
			points.push(new Point(300,50));
			new MoveOnCurve(target).run(points,duration,Elastic.easeInOut);
		}		
				
		public function testRun():void {
			createTarget();
			
			
			var points:Array = new Array();
			points.push(new Point(100,100));
			points.push(new Point(200,200));
			points.push(new Point(300,50));
			testInstance = new MoveOnCurve(target);
			testInstance.animationStyle(duration,Sine.easeInOut);
			
			listenStartEvent(testInstance, 0, false);
			
			testInstance.run(points);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, 100, false);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimate():void {
			createTarget();
			
			var points:Array = new Array();
			points.push(new Point(100,100));
			points.push(new Point(200,200));
			points.push(new Point(300,50));			
			testInstance = new MoveOnCurve(target,points);
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

			var points:Array = new Array();
			points.push(new Point(100,100));
			points.push(new Point(200,200));
			points.push(new Point(300,50));			
			testInstance = new MoveOnCurve(target,points);
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
			
			var points:Array = new Array();
			points.push(new Point(100,100));
			points.push(new Point(200,200));
			points.push(new Point(300,50));			
			testInstance = new MoveOnCurve(target,points);
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