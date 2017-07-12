package de.alex_uhlmann.animationpackage.drawing {
	
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.MoveOnCurve;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

import flash.display.Sprite;
import flash.geom.Point;

public class Curve extends Shape	implements IDrawable, ISingleAnimatable {	

	private var points:Array;
	private var myPoints:Array;
	/*points already calculated by getPointsOnCurve*/
	private var calculatedPoints:Array;
	private var myMoveOnCurve:MoveOnCurve;
	private var x1:Number;
	private var y1:Number;
	private var mode:String = "REDRAW";

	public function Curve(...arguments:Array) {
		super();
		this.init.apply(this,arguments);
		this.lineStyle(NaN);
		this.animationStyle(NaN);
	}
	
	public function run(...arguments:Array):void {
	}

	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}

	private function init(...arguments:Array):void {		
		if(arguments[0] is Sprite) {			
			this.initCustom.apply(this,arguments);
		} else {			
			this.initAuto.apply(this,arguments);
		}			
	}

	private function initCustom(...arguments:Array):void {		
		
		this.mc = this.createClip({mc:arguments[0], x:0, y:0});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(...arguments:Array):void {		
		
		this.mc = this.createClip({name:"apDraw", x:0, y:0});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(points:Array):void {
		
		this.points = points;
		var i:Number = this.points.length;		
		this.myPoints = new Array();
		while(--i>-1) {
			//Copy array by value.			
			this.myPoints[i] = new Point(this.points[i].x, this.points[i].y);
		}
	}

	public function draw():void {
		this.setDefaultRegistrationPoint({position:"CENTER"});
		this.clearDrawing();
		this.mode = "REDRAW";
		this.setCurrentPercentage(100);
	}

	//TODO: include a *real* drawBy method. ( ;
	public function drawBy():void {
		this.mode = "DRAW";
		this.setCurrentPercentage(100);
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
		var setter:String;	
		if(this.mode == "REDRAW") {
			this.setDefaultRegistrationPoint({position:"CENTER"});
			setter = "drawLineCurve";
		} else {
			if(this.lineStyleModified) {
				this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
			}
			setter = "drawLineCurveBy";
		}
		this.setStartValue(0);
		this.setEndValue(100);	
		/*how to continuesly draw a curve. Ask MoveOnCurve.*/
		this.myMoveOnCurve = new MoveOnCurve(null, this.myPoints);		
		this.x1 = this.myPoints[0].x;
		this.y1 = this.myPoints[0].y;			
		
		this.calculatedPoints = new Array();

		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [100];
		this.myAnimator.setter = [[this, setter]];
		if(isGoto == false) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(end);
		}		
	}

	public function animate(start:Number, end:Number):void {
		this.mode = "REDRAW";
		this.invokeAnimation(start, end);
	}

	public function animateBy(start:Number, end:Number):void {	
		this.mode = "DRAW";
		this.invokeAnimation(start, end);
	}

	//clunky and slow. I don't like it. But it does the job.
	public function drawLineCurve(v:Number):void {		
		this.clearDrawing();
		this.mc.graphics.moveTo(this.x1, this.y1);
		var p:Object;
		var calc:Array = this.calculatedPoints;
		var s:Number = this.getStartValue();		
		var len:Number = Math.round(v);
		var i:Number;
		for(i = s; i <= len; i++) {
			if(calc[i] == null) {
				p = calc[i] = this.myMoveOnCurve.getPointsOnCurve(i);
			} else {
				p = calc[i];
			}
			this.mc.graphics.lineTo(p.x, p.y);
		}
	}
	
	public function drawLineCurveBy(v:Number):void {		
		this.mc.graphics.moveTo(this.x1, this.y1);		
		var p:Object;
		var calc:Array = this.calculatedPoints;
		var calcL:Number = this.calculatedPoints.length;		
		var s:Number = this.getStartValue();		
		var len:Number = Math.round(v);
		var i:Number;
		for(i = s; i <= len; i++) {
			if(calc[i] == null) {
				p = calc[i] = this.myMoveOnCurve.getPointsOnCurve(i);
			} else {
				p = calc[i];
			}
			this.mc.graphics.lineTo(p.x, p.y);				
		}
	}	

	public function setRegistrationPoint(registrationObj:Object):void {	
		this.reset();
		/*retrieve boundaries of the curve in order to compute the center for positioning.*/
		var minX:Number = this.getBoundary("x", "min");
		var minY:Number = this.getBoundary("y", "min");
		var maxX:Number = this.getBoundary("x", "max");
		var maxY:Number = this.getBoundary("y", "max");
		
		var centerX:Number;
		var centerY:Number;		
		if(registrationObj.position == "CENTER") {	
			centerX = (maxX - minX) / 2 + minX;
			centerY = (maxY - minY) / 2 + minY;		
		} else if (registrationObj.x != null || registrationObj.y != null) {
			centerX = minX + registrationObj.x;
			centerY = minY + registrationObj.y;		
		} else {
			centerX = 0;
			centerY = 0;
		}
	
		this.mc.x = centerX;
		this.mc.y = centerY;
		
		/*apply center values*/
		var i:Number = this.points.length;		
		this.myPoints = new Array();
		while(--i>-1) {
			//Copy array by value and modify that value.			
			this.myPoints[i] = {x: this.points[i].x, y: this.points[i].y};
			this.myPoints[i].x -= centerX;
			this.myPoints[i].y -= centerY;			
		}
		this.initialized = true;
	}

	private function getBoundary(prop:String, meth:String):Number {
		var i:Number = this.points.length;
		var result:Number = this.points[--i][prop];
		while(--i>-1) {
			var element:Number = this.points[i][prop];
			result = Math[meth](element, result);
		}
		return result;
	}

	private function setDefaultRegistrationPoint(registrationObj:Object):void {		
		
		if(!this.initialized) {			
			this.setRegistrationPoint(registrationObj);			
		}
	}
	
	public function reset():void {
		this.initialized = false;
	}
}
}