package de.alex_uhlmann.animationpackage.animation {
	
import flash.geom.Point;
import flash.geom.Rectangle;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

public class Scale extends AnimationCore implements IMultiAnimatable {	
	
	public var x:Number = 0;
	public var y:Number = 0;	
	private var scaleXProperty:String = "scaleX";
	private var scaleYProperty:String = "scaleY";
	private var xProperty:String = "x";
	private var yProperty:String = "y";	
	private var pixelscale:Boolean = false;
	private var pixelscaleConstructValue:Boolean;
	private var areStartValuesSet:Boolean = false;	
	private var modifiedRegistrationPoint:Boolean = false;
	private var registrationObj:Object;
	private var myInstances:Array;

	public function Scale(...arguments:Array) {
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
	
	private function initAnimation():void {		
		
		if (arguments.length > 2) {	
			this.animationStyle(arguments[2], arguments[3]);
		} else {
			this.animationStyle(this.duration, this.easing);
		}
		
		if(this.mc != null) {
			this.pixelscaleConstructValue = this.pixelscale;
			this.setStartValues([this.mc[this.scaleXProperty], this.mc[this.scaleYProperty]], true);
		}
		this.setEndValues([arguments[0], arguments[1]]);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
		this.startInitialized = false;		
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = this.getEndValues();

		if(this.mc != null) {

			//in case the pixelscale has been changed to true after the start values have been set via 
			//constructor, we need to calculate the start values again, but only if start values 
			//havn't been set and have to be calculated from current values.
			var hasPixelScaleChanged:Boolean = (this.pixelscaleConstructValue != this.pixelscale && this.pixelscale == true)
			if(hasPixelScaleChanged && !this.areStartValuesSet) {
				this.setStartValues([this.mc[this.scaleXProperty], this.mc[this.scaleYProperty]]);
			}
			
			this.myAnimator.start = this.getStartValues();
			
			if(!this.modifiedRegistrationPoint) {
				this.myAnimator.setter = [[this.mc, this.scaleXProperty], 
										[this.mc, this.scaleYProperty]];					
			} else {
				this.myAnimator.setter = [[this,"setX"], [this,"setY"]];
			}

		} else {
			
			if(!this.modifiedRegistrationPoint) {
				this.myAnimator.multiStart = [this.scaleXProperty, this.scaleYProperty];	
				this.myAnimator.multiSetter = [[this.mcs, this.scaleXProperty], 
									[this.mcs, this.scaleYProperty]];				
			} else {
				var myInstances:Array = [];			
				var len:Number = this.mcs.length;
				var mcs:Array = this.mcs;
				var i:Number = len;
				while(--i>-1) {
					myInstances[i] = new Scale(mcs[i]);
					myInstances[i].setStartValues(this.getStartValues());
					myInstances[i].scaleXProperty = this.scaleXProperty;
					myInstances[i].scaleYProperty = this.scaleYProperty;
					myInstances[i].setRegistrationPoint(registrationObj);
				}
				this.myInstances = myInstances;
				this.myAnimator.multiStart = ["getMultiStartXValue","getMultiStartYValue"];	
				this.myAnimator.multiSetter = [[this.myInstances,"setX"], 
									[this.myInstances,"setY"]];
			}
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

	public function getMultiStartXValue():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.mc[this.scaleXProperty];
		} else {
			return startValues[0];
		}
	}
	
	public function getMultiStartYValue():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.mc[this.scaleXProperty];
		} else {
			return startValues[1];
		}
	}
	
	/*Adapted from solutions of Robert Penner, Darron Schall and Ben Jackson*/
	public function setX(value:Number):void {		
		var bounds:Rectangle = this.mc.getBounds(this.mc);		
		var xorigin:Number = bounds.left + this.x;
		var a:Point = new Point(xorigin, 0);		
		a = this.mc.localToGlobal(a);
		this.mc[this.scaleXProperty] = value;
		var b:Point = new Point(xorigin, 0);
		b = this.mc.localToGlobal(b);
		this.mc[this.xProperty] -= b.x - a.x;	
	}

	/*Adapted from solutions of Robert Penner, Darron Schall and Ben Jackson*/
	public function setY(value:Number):void {		
		var bounds:Rectangle = this.mc.getBounds(this.mc);		
		var yorigin:Number = bounds.top + this.y;
		var a:Point = new Point(0, yorigin);		
		a = this.mc.localToGlobal(a);
		this.mc[this.scaleYProperty] = value;
		var b:Point = new Point(0, yorigin);
		b = this.mc.localToGlobal(b);
		this.mc[this.yProperty] -= b.y - a.y;
	}
	
	public function scaleWithPixels(pixelscale:Boolean):void {
		if(pixelscale) {
			this.scaleXProperty = "width";
			this.scaleYProperty = "height";
		} else {
			this.scaleXProperty = "scaleX";
			this.scaleYProperty = "scaleY";			
		}
		this.pixelscale = pixelscale;		
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

	override public function setStartValues(startValues:Array, optional:Boolean = false):Boolean {
		if(optional == false) {	
			this.areStartValuesSet = true;
		}
		return super.setStartValues(startValues, optional);
	}
}
}