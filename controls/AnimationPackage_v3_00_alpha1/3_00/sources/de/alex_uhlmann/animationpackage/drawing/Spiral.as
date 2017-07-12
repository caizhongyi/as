package de.alex_uhlmann.animationpackage.drawing {

import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

import flash.display.Sprite;

public class Spiral extends Shape implements IDrawable, ISingleAnimatable {
	
	public static var xRadius_def:Number = 0;
	public static var yRadius_def:Number = 0;
	public static var xGrowth_def:Number = 9;
	public static var yGrowth_def:Number = 9;
	public static var startAngle_def:Number = 0;
	public static var revolutions_def:Number = 9;
	private var x:Number = 0;
	private var y:Number = 0;	
	private var xRadius:Number;
	private var xGrowth:Number;
	private var yRadius:Number;
	private var yGrowth:Number;
	private var startAngle:Number;
	private var revolutions:Number;	
	
	/*startAngle doesn't seem to have any effect on the spiral*/
	public function Spiral(...arguments:Array) {
		super();
		this.init.apply(this,arguments);
		this.lineStyle(NaN);
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
	
		this.xRadius = (isNaN(arguments[2])) ? Spiral.xRadius_def : arguments[2];
		this.yRadius = (isNaN(arguments[3])) ? Spiral.yRadius_def : arguments[3];		
		this.xGrowth = (isNaN(arguments[4])) ? Spiral.xGrowth_def : arguments[4];
		this.yGrowth = (isNaN(arguments[5])) ? Spiral.yGrowth_def : arguments[5];	
		this.startAngle = (isNaN(arguments[6])) ? Spiral.startAngle_def : arguments[6];
		this.revolutions = (isNaN(arguments[7])) ? Spiral.revolutions_def : arguments[7];
		this.setStartValue(this.startAngle);
		this.setEndValue(this.revolutions);	
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
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
		this.startAngle = startValue;
		return super.setStartValue(startValue);
	}
	
	override public function setEndValue(endValue:Number):Boolean {
		this.revolutions = endValue;
		return super.setEndValue(endValue);
	}
	
	public function setRadius(xRadius:Number, yRadius:Number):void {	
		this.xRadius = xRadius;
		this.yRadius = yRadius;		
	}

	public function getGrowth():Object {
		return { x:this.xGrowth, y:this.yGrowth };	
	}
	
	public function setGrowth(xGrowth:Number, yGrowth:Number):void {	
		this.xGrowth = xGrowth;
		this.yGrowth = yGrowth;		
	}
	
	public function getStartAngle():Number {
		return this.startAngle;		
	}

	public function setStartAngle(startAngle:Number):void {
		this.startAngle = startAngle;
		this.setStartValue(startAngle);
	}	
	
	public function getRevolutions():Number {
		return this.revolutions;		
	}
	
	public function setRevolutions(revolutions:Number):void {
		this.revolutions = revolutions;
		this.setEndValue(revolutions);
	}
	
	public function drawShape(v:Number):void {
		this.clearDrawing();
		this.revolutions = v;
		this.drawNew();
	}
	
	private function drawNew():void {	
		this.mc.graphics.moveTo(this.x, this.y);
		this.drawSpiral(this.x, this.y, this.startAngle, this.revolutions, 
						this.xRadius, this.xGrowth, this.yRadius, this.yGrowth);
	}
	
	/* *** MovieClip.drawSpiral *********************************************************************************
	 ************************************************************************************************************
	 **  PURPOSE:	a method for drawing regular and elliptical spirals (non-logarithmic). This method was 
	 **				inspired by an afternoon (ok, a whole freakin' day)	spent with a number of advanced 
	 **				drawing API methods written by Ric Ewing (ric@ricewing.com). Ric's code is available here:
	 **
	 **						http://www.macromedia.com/devnet/mx/flash/articles/adv_draw_methods.html
	 **
	 **				I have changed my code somewhat so that it will blend in reasonably well with Ric's methods.
	 **				Thanks to Ric for the inspiration.
	 **
	 **  NOTE:		I REALLY wanted to do this with fewer segments per revolution (e.g. the usual 8) using curveTo
	 **				instead of lineTo, but I was unable to figure out how to determine the control points 
	 **				correctly. If anyone can clue me in on the required math, I will update this method and give 
	 **				you due credit and boundless gratitude. Enjoy.  ---jim
	 **	
	 **	 REQUIRED PARAMETERS:
	 **
	 **		x, y	    -- center point for the spiral
	 **		startAngle  -- starting angle in degrees. a value of 0 starts rendering at (x,y)
	 **		revolutions -- number of complete cycles in final spiral
	 **		xRadius		-- radius for x-axis in pixels
	 **		xGrowth	    -- number of pixels added to xRadius with each complete revolution
	 **
	 **	 OPTIONAL PARAMETERS: ( will be set identical to x-values if not included )
	 **
	 **		yRadius     -- radius for y-axis in pixels
	 **		yGrowth	    -- number of pixels added to xRadius with each complete revolution
	 **
	 **
	 **	 BY::::::::::::::::::::james w. bennett iii ( snowballs.chance@hell.com ) -- version 1.0 -- march2003
	 **
	 ******/
	private function drawSpiral(x:Number, y:Number, startAngle:Number, revolutions:Number, 
								xRadius:Number, xGrowth:Number, yRadius:Number, yGrowth:Number):void {
		
		// drawing resolution. STEP_SIZE = 6 yields 60 linesegments per revolution
		var STEP_SIZE:Number = 6; 	// in degrees
		
		// if y-axis information not included, set identical to x-axis
		if ( isNaN(yRadius) )
		{
			yRadius = xRadius;
			yGrowth = xGrowth;
		}
		else if ( isNaN(yGrowth) )
		{
			yGrowth = xGrowth;
		}
	
	
		// reverse the signs in order to reverse directions
		if ( revolutions < 0 )
		{
			STEP_SIZE  = -STEP_SIZE;
			startAngle = -startAngle;
		}
	
		// initialize variables
		var startRadians:Number, currentRadians:Number, endRadians:Number;
		var xRadiusDelta:Number, yRadiusDelta:Number;
		var stepsPerRevolution:Number;
		var ax:Number, ay:Number;
		var bx:Number, by:Number;		
		// convert angles from degrees to radians
		startRadians = -(startAngle / 180) * Math.PI;
		endRadians   = -((revolutions * 360) / 180) * Math.PI;
		var theta:Number        = -(STEP_SIZE   / 180) * Math.PI;
		
		// calculate step size
		stepsPerRevolution = Math.abs((2 * Math.PI) / theta);
		
		// calculate pixel-growth per step
		xRadiusDelta = xGrowth / stepsPerRevolution;
		yRadiusDelta = yGrowth / stepsPerRevolution;
		
		// get the starting point and ... 
		ax = x + xRadius * Math.cos( startRadians );
		ay = y + yRadius * Math.sin( startRadians );
		
		// ... move there
		this.mc.graphics.moveTo( ax, ay );
		
		// advance angle by one step (theta)
		currentRadians = startRadians + theta;
		
		// draw it
		while( Math.abs(currentRadians) < Math.abs(endRadians) )
		{
			// calculate the next point
			bx = x + xRadius * Math.cos( currentRadians );
			by = y + yRadius * Math.sin( currentRadians );
			
			// draw the line to it
			this.mc.graphics.lineTo( bx, by );
			
			// advance the angle
			currentRadians += theta;
			
			// increase the radius
			xRadius += xRadiusDelta;
			yRadius += yRadiusDelta;
		}
	}
	
	public function setRegistrationPoint(registrationObj:Object):void {
		if(registrationObj.position == "CENTER") {		
			this.x = 0;
			this.y = 0;
		} else {	
			this.x = (this.revolutions * this.xGrowth) + registrationObj.x;
			this.y = (this.revolutions * this.yGrowth) + registrationObj.y;			
		}
	}
}
}