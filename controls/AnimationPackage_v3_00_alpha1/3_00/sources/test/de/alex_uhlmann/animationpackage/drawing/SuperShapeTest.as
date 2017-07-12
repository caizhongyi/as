package test.de.alex_uhlmann.animationpackage.drawing {
	
	import com.robertpenner.easing.*;
		
	import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
	import de.alex_uhlmann.animationpackage.animation.DropShadow;
	import de.alex_uhlmann.animationpackage.drawing.SuperShape;	
	
	import flash.display.Sprite;
	import flash.filters.*;
	
	import test.de.alex_uhlmann.animationpackage.AnimationPackageTest;
	
	public class SuperShapeTest extends AnimationPackageTest {
		
		public var testInstance:SuperShape;
		public var lockFilter:Boolean;
		
		public function SuperShapeTest(root:Sprite) {			
			super(root);
		}
		
		public function run():void {
			//testDraw();
			//testAnimatePreset();
			//testAnimate();
			//testAnimateProps();
			//testMorph();
			//testMorphWithDropShadow();
			testMorphWithGradientBevel();
		}
		
		public function testDraw():void {
			createEmptyTarget();
				
			testInstance = new SuperShape(target,275,200);
			testInstance.addPreset({label:"Bundeswehr", data:{m:4, n1:10000, n2:8000, n3:8000, range:2, scaling:1, detail:1000}});
			testInstance.setPreset("Bundeswehr");
			testInstance.draw();
			tearDownMethod = removeTarget;
		}
		
		
		public function testAnimatePreset():void {
			createEmptyTarget();
			
			testInstance = new SuperShape(target,275,200);
			testInstance.setPreset("circle");
			testInstance.fillStyle(0xff0000);
			
			listenStartEvent(testInstance, 1000);
			
			testInstance.animate(100,0);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 0);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimate():void {
			createEmptyTarget();
			
			testInstance = new SuperShape(target,200, 200, 19/6, .3, .3, .3, 12, 1, 5000);
			testInstance.fillStyle(0);
			testInstance.animationStyle(duration);
			
			listenStartEvent(testInstance, 0);
			
			testInstance.animate(0,100);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 5000);
			tearDownMethod = removeTarget;
		}
		
		public function testAnimateProps():void {
			createEmptyTarget();

			testInstance = new SuperShape(target,275,200);
			testInstance.lineStyle(6);
			testInstance.fillStyle(0xff0000);
			testInstance.animationStyle(duration,Circ.easeOut);
			testInstance.setPreset("circle");
			
			listenStartEvent(testInstance, 1000);
			
			testInstance.animateProps(["detail"],[3]);
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration, 3);
			tearDownMethod = removeTarget;
		}		
		
		public function testMorph():void {
			createEmptyTarget();

			testInstance = new SuperShape(target,275,200);
			testInstance.lineStyle(3);
			testInstance.fillStyle(0xff0000);
			testInstance.animationStyle(duration,Circ.easeInOut);
			
			listenStartEvent(testInstance);
			
			testInstance.morph("windmill","radioactive");
			
			listenUpdateEvent(testInstance, duration);
			listenEndEvent(testInstance, duration);
			tearDownMethod = removeTarget;
		}
		
		public function testMorphWithDropShadow():void {
			createEmptyTarget();
			
			duration = 2000 * 7;
			lockFilter = true;
			
			testInstance = new SuperShape(target,275,200);			
			testInstance.lineStyle(3);
			testInstance.fillStyle(0xff0000);
			testInstance.animationStyle(duration / 7,Circ.easeInOut);

			testInstance.setPreset("burst");
			
			testInstance.addPreset({label:"rounded Polygon", data:{m:5, n1:1, n2:1.7, n3:1.7, range:2, scaling:1, detail:1000}});
			testInstance.addEventListener(AnimationEvent.END, onStart);
			
			var filter:DropShadowFilter = new DropShadowFilter();
			filter.distance = 20;
			var filterAni:DropShadow = new DropShadow(target,filter);			
			filterAni.duration = 5000;
			filterAni.animate(0,100);
			
			testInstance.morph("burst","rounded Polygon");	
			
			tearDownMethod = removeTarget;
		}		
		
		public function testMorphWithGradientBevel():void {
			createEmptyTarget();
			
			duration = 2000 * 7;
			lockFilter = false;
			
			testInstance = new SuperShape(target,275,200);			
			testInstance.lineStyle(3);
			testInstance.fillStyle(0xff0000);
			testInstance.animationStyle(duration / 7,Circ.easeInOut);

			testInstance.setPreset("burst");
			
			testInstance.addPreset({label:"rounded Polygon", data:{m:5, n1:1, n2:1.7, n3:1.7, range:2, scaling:1, detail:1000}});
			testInstance.addEventListener(AnimationEvent.END, onStart);
			
			var filter:GradientBevelFilter = getGradientBevelFilter();			
			target.filters = [filter];
			
			testInstance.morph("burst","rounded Polygon");	
			
			tearDownMethod = removeTarget;
		}
		
		private function getGradientBevelFilter():GradientBevelFilter {
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
		
		private function getGradientGlowFilter():GradientGlowFilter {
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
				
		private function onStart(event:AnimationEvent):void {
			testInstance.removeEventListener(AnimationEvent.END, onStart);
			testInstance.addEventListener(AnimationEvent.END, onRoundStar);
			testInstance.animateProps(["n1"],[0.09]);
		}
		
		private function onRoundStar(event:AnimationEvent):void {
			testInstance.removeEventListener(AnimationEvent.END, onRoundStar);
			testInstance.addEventListener(AnimationEvent.END, onN1Out);
			testInstance.animateProps(["n1"],[1]);
			if(!lockFilter) {
				var filter:GradientGlowFilter = getGradientGlowFilter();			
				target.filters = [filter];
			}
		}
		
		private function onN1Out(event:AnimationEvent):void {
			testInstance.removeEventListener(AnimationEvent.END, onN1Out);
			testInstance.addEventListener(AnimationEvent.END, onN2In);
			testInstance.animateProps(["n2"],[6]);
			if(!lockFilter) {
				var filter:GlowFilter = new GlowFilter();			
				target.filters = [filter];
			}	
		}	
		
		private function onN2In(event:AnimationEvent):void {
			testInstance.removeEventListener(AnimationEvent.END, onN2In);
			testInstance.addEventListener(AnimationEvent.END, onN2Out);
			testInstance.animateProps(["n2"],[1]);
			if(!lockFilter) {
				var filter:BevelFilter = new BevelFilter();			
				target.filters = [filter];
			}	
		}	
		
		private function onN2Out(event:AnimationEvent):void {
			testInstance.removeEventListener(AnimationEvent.END, onN2Out);
			testInstance.addEventListener(AnimationEvent.END, onN3In);
			testInstance.animateProps(["n2","n3"],[6,6]);
		}
		
		private function onN3In(event:AnimationEvent):void {
			testInstance.removeEventListener(AnimationEvent.END, onN3In);
			testInstance.animateProps(["n2","n3"],[1,1]);
			if(!lockFilter) {
				var filter:BlurFilter = new BlurFilter();			
				target.filters = [filter];
			}
		}							
	}
}