package de.alex_uhlmann.animationpackage.animation {

import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.ColorFX;

public class ColorBrightness extends AnimationCore implements ISingleAnimatable, IMultiAnimatable {
	
	private var myColorFX:ColorFX;
	
	public function ColorBrightness(...arguments:Array) {
		super();
		this.overwriteProperty = "target";
		if(arguments[0] is Array) {
			this.mcs = arguments[0];
			this.myColorFX = new ColorFX(this.mcs[0]);
		} else {
			this.mc = arguments[0];
			this.myColorFX = new ColorFX(this.mc);
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
		this.setStartValue(this.myColorFX.getBrightness(), true);
		this.setEndValue(arguments[0]);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {		
		this.startInitialized = false;
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = [this.getEndValue()];
		
		if(this.mc != null) {
			this.myAnimator.start = [this.getStartValue()];
			this.myAnimator.setter = [[this.myColorFX,"setBrightness"]];
		} else {
			
			var myColorFXs:Array = [];
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				myColorFXs[i] = new ColorFX(this.mcs[i]);
			}
			
			this.myAnimator.multiStart = ["getBrightness"];										
			this.myAnimator.multiSetter = [[myColorFXs,"setBrightness"]];			
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