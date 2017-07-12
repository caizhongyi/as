package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Glow;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class GlowTest extends AnimationPackageTest {
		
		public var testInstance:Glow;		
		
		public function GlowTest(root:Sprite) {
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
			
			var filterEnd:GlowFilter = new GlowFilter();
			testInstance = new Glow(target,filterEnd);
			
			listenStartEvent(testInstance, [0,0,0,0], false);
			
			testInstance.animate(0,100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [1,6,6,2], false);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward():void {
			createTarget();
			
			var filterEnd:GlowFilter = new GlowFilter();
			testInstance = new Glow(target,filterEnd);
			
			listenStartEvent(testInstance, [1,6,6,2]);
			
			testInstance.animate(100,0);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward2():void {
			createTarget();
			
			var filterStart:GlowFilter = new GlowFilter();
			testInstance = new Glow(target,[filterStart, null]);
			
			listenStartEvent(testInstance, [1,6,6,2]);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testFilterIndex():void {
			createTarget();
			
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter();
			target.filters = [dropShadowFilter];
			var filter:GlowFilter = new GlowFilter();
			target.filters = [dropShadowFilter,filter];	
			
			var newGlowFilter:GlowFilter = new GlowFilter();
			newGlowFilter.blurX = 50;
			testInstance = new Glow(target, 1, newGlowFilter);
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testNonAnimatableProps():void {
			createTarget();			

			var filter:GlowFilter = new GlowFilter();
			filter.blurX = 15;
			filter.blurY = 15;			
			testInstance = new Glow(target, filter);
			testInstance.knockout = true;
			testInstance.inner = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testMultiple():void {
			createTargets();			
			
			var filter:GlowFilter = new GlowFilter();
			testInstance = new Glow(targets, filter);
			testInstance.inner = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}		
	}
}