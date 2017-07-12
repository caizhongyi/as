package de.alex_uhlmann.animationpackage.animation {

import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

public class Alpha extends AnimationCore implements ISingleAnimatable {

	private var alphaProperty:String = "alpha";
	
	public function Alpha(...arguments:Array) {
		super();
		if(arguments[0] is Array) {
			this.mcs = arguments[0];
		} else {
			this.mc = arguments[0];
		}
		if(arguments.length > 1) {
			arguments.shift();
			this.init.apply(this, arguments);
		}
	}
	
	//initialisation for classes with one identifier to animate	
	private function init(...arguments:Array):void {		
		if(arguments[0] is Array) {
			var values:Array = arguments[0];
			arguments.shift();
			arguments.unshift(values.pop());				
			this.initAnimation.apply(this, arguments);
			this.setStartValue(values[0]);
		} else if(arguments.length > 0) {
			this.initAnimation.apply(this, arguments);
		}
	}	
	
	private function initAnimation(...arguments:Array):void {		
		if (arguments.length > 1) {			
			this.animationStyle(arguments[1], arguments[2]);
		} else {
			this.animationStyle(this.duration, this.easing);
		}
		if(this.mc != null) {
			this.setStartValue(this.mc[this.alphaProperty], true);	
		}
		this.setEndValue(arguments[0]);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {		
		this.startInitialized = false;		
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = [this.getEndValue()];
		
		if(this.mc != null) {
			this.myAnimator.start = [this.getStartValue()];
			this.myAnimator.setter = [[this.mc, this.alphaProperty]];
		} else {			
			this.myAnimator.multiStart = [this.alphaProperty];										
			this.myAnimator.multiSetter = [[this.mcs, this.alphaProperty]];			
		}

		if(!isNaN(end)) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(start);
		}
	}	

	public function run(...arguments:Array):void {		
		this.init.apply(this, arguments);
		this.invokeAnimation(0, 100);		
	}

	public function animate(start:Number, end:Number):void {		
		this.invokeAnimation(start, end);
	}
	
	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}
}
}