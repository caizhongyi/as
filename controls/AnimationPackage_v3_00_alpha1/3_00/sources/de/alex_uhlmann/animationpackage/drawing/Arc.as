package de.alex_uhlmann.animationpackage.drawing {


import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

import flash.display.Sprite;

public class Arc extends Shape implements IDrawable, ISingleAnimatable {	

	public static var radius_def:Number = 100;
	public static var start_def:Number = 0;
	public static var end_def:Number = 360;
	public static var type_def:String = "CHORD";	
	private var x:Number = 0;
	private var y:Number = 0;
	private var radius:Number;
	private var start:Number;
	private var end:Number;
	private var type:String;
	
	public function Arc(...arguments:Array) {
		super();
		this.init.apply(this,arguments);
		this.fillStyle(0);
		this.animationStyle(NaN);
	}
	
	private function init(...arguments:Array):void {
		if(arguments[0] is Sprite) {				
			this.initCustom.apply(this,arguments);
		} else {			
			this.initAuto.apply(this,arguments);
		}			
	}

	private function initCustom(...arguments:Array):void {
		this.mc = this.createClip({mc:arguments[0], x:arguments[1], y:arguments[2]});
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(...arguments:Array):void {
		
		this.mc = this.createClip({name:"apDraw",x:arguments[0], y:arguments[1]});
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(...arguments:Array):void {
	
		this.radius = (isNaN(arguments[2])) ? Arc.radius_def : arguments[2];
		this.start = (isNaN(arguments[3])) ? Arc.start_def : arguments[3];		
		this.end = (isNaN(arguments[4])) ? Arc.end_def : arguments[4];
		this.type = (isNaN(arguments[5])) ? Arc.type_def : arguments[5];
								
		if(this.type == "PIE") {
			this.x = 0;
		} else {
			this.x = this.radius;
		}
		this.setStartValue(this.start);
		this.setEndValue(this.end);
	}

	private function invokeAnimation(start:Number, end:Number):void {
		this.startInitialized = false;
		
		var isGoto:Boolean;
		if(isNaN(end)) {
			isGoto = true;
			end = start;
			start = 0;			
		} else {
			isGoto = false;
		}

		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [this.getStartValue()];
		this.myAnimator.end = [this.getEndValue()];
		this.myAnimator.setter = [[this, "drawShape"]];
		if(isGoto == false) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(end);
		}
	}
	
	public function animate(start:Number, end:Number):void {		
		this.invokeAnimation(start, end);
	}	
	
	public function run(...arguments:Array):void {
		this.init.apply(this, arguments);
		this.invokeAnimation(0, 100);		
	}

	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}	
	
	public function draw():void {
		this.clearDrawing();
		this.drawNew();
	}
	
	public function drawBy():void {
		if(this.lineStyleModified) {
			this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, 
												this.lineAlpha, this.linePixelHinting, 
												this.lineScaleMode, this.lineCaps, 
												this.lineJoints, this.lineMiterLimit);
		}
		this.drawNew();
	}
	
	override public function setStartValue(startValue:Number, optional:Boolean = false):Boolean {
		this.start = startValue;
		return super.setStartValue(startValue);
	}
	
	override public function setEndValue(endValue:Number):Boolean {
		this.end = endValue;
		return super.setEndValue(endValue);
	}
		
	public function drawShape(v:Number):void {
		this.clearDrawing();
		this.end = v;
		this.drawNew();
	}

	public function getRadius():Number {		
		return this.radius;		
	}
		
	public function setRadius(radius:Number):void {	
		this.radius = radius;		
	}

	public function getAngleStart():Number {
		return this.start;		
	}

	public function setAngleStart(startAngle:Number):void {
		this.start = startAngle;
		this.setStartValue(startAngle);
	}	

	public function getAngleExtent():Number {
		return this.end;		
	}	

	public function setAngleExtent(angExt:Number):void {
		this.end = angExt;	
		this.setEndValue(angExt);
	}
	
	public function getArcType():String {
		return this.type;		
	}
	
	public function setArcType(type:String):void {		
		if(type == "PIE") {			
			if(this.x > this.radius) {
				this.x = this.radius;
			} else {
				this.x = 0;
			}
		} else {
			if(this.x > this.radius) {
				this.x = 2*this.radius;
			} else {
				this.x = this.radius;
			}
		}
		this.type = type;
	}
	
	public function setRegistrationPoint(registrationObj:Object):void {
		if(registrationObj.position == "CENTER") {	
			if(this.type == "PIE") {
				this.x = 0;
			} else {
				this.x = this.radius;
			}			
			this.y = 0;
		} else if (registrationObj.x != null || registrationObj.y != null) {
			if(this.type == "PIE") {
				this.x = this.radius + registrationObj.x;
			} else {
				this.x = 2* (this.radius + registrationObj.x);
			}
			this.y = this.radius + registrationObj.y;
		}
	}
	
	private function drawNew():void {
		this.mc.graphics.moveTo(this.x, this.y);
		if (!isNaN(this.fillRGB) && this.fillGradient == false) {	
			this.mc.graphics.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.graphics.beginGradientFill(this.gradientFillType, 
													this.gradientColors, 
													this.gradientAlphas, 
													this.gradientRatios, 
													this.gradientMatrix,
													this.gradientSpreadMethod,
													this.gradientInterpolationMethod,
													this.gradientFocalPointRatio);
		}
		this.drawArc(this.x, this.y, this.start, this.end, this.radius);
		this.mc.graphics.endFill();
	}

	/*-------------------------------------------------------------
		drawArc is a method for drawing regular and elliptical 
		arc segments and pie shaped wedges. Thanks to: 
		Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
	-------------------------------------------------------------*/
	private function drawArc(x:Number, y:Number, startAngle:Number,
							   arc:Number, radius:Number):void {
				
		// ==============
		// drawArc() - by Ric Ewing (ric@formequalsfunction.com) - version 1.5 - 4.7.2002
		// 
		// x, y = This must be the current pen position... other values will look bad
		// radius = radius of Arc. If [optional] yRadius is defined, then r is the x radius
		// arc = sweep of the arc. Negative values draw clockwise.
		// startAngle = starting angle in degrees.
		// yRadius = [optional] y radius of arc. Thanks to Robert Penner for the idea.
		// ==============
		// Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
		// ==============
		
		// if yRadius is undefined, yRadius = radius
		var yRadius:Number = arguments[5];
		if (isNaN(yRadius)) {
			yRadius = radius;
		}
		// Init vars
		var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number;
		var ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
		// no sense in drawing more than is needed :)
		if (Math.abs(arc)>360) {
			arc = 360;
		}
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil(Math.abs(arc)/45);
		// Now calculate the sweep of each segment
		segAngle = arc/segs;		
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians. 
		theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		angle = -(startAngle/180)*Math.PI;
		if(this.type == "CHORD" || this.type == "OPEN") {			
			// find our starting points (ax,ay) relative to the secified x,y
			ax = x-Math.cos(angle)*radius;
			ay = y-Math.sin(angle)*yRadius;
		}
		// if our arc is larger than 45 degrees, draw as 45 degree segments
		// so that we match Flash's native circle routines.
		if (segs>0) {			
			if(this.type == "PIE") {
				// draw a line from the center to the start of the curve
				ax = x+Math.cos(startAngle/180*Math.PI)*radius;
				ay = y+Math.sin(-startAngle/180*Math.PI)*yRadius;
				this.mc.graphics.lineTo(ax, ay);			
				ax = x;
				ay = y;
			} 
			// Loop for drawing arc segments
			var i:Number;
			for(i = 0; i<segs; i++) {
				// increment our angle
				angle += theta;
				// find the angle halfway between the last angle and the new
				angleMid = angle-(theta/2);

				// calculate our end point
				bx = ax+Math.cos(angle)*radius;
				by = ay+Math.sin(angle)*yRadius;
				// calculate our control point
				cx = ax+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = ay+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));				
	
				// draw the arc segment
				this.mc.graphics.curveTo(cx, cy, bx, by);
			}
			// close the wedge by drawing a line to the center. 
			// Draw transparent for open arc.
			if(this.type == "OPEN") {				
				this.mc.graphics.lineStyle(0,0,0);
				this.mc.graphics.lineTo(x, y);
				this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
			} else {
				this.mc.graphics.lineTo(x, y);
			}			
		}
		// In the native draw methods the user must specify the end point
		// which means that they always know where they are ending at, but
		// here the endpoint is unknown unless the user calculates it on their 
		// own. Lets be nice and let save them the hassle by passing it back. 
		//return {x:bx, y:by};
	}
}
}