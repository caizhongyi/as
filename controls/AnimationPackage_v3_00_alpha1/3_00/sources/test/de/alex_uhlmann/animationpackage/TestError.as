package test.de.alex_uhlmann.animationpackage {

	public class TestError extends Error {

		public function TestError(expected:*, found:*) {
			super("Expected: "+expected+"; found: "+found); 
			name = "TestError";
		}	
	}
}