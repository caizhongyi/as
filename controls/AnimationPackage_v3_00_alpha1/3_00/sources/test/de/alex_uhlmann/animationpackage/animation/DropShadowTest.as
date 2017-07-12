package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.DropShadow;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class DropShadowTest extends AnimationPackageTest {
		
		public var testInstance:DropShadow;		
		
		public function DropShadowTest(root:Sprite) {
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
			
			var filterEnd:DropShadowFilter = new DropShadowFilter();
			testInstance = new DropShadow(target,filterEnd);
			
			listenStartEvent(testInstance, [0,0,0,0,0,0], false);
			
			testInstance.animate(0,100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [4,45,1,4,4,1], false);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward():void {
			createTarget();
			
			var filterEnd:DropShadowFilter = new DropShadowFilter();
			testInstance = new DropShadow(target,filterEnd);
			
			listenStartEvent(testInstance, [4,45,1,4,4,1]);
			
			testInstance.animate(100,0);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward2():void {
			createTarget();
			
			var filterStart:DropShadowFilter = new DropShadowFilter();
			testInstance = new DropShadow(target,[filterStart, null]);
			
			listenStartEvent(testInstance, [4,45,1,4,4,1]);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testFilterIndex():void {
			createTarget();
			
			var glowFilter:GlowFilter = new GlowFilter();
			target.filters = [glowFilter];
			var filter:DropShadowFilter = new DropShadowFilter();
			target.filters = [glowFilter,filter];	
			
			var newDropShadowFilter:DropShadowFilter = new DropShadowFilter();
			newDropShadowFilter.distance = 60;
			testInstance = new DropShadow(target, 1, newDropShadowFilter);
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testNonAnimatableProps():void {
			createTarget();			

			var filter:DropShadowFilter = new DropShadowFilter();
			filter.distance = 8;
			filter.blurX = 15;
			filter.blurY = 15;			
			testInstance = new DropShadow(target, filter);
			testInstance.knockout = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testMultiple():void {
			createTargets();			
			
			var filter:DropShadowFilter = new DropShadowFilter();
			testInstance = new DropShadow(targets, filter);
			testInstance.knockout = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}		
	}
}