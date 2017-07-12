package de.alex_uhlmann.animationpackage.animation {

import flash.geom.Point;
import flash.geom.Rectangle;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

public class Rotation extends AnimationCore implements ISingleAnimatable {
	
	public var x:Number = 0;
	public var y:Number = 0;
	private var xProperty:String = "x";
	private var yProperty:String = "y";
	private var rotationProperty:String = "rotation";
	private var modifiedRegistrationPoint:Boolean = false;
	private var registrationObj:Object;
	private var myInstances:Array;
	
	public function Rotation(...arguments:Array) {		
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
			this.setStartValue(this.mc[this.rotationProperty], true);		
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
			if(!this.modifiedRegistrationPoint) {
				this.myAnimator.setter = [[this.mc,this.rotationProperty]];						
			} else {
				this.myAnimator.setter = [[this,"setXY"]];
			}
		
		} else {

			if(!this.modifiedRegistrationPoint) {
				
				this.myAnimator.multiStart = [this.rotationProperty];										
				this.myAnimator.multiSetter = [[this.mcs,this.rotationProperty]];			
			
			} else {
				
				var myInstances:Array = [];			
				var len:Number = this.mcs.length;
				var mcs:Array = this.mcs;
				var i:Number = len;
				while(--i>-1) {
					myInstances[i] = new Rotation(mcs[i]);
					myInstances[i].setStartValue(this.getStartValue());		
					myInstances[i].setRegistrationPoint(registrationObj);
				}
				this.myInstances = myInstances;
				this.myAnimator.multiStart = ["getMultiStartXYValue"];	
				this.myAnimator.multiSetter = [[this.myInstances,"setXY"]];
			}
		}

		if(!isNaN(end)) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(start);
		}
	}
	
	public function getMultiStartXYValue():Number {
		var startValue:Number = this.getStartValue();
		if(isNaN(startValue)) {
			return this.mc[this.rotationProperty];
		} else {
			return startValue;
		}
	}
	
	//Adapted from solutions of Robert Penner, Darron Schall and Ben Jackson
	public function setXY(value:Number):void {		
		var bounds:Rectangle = this.mc.getBounds(this.mc);		
		var xorigin:Number = bounds.left + this.x;
		var yorigin:Number = bounds.top + this.y;
		var a:Point = new Point(xorigin, yorigin);		
		a = this.mc.localToGlobal(a);
		this.mc[this.rotationProperty] = value;
		var b:Point = new Point(xorigin, yorigin);
		b = this.mc.localToGlobal(b);
		this.mc[this.xProperty] -= b.x - a.x;
		this.mc[this.yProperty] -= b.y - a.y;
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
	
	public function setRegistrationPoint(registrationObj:Object):void {
		this.modifiedRegistrationPoint = true;		
		if(this.mc == null) {
			this.registrationObj = registrationObj;
			return;
		}
		if(registrationObj.position == "CENTER") {
			this.x = this.mc.width / 2;
			this.y = this.mc.height / 2;
		} else {
			if(registrationObj.x != null ) {
				this.x = registrationObj.x;
			}
			if(registrationObj.y != null ) {
				this.y = registrationObj.y;
			}
		}
	}	
}
}