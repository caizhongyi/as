package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.GradientBevel;
	
	import flash.filters.BlurFilter;
	import flash.filters.GradientBevelFilter;
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class GradientBevelTest extends AnimationPackageTest {
		
		public var testInstance:GradientBevel;		
		
		public function GradientBevelTest(root:Sprite) {
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
		
		private function getFilter():GradientBevelFilter {
			var filter:GradientBevelFilter = new GradientBevelFilter();
			filter.colors = [0xFFFFFF, 0xFF0000, 0x000000];
			filter.alphas = [1, 1, 1];
			filter.ratios = [0, 128, 255];
			filter.quality = 3; 
			filter.type = "inner"; 
			filter.knockout = true;
			filter.distance = 5;
			filter.angle = 225; 
			filter.blurX = 8;
			filter.blurY = 8; 
			filter.strength = 2;
			return filter;
		}
		
		public function testForward():void {
			createTarget();
			
			var filterEnd:GradientBevelFilter = getFilter();
			testInstance = new GradientBevel(target,filterEnd);
			
			listenStartEvent(testInstance, [0,0,0,0,0], false);
			
			testInstance.animate(0,100);			
			
			listenUpdateEvent(testInstance, duration, false);
			listenEndEvent(testInstance, duration, [5,225,8,8,2], false);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward():void {
			createTarget();
			
			var filterEnd:GradientBevelFilter = getFilter();
			testInstance = new GradientBevel(target,filterEnd);
			
			listenStartEvent(testInstance, [5,225,8,8,2]);
			
			testInstance.animate(100,0);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward2():void {
			createTarget();
			
			var filterStart:GradientBevelFilter = getFilter();
			testInstance = new GradientBevel(target,[filterStart, null]);
			
			listenStartEvent(testInstance, [5,225,8,8,2]);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0,0,0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testFilterIndex():void {
			createTarget();
			
			var blurFilter:BlurFilter = new BlurFilter();
			target.filters = [blurFilter];
			var filter:GradientBevelFilter = getFilter();
			target.filters = [blurFilter,filter];	
			
			var newGradientBevelFilter:GradientBevelFilter = getFilter();
			newGradientBevelFilter.distance = 20;
			testInstance = new GradientBevel(target, 1, newGradientBevelFilter);
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testNonAnimatableProps():void {
			createTarget();			

			var filter:GradientBevelFilter = getFilter();
			testInstance = new GradientBevel(target, filter);
			testInstance.type = "full";
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testMultiple():void {
			createTargets();			
			
			var filter:GradientBevelFilter = getFilter();
			testInstance = new GradientBevel(targets, filter);
			testInstance.knockout = true;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}		
	}
}