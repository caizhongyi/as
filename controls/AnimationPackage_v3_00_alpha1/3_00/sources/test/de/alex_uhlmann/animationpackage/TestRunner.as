package test.de.alex_uhlmann.animationpackage {
	
	import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	public class TestRunner {
		
		private var root:Sprite;
		private var tests:Array;
		private var currentTestClass:TestClass;
		private var currentTestClassIndex:int;
		private var testClassLabel:TextField;
		private var testMethodLabel:TextField;
		
		public function TestRunner(root:Sprite) {		
			this.root = root;
			tests = new Array();
			drawTestTextFields();
		}
		
		public function addTestSuite(clazz:Class):void {
			var testClass:TestClass = new TestClass();
			testClass.testInstance = new clazz(root);
			testClass.methods = getTestMethods(testClass.testInstance);		
			tests.push(testClass);
		}
		
		public function run(index:int):void {
			currentTestClassIndex = index;
			currentTestClass = tests[index];
			if(currentTestClass == null) {
				trace("TestSuite is complete");
				//testMethodLabel.text += "           COMPLETE";
				testMethodLabel.appendText( "           COMPLETE" );
				return;
			}
			runTestClass(currentTestClass);
		}		
		
		private function drawTestTextFields():void {
         var format:TextFormat = new TextFormat();
         format.size = 8;
			testClassLabel = new TextField();
			testClassLabel.defaultTextFormat = format;
			testClassLabel.autoSize = TextFieldAutoSize.LEFT;
			testMethodLabel = new TextField();
			testMethodLabel.defaultTextFormat = format;
			testMethodLabel.autoSize = TextFieldAutoSize.LEFT;
			testMethodLabel.y = 10;
         root.addChild(testClassLabel);
         root.addChild(testMethodLabel);            
		}
		
		private function printTestAction(testInstance:*, method:String):void {
			testClassLabel.text = getQualifiedClassName(testInstance);
			testMethodLabel.text = method;
		}
		
		private function getTestMethods(test:*):Array {
			var testMethods:Array = new Array();
			var classInfo:XML = describeType(test)
			for each(var m:XML in classInfo..method) {				
				var method:String = m.@name.toString();
				var isTestMethod:Boolean = (method.substring(0, 4) == "test");
				if(isTestMethod)
					testMethods.push(method);				
			}
			return testMethods;
		}
		
		private function runTestClass(testClass:TestClass):void {				
			var testInstance:* = testClass.testInstance;	
			var method:String = testClass.methods.pop();
			//a testShort method does not use an instance variable to monitor it's state			
			if(method.substring(0,9) == "testShort")
				method = testClass.methods.pop();
			printTestAction(testInstance, method);
			testInstance[method]();
			var timer:Timer = new Timer(testInstance.duration + 2100,1);
			timer.addEventListener(TimerEvent.TIMER, handleSuccessor);
			timer.start();
		}	
		
		private function handleSuccessor(event:TimerEvent):void {
			if(currentTestClass.methods.length > 1) {
				if(currentTestClass.testInstance.tearDownMethod != null)
					currentTestClass.testInstance.tearDownMethod();
				runTestClass(currentTestClass);
			} else if(currentTestClass.methods.length == 1) {
				if(currentTestClass.methods[0].substring(0,9) == "testShort") {
					currentTestClass.methods.pop();
				}
				nextClass();
			} else {
				nextClass();
			}		
		}	
		
		private function nextClass():void {
			if(currentTestClass.testInstance.tearDownMethod != null)
				currentTestClass.testInstance.tearDownMethod();
			currentTestClassIndex++;
			run(currentTestClassIndex);		
		}		
	}
}