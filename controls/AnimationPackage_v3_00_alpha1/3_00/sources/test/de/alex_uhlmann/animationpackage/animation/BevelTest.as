package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Bevel;
	
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class BevelTest extends AnimationPackageTest {
		
		public var testInstance:Bevel;		
		
		public function BevelTest(root:Sprite) {
			super(root);
		}
		
		public function run():void {
			//testForward();
			//testBackward();
			//testBackward2();
			//testFilterIndex();
			//testNonAnimatableProps();
			//testMultiple();
		}
		
		public function testForward():void {
			createTarget();
			
			var filterEnd:BevelFilter = new BevelFilter();
			testInstance = new Bevel(target,filterEnd);
			
			listenStartEvent(testInstance, [0,0,1,1,0,0,0]);
			
			testInstance.animate(0,100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [4,45,1,1,4,4,1]);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward():void {
			createTarget();
			
			var filterEnd:BevelFilter = new BevelFilter();
			testInstance = new Bevel(target,filterEnd);
			
			listenStartEvent(testInstance, [4,45,1,1,4,4,1]);
			
			testInstance.animate(100,0);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,1,1,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward2():void {
			createTarget();
			
			var filterStart:BevelFilter = new BevelFilter();
			testInstance = new Bevel(target,[filterStart, null]);
			
			listenStartEvent(testInstance, [4,45,1,1,4,4,1]);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,1,1,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testFilterIndex():void {
			createTarget();
			
			var glowFilter:GlowFilter = new GlowFilter();
			target.filters = [glowFilter];
			var bevelFilter:BevelFilter = new BevelFilter();
			target.filters = [glowFilter,bevelFilter];	
			
			var newBevelFilter:BevelFilter = new BevelFilter();
			newBevelFilter.blurX = 15;			
			testInstance = new Bevel(target, 1, newBevelFilter);
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testNonAnimatableProps():void {
			createTarget();			

			var bevelFilter:BevelFilter = new BevelFilter();
			testInstance = new Bevel(target, bevelFilter);
			testInstance.knockout = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testMultiple():void {
			createTargets();			
			
			var bevelFilter:BevelFilter = new BevelFilter();
			testInstance = new Bevel(targets, bevelFilter);
			testInstance.knockout = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}		
	}
}