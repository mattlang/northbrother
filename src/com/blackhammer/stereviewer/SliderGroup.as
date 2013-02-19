﻿package com.blackhammer.stereviewer {		import flash.display.*;	import flash.events.Event;	import flash.geom.*;	import flash.media.*;	import com.greensock.*;	import flash.events.MouseEvent;		public class SliderGroup extends MovieClip{		private var _myDaddy:Object;		private var _gSprite:Sprite = new Sprite();		private var _g:Graphics;		private var _slider1_label;		private var _slider2_label;		public var _slider1;		public var _slider2;		private var _myX:Number;		private var _myY:Number;		private var _isShowing:Boolean = false;				private const SLIDEX1:int = 10;		private const SLIDEY1:int = 30;		private const SLIDEX2:int = 10;		private const SLIDEY2:int = 74;		private const _backingWidth:int = 320;		private const _backingHeight:int = 160;		private var _slider1labelVisible:Boolean;		private var _slider2labelVisible:Boolean;				public function SliderGroup(myDaddy:Object,daX:Number, daY:Number,showbackground:Boolean) {			_myDaddy = myDaddy;			_myX = daX;			_slider1labelVisible = false;			_slider2labelVisible = false;			this.x = _myX; // + _backingWidth;			this.y = _myY = daY;			this.alpha = 1;			_isShowing = true;			//this.visible = false;			if (showbackground) createBacking();						_slider1_label = new StaticTextField(this,100,30); //parent, fw,fh,margin			_slider1_label.mPlay("flicker rate",11,false,false);			_slider1_label.x = SLIDEX1;			_slider1_label.y = SLIDEY1 -14;			_slider1_label.mShow(); //mHide();			addChild(_slider1_label);			_slider1labelVisible = true;			_slider2_label = new StaticTextField(this,100,30); //parent, fw,fh,margin			_slider2_label.mPlay("convergence",11,false,false);			_slider2_label.x = SLIDEX2;			_slider2_label.y = SLIDEY2 -14;			_slider2_label.mShow(); //.mHide();			addChild(_slider2_label);			_slider2labelVisible = true;			_slider1 = new Slider(this,SLIDEX1,SLIDEY1,.9,1/8,.7,true);			_slider2 = new Slider(this,SLIDEX2,SLIDEY2,-15,15,.5);			addChild(_slider1);			addChild(_slider2);			_slider1.sliderBack.addEventListener(MouseEvent.CLICK,slider1LabelClick,false,0,true);			_slider2.sliderBack.addEventListener(MouseEvent.CLICK,slider2LabelClick,false,0,true);		}		private function slider1LabelClick(e:MouseEvent):void{			if(_slider1labelVisible){				_slider1labelVisible = false;				_slider1_label.mHide();			}else{				_slider1labelVisible = true;				_slider1_label.mShow();			}		}		private function slider2LabelClick(e:MouseEvent):void{			if(_slider2labelVisible){				_slider2labelVisible = false;				_slider2_label.mHide();			}else{				_slider2labelVisible = true;				_slider2_label.mShow();			}		}		public function changeFontColor(fontColor:uint):void{			_slider1_label.changeFontColor(fontColor);			_slider2_label.changeFontColor(fontColor);		}		public function mShow():void{			if (_isShowing) return;			TweenLite.to(this,.75,{alpha:1,x:_myX});			_isShowing = true;		}				public function mHide():void{			if (!_isShowing) return;			TweenLite.to(this,.75,{alpha:0,x:_myX + _backingWidth});			_isShowing = false;		}				private function createBacking():void{			_g = _gSprite.graphics;			_g.clear();			_g.beginFill(0x555555,0.90);			_g.drawRoundRect(0,0,_backingWidth,_backingHeight,10);			_gSprite.alpha = .9;			addChild(_gSprite);		}				public function sliderUpdate(slider:Slider,theValue:Number):void{			_myDaddy.sliderUpdate(slider,theValue);		}			}	}