package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Colorizer;
	import de.alex_uhlmann.animationpackage.utility.ColorFX;
	
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class ColorizerTest extends AnimationPackageTest {
		
		public var testInstance:Colorizer;
		
		public function ColorizerTest(root:Sprite) {
			super(root);
		}
		
		public function run():void {
			//testShortColorTransform();
			//testShortColorRGB();
			//testLongColorTransform();
			//testLongRGB();
			//testStartEndValuesRGB();
			//testStartEndValuesRGB2();
			//testStartEndValuesColorTransform();
			//testStartEndValuesColorTransform2();
			
			//TODO: test more multipe
			//testMultiple();
		}
		
		public function testShortColorTransform():void {
			createTarget();			
			new Colorizer(target).run(new ColorTransform(1, 1, 1, 1, 255, 0, 0, 0));
		}
		
		public function testShortColorRGB():void {
			createTarget();			
			new Colorizer(target).run(0xff0000,.5);
		}
		
		public function testLongColorTransform():void {
			createTarget();
			
			testInstance = new Colorizer(target);
			testInstance.animationStyle(duration,Quad.easeOut);
			
			listenStartEvent(testInstance, [1,0,1,0,1,0,1,0], false);
			
			var red:ColorTransform = new ColorTransform(1, 1, 1, 1, 255, 0, 0, 0);
			testInstance.run(red);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [1,255,1,0,1,0,1,0], false);
			tearDownMethod = removeTarget;
		}
		
		public function testLongRGB():void {
			createTarget();
			
			testInstance = new Colorizer(target);
			testInstance.animationStyle(duration,Quad.easeOut);
			
			listenStartEvent(testInstance, null, false);

			testInstance.run(0xff0000,.2);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, null, false);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValuesRGB():void {
			createTarget();
			
			testInstance = new Colorizer(target);
			testInstance.animationStyle(duration,Quad.easeOut);

			listenStartEvent(testInstance, [0.2,0,0.2,0,0.2,255,1,0], false);

			testInstance.run([0x0000ff,.2,0xff0000,.2]);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [0.2,255,0.2,0,0.2,0,1,0], false);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValuesRGB2():void {
			createTarget();
			
			testInstance = new Colorizer(target);
			testInstance.animationStyle(duration,Quad.easeOut);
			testInstance.setStartValues([0x0000ff,.2]);
			testInstance.setEndValues([0xff0000,.2]);
			
			listenStartEvent(testInstance, null, false);

			testInstance.animate(0,100);

			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, null, false);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValuesColorTransform():void {
			createTarget();
			
			var red:ColorTransform = new ColorTransform(1, 1, 1, 1, 255, 0, 0, 0);
			var green:ColorTransform = new ColorTransform(0, 1, 1, .8, 0, 255, 0, 0);
			testInstance = new Colorizer(target);
			testInstance.animationStyle(duration,Quad.easeOut);
			
			listenStartEvent(testInstance, [0,0,1,255,1,0,0.8,0], false);

			testInstance.run([green,red]);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [1,255,1,0,1,0,1,0], false);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValuesColorTransform2():void {
			createTarget();
			
			var red:ColorTransform = new ColorTransform(1, 1, 1, 1, 255, 0, 0, 0);
			var green:ColorTransform = new ColorTransform(0, 1, 1, .8, 0, 255, 0, 0);			
			testInstance = new Colorizer(target);
			testInstance.animationStyle(duration,Quad.easeOut);
			testInstance.setStartValues([green]);
			testInstance.setEndValues([red]);
			
			listenStartEvent(testInstance, [0,0,1,255,1,0,0.8,0], false);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [1,255,1,0,1,0,1,0], false);
			tearDownMethod = removeTarget;
		}
		
		public function testMultiple():void {
			createTargets();
			
			var red:ColorTransform = new ColorTransform(1, 1, 1, 1, 255, 0, 0, 0);
			var green:ColorTransform = new ColorTransform(0, 1, 1, .8, 0, 255, 0, 0);			
			testInstance = new Colorizer(targets);
			testInstance.animationStyle(duration,Quad.easeOut);
			testInstance.setStartValues([red]);
			testInstance.setEndValues([green]);
			
			listenStartEvent(testInstance, null, false);

			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, null, false);
			tearDownMethod = removeTargets;
		}		
	}
}