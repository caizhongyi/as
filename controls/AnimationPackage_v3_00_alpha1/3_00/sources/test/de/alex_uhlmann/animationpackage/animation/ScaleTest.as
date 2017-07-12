package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Scale;
	
	import flash.display.Sprite;
		
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class ScaleTest extends AnimationPackageTest {
		
		public var testInstance:Scale;
		
		public function ScaleTest(root:Sprite) {
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
			//testSetRegistrationPoint1();
			//testSetRegistrationPoint2();
			//testScaleWithPixels();
			//testScaleWithPixelsAndRegistrationPoint();	
			
			//--------------------------------------------------------------------
			
			//testMultiple();
			//testMultipleWithRegistrationPoint();
		}		
		
		public function testLong():void {
			createTarget();
			
			testInstance = new Scale(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			listenStartEvent(testInstance, [1,1]);
			testInstance.run(15,15);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [15,15]);
			tearDownMethod = removeTarget;
		}
		
		public function testLong2():void {
			createTarget();
			
			testInstance = new Scale(target,1.5,1.5);
			testInstance.duration = duration;
			testInstance.easing = Elastic.easeOut;
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [1.5,1.5]);
			tearDownMethod = removeTarget;
		}
		
		public function testShort():void {
			createTarget();
			
			new Scale(target).run(.5,.5,duration,Quad.easeIn);
		}
			
		public function testStartEndValues1():void {
			createTarget();
			
			testInstance = new Scale(target,[.5,.5,1.5,1.5],duration,Quad.easeIn);
			
			listenStartEvent(testInstance, [.5,.5]);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [1.5,1.5]);	
			tearDownMethod = removeTarget;		
		}
		
		public function testStartEndValues2():void {
			createTarget();
			
			testInstance = new Scale(target,duration,Quad.easeIn);
			testInstance.setStartValues([.5,.5]);
			testInstance.setEndValues([1.5,1.5]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [1.5,1.5]);
			tearDownMethod = removeTarget;
		}
		
		public function testStartEndValues3():void {
			createTarget();
			
			testInstance = new Scale(target,1.5,1.5,duration,Quad.easeIn);
			testInstance.setStartValues([.5,.5]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [1.5,1.5]);
			tearDownMethod = removeTarget;
		}
		
		public function testCustomEasing():void {
			createTarget();
			
			testInstance = new Scale(target,.8,.8);
			testInstance.animationStyle(duration,[Back.easeOut,4]);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [.8,.8]);
			tearDownMethod = removeTarget;
		}
		
		public function testSetRegistrationPoint1():void {
			createTarget();
			
			testInstance = new Scale(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.setRegistrationPoint({x:0, y:0});
			testInstance.run(.5,.5);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [.5,.5]);
			tearDownMethod = removeTarget;			
		}
				
		public function testSetRegistrationPoint2():void {
			createTarget();
			
			testInstance = new Scale(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.setRegistrationPoint({position:"CENTER"});
			testInstance.run(.5,.5);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [.5,.5]);
			tearDownMethod = removeTarget;			
		}
		
		public function testScaleWithPixels():void {
			createTarget();
			
			testInstance = new Scale(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.scaleWithPixels(true);
			testInstance.run(200,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [200,100]);	
			tearDownMethod = removeTarget;	
		}
		
		public function testScaleWithPixelsAndRegistrationPoint():void {
			createTarget();
			
			testInstance = new Scale(target);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.setRegistrationPoint({position:"CENTER"});
			testInstance.scaleWithPixels(true);
			testInstance.run(200,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [200,100]);		
			tearDownMethod = removeTarget;	
		}		
		
		//--------------------------------------------------------------------
			
		public function testMultiple():void {
			createTargets();
			
			target2.scaleX = 2;
			testInstance = new Scale(targets,[.5,.5,1.5,1.5]);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [1.5,1.5,1.5,1.5,1.5,1.5]);
			tearDownMethod = removeTargets;
		}
		
		public function testMultipleWithRegistrationPoint():void {
			createTargets();
			
			target2.scaleX = 2;
			testInstance = new Scale(targets,1.5,1);
			testInstance.animationStyle(duration,Quad.easeIn);
			testInstance.setRegistrationPoint({position:"CENTER"});
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;	
		}
	}
}