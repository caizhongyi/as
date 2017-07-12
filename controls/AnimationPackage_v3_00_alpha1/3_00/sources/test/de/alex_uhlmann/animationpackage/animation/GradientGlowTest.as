package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.GradientGlow;
	
	import flash.filters.BlurFilter;
	import flash.filters.GradientGlowFilter;
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class GradientGlowTest extends AnimationPackageTest {
		
		public var testInstance:GradientGlow;		
		
		public function GradientGlowTest(root:Sprite) {
			super(root);
		}
		
		public function run():void {
			testForward();
			//testBackward();
			//testBackward2();
			//testFilterIndex();
			//testNonAnimatableProps();
			//testMultiple();
		}
		
		private function getFilter():GradientGlowFilter {
			var filter:GradientGlowFilter = new GradientGlowFilter();
			filter.colors = [0xFFFFFF, 0xFF0000, 0xFFFF00, 0x00CCFF];
			filter.alphas = [0, 1, 1, 1, 1];
			filter.ratios = [0, 63, 126, 255];
			filter.quality = 3; 
			filter.type = "outer"; 
			filter.knockout = false;
			filter.distance = 0;
			filter.angle = 0;
			filter.blurX = 8;
			filter.blurY = 8; 
			filter.strength = 2.5;
			return filter;
		}
		
		public function testForward():void {
			createTarget();
			
			var filterEnd:GradientGlowFilter = getFilter();
			testInstance = new GradientGlow(target,filterEnd);
			
			listenStartEvent(testInstance, [0,0,0,0,0], false);
			
			testInstance.animate(0,100);			
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [0,0,8,8,2.5], false);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward():void {
			createTarget();
			
			var filterEnd:GradientGlowFilter = getFilter();
			testInstance = new GradientGlow(target,filterEnd);
			
			listenStartEvent(testInstance, [0,0,8,8,2.5]);
			
			testInstance.animate(100,0);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward2():void {
			createTarget();
			
			var filterStart:GradientGlowFilter = getFilter();
			testInstance = new GradientGlow(target,[filterStart, null]);
			
			listenStartEvent(testInstance, [0,0,8,8,2.5]);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testFilterIndex():void {
			createTarget();
			
			var blurFilter:BlurFilter = new BlurFilter();
			target.filters = [blurFilter];
			var filter:GradientGlowFilter = getFilter();
			target.filters = [blurFilter,filter];	
			
			var newGradientGlowFilter:GradientGlowFilter = getFilter();
			newGradientGlowFilter.distance = 20;
			testInstance = new GradientGlow(target, 1, newGradientGlowFilter);
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testNonAnimatableProps():void {
			createTarget();			

			var filter:GradientGlowFilter = getFilter();
			testInstance = new GradientGlow(target, filter);
			testInstance.type = "full";
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testMultiple():void {
			createTargets();			
			
			var filter:GradientGlowFilter = getFilter();
			testInstance = new GradientGlow(targets, filter);
			testInstance.knockout = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}		
	}
}