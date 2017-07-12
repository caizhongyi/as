package de.alex_uhlmann.animationpackage.animation {
	
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

public class Move extends AnimationCore implements IMultiAnimatable {

	public var xProperty:String = "x";
	public var yProperty:String = "y";
	public var rotationProperty:String = "rotation";
	private var pathOrientation:Boolean = false;	
	
	public function Move(...arguments:Array) {
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

	private function init(...arguments:Array):void {
		if(arguments[0] is Array) {				
			var values:Array = arguments[0];
			var endValues:Array = values.slice(-2);
			arguments.shift();
			arguments.splice(0, 0, endValues[0], endValues[1]);
			this.initAnimation.apply(this, arguments);
			this.setStartValues([values[0], values[1]]);
		} else if(arguments.length > 0) {			
			this.initAnimation.apply(this, arguments);
		}
	}

	private function initAnimation(...arguments:Array):void {
	
		if (arguments.length > 2) {
			this.animationStyle(arguments[2], arguments[3]);
		} else {
			this.animationStyle(this.duration, this.easing);
		}	
		if(this.mc != null) {
			this.setStartValues([this.mc[this.xProperty], this.mc[this.yProperty]], true);
		}
		this.setEndValues([arguments[0], arguments[1]]);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
		this.startInitialized = false;
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = this.getEndValues();
		
		if(this.mc != null) {
			
			this.myAnimator.start = this.getStartValues();
			this.myAnimator.setter = [[this.mc,this.xProperty], [this.mc,this.yProperty]];
			
		} else {

			this.myAnimator.multiStart = [this.xProperty,this.yProperty];										
			this.myAnimator.multiSetter = [[this.mcs,this.xProperty], 
									[this.mcs,this.yProperty]];
		
		}		

		if(!isNaN(end)) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(start);
		}
		
		if(this.pathOrientation == true) {
			this.rotate(this.getStartValues()[0], this.getStartValues()[1], 
						this.getEndValues()[0], this.getEndValues()[1]);			
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
	
	private function rotate(startx:Number, starty:Number, endx:Number, endy:Number):void {		
		var t:Number, deg:Number;
		var d:Number;
		if(starty > this.getEndValues()[1]) {
			d = Math.abs(endx - startx) / Math.abs(endy - starty);
			t = Math.atan(d);
		} else {
			d = Math.abs(endy - starty) / Math.abs(endx - startx);
			t = Math.atan(d) + Math.PI / 2;
		}
		deg = t * (180 / Math.PI);
		if(startx > endx) {
			this.mc[this.rotationProperty] = -deg;
		} else {
			this.mc[this.rotationProperty] = deg;
		}		
	}

	public function orientToPath(bool:Boolean):void {
		this.pathOrientation = bool;
	}
}
}