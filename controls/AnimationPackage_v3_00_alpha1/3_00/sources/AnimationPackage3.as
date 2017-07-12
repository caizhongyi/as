package {

	import flash.display.Sprite;
	
	import test.de.alex_uhlmann.animationpackage.*;
	import test.de.alex_uhlmann.animationpackage.animation.*;
	import test.de.alex_uhlmann.animationpackage.drawing.*;
	import test.de.alex_uhlmann.animationpackage.utility.*;
	
	public class AnimationPackage3 extends Sprite {
		
		public function AnimationPackage3() {
			//runTestRunner();
			runManualTestRunner();
		}
		
		private function runTestRunner():void {
			var testRunner:TestRunner = new TestRunner(this);
			testRunner.addTestSuite(RotationTest);
			testRunner.addTestSuite(AlphaTest);
			testRunner.addTestSuite(MoveTest);
			testRunner.addTestSuite(ScaleTest);
			testRunner.addTestSuite(AnimationCoreTest);
			testRunner.addTestSuite(PauseTest);
			testRunner.addTestSuite(BevelTest);
			testRunner.addTestSuite(DropShadowTest);
			testRunner.addTestSuite(BlurTest);
			testRunner.addTestSuite(GlowTest);
			testRunner.addTestSuite(GradientBevelTest);
			testRunner.addTestSuite(GradientGlowTest);
			testRunner.addTestSuite(ColorNegativeTest);
			testRunner.addTestSuite(ColorBrightnessTest);
			testRunner.addTestSuite(ColorizerTest);
			testRunner.addTestSuite(MoveOnQuadCurveTest);
			testRunner.addTestSuite(MoveOnCubicCurveTest);
			testRunner.addTestSuite(MoveOnCurveTest);
			testRunner.addTestSuite(ParallelTest);
			testRunner.addTestSuite(SequenceTest);			
			testRunner.addTestSuite(AnimationTest);
			testRunner.addTestSuite(LineTest);
			testRunner.addTestSuite(DashLineTest);
			testRunner.addTestSuite(QuadCurveTest);
			testRunner.addTestSuite(CubicCurveTest);
			testRunner.addTestSuite(CurveTest);
			testRunner.addTestSuite(DrawerTest);
			testRunner.addTestSuite(ArcTest);
			testRunner.addTestSuite(SpiralTest);
			testRunner.addTestSuite(SuperShapeTest);
										
			testRunner.run(0);	
		}
		
		private function runManualTestRunner():void {
			var testRunner:ManualTestRunner = new ManualTestRunner(this);
			//testRunner.run(RotationTest);
			//testRunner.run(AnimationCoreTest);
			//testRunner.run(PauseTest);
			//testRunner.run(BevelTest);
			//testRunner.run(DropShadowTest);
			//testRunner.run(BlurTest);
			//testRunner.run(GlowTest);
			//testRunner.run(GradientBevelTest);
			//testRunner.run(GradientGlowTest);
			//testRunner.run(ColorNegativeTest);
			//testRunner.run(ColorBrightnessTest);
			//testRunner.run(ColorizerTest);
			//testRunner.run(MoveOnQuadCurveTest);
			//testRunner.run(MoveOnCubicCurveTest);
			//testRunner.run(MoveOnCurveTest);
			//testRunner.run(ParallelTest);
			//testRunner.run(SequenceTest);
			//testRunner.run(AnimationTest);
			//testRunner.run(LineTest);
			//testRunner.run(DashLineTest);
			//testRunner.run(QuadCurveTest);
			//testRunner.run(CubicCurveTest);
			//testRunner.run(CurveTest);
			//testRunner.run(DrawerTest);
			//testRunner.run(ArcTest);
			//testRunner.run(SpiralTest);
			testRunner.run(SuperShapeTest);
		}
	}
}