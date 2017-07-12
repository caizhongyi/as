package de.alex_uhlmann.animationpackage.animation {
	
import flash.geom.ColorTransform;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

public class Colorizer extends AnimationCore implements IMultiAnimatable {

	private var colorTransformMode:Boolean = false;
	private var startRGB:Number;
	private var startMultiplier:Number;
	private var endRGB:Number;
	private var endMultiplier:Number;
	private var transformObject:ColorTransform;
	private var hasStartValues:Boolean;
	private var myInstances:Array;
	//private var overwriteProperty:String = "movieclip";
	
	public function Colorizer(...arguments:Array) {
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
			var endValues:Array;
			if(values.length == 4) {
				endValues = values.slice(-2);
				arguments.shift();
				arguments.splice(0, 0, endValues[0], endValues[1]);
				this.initAnimation.apply(this, arguments);
				this.setStartValues([values[0], values[1]]);
			} else {
				endValues = values.slice(-1);
				arguments.shift();
				arguments.splice(0, 0, endValues[0]);
				this.initAnimation.apply(this, arguments);				
				this.setStartValues([values[0]]);					
			}
		} else if(arguments.length > 0) {			
			this.initAnimation.apply(this, arguments);
		}		
	}
	
	override public function setStartValues(startValues:Array, optional:Boolean = false):Boolean {
		var colorFrom:ColorTransform;
		if(startValues[0] is ColorTransform) {
			
			this.colorTransformMode = true;
			colorFrom = this.transformObject = startValues[0];
			if(optional) {
				this.hasStartValues = false;
			} else {
				this.hasStartValues = true;
			}
			return super.setStartValues([colorFrom.redMultiplier, colorFrom.redOffset, 
										colorFrom.greenMultiplier, colorFrom.greenOffset, 
										colorFrom.blueMultiplier, colorFrom.blueOffset,
										colorFrom.alphaMultiplier, colorFrom.alphaOffset], optional);						
		
		} else if(startValues.length == 2) {
			
			this.colorTransformMode = false;
			this.startRGB = startValues[0];
			this.startMultiplier = startValues[1];
			colorFrom = createRGBColor(this.startRGB, this.startMultiplier);
			return super.setStartValues([colorFrom.redMultiplier, colorFrom.redOffset, 
										colorFrom.greenMultiplier, colorFrom.greenOffset, 
										colorFrom.blueMultiplier, colorFrom.blueOffset,
										colorFrom.alphaMultiplier, colorFrom.alphaOffset], optional);									
		} else {
			return super.setStartValues.apply(this,arguments);
		}					
	}
	
	override public function setEndValues(endValues:Array):Boolean {
		var colorTo:ColorTransform;
		if(endValues[0] is ColorTransform) {
			
			this.colorTransformMode = true;
			colorTo = endValues[0];
			return super.setEndValues([colorTo.redMultiplier, colorTo.redOffset, 
										colorTo.greenMultiplier, colorTo.greenOffset, 
										colorTo.blueMultiplier, colorTo.blueOffset,
										colorTo.alphaMultiplier, colorTo.alphaOffset]);						
		
		} else if(endValues.length == 2) {
			
			this.colorTransformMode = false;
			this.endRGB = endValues[0];
			this.endMultiplier = endValues[1];
			colorTo = createRGBColor(this.endRGB, this.endMultiplier);
			return super.setEndValues([colorTo.redMultiplier, colorTo.redOffset, 
										colorTo.greenMultiplier, colorTo.greenOffset, 
										colorTo.blueMultiplier, colorTo.blueOffset,
										colorTo.alphaMultiplier, colorTo.alphaOffset]);		
		} else {
			return super.setEndValues.apply(this,arguments);
		}				
	}
	
	/*
	* If the user specified one offset and one multiplier 
	* value, only they will be returned.
	*/
	override public function getStartValues():Array {
		if(this.colorTransformMode == false && this.mc != null) {
			return [this.startRGB, this.startMultiplier];			
		}
		return super.getStartValues();	
	}
	
	override public function getCurrentValues():Array {		
		if(this.colorTransformMode == false && this.mc != null) {
			var colors:Array = super.getCurrentValues();			
			var currentRGB:Number = this.rgb2hexrgb(colors[1], colors[3], colors[5]);			
			var currentMultiplier:Number = colors[0];
			return [currentRGB, currentMultiplier];			
		}
		return super.getCurrentValues();
	}
	
	//Adapted from Colin Moock, ASDG2
	public function rgb2hexrgb(r:Number, g:Number, b:Number):Number {
		/*combine the color values into a single number.*/
		return ((r<<16) | (g<<8) | b);
	}
	
	override public function getEndValues():Array {		
		if(this.colorTransformMode == false && this.mc != null) {
			return [this.endRGB, this.endMultiplier];			
		}
		return super.getEndValues();
	}
	
	private function createRGBColor(rgb:Number, multiplier:Number):ColorTransform {
		var colorTransform:ColorTransform = new ColorTransform();	
		colorTransform.color = rgb;
		colorTransform.redMultiplier = multiplier;
		colorTransform.greenMultiplier = multiplier;
		colorTransform.blueMultiplier = multiplier;
		colorTransform.alphaMultiplier = 1;
		colorTransform.alphaOffset = 0;		
		return colorTransform;
	}	
	
	private function initAnimation():void {		
		
		if(arguments[0] is ColorTransform) {
			
			if(arguments.length > 1) {			
				this.animationStyle(arguments[1], arguments[2]);
			} else {
				this.animationStyle(this.duration, this.easing);
			}
			
			this.setStartValues([this.movieclip.transform.colorTransform], true);
			this.setEndValues([arguments[0]]);			
		
		} else {			
			
			if(arguments.length > 2) {
				this.animationStyle(arguments[2], arguments[3]);
			} else {
				this.animationStyle(this.duration, this.easing);
			}
			
			var rgb:Number = this.movieclip.transform.colorTransform.color;	
			this.setStartValues([rgb, this.movieclip.transform.colorTransform.redMultiplier], true);
			this.setEndValues([arguments[0], arguments[1]]);
		}
	}
	
	private function invokeAnimation(start:Number, end:Number):void {		
		
		this.startInitialized = false;
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = super.getEndValues();
		
		if(this.mc != null) {
			//colorize movieclip right away when a fixed start value has been set.
			if(this.colorTransformMode) {
				this.movieclip.transform.colorTransform = this.transformObject;
			}
			this.myAnimator.start = super.getStartValues();				
			this.myAnimator.setter = [[this, "setColor"]];		
		} else {
			var myInstances:Array = [];
			var len:Number = this.mcs.length;
			var mcs:Array = this.mcs;
			var i:Number = len;
			if(this.colorTransformMode == true && this.hasStartValues == true) {
				while(--i>-1) {
					myInstances[i] = new Colorizer(mcs[i]);
					myInstances[i].setStartValues([this.transformObject]);
				}
			} else {
				while(--i>-1) {
					myInstances[i] = new Colorizer(mcs[i]);
				}				
			}
			this.myInstances = myInstances;
			
			this.myAnimator.multiStart = ["getRedMultiplier", 
									"getRedOffset", 
									"getGreenMultiplier",
									"getGreenOffset", 
									"getBlueMultiplier", 
									"getBlueOffset",
									"getAlphaMultiplier", 
									"getAlphaOffset"];			
			
			this.myAnimator.multiSetter = [[myInstances, "setRedMultiplier"], 
									[myInstances, "setRedOffset"], 
									[myInstances, "setGreenMultiplier"],
									[myInstances, "setGreenOffset"], 
									[myInstances, "setBlueMultiplier"], 
									[myInstances, "setBlueOffset"],
									[myInstances, "setAlphaMultiplier"],
									[myInstances, "setAlphaOffset"]];
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
										
	public function setColor(redMultiplier:Number, redOffset:Number, 
									greenMultiplier:Number, greenOffset:Number, 
									blueMultiplier:Number, blueOffset:Number, 
									alphaMultiplier:Number, alphaOffset:Number):void {
		
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = redMultiplier;
		targetTransform.redOffset = redOffset;
		targetTransform.greenMultiplier = greenMultiplier;
		targetTransform.greenOffset = greenOffset;		
		targetTransform.blueMultiplier = blueMultiplier;
		targetTransform.blueOffset = blueOffset;
		targetTransform.alphaMultiplier = alphaMultiplier;
		targetTransform.alphaOffset = alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}	
	
	public function getRedMultiplier():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.redMultiplier;
		} else {
			return startValues[0];
		}		
	}
	
	public function setRedMultiplier(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = value;
		targetTransform.redOffset = currentTransform.redOffset;
		targetTransform.greenMultiplier = currentTransform.greenMultiplier;
		targetTransform.greenOffset = currentTransform.greenOffset;
		targetTransform.blueMultiplier = currentTransform.blueMultiplier;
		targetTransform.blueOffset = currentTransform.blueOffset;
		targetTransform.alphaMultiplier = currentTransform.alphaMultiplier;
		targetTransform.alphaOffset = currentTransform.alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}
	
	public function getRedOffset():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.redOffset;
		} else {
			return startValues[1];
		}
	}
	
	public function setRedOffset(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = currentTransform.redMultiplier;
		targetTransform.redOffset = value;
		targetTransform.greenMultiplier = currentTransform.greenMultiplier;
		targetTransform.greenOffset = currentTransform.greenOffset;
		targetTransform.blueMultiplier = currentTransform.blueMultiplier;
		targetTransform.blueOffset = currentTransform.blueOffset;
		targetTransform.alphaMultiplier = currentTransform.alphaMultiplier;
		targetTransform.alphaOffset = currentTransform.alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}
	
	public function getGreenMultiplier():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.greenMultiplier;
		} else {
			return startValues[2];
		}
	}
	
	public function setGreenMultiplier(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = currentTransform.redMultiplier;
		targetTransform.redOffset = currentTransform.redOffset;
		targetTransform.greenMultiplier = value;
		targetTransform.greenOffset = currentTransform.greenOffset;
		targetTransform.blueMultiplier = currentTransform.blueMultiplier;
		targetTransform.blueOffset = currentTransform.blueOffset;
		targetTransform.alphaMultiplier = currentTransform.alphaMultiplier;
		targetTransform.alphaOffset = currentTransform.alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}
	
	public function getGreenOffset():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.greenOffset;
		} else {
			return startValues[3];
		}
	}
	
	public function setGreenOffset(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = currentTransform.redMultiplier;
		targetTransform.redOffset = currentTransform.redOffset;
		targetTransform.greenMultiplier = currentTransform.greenMultiplier;
		targetTransform.greenOffset = value;
		targetTransform.blueMultiplier = currentTransform.blueMultiplier;
		targetTransform.blueOffset = currentTransform.blueOffset;
		targetTransform.alphaMultiplier = currentTransform.alphaMultiplier;
		targetTransform.alphaOffset = currentTransform.alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}
	
	public function getBlueMultiplier():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.blueMultiplier;
		} else {
			return startValues[4];
		}
	}
	
	public function setBlueMultiplier(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = currentTransform.redMultiplier;
		targetTransform.redOffset = currentTransform.redOffset;
		targetTransform.greenMultiplier = currentTransform.greenMultiplier;
		targetTransform.greenOffset = currentTransform.greenOffset;
		targetTransform.blueMultiplier = value;
		targetTransform.blueOffset = currentTransform.blueOffset;
		targetTransform.alphaMultiplier = currentTransform.alphaMultiplier;
		targetTransform.alphaOffset = currentTransform.alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}	
	
	public function getBlueOffset():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.blueOffset;
		} else {
			return startValues[5];
		}
	}
	
	public function setBlueOffset(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = currentTransform.redMultiplier;
		targetTransform.redOffset = currentTransform.redOffset;
		targetTransform.greenMultiplier = currentTransform.greenMultiplier;
		targetTransform.greenOffset = currentTransform.greenOffset;
		targetTransform.blueMultiplier = currentTransform.blueMultiplier;
		targetTransform.blueOffset = value;
		targetTransform.alphaMultiplier = currentTransform.alphaMultiplier;
		targetTransform.alphaOffset = currentTransform.alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}
	
	public function getAlphaMultiplier():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.alphaMultiplier;
		} else {
			return startValues[6];
		}
	}
	
	public function setAlphaMultiplier(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = currentTransform.redMultiplier;
		targetTransform.redOffset = currentTransform.redOffset;
		targetTransform.greenMultiplier = currentTransform.greenMultiplier;
		targetTransform.greenOffset = currentTransform.greenOffset;
		targetTransform.blueMultiplier = currentTransform.blueMultiplier;
		targetTransform.blueOffset = currentTransform.blueOffset;
		targetTransform.alphaMultiplier = value;
		targetTransform.alphaOffset = currentTransform.alphaOffset;
		this.movieclip.transform.colorTransform = targetTransform;
	}
	
	public function getAlphaOffset():Number {
		var startValues:Array = this.getStartValues();
		if(startValues == null) {
			return this.movieclip.transform.colorTransform.alphaOffset;
		} else {
			return startValues[7];
		}		
	}	
		
	public function setAlphaOffset(value:Number):void {
		var currentTransform:ColorTransform = this.movieclip.transform.colorTransform;
		var targetTransform:ColorTransform = new ColorTransform();
		targetTransform.redMultiplier = currentTransform.redMultiplier;
		targetTransform.redOffset = currentTransform.redOffset;
		targetTransform.greenMultiplier = currentTransform.greenMultiplier;
		targetTransform.greenOffset = currentTransform.greenOffset;
		targetTransform.blueMultiplier = currentTransform.blueMultiplier;
		targetTransform.blueOffset = currentTransform.blueOffset;
		targetTransform.alphaMultiplier = currentTransform.alphaMultiplier;
		targetTransform.alphaOffset = value;
		this.movieclip.transform.colorTransform = targetTransform;
	}
}
}