package test.de.alex_uhlmann.animationpackage {
	
	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.*;
	import test.de.alex_uhlmann.animationpackage.animation.*;
	
	public class ManualTestRunner {
		
		private var tests:Array;
		private var root:Sprite;
		
		public function ManualTestRunner(root:Sprite) {
			this.root = root;
		}
		
		public function run(testInstanceType:Class):void {
			var testInstance:* = new testInstanceType(root);
			testInstance.run();
		}
	}
}