package test.de.alex_uhlmann.animationpackage.animation {
	
	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Rotation;
	
	import flash.display.Sprite;	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class RotationTest extends AnimationPackageTest {
		
		public var testInstance:Rotation;
		
		public function RotationTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			testLong();
			//testLong2();
			//testShort();
			//testStartEndValues1();
			//testStartEndValues2();
			//testStartEndValues3();
			//testCustomEasing();
			//testSetRegistrationPoint1();
			//testSetRegistrationPoint2();			
			
			//--------------------------------------------------------------------
			
			//testMultiple();
			//testMultipleWithRegistrationPoint();		
		}
				
		public function testLong():void {
			createTarget();
			
			testInstance = new Rotation(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.run(360);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 360);
			tearDownMethod = removeTarget;
		}
		
		public function testLong2():void {
			createTarget();
			
			testInstance = new Rotation(target,90);
			testInstance.duration = duration;
			testInstance.easing = Elastic.easeOut;
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 90);
			tearDownMethod = removeTarget;	
		}

		public function testShort():void {
			createTarget();
			new Rotation(target).run(-360,duration,Quad.easeIn);
		}
			
		public function testStartEndValues1():void {
			createTarget();
			
			testInstance = new Rotation(target,[90,270],duration,Quad.easeIn);
			
			listenStartEvent(testInstance, 90);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 270);
			tearDownMethod = removeTarget;
		}

		public function testStartEndValues2():void {
			createTarget();
			
			testInstance = new Rotation(target,duration,Quad.easeIn);
			testInstance.setStartValue(90);
			testInstance.setEndValue(270);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 270);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues3():void {
			createTarget();
			
			testInstance = new Rotation(target,270,duration,Quad.easeIn);
			testInstance.setStartValue(90);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 270);
			tearDownMethod = removeTarget;
		}
		
		public function testCustomEasing():void {
			createTarget();
			
			testInstance = new Rotation(target,360);
			testInstance.animationStyle(duration,[Back.easeOut,4]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 360);
			tearDownMethod = removeTarget;
		}
		
		public function testSetRegistrationPoint1():void {
			createTarget();
			
			testInstance = new Rotation(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.setRegistrationPoint({x:0, y:0});
			testInstance.run(360);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 360);
			tearDownMethod = removeTarget;
		}
				
		public function testSetRegistrationPoint2():void {
			createTarget();
			
			testInstance = new Rotation(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.setRegistrationPoint({position:"CENTER"});
			testInstance.run(360);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 360);
			tearDownMethod = removeTarget;
		}
		
		//--------------------------------------------------------------------
			
		public function testMultiple():void {
			createTargets();
			
			target2.rotation = 90;
			testInstance = new Rotation(targets,360);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}
		
		public function testMultipleWithRegistrationPoint():void {
			createTargets();
			
			target2.rotation = 90;
			testInstance = new Rotation(targets,360);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.setRegistrationPoint({position:"CENTER"});
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;	
		}
	}
}