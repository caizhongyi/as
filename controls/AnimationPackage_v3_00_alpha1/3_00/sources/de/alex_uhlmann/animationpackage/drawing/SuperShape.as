package de.alex_uhlmann.animationpackage.drawing {
	
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

import flash.display.Sprite;

public class SuperShape	extends Shape implements ISingleAnimatable, IMultiAnimatable {

	public static var m_def:Number = 4;
	public static var n1_def:Number = 1;
	public static var n2_def:Number = 1;
	public static var n3_def:Number = 1;
	public static var range_def:Number = 12;
	public static var scaling_def:Number = 200;
	public static var detail_def:Number = 10000;
	private var x:Number = 0;
	private var y:Number = 0;
	private var m_m:Number;
	private var m_n1:Number;
	private var m_n2:Number;
	private var m_n3:Number;
	private var m_range:Number;
	private var m_scaling:Number;
	private var m_detail:Number;
	private var presets:Object;
	private var forward:Boolean = true;
	private var redrawBool:Boolean = true;
	private var counter:Number;
	private var counterMax:Number;
	private var multipleValues:Boolean = false;
	/* if true, shape gets drawn from the center.*/
	private var m_animateFromCenter:Boolean = false;
	/*points already calculated by getPointsOnCurve*/
	private var calculatedPoints:Array;

	public function SuperShape(...arguments:Array) {
		super();
		this.init.apply(this,arguments);
		this.fillStyle(NaN);
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

		this.initPresets();
		this.initParams.apply(this,arguments.slice(2));
	}

	private function initPresets():void {
		this.presets = new Object();
		this.addPreset({label:"circle", data:{m:0, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"square", data:{m:4, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"triangle", data:{m:3, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"burst", data:{m:5, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"radioactive", data:{m:3, n1:10000, n2:9999, n3:9999, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"windmill", data:{m:15, n1:10000, n2:9000, n3:9000, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"drop", data:{m:1 / 6, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
		this.addPreset({label:"star3peaks", data:{m:3, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
		this.addPreset({label:"star4peaks", data:{m:4, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
		this.addPreset({label:"star5peaks", data:{m:5, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
	}

	private function initParams(...arguments:Array):void {
		
		this.m_m = (isNaN(arguments[0])) ? SuperShape.m_def : arguments[0];
		this.m_n1 = (isNaN(arguments[1])) ? SuperShape.n1_def : arguments[1];
		this.m_n2 = (isNaN(arguments[2])) ? SuperShape.n2_def : arguments[2];
		this.m_n3 = (isNaN(arguments[3])) ? SuperShape.n3_def : arguments[3];
		this.m_range = (isNaN(arguments[4])) ? SuperShape.range_def : arguments[4];
		this.m_scaling = (isNaN(arguments[5])) ? SuperShape.scaling_def : arguments[5];
		this.m_detail = (isNaN(arguments[6])) ? SuperShape.detail_def : arguments[6];
	}
				
	public function draw():void {
		var start:Number = arguments[0];
		var end:Number = arguments[1];
		this.redrawBool = false;
		if(isNaN(start) && isNaN(end)) {
			start = 0;
			end = 100;
		}
		var endDetail:Number = end / 100 * this.m_detail;
		if(start > end) {
			this.forward = false;
		} else {
			this.forward = true;
		}
		this.calculatedPoints = new Array();
		this.drawNewShape(endDetail);
	}
	
	public function run(...arguments:Array):void {
		this.init.apply(this, arguments);
		this.invokeAnimation(0, 100);
	}	

	/*
	* redraws the shape in each iteration like every animated shape in AnimationPackage.
	* Bounce, Elastic and Back Easing is possible. Due to the complex operations for the superformula
	* this can be very slow.
	*/
	public function animate(start:Number, end:Number):void {
		this.redrawBool = true;
		this.invokeAnimation(start, end);
	}
	
	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}	

	public function animateProps(propArr:Array, endArr:Array):void {
		this.calculatedPoints = new Array();
		this.myAnimator = new Animator();
		this.myAnimator.animationStyle(this.duration, this.easing);
		this.myAnimator.caller = this;
		var startArr:Array = new Array();
		var setterArr:Array = new Array();
		var i:Number = propArr.length;
		while(--i>-1) {
			startArr.push(this[propArr[i]]);
			setterArr.push(new Array(this,"a_"+propArr[i]));
		}
		this.counter = 0;
		this.counterMax = startArr.length;
		if(this.counterMax > 1) {
			this.multipleValues = true;
			this.setStartValues(startArr);
			this.setEndValues(endArr);
		} else {
			this.multipleValues = false;
			this.setStartValue(startArr[0]);
			this.setEndValue(endArr[0]);
		}
		this.myAnimator.start = startArr;
		this.myAnimator.end = endArr;
		this.myAnimator.setter = setterArr;
		this.myAnimator.run();
	}

	public function a_m(v:Number):void {
		this.m_m = v;
		this.collect();
	}
	public function a_n1(v:Number):void {
		this.m_n1 = v;
		this.collect();
	}
	public function a_n2(v:Number):void {
		this.m_n2 = v;
		this.collect();
	}
	public function a_n3(v:Number):void {
		this.m_n3 = v;
		this.collect();
	}
	public function a_range(v:Number):void {
		this.m_range = v;
		this.collect();
	}
	public function a_scaling(v:Number):void {
		this.m_scaling = v;
		this.collect();
	}
	public function a_detail(v:Number):void {
		this.m_detail = v;
		this.collect();
	}

	private function collect():void {
		this.counter++;
		if(this.counter == this.counterMax) {
			this.counter = 0;			
			this.drawNewShape(this.m_detail);
		}
	}	

	public function morph(presetStart:String, presetEnd:String):void {
		this.calculatedPoints = new Array();
		var p1:Object = this.presets[presetStart];
		var p2:Object = this.presets[presetEnd];
		this.initParams(p1.m, p1.n1, p1.n2, p1.n3, p1.range, p1.scaling, p1.detail);
		this.myAnimator = new Animator();
		this.myAnimator.animationStyle(this.duration, this.easing);
		this.myAnimator.caller = this;
		var startArr:Array = new Array();
		var endArr:Array = new Array();
		var setterArr:Array = new Array();
		/*determine difference between preset shapes and animate with Animator.*/
		if(p1.m != p2.m) {
			startArr.push(p1.m);
			endArr.push(p2.m);
			setterArr.push(new Array(this,"a_m"));
		}
		if(p1.n1 != p2.n1) {
			startArr.push(p1.n1);
			endArr.push(p2.n1);
			setterArr.push(new Array(this,"a_n1"));
		}
		if(p1.n2 != p2.n2) {
			startArr.push(p1.n2);
			endArr.push(p2.n2);
			setterArr.push(new Array(this,"a_n2"));
		}
		if(p1.n3 != p2.n3) {
			startArr.push(p1.n3);
			endArr.push(p2.n3);
			setterArr.push(new Array(this,"a_n3"));
		}
		if(p1.range != p2.range) {
			startArr.push(p1.range);
			endArr.push(p2.range);
			setterArr.push([this,"a_range"]);
		}
		if(p1.scaling != p2.scaling) {
			startArr.push(p1.scaling);
			endArr.push(p2.scaling);
			setterArr.push([this,"a_scaling"]);
		}
		if(p1.detail != p2.detail) {
			startArr.push(p1.detail);
			endArr.push(p2.detail);
			setterArr.push([this,"a_detail"]);
		}
		this.counter = 0;
		this.counterMax = startArr.length;
		if(this.counterMax > 1) {
			this.multipleValues = true;
			this.setStartValues(startArr);
			this.setEndValues(endArr);
		} else {
			this.multipleValues = false;
			this.setStartValue(startArr[0]);
			this.setEndValue(endArr[0]);
		}
		this.myAnimator.start = startArr;
		this.myAnimator.end = endArr;
		this.myAnimator.setter = setterArr;
		this.myAnimator.run();
	}

	public function addPreset(item:Object):void {
		if(this.presets[item.label] != null) {
			trace("Preset "+this.presets[item.label]+" overwritten!");
		}
		this.presets[item.label] = item.data;
	}

	public function getPreset(preset:String):Object {
		if(preset != null) {
			return this.presets[preset];
		}
		return this.presets;
	}

	public function setPreset(preset:String):void {
		var p:Object = this.presets[preset];
		this.initParams(p.m, p.n1, p.n2, p.n3, p.range, p.scaling, p.detail);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
		this.startInitialized = false;
		
		this.calculatedPoints = new Array();
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		var startDetail:Number = 0;
		this.myAnimator.start = [startDetail];
		this.setStartValue(startDetail);
		this.multipleValues = false;
		var endDetail:Number = this.m_detail;
		if(start > end) {
			this.forward = false;
		} else {
			this.forward = true;
		}
		this.myAnimator.end = [endDetail];
		this.setEndValue(endDetail);
		this.myAnimator.setter = [[this,"drawNewShape"]];
		if(!isNaN(end)) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(start);
		}
	}
	
	public function drawNewShape(s:Number):void {
		this.clearDrawing();
		if(!isNaN(this.fillRGB) && this.fillGradient == false) {	
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
		this.drawShape(s);
		this.mc.graphics.endFill();
	}
	
	/* Optimized, less readable code.*/
	private function drawShape(s:Number):void {
		var mc:Sprite = this.mc;
		var m:Number = this.m_m;
		var n1:Number = this.m_n1;
		var n2:Number = this.m_n2;
		var n3:Number = this.m_n3;
		var ra:Number = this.m_range;
		var sc:Number = this.m_scaling * 90;
		var d:Number = this.m_detail;
		if(isNaN(s)) {
			s = d;
		}
		var phi:Number;
		var pi:Number = Math.PI;
		/*
		* getPoint() variables. To improve performance, 
		* the implementation of getPoint() is also included in drawShape, 
		* saving another function call in loops.
		*/
		var r:Number;
		var x:Number, y:Number;
		var cos:Function = Math.cos;
		var sin:Function = Math.sin;
		var pow:Function = Math.pow;
		var abs:Function = Math.abs;		
		var p:Number;
		var q:Object;
		//cache
		var calc:Array = this.calculatedPoints;
		/*calculate starting point if not animated from center*/				
		if(this.animateFromCenter == false) {			
			var pos1:Object = this.getPoint(m, n1, n2, n3, 0);
			mc.graphics.moveTo(pos1.x * sc, pos1.y * sc);
		}
		var i:Number;
		if(this.forward) {
			for(i = 0; i <= s; i++) {
				if(isNaN(calc[i])) {
					phi = ra * pi * (i / d);				
					p = m * phi / 4;		
					r = pow(pow(abs(cos(p) / 1), n2) -(-pow(abs(sin(p) / 1), n3)), 1 / n1);
					if (r == 0) {
						x = y = 0;
					}
					else {
						r = 1 / r;
						x = r * cos(phi) * sc;
						y = r * sin(phi) * sc;
					}
					q = calc[i] = {x:x, y:y};
				} else {
					q = calc[i];
				}
				mc.graphics.lineTo(q.x, q.y);
			}
		} else {
			i = s;
			while(--i>-1) {
				if(isNaN(calc[i])) {
					phi = ra * pi * (i / d);				
					p = m * phi / 4;		
					r = pow(pow(abs(cos(p) / 1), n2) -(-pow(abs(sin(p) / 1), n3)), 1 / n1);
					if (r == 0) {
						x = y = 0;			
					}
					else {
						r = 1 / r;
						x = r * cos(phi) * sc;
						y = r * sin(phi) * sc;
					}
					q = calc[i] = {x:x, y:y};
				} else {
					q = calc[i];
				}		
				mc.graphics.lineTo(q.x, q.y);
			}
		}	
	}
	
	/* Optimized, less readable code.*/
	private function getPoint(m:Number, n1:Number, n2:Number, n3:Number, phi:Number):Object {		
		var r:Number;		
		var x:Number, y:Number;
		var cos:Function = Math.cos;
		var sin:Function = Math.sin;
		var pow:Function = Math.pow;
		var abs:Function = Math.abs;		
		var p:Number;
		p = m * phi / 4;		
		r = pow(pow(abs(cos(p) / 1), n2) -(-pow(abs(sin(p) / 1), n3)), 1 / n1);
		if (r == 0) {
			x = y = 0;			
		}
		else {
			r = 1 / r;
			x = r * cos(phi);
			y = r * sin(phi);
		}		
		return {x:x, y:y};
	}
	
	/*getter / setter*/
	public function get m():Number {
		return this.m_m;
	}

	public function set m(m:Number):void {
		this.m_m = m;
	}

	public function get n1():Number {
		return this.m_n1;
	}

	public function set n1(n1:Number):void {
		this.m_n1 = n1;
	}

	public function get n2():Number {
		return this.m_n2;
	}

	public function set n2(n2:Number):void {
		this.m_n2 = n2;
	}

	public function get n3():Number {
		return this.m_n3;
	}

	public function set n3(n3:Number):void {
		this.m_n3 = n3;
	}

	public function get range():Number {
		return this.m_range;
	}

	public function set range(range:Number):void {
		this.m_range = range;
	}

	public function get scaling():Number {
		return this.m_scaling;
	}

	public function set scaling(scaling:Number):void {
		this.m_scaling = scaling;
	}

	public function get detail():Number {
		return this.m_detail;
	}

	public function set detail(detail:Number):void {
		this.m_detail = detail;
	}	
	
	public function get animateFromCenter():Boolean {
		return this.m_animateFromCenter;
	}

	public function set animateFromCenter(bool:Boolean):void {
		this.m_animateFromCenter = bool;
	}	
	
	override public function getStartValue():Number {		
		return 0;
	}
	
	override public function getEndValue():Number {		
		return 100;
	}
	
	override public function getCurrentValue():Number {
		var start:Number;
		var end:Number;
		var current:Number;		
		var multipleValues:Boolean;
		
		if(this.multipleValues) {
			start = super.getStartValues()[0];
			end = super.getEndValues()[0];
			current = super.getCurrentValues()[0];
		} else {
			start = super.getStartValue();
			end = super.getEndValue();
			current = super.getCurrentValue();
		}
		if(start < end) {				
			return (current - start) / (end - start) * 100;
		} else {
			return 100 - ((current - end) / (start - end) * 100);
		}
	}
}
}