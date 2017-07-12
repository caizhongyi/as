package de.alex_uhlmann.animationpackage.animation {

import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import flash.filters.BitmapFilter;

/*
* @class Filter
* @author Alex Uhlmann
* @description  Base class for all filter classes.
* 			<p>
*/
public class Filter extends AnimationCore {
	

	public var filterIndex:Number;
	public var filters:Array;
	
	private var initialized:Boolean = false;
	protected var myInstances:Array;
	protected var hasStartValues:Boolean = false;

	public function Filter() {
		super();
	}
			
	protected function addFilter(filter:BitmapFilter):void {				
		if(hasFilters(this.mc.filters)) {			
			this.addToEnd(filter);
		} else {
			this.createFilters(filter);
		}		
		this.filters.push(filter);
	}
	
	protected function warnOfFilterOverwrite(filterIndex:Number):void {
		trace("Warning: de.alex_uhlmann.animationpackage.animation."+this+": "
				+"Element "+filterIndex+" of "+this.mc+".filters will be overwritten.");		
	}		

	private function addToEnd(filter:BitmapFilter):void {
		this.filters = this.mc.filters;
		this.filterIndex = this.filters.length;
	}
	
	private function createFilters(filter:BitmapFilter):void {
		this.filters = new Array();
		this.filterIndex = 0;
	}
	
	private function hasFilters(filters:Array):Boolean {
		return (filters.length > 0);
	}
}
}