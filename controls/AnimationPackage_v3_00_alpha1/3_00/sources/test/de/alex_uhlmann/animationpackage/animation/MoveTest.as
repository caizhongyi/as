package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Move;
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class MoveTest extends AnimationPackageTest {
		
		public var testInstance:Move;
		
		public function MoveTest(root:Sprite) {
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
			//testOrientToPath();
			
			//--------------------------------------------------------------------
			
			//testMultiple();
		}
				
		public function testLong():void {
			createTarget();
			
			testInstance = new Move(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			listenStartEvent(testInstance, [100,100]);
			testInstance.run(200,200);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [200,200]);
			tearDownMethod = removeTarget;
		}
		
		public function testLong2():void {
			createTarget();
			
			testInstance = new Move(target,200,200);
			testInstance.duration = duration;
			testInstance.easing = Elastic.easeOut;
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [200,200]);
			tearDownMethod = removeTarget;
		}
		
		public function testShort():void {
			createTarget();
			
			new Move(target).run(200,100,duration,Quad.easeIn);
		}
			
		public function testStartEndValues1():void {
			createTarget();
			
			testInstance = new Move(target,[200,200,100,100],duration,Quad.easeIn);
			
			listenStartEvent(testInstance, [200,200]);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [100,100]);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues2():void {
			createTarget();
			
			testInstance = new Move(target,duration,Quad.easeIn);
			testInstance.setStartValues([200,200]);
			testInstance.setEndValues([100,100]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [100,100]);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues3():void {
			createTarget();
			
			testInstance = new Move(target,100,100,duration,Quad.easeIn);
			testInstance.setStartValues([200,200]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [100,100]);
			tearDownMethod = removeTarget;
		}
		
		public function testCustomEasing():void {
			createTarget();
			
			testInstance = new Move(target,200,200);
			testInstance.animationStyle(duration,[Back.easeOut,4]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [200,200]);
			tearDownMethod = removeTarget;
		}
		
		public function testOrientToPath():void {
			createTarget();
			
			testInstance = new Move(target,[200,200,100,100]);
			testInstance.orientToPath(true);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [100,100]);			
			tearDownMethod = removeTarget;
		}
		
		//--------------------------------------------------------------------
		
		public function testMultiple():void {
			createTargets();
			
			target2.x = 0;
			testInstance = new Move(targets,[200,200,100,100]);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}
	}
}