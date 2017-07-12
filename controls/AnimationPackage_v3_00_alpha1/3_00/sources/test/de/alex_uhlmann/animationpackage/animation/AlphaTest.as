package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Alpha;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class AlphaTest extends AnimationPackageTest {
		
		public var testInstance:Alpha;		
		
		public function AlphaTest(root:Sprite) {
			super(root);
		}
		
		public function run():void {
			//testLong();
			//testLong2();
			//testShort();
			//testStartEndValues1();
			//testStartEndValues2();
			//testStartEndValues3();
			//testCustomEasing();
	
			//--------------------------------------------------------------------
			
			//createTargets();
			//renderTargets();
			
			//testMultiple();	
		}
		
		public function testLong():void {
			createTarget();
			
			testInstance = new Alpha(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			listenStartEvent(testInstance, 1);
			testInstance.run(.4);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, .4);
			tearDownMethod = removeTarget;
		}
		
		public function testLong2():void {
			createTarget();
			
			testInstance = new Alpha(target,.4);
			testInstance.duration = duration;
			testInstance.easing = Elastic.easeOut;
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, .4);
			tearDownMethod = removeTarget;
		}
		
		public function testShort():void {
			createTarget();
			
			new Alpha(target).run(0,duration,Quad.easeIn);
		}
			
		public function testStartEndValues1():void {
			createTarget();
			
			testInstance = new Alpha(target,[.5,0],duration,Quad.easeIn);
			
			listenStartEvent(testInstance, .5);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues2():void {
			createTarget();
			
			testInstance = new Alpha(target,duration,Quad.easeIn);
			testInstance.setStartValue(.5);
			testInstance.setEndValue(0);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues3():void {
			createTarget();
			
			testInstance = new Alpha(target,0,duration,Quad.easeIn);
			testInstance.setStartValue(.5);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}
		
		public function testCustomEasing():void {
			createTarget();
			
			testInstance = new Alpha(target,.5);
			testInstance.animationStyle(duration,[Back.easeOut,4]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, .5);
			tearDownMethod = removeTarget;
		}
		
		//--------------------------------------------------------------------

		public function testMultiple():void {
			createTargets();
			
			target2.alpha = .3;
			testInstance = new Alpha(targets,0);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}
	}
}