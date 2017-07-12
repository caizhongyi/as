package de.alex_uhlmann.animationpackage.drawing {

import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import flash.geom.Matrix;

public class Shape extends AnimationCore {

	public static var lineRGB_def:Number = 0x000000;
	public static var lineAlpha_def:Number = 1;
	public static var linePixelHinting_def:Boolean = false;
	public static var lineScaleMode_def:String = "normal";
	public static var lineCaps_def:String = null;
	public static var lineJoints_def:String = null;
	public static var lineMiterLimit_def:Number = 3;
	public static var fillRGB_def:Number = 0x000000;
	public static var fillAlpha_def:Number = 1;
	private static var m_lineThickness_def:Number = 1;
	private static var lineThickness_defModified:Boolean = false;	
	private static var gradientFillType_def:String;
	private static var gradientColors_def:Array;	
	private static var gradientAlphas_def:Array;
	private static var gradientRatios_def:Array;
	private static var gradientMatrix_def:Matrix;
	private static var gradientSpreadMethod_def:String;
	private static var gradientInterpolationMethod_def:String;
	private static var gradientFocalPointRatio_def:Number;			
	public var penX:Number;
	public var penY:Number;
	protected var initialized:Boolean = false;
	protected var lineStyleModified:Boolean = false;
	
	private var m_lineThickness:Number;
	private var m_lineRGB:Number;
	private var m_lineAlpha:Number;
	private var m_linePixelHinting:Boolean;
	private var m_lineScaleMode:String;
	private var m_lineCaps:String;
	private var m_lineJoints:String;
	private var m_lineMiterLimit:Number;
	
	public var fillRGB:Number;
	public var fillAlpha:Number;
	
	public var fillGradient:Boolean = false;	
	public var gradientFillType:String;
	public var gradientColors:Array;	
	public var gradientAlphas:Array;
	public var gradientRatios:Array;	
	public var gradientMatrix:Matrix;	
	public var gradientSpreadMethod:String;	
	public var gradientInterpolationMethod:String;	
	public var gradientFocalPointRatio:Number;
	
	public function Shape() {		
		super();
	}
	
	public function getPenPosition():Object {
		return {x:this.penX, y:this.penY};
	}
	
	public function setPenPosition(p:Object):void {
		this.penX = p.x;
		this.penY = p.y;
	}
	
	public function lineStyle(thickness:Number = 1.0, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {		
		this.lineStyleModified = true;
		this.m_lineThickness = thickness;	
		this.m_lineRGB = color;
		this.m_lineAlpha = alpha;
		this.m_linePixelHinting = pixelHinting;
		this.m_lineScaleMode = scaleMode;
		this.m_lineCaps = caps;
		this.m_lineJoints = joints;
		this.m_lineMiterLimit = miterLimit;								
	}
	
	public function fillStyle(color:uint, alpha:Number = 1.0):void {
		this.fillGradient = false;
		this.fillRGB = (isNaN(color)) ? Shape.fillRGB_def : color;
		this.fillAlpha = alpha;
	}

	public function gradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void {
		this.fillGradient = true;
		this.gradientFillType = type;
		this.gradientColors = colors;
		this.gradientAlphas = alphas;
		this.gradientRatios = ratios;
		this.gradientMatrix = matrix;
		this.gradientSpreadMethod = spreadMethod;
		this.gradientInterpolationMethod = interpolationMethod;
		this.gradientFocalPointRatio = focalPointRatio;
	}
	
	protected function clearDrawing():void {
		this.mc.graphics.clear();
		if(this.lineStyleModified) {
			this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, 
												this.lineAlpha, this.linePixelHinting, 
												this.lineScaleMode, this.lineCaps, 
												this.lineJoints, this.lineMiterLimit);
		}
	}
	
	public function clear():void {
		this.mc.graphics.clear();
	}	

	public function setInitialized(initialized:Boolean):void {
		this.initialized = initialized;
	}
	
	public function getInitialized():Boolean {
		return this.initialized;
	}	
	
	public function get lineThickness():Number {
		return this.m_lineThickness;
	}

	public function set lineThickness(lineThickness:Number):void {
		this.m_lineThickness = lineThickness;
	}	
	
	public function get lineRGB():Number {		
		return this.m_lineRGB;
	}
	
	public function set lineRGB(lineRGB:Number):void {
		this.m_lineRGB = lineRGB;
	}
	
	public function get lineAlpha():Number {
		return this.m_lineAlpha;
	}
	
	public function set lineAlpha(lineAlpha:Number):void {
		this.m_lineAlpha = lineAlpha;
	}
	
	public function get linePixelHinting():Boolean {
		return this.m_linePixelHinting;
	}
	
	public function set linePixelHinting(linePixelHinting:Boolean):void {
		this.m_linePixelHinting = linePixelHinting;
	}	
	
	public function get lineScaleMode():String {
		return this.m_lineScaleMode;
	}
	
	public function set lineScaleMode(lineScaleMode:String):void {
		this.m_lineScaleMode = lineScaleMode;
	}	
	
	public function get lineCaps():String {
		return this.m_lineCaps;
	}
	
	public function set lineCaps(lineCaps:String):void {
		this.m_lineCaps = lineCaps;
	}	
	
	public function get lineJoints():String {
		return this.m_lineJoints;
	}
	
	public function set lineJoints(lineJoints:String):void {
		this.m_lineJoints = lineJoints;
	}	
	
	public function get lineMiterLimit():Number {
		return this.m_lineMiterLimit;
	}
	
	public function set lineMiterLimit(lineMiterLimit:Number):void {
		this.m_lineMiterLimit = lineMiterLimit;
	}	
}
}