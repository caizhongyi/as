package test.de.alex_uhlmann.animationpackage.animation {

	import com.robertpenner.easing.*;
	
	import de.alex_uhlmann.animationpackage.animation.Blur;
	
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class BlurTest extends AnimationPackageTest {
		
		public var testInstance:Blur;		
		
		public function BlurTest(root:Sprite) {
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
			
			var filterEnd:BlurFilter = new BlurFilter();
			testInstance = new Blur(target,filterEnd);
			
			listenStartEvent(testInstance, [0,0], false);
			
			testInstance.animate(0,100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [4,4], false);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward():void {
			createTarget();
			
			var filterEnd:BlurFilter = new BlurFilter();
			testInstance = new Blur(target,filterEnd);
			
			listenStartEvent(testInstance, [4,4]);
			
			testInstance.animate(100,0);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testBackward2():void {
			createTarget();
			
			var filterStart:BlurFilter = new BlurFilter();
			testInstance = new Blur(target,[filterStart, null]);
			
			listenStartEvent(testInstance, [4,4]);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, [0,0]);
			tearDownMethod = removeTarget;
		}
		
		public function testFilterIndex():void {
			createTarget();
			
			var glowFilter:GlowFilter = new GlowFilter();
			target.filters = [glowFilter];
			var filter:BlurFilter = new BlurFilter();
			target.filters = [glowFilter,filter];	
			
			var newBlurFilter:BlurFilter = new BlurFilter();
			newBlurFilter.blurX = 15;
			testInstance = new Blur(target, 1, newBlurFilter);
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testNonAnimatableProps():void {
			createTarget();			

			var filter:BlurFilter = new BlurFilter();
			filter.blurX = 15;
			filter.blurY = 15;			
			testInstance = new Blur(target, filter);
			testInstance.quality = 15;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testMultiple():void {
			createTargets();			
			
			var filter:BlurFilter = new BlurFilter();
			testInstance = new Blur(targets, filter);
			testInstance.quality = 3;
			
			listenStartEvent(testInstance);
			
			testInstance.animate(0, 100);			
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTargets;
		}		
	}
}