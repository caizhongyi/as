package de.alex_uhlmann.animationpackage.drawing {
	
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.IOutline;
import de.alex_uhlmann.animationpackage.drawing.Line;

import flash.display.Sprite;
import flash.geom.Point;

public class DashLine extends Line implements IDrawable, IOutline, ISingleAnimatable {	

	public static var len_def:Number = 8;
	public static var gap_def:Number = 8;	
	private var len:Number;
	private var gap:Number;	
	
	public function DashLine(...arguments:Array) {
		super(false);
		this.init.apply(this, arguments);
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
		this.mc = this.createClip({mc:arguments[0], x:0, y:0});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(...arguments:Array):void {		
		
		this.mc = this.createClip({name:"apDraw", x:0, y:0});		
		this.initShape.apply(this,arguments);
	}
		
	override protected function initShape(...arguments:Array):void {
		var len:Number = arguments[4];
		var gap:Number = arguments[5];
		this.len = (isNaN(len)) ? DashLine.len_def : len;
		this.gap = (isNaN(gap)) ? DashLine.gap_def : gap;
		super.initShape(arguments[0], arguments[1], arguments[2], arguments[3]);		
	}
	
	override public function draw():void {
		this.setInitialized(false);
		this.setDefaultRegistrationPoint({position:"CENTER"});
		this.clearDrawing();
		this.mc.graphics.moveTo(this.x1, this.y1);
		this.drawNewPoint(this.x2, this.y2);		
	}
	
	override public function drawLine(v:Number):void {
		var p:Point = this.getPointsOnLine(v);		
		this.clearDrawing();			
		this.drawNewPoint(p.x, p.y);
	}	
	
	public function drawNewPoint(x2:Number, y2:Number):void {	
		this.dashTo(this.x1, this.y1, x2, y2);
		this.penX = x2;
		this.penY = y2;		
	}
	
	/*-------------------------------------------------------------
	mc.dashTo is a metod for drawing dashed (and dotted) 
	lines. I made this to extend the lineTo function because it
	doesnÕt have the cutom line types that the in program
	line tool has. To make a dotted line, specify a dash length
	between .5 and 1.
	-------------------------------------------------------------*/
	private function dashTo(startx:Number, starty:Number, 
							endx:Number, endy:Number):void {
		// ==============
		// mc.dashTo() - by Ric Ewing (ric@formequalsfunction.com) - version 1.2 - 5.3.2002
		// 
		// startx, starty = beginning of dashed line
		// endx, endy = end of dashed line
		// len = length of dash
		// gap = length of gap between dashes
		// ==============
		// init vars
		var seglength:Number, deltax:Number, deltay:Number;
		var segs:Number, cx:Number, cy:Number;
		// calculate the legnth of a segment
		seglength = this.len + this.gap;
		// calculate the length of the dashed line
		deltax = endx - startx;
		deltay = endy - starty;
		var delta:Number = Math.sqrt((deltax * deltax) + (deltay * deltay));
		// calculate the number of segments needed
		segs = Math.floor(Math.abs(delta / seglength));
		// get the angle of the line in radians
		var radians:Number = Math.atan2(deltay,deltax);
		// start the line here
		cx = startx;
		cy = starty;
		// add these to cx, cy to get next seg start
		deltax = Math.cos(radians)*seglength;
		deltay = Math.sin(radians)*seglength;
		// loop through each seg
		var n:Number;
		for (n = 0; n < segs; n++) {
			this.mc.graphics.moveTo(cx,cy);
			this.mc.graphics.lineTo(cx+Math.cos(radians)*this.len,cy+Math.sin(radians)*this.len);
			cx += deltax;
			cy += deltay;
		}
		// handle last segment as it is likely to be partial
		this.mc.graphics.moveTo(cx,cy);
		delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
		if(delta>this.len){
			// segment ends in the gap, so draw a full dash
			this.mc.graphics.lineTo(cx+Math.cos(radians)*this.len,cy+Math.sin(radians)*this.len);
		} else if(delta>0) {
			// segment is shorter than dash so only draw what is needed
			this.mc.graphics.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
		}
		// move the pen to the end position
		this.mc.graphics.moveTo(endx,endy);
	}
}
}