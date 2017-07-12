package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.drawing.Curve;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class CurveTest extends AnimationPackageTest {
		
		public var testInstance:Curve;
		
		public function CurveTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testStyling();
			//testLong();
			testReverse();
		}
		
		public function testStyling():void {
			createEmptyTarget();
			
			var x1:Number = 350;
			var y1:Number = 50;
			var x2:Number = 50;
			var y2:Number = 50;
			var x3:Number = 50;
			var y3:Number = 200;
			var x4:Number = 850;
			var y4:Number = 200;
			var x5:Number = 350;
			var y5:Number = 350;
			var x6:Number = 50;
			var y6:Number = 350;
			var x7:Number = -550;
			var y7:Number = 500;
			var x8:Number = 600;
			var y8:Number = 600;
			var x9:Number = 650;
			var y9:Number = 500;
			var x10:Number = 650;
			var y10:Number = 50;
			var x11:Number = 350;
			var y11:Number = 50;

			var points:Array = new Array();
			points.push(new Point(x1, y1));
			points.push(new Point(x2, y2));
			points.push(new Point(x3, y3));
			points.push(new Point(x4, y4));
			points.push(new Point(x5, y5));
			points.push(new Point(x6, y6));
			points.push(new Point(x7, y7));
			points.push(new Point(x8, y8));
			points.push(new Point(x9, y9));
			points.push(new Point(x10, y10));
			points.push(new Point(x11, y11));
						
			testInstance = new Curve(target,points);
			testInstance.lineStyle(10,0xff0000,.5);
			testInstance.draw();
			
			tearDownMethod = removeTarget;
		}
		
		public function testLong():void {
			createEmptyTarget();
			
			var points:Array = new Array();
			points.push(new Point(100,100));
			points.push(new Point(200,200));
			points.push(new Point(300,50));
			
			testInstance = new Curve(target,points);
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
			
			var points:Array = new Array();
			points.push(new Point(100,100));
			points.push(new Point(200,200));
			points.push(new Point(300,50));
						
			testInstance = new Curve(target,points);
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