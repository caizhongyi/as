package de.alex_uhlmann.animationpackage.animation {
	
import de.alex_uhlmann.animationpackage.utility.Animator;

import flash.filters.BevelFilter;
import flash.filters.BitmapFilter;

public class Bevel extends Filter implements IMultiAnimatable {

	public var filter:BevelFilter;
	private var m_highlightColor:Number = 0xFFFFFF;
	private var m_shadowColor:Number = 0x000000;
	private var m_quality:Number = 1;
	private var m_type:String = "inner";
	private var m_knockout:Boolean = false;

	public function Bevel(...arguments:Array) {
		if(arguments[0] is Array) {
			this.mcs = arguments[0];
		} else {
			this.mc = arguments[0];
		}
		arguments.shift();
		this.init.apply(this, arguments);
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

	override public function setStartValues(startValues:Array, optional:Boolean = false):Boolean {
		this.hasStartValues = optional ? false : true;
		
		if(startValues[0] == null) {
			startValues[0] = createEmptyFilter();
		}
		if(startValues[0] is BevelFilter) {			
			var filter:BevelFilter = startValues[0];
			
			if(this.hasStartValues) {
				this.setNonAnimatedProperties(filter);
			}
			
			return super.setStartValues([filter.distance, filter.angle, 
										filter.highlightAlpha, filter.shadowAlpha, 
										filter.blurX, filter.blurY, 
										filter.strength], optional);	
		} else {
			return super.setStartValues(startValues, optional);
		}
	}
	
	override public function setEndValues(endValues:Array):Boolean {
		if(endValues[0] == null) {
			endValues[0] = createEmptyFilter();
		}
		if(endValues[0] is BevelFilter) {
			
			var filter:BevelFilter = endValues[0];
			this.setNonAnimatedProperties(filter);
			
			return super.setEndValues([filter.distance, filter.angle, 
										filter.highlightAlpha, filter.shadowAlpha, 
										filter.blurX, filter.blurY, 
										filter.strength]);		
		} else {
			return super.setEndValues(endValues);
		}

	}
	
	private function init(...arguments:Array):void {
		if(isNaN(arguments[0])) {
			arguments.unshift(null);
		}
		if(arguments[1] is Array) {
			var values:Array = arguments[1];
			var endValues:Array = values.slice(-1);
			arguments.splice(1, 1, endValues[0]);
			this.initAnimation.apply(this, arguments);
			this.setStartValues([values[0]]);
		} else {
			this.initAnimation.apply(this, arguments);
		}
	}
	
	private function initAnimation(...arguments:Array):void {
		if(arguments.length > 2) {
			this.animationStyle(arguments[2], arguments[3]);
		} else {			
			this.animationStyle(this.duration, this.easing);
		}	
		
		this.initializeFilter(arguments[0], arguments[1]);
		
		this.setStartValues([this.filter], true);
		this.setEndValues([arguments[1]]);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = this.getEndValues();
		if(this.mc != null) {
			this.initSingleMC();			
		} else {			
			this.initMultiMC();			
		}
		
		if(!isNaN(end)) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(start);
		}

		this.startInitialized = false;
	}
	
	private function initializeFilter(filterIndex:Number, filterEnd:BevelFilter):void {		
		if(this.mc != null) {	
			
			if(isNaN(filterIndex)) {				
				
				this.filter = this.createEmptyFilter();
				this.addFilter(this.filter);
				
			} else {			
				
				//if no filter of correct type is found at filterIndex, 
				//a new filter will be created.
				this.modifyOrCreateFilter(filterIndex);
			}
			
		} else {
			
			this.filterIndex = filterIndex;
			this.filter = filterEnd;
			
		}
	}	
	
	private function modifyOrCreateFilter(filterIndex:Number):void {		
		this.filter = BevelFilter(this.findFilter(filterIndex));
		this.filters = this.mc.filters;
		this.filterIndex = filterIndex;
	}
	
	private function findFilter(filterIndex:Number):BitmapFilter {
		var filter:BitmapFilter = this.mc.filters[filterIndex];
		
		var isOfCorrectType:Boolean = this.isFilterOfCorrectType(filter);
		
		if(!isOfCorrectType && filter != null) {
			this.warnOfFilterOverwrite(filterIndex);
		}
		
		if(filter == null || !isOfCorrectType) {
			filter = this.createEmptyFilter();
		}
		return filter;
	}

	private function isFilterOfCorrectType(filter:BitmapFilter):Boolean {
		return (filter is BevelFilter == true);
	}
	
	private function createEmptyFilter():BevelFilter {
		var filter:BevelFilter = new BevelFilter();
		filter.distance = 0;
		filter.angle = 0;
		filter.highlightAlpha = 100;
		filter.shadowAlpha = 100;
		filter.blurX = 0;
		filter.blurY = 0;
		filter.strength = 0;
		return filter;
	}
	
	private function initSingleMC():void {
		this.myAnimator.start = this.getStartValues();
		
		if(this.getOptimizationMode() 
			&& this.myAnimator.hasEquivalents()) {
				
			this.myAnimator.setter = [[this,"setDistance"],
								[this,"setAngle"],
								[this,"setHighlightAlpha"],
								[this,"setShadowAlpha"],
								[this,"setBlurX"],
								[this,"setBlurY"],
								[this,"setStrength"]];							
		} else {				
			this.myAnimator.setter = [[this,"setBevel"]];	
		}
	}
	
	private function initMultiMC():void {
		var myInstances:Array = [];			
		var len:Number = this.mcs.length;
		var mcs:Array = this.mcs;
		var i:Number = len;
		while(--i>-1) {
			myInstances[i] = new Bevel(mcs[i],this.filterIndex,this.filter);			
			var filter:BevelFilter = this.updateFilter(createEmptyFilter());
			myInstances[i].setNonAnimatedProperties(filter);
		}
		this.myInstances = myInstances;

		this.myAnimator.multiStart = ["getMultiDistanceValue","getMultiAngleValue",
									"getMultiHighlightAlphaValue","getMultiShadowAlphaValue",
									"getMultiBlurXValue","getMultiBlurYValue",
									"getMultiStrengthValue"];
									
		this.myAnimator.multiSetter = [[this.myInstances,"setDistance"],
									[this.myInstances,"setAngle"],
									[this.myInstances,"setHighlightAlpha"],
									[this.myInstances,"setShadowAlpha"],
									[this.myInstances,"setBlurX"],
									[this.myInstances,"setBlurY"],
									[this.myInstances,"setStrength"]];	

	}
	
	private function updateFilter(filter:BevelFilter):BevelFilter {		
		filter.highlightColor = this.m_highlightColor;
		filter.shadowColor = this.m_shadowColor;
		filter.quality = this.m_quality;
		filter.type = this.m_type;
		filter.knockout = this.m_knockout;
		return filter;
	}	
	
	private function updateProperties(filter:BitmapFilter):void {
		this.filter = updateFilter(BevelFilter(filter));		
		this.setStartValues([this.filter], true);		
	}
	
	private function setNonAnimatedProperties(filter:BevelFilter):void {
		this.highlightColor = filter.highlightColor;
		this.shadowColor = filter.shadowColor;
		this.quality = filter.quality;
		this.type = filter.type;
		this.knockout = filter.knockout;		
	}
	
	public function getMultiDistanceValue():Number {
		return this.filter.distance;
	}
	
	public function getMultiAngleValue():Number {
		return this.filter.angle;
	}
	
	public function getMultiHighlightAlphaValue():Number {
		return this.filter.highlightAlpha;
	}
	
	public function getMultiShadowAlphaValue():Number {
		return this.filter.shadowAlpha;
	}
	
	public function getMultiBlurXValue():Number {
		return this.filter.blurX;
	}
	
	public function getMultiBlurYValue():Number {
		return this.filter.blurY;
	}
	
	public function getMultiStrengthValue():Number {
		return this.filter.strength;
	}	
		
	public function setBevel(distance:Number, angle:Number, 
							highlightAlpha:Number, shadowAlpha:Number, 
							blurX:Number, blurY:Number, strength:Number):void {

		this.filter.distance = distance;
		this.filter.angle = angle;
		this.filter.highlightAlpha = highlightAlpha;
		this.filter.shadowAlpha = shadowAlpha;
		this.filter.blurX = blurX;
		this.filter.blurY = blurY;
		this.filter.strength = strength;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;	
	}

	public function setDistance(distance:Number):void {		
		this.filter.distance = distance;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}	

	public function setAngle(angle:Number):void {		
		this.filter.angle = angle;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}	
	
	public function setHighlightAlpha(highlightAlpha:Number):void{		
		this.filter.highlightAlpha = highlightAlpha;		
		this.mc.filters = [this.filter];
	}
	
	public function setShadowAlpha(shadowAlpha:Number):void {		
		this.filter.shadowAlpha = shadowAlpha;		
		this.mc.filters = [this.filter];
	}	

	public function setBlurX(blurX:Number):void {		
		this.filter.blurX = blurX;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function setBlurY(blurY:Number):void {		
		this.filter.blurY = blurY;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function setStrength(strength:Number):void {		
		this.filter.strength = strength;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function get highlightColor():Number {
		return this.m_highlightColor;
	}
	
	public function set highlightColor(highlightColor:Number):void {
		this.filter.highlightColor = highlightColor;
		this.m_highlightColor = highlightColor;
	}
	
	public function get shadowColor():Number {
		return this.m_shadowColor;
	}
	
	public function set shadowColor(shadowColor:Number):void {
		this.filter.shadowColor = shadowColor;
		this.m_shadowColor = shadowColor;
	}
	
	public function get quality():Number {
		return this.m_quality;
	}
	
	public function set quality(quality:Number):void {
		this.filter.quality = quality;
		this.m_quality = quality;
	}
	
	public function get type():String {
		return this.m_type;
	}
	
	public function set type(type:String):void {
		this.filter.type = type;
		this.m_type = type;
	}
	
	public function get knockout():Boolean {
		return this.m_knockout;
	}
	
	public function set knockout(knockout:Boolean):void {
		this.filter.knockout = knockout;
		this.m_knockout = knockout;
	}
}
}