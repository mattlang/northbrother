﻿package com.blackhammer.stereviewer {		import flash.display.MovieClip;	import flash.events.Event;	import flash.display.BitmapData;	import flash.display.Bitmap;		import com.greensock.TweenAlign;	import com.greensock.TimelineMax;	import com.greensock.TweenMax;	import com.greensock.easing.*;		public class StereoPair extends MovieClip{		private var _myDaddy:Object;		private var _leftEdge:int;		private var _flickerRate:Number=.3;		private var _myX:int;		//private var _leftImageBMD:BitmapData;		//private var _rightImageBMD:BitmapData;		private var _leftImageBM:Bitmap;		private var _rightImageBM:Bitmap;		private var _myTimeline:TimelineMax;		public var _type:String = "stereopair";				public function StereoPair(myDaddy:Object, daX:int, daY:int,leftImageBMD:BitmapData,rightImageBMD:BitmapData) {			_myDaddy = myDaddy;			this.x = _myX = daX;			this.y = daY;			//_leftImageBMD = leftImageBMD;			//_rightImageBMD = rightImageBMD;			_leftImageBM = new Bitmap(leftImageBMD);			_rightImageBM = new Bitmap(rightImageBMD);			_leftImageBM.x = _rightImageBM.x = daX;			_leftImageBM.y = _rightImageBM.y = daY;			addChild(_leftImageBM);			addChild(_rightImageBM);		}				private function updateFade():void{			_myTimeline = new TimelineMax({onComplete:updateFade}); //{onComplete:updateFade}			_myTimeline.autoRemoveChildren = true;			_myTimeline.append(TweenMax.to (_rightImageBM, _flickerRate/2, {alpha:0.0, ease:Sine.easeInOut} ) );			_myTimeline.append(TweenMax.to (_rightImageBM, _flickerRate/2, {alpha:1.0, ease:Sine.easeInOut} ) );		}				public function mPlay():void{			mStop();//belt and suspenders			_flickerRate =  _myDaddy._sliderGroup._slider1.slidervalue;			//trace("_flickerRate",_flickerRate);			updateFade();		}		public function mStop():void{			//_myTimeline.killTweensOf(_rightImageBM);			//trace("_myTimeline",_myTimeline);			if (_myTimeline!=null) _myTimeline.kill();			_rightImageBM.alpha = 0;		}		public function updateFlickerRate(newRate:Number):void{			_flickerRate = newRate;		}		public function updateRX(newX:Number):void{			_rightImageBM.x = newX;		}	}	}