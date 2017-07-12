package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
	import de.alex_uhlmann.animationpackage.animation.Alpha;
	import de.alex_uhlmann.animationpackage.animation.Colorizer;
	import de.alex_uhlmann.animationpackage.drawing.Drawer;
	import de.alex_uhlmann.animationpackage.drawing.Line;
	import de.alex_uhlmann.animationpackage.drawing.DashLine;
	import de.alex_uhlmann.animationpackage.drawing.QuadCurve;
	import de.alex_uhlmann.animationpackage.drawing.CubicCurve;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class DrawerTest extends AnimationPackageTest {
		
		public var testInstance:Drawer;
		
		public function DrawerTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testDraw();
			//testDrawBy();
			//testAnimate();
			//testAnimateBy();
			testAnimateAndFill();
			//testReverse();
		}
		
		public function testDraw():void {
			createEmptyTarget();			

			var part1:Line = new Line(100,100,200,100);
			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,350);
			var part4:Line = new Line(300,350,90,350,1,8);
			var part5:Line = new Line(90,350,100,100);

			var testInstance:Drawer = new Drawer(target);
			testInstance.addChild(part1);
			testInstance.addChild(part2);
			testInstance.addChild(part3);
			testInstance.addChild(part4);
			testInstance.addChild(part5);
			testInstance.lineStyle(5,0xFF0000,.5);
			testInstance.draw();
			testInstance.fillStyle(0xffff00,.3);
			testInstance.fill();
			
			tearDownMethod = removeTarget;
		}
		
		public function testDrawBy():void {
			createEmptyTarget();			

			var part1:Line = new Line(100,100,200,100);
			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,350);
			var part4:Line = new Line(300,350,90,350,1,8);
			var part5:Line = new Line(90,350,100,100);

			var testInstance:Drawer = new Drawer(target);
			testInstance.addChild(part1);
			testInstance.addChild(part2);
			testInstance.addChild(part3);
			testInstance.addChild(part4);
			testInstance.addChild(part5);
			testInstance.lineStyle(5,0xFF0000,.5);
			testInstance.drawBy();
			testInstance.fillStyle(0xffff00,.3);
			testInstance.fill();
			
			tearDownMethod = removeTarget;
		}
		
		public function testAnimate():void {
			createEmptyTarget();			

			duration = 300;

			var part1:Line = new Line(100,100,200,100);
			part1.lineStyle(5,0x0000FF,.9);
			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
			part2.lineStyle(5,0xFFFFFF,.3);
			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,350);
			part3.lineStyle(5,0xFFFFFF,.3);
			var part4:DashLine = new DashLine(300,350,90,350,1,8);
			part4.lineStyle(5,0xFFFF00,1);
			var part5:Line = new Line(90,350,100,100);
			
			var testInstance:Drawer = new Drawer(target);
			testInstance.addChild(part1);
			testInstance.addChild(part2);
			testInstance.addChild(part3);
			testInstance.addChild(part4);
			testInstance.addChild(part5);						
			
			listenStartEvent(testInstance);
			
			testInstance.animationStyle(duration,Circ.easeInOut);
			//testInstance.lineStyle(5,0xFF0000,.5);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration * 5);
			listenEndEvent(testInstance, duration * 5);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimateBy():void {
			createEmptyTarget();			

			duration = 300;

			var part1:Line = new Line(100,100,200,100);
			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,350);
			var part4:Line = new Line(300,350,90,350,1,8);
			var part5:Line = new Line(90,350,100,100);

			var testInstance:Drawer = new Drawer(target);
			testInstance.addChild(part1);
			testInstance.addChild(part2);
			testInstance.addChild(part3);
			testInstance.addChild(part4);
			testInstance.addChild(part5);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animationStyle(duration,Circ.easeInOut);
			testInstance.lineStyle(5,0xFF0000,.5);
			testInstance.animateBy(0,100);
			
			listenUpdateEvent(testInstance, duration * 5);
			listenEndEvent(testInstance, duration * 5, 5);
			tearDownMethod = removeTarget;
		}		
		
		public function testAnimateAndFill():void {
			createEmptyTarget();
			
			duration = 300;
			var part1:DashLine = new DashLine(100,100,200,100);
			part1.lineStyle(2,0x000000,50);
			part1.animationStyle(1000,Sine.easeIn);
			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
			part2.lineStyle(1,0xff0000,100);
			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,350);
			part3.lineThickness = 4;
			var part4:DashLine = new DashLine(300,350,90,350,1,8);
			part4.lineStyle(6,0x0000ff,100);
			var part5:Line = new Line(90,350,100,100);
			part5.lineStyle(6,0x00ff00);

			testInstance = new Drawer(target);
			testInstance.addChild(part1);
			testInstance.addChild(part2);
			testInstance.addChild(part3);
			testInstance.addChild(part4);
			testInstance.addChild(part5);
			testInstance.animationStyle(duration,Circ.easeInOut);
			testInstance.addEventListener(AnimationEvent.END, fillShape);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration * 5);
			listenEndEvent(testInstance, duration * 5, 5);
		}
		
		private function fillShape(event:AnimationEvent):void {
			testInstance.fillStyle(0xff0000,.5);
			testInstance.fill();
			testInstance.fillMovieclip.alpha = 0;
			new Alpha(testInstance.fillMovieclip).run(100,200);
			new Colorizer(testInstance.lineMovieclip).run(0xffff00,0,200,Quad.easeOut);
			
			tearDownMethod = removeTarget;			
		}
		
		public function testReverse():void {
			createEmptyTarget();
			
			duration = 300;
			
			var part1:DashLine = new DashLine(100,100,200,100);
			part1.lineStyle(2,0x000000,50);
			part1.animationStyle(1000,Sine.easeIn);
			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
			part2.lineStyle(1,0xff0000,100);
			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,350);
			part3.lineThickness = 4;
			var part4:DashLine = new DashLine(300,350,90,350,1,8);
			part4.lineStyle(6,0x0000ff,100);
			var part5:Line = new Line(90,350,100,100);
			part5.lineStyle(6,0x00ff00);

			testInstance = new Drawer(target);
			testInstance.addChild(part1);
			testInstance.addChild(part2);
			testInstance.addChild(part3);
			testInstance.addChild(part4);
			testInstance.addChild(part5);

			listenStartEvent(testInstance);
			
			testInstance.animationStyle(duration,Circ.easeOut);							
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration * 5);
			listenEndEvent(testInstance, duration * 5);
			tearDownMethod = removeTarget;
		}		

	}
}