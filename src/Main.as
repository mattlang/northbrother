﻿package  {	import flash.display.*;	import flash.events.Event;	//import flash.events.ProgressEvent;	import flash.net.URLRequest;	import flash.events.MouseEvent;	import flash.utils.getDefinitionByName;	import flash.utils.getTimer;		import flash.media.Sound;	import flash.media.SoundChannel;    import flash.net.FileReference;	import flash.events.TransformGestureEvent;	//import fl.controls.ProgressBar;	import fl.containers.ScrollPane;	import com.blackhammer.stereviewer.*;	import com.naftali.components.IPhonePageScroller;	import flash.display.Sprite;	import flash.utils.Dictionary;	import com.blackhammer.util.BHUtils;	import com.blackhammer.util.LoadXML;	import com.blackhammer.stereviewer.TextDisplay;	import com.greensock.*;	import com.greensock.easing.*;	import com.hires.debug.Stats;		[SWF(frameRate=60, width=1024, height=768, 0x000000)]		public class Main extends MovieClip{		private var _shakerate:Number; 		private var _leftOffsetH:Number;		private var _xOffset:Number = 0;		private var _yOffset:Number = 0;		public var _sliderGroup:SliderGroup;				private var _mcContent:MovieClip;		private var _lastTime:uint;		private var _scroller:IPhonePageScroller;		public var _numOfScreens:int;		private var _screenW:int;		private var _screenH:int;		private var _imageW:int;		private var _indx:int = 0;		private var _lastIndx:int = 0;		//screen text		public var _appMetaData:LoadXML;		private var _revertAppMetaData:LoadXML;		private const _killDELETEs:Boolean = true;		private var _margin:int = 20;		private var _headingText:TextDisplay;		private var _pageText:TextDisplay;		private var _pageTextImage:Image_Manager;		private var _fileList:Array = [];		private var _stereoPathPrefix:String = "assets/stereo_images/";		private var _stillPathPrefix:String = "assets/still_images/";		private var _counter:int;		//private var _loadLeft:Loader = new Loader();		//private var _loadRight:Loader = new Loader();		private var _loadimage:Loader = new Loader();		private var _bytesLoadedLatch:uint = 0;		private var _bytesLoaded:uint = 0;		private var _progressBar:progressbar = new progressbar();		private var _Config:SV_Config;		private var _maskSprite:Sprite;		private var _leftRight:String;		private var _isBackBlack:Boolean = true;		//private var _jumpNav;		private var _startSwipeTime:uint;		private var _startSwipeX:Number			public function Main() {			if ( stage ) 	init();			else			addEventListener(Event.ADDED_TO_STAGE, init,false,0,true);			//this.addEventListener(flash.events.Event.ADDED_TO_STAGE,onTheStage, false, 0, true);		}				private function init(e:Event=null):void 		{			trace("stage e",e);			removeEventListener(Event.ADDED_TO_STAGE, init);			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage,false,0,true);					_Config = SV_Config.getInstance();			SV_Config.setStageVars(stage);			_margin = SV_Config.CENTERMARGIN;						_screenW = 1024;			_screenH = 768;			//var bgcolor = SV_Config.BGCOLOR;			//var aSprite:Sprite = new Sprite();			//var a = aSprite.graphics;			//a.beginFill(bgcolor,1);			//a.drawRect(0,0,_screenW,_screenH);			//addChild(aSprite);			trace("putting up the logo");			var logo:Logo = new Logo();			logo.x = _screenW/2;			logo.y = _screenH/2;			logo.alpha = 0;			logo.name = "logo";			addChild(logo);			TweenLite.to (logo, .7, {alpha:1.0, ease:Sine.easeInOut} );			_progressBar.x = _screenW/2 - 150;			_progressBar.y = _screenH/2 + 200;			_progressBar.scaleX = 0;			addChild(_progressBar);						///LOAD XML			_appMetaData = new LoadXML("nb_text.xml");			_appMetaData.addEventListener("xmlLoaded", onLoadXML, false, 0, true);		}		private function onLoadXML(e:Event):void{			_appMetaData.removeEventListener("xmlLoaded", onLoadXML);			trace("XML Loaded");			trace(e);			//trace(_appMetaData.xmlData);			_numOfScreens = int(_appMetaData.xmlData.VARIABLES.@numOfScreens);			/*for(var ii:int = 0; ii<_numOfScreens; ii++){				trace(ii, _appMetaData.xmlData.PAGE[ii].NOTES);			}*/			for (var i:int = _numOfScreens-1; i>0 ; i--){				if(_killDELETEs && _appMetaData.xmlData.PAGE[i].NOTES.toString().slice(0,6) == "DELETE"){					//trace(i);					//trace(_appMetaData.xmlData.PAGE[i]);					delete _appMetaData.xmlData.PAGE[i];					_numOfScreens--;					}			}			//trace(_appMetaData.xmlData);			initPart2();		}		private function initPart2():void{						_imageW = SV_Config.IMAGEWIDTH;			_mcContent = new MovieClip();							//_numOfScreens = int(_appMetaData.xmlData.VARIABLES.@numOfScreens);			var aBool:Boolean = BHUtils.StringToBoolean(_appMetaData.xmlData.VARIABLES.@editmode);			SV_Config.FONTSIZE = Number(_appMetaData.xmlData.text_variables.@fontsize);			SV_Config.TITLEFONTSIZE = Number(_appMetaData.xmlData.text_variables.@headingfontsize);			SV_Config.FONTCOLOR1 = Number(_appMetaData.xmlData.text_variables.@fontcolor1);			SV_Config.FONTCOLOR2 = Number(_appMetaData.xmlData.text_variables.@fontcolor2);			SV_Config.LEADING = Number(_appMetaData.xmlData.text_variables.@leading);			_Config.setEditMode(aBool);			for (var i:int = 0; i<_numOfScreens; i++){				_fileList.push(_appMetaData.xmlData.PAGE[i].FILE);			}			_counter = 0;			var titlemc = new TitleScreen()			titlemc.x = _screenW * (_counter);  //_imageW			_mcContent.addChild(titlemc);			_counter++;					//_loadLeft.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,reportProgress);			//_loadRight.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,reportProgress);			//loadLeft();			buildPages();		}		private function buildPages():void{			var mc:MovieClip;			var leftText:String;			var rightText:String;			var thePathL:String;			var thePathR:String;			var titleText:String;			var someText:String;			var theImagePath:String;			trace("_counter",_counter," _numOfScreens ", _numOfScreens);			while(_counter<_numOfScreens){				if(_fileList[_counter] == ""){					//addDoubleTextPage();					leftText = _appMetaData.xmlData.PAGE[_counter].NOTES.LEFT;					rightText = _appMetaData.xmlData.PAGE[_counter].NOTES.RIGHT;					//mc = new MovieClip ();					mc = new DoubleTextPage(this, leftText, rightText,_counter);				}else{					//3Dpage					thePathL = _stereoPathPrefix+_fileList[_counter].toString()+"_L.jpg";					thePathR = _stereoPathPrefix+_fileList[_counter].toString()+"_R.jpg";						mc = new ThreeDPage(this,_xOffset,_yOffset,thePathL,thePathR,_margin,_imageW,_counter);					//mc = new MovieClip();					//mc.addChild(new Bitmap(new BitmapData(_screenW,_screenH,false,Math.random()*1502500) ) );					if (_counter<4) mc.mLoad();					if (_appMetaData.xmlData.PAGE[_counter] != null) {						titleText = _appMetaData.xmlData.PAGE[_counter].TITLE.toString();						mc._headingText.mPlay(titleText,SV_Config.TITLEFONTSIZE, 0, false, false, false, 0);						someText = _appMetaData.xmlData.PAGE[_counter].NOTES.toString();						mc._pageText.mPlay(someText,SV_Config.FONTSIZE, 0, false, false, false, 0);									}				}				var filename:String = _appMetaData.xmlData.PAGE[_counter].IMAGE.@file.toString();				if(filename != ""){					theImagePath = _stillPathPrefix + filename;						mc.loadImage(theImagePath);				}				mc.x = _screenW * (_counter);				_mcContent.addChild(mc);				_counter++;				fakeProgress();			}			delayInit3();		}		private function delayInit3():void{			removeChild(_progressBar);			_progressBar = null;			TweenLite.delayedCall(2,initPart3);		}		/*private function reportProgress(e:ProgressEvent):void {			// get bytes loaded and bytes total			var thisImageBytesLoaded:int = e.bytesLoaded; //root.loaderInfo.bytesLoaded;			var allImagesBytesTotal:int = 75864898 //83792245; //e.bytesTotal//this.root.loaderInfo.bytesTotal;			if (_bytesLoadedLatch == 0) _bytesLoadedLatch = e.bytesTotal;    		//trace(_bytesLoaded + e.bytesLoaded + " loaded out of " + allImagesBytesTotal);			_progressBar.scaleX = (_bytesLoaded + e.bytesLoaded)/allImagesBytesTotal;		}*/		private function fakeProgress():void {			_progressBar.scaleX = _counter/_numOfScreens;			//TweenLite.to(_progressBar,.2,{scaleX:_counter/_numOfScreens});		}		private function fakeSwipe(e:MouseEvent):void{			stage.removeEventListener(MouseEvent.MOUSE_DOWN,fakeSwipe);			stage.addEventListener(MouseEvent.MOUSE_UP,fakeSwipeUp);			_startSwipeTime = getTimer();			_startSwipeX = stage.mouseX;		}		private function fakeSwipeUp(e:MouseEvent):void{			var swipeTime = getTimer()-_startSwipeTime;			if(swipeTime < 2000 && Math.abs(stage.mouseX-_startSwipeX)>30){				if(stage.mouseX>_startSwipeX){					_indx--;				}else{					_indx++;				} 				if (_indx<0)_indx=0;				if (_indx>_numOfScreens-1)_indx=_numOfScreens-1;				TweenLite.to(_mcContent,.5,{x:-_indx*_screenW, ease:Sine.easeInOut, onComplete:navDone});			}		}		private function onSwipe(e:TransformGestureEvent):void{ 			trace("got a swipe");			if(e.offsetX ==1 && _indx >0){				_indx--;			}			if(e.offsetX == -1 && _indx < _numOfScreens){				_indx++;			}			TweenLite.to(_mcContent,.7,{x:-_indx*_screenW, ease:Sine.easeInOut, onComplete:navDone});		}				private function initPart3():void{						//trace("in init part 3");			//trace ("getChildAt(0).name ",getChildAt(0).name);			TweenLite.to(getChildAt(0),1,{alpha:0,onComplete:continueInitPart3});		}		private function continueInitPart3():void{			removeChild(getChildAt(0));			//_loadLeft.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,reportProgress);			//_loadRight.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,reportProgress);			///_scroller = new IPhonePageScroller( _mcContent, stage, this );			///_scroller.pageWidth = _screenW;			////_lastTime = getTimer();			////addEventListener(Event.ENTER_FRAME, onEveryEnterFrame);			//stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);			stage.addEventListener(MouseEvent.MOUSE_DOWN,fakeSwipe,false,0,true);			addChild( _mcContent );			var bgcolor = SV_Config.BGCOLOR;			//for android			var aSprite:Sprite = new Sprite();			var a = aSprite.graphics;			a.beginFill(bgcolor,1);			a.drawRect(-142,0,142,_screenH);			//addChild(gSprite);			a.beginFill(bgcolor,1);			a.drawRect(1023,0,143,_screenH);			addChild(aSprite);			//end android bars									/*_jumpNav = new JumpNav(this,_numOfScreens,700,752);			addChild(_jumpNav);			_jumpNav.mHide();*/						var showMetrics = BHUtils.StringToBoolean(_appMetaData.xmlData.VARIABLES.@showmetrics)			if(showMetrics){				addChild(new Stats());  //for hires			}						_mcContent.getChildAt(0).mShow(); //mPlay();		}				private function showSliders(e:Event):void{			_sliderGroup.mShow();			//_pageText.removeEventListener(MouseEvent.CLICK,showSliders);		}				public function revertTextFromXML():void{			_pageText.updateText(_appMetaData.xmlData.PAGE[_indx].NOTES);		}				public function revertTextFromFile(leftRight:String):void{			_leftRight = leftRight;			_revertAppMetaData = new LoadXML("nb_text.xml");			_revertAppMetaData.addEventListener("xmlLoaded", onLoadXMLforRevert, false, 0, true);		}		private function onLoadXMLforRevert(e:Event):void{			_revertAppMetaData.removeEventListener("xmlLoaded", onLoadXMLforRevert);			var daText:String;			//trace("e",e);			if (_leftRight==""){				daText = _revertAppMetaData.xmlData.PAGE[_indx].NOTES;				//_pageText.updateText(daText);				_mcContent.getChildAt(_indx)._pageText.updateText(daText);				_appMetaData.xmlData.PAGE[_indx].NOTES = daText			}else if (_leftRight=="LEFT"){				daText = _revertAppMetaData.xmlData.PAGE[_indx].NOTES.LEFT;				//_pageText.updateText(daText);				_mcContent.getChildAt(_indx)._textDisplayL.updateText(daText);				_appMetaData.xmlData.PAGE[_indx].NOTES.LEFT = daText			}else if (_leftRight=="RIGHT"){				daText = _revertAppMetaData.xmlData.PAGE[_indx].NOTES.RIGHT;				//_pageText.updateText(daText);				_mcContent.getChildAt(_indx)._textDisplayR.updateText(daText);				_appMetaData.xmlData.PAGE[_indx].NOTES.RIGHT = daText			}					}				public function saveXMLlocal(daText:String,leftRight:String):void{			if (leftRight==""){				_appMetaData.xmlData.PAGE[_indx].NOTES = daText;			}else if (leftRight=="LEFT"){				_appMetaData.xmlData.PAGE[_indx].NOTES.LEFT = daText;				//trace(_appMetaData.xmlData.PAGE[_indx].NOTES.LEFT);			}else if (leftRight=="RIGHT"){				_appMetaData.xmlData.PAGE[_indx].NOTES.RIGHT = daText;				//trace(_appMetaData.xmlData.PAGE[_indx].NOTES.RIGHT);			}		}		public function saveXMLtoFile(daText:String,leftRight:String):void{			saveXMLlocal(daText,leftRight)			//_appMetaData.xmlData.PAGE[_indx].NOTES = daText;			var file:FileReference = new FileReference;			file.save(_appMetaData.xmlData, "nb_text.xml" );		}		public function saveImageCoords(daX:Number,daY:Number):void{			var stringX:String = String(daX);			var stringY:String = String(daY);			_appMetaData.xmlData.PAGE[_indx].IMAGE.@imageX = stringX;			_appMetaData.xmlData.PAGE[_indx].IMAGE.@imageY = stringY;		}				private function showPageText():void{			if (_appMetaData.xmlData.PAGE[_indx] == null) return;  //|| _appMetaData.xmlData.PAGE[_ind] == null			//mPlay(daText:String,fontSize:Number,readDelay:Number,isbold:Boolean = false,showBacking:Boolean=false,clickToKill:Boolean=false,messageID:int = 0)			var titleText:String = _appMetaData.xmlData.PAGE[_indx].TITLE.toString();			_headingText.mPlay(titleText,18, 0, false, false, false, 0);			var someText:String = _appMetaData.xmlData.PAGE[_indx].NOTES.toString();			_pageText.mPlay(someText,SV_Config.FONTSIZE, 0, false, false, false, 0);			/////add the image if there is one/////			var filename:String = _appMetaData.xmlData.PAGE[_indx].IMAGE.@file.toString();			if(filename != ""){				var theImagePath:String = _stillPathPrefix + filename;					_loadimage.load(new URLRequest(theImagePath));				_loadimage.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded, false, 0 , true);			}		}		private function hidePageText():void{			_headingText.mHide();			_pageText.mHide();		}		private function imageLoaded(e:Event):void{			var loadimageBMD:BitmapData = _loadimage.content.bitmapData;			_loadimage.contentLoaderInfo.removeEventListener(Event.COMPLETE,imageLoaded);			var daX:Number = Number(_appMetaData.xmlData.PAGE[_indx].IMAGE.@imageX.toString());			var daY:Number = Number(_appMetaData.xmlData.PAGE[_indx].IMAGE.@imageY.toString());			var caption:String = _appMetaData.xmlData.PAGE[_indx].IMAGE.@caption;			_pageTextImage.setNewImage(loadimageBMD, daX, daY,caption);			_pageTextImage.mShow();		}						//not used in new scheme		public function sliderUpdate(daSlider:Slider,daSliderValue:Number):void{			if (_sliderGroup == null) return;			/*trace("daSlider",daSlider);			trace("daSliderValue",daSliderValue);			trace("_sliderGroup",_sliderGroup);			trace("_sliderGroup._slider1",_sliderGroup._slider1);			trace("==",_sliderGroup._slider1 == daSlider);*/			switch(daSlider){				case _sliderGroup._slider1:					//trace(_mcContent.getChildAt(_indx));					_mcContent.getChildAt(_indx).updateFlickerRate(daSliderValue);					break;				case _sliderGroup._slider2:					_mcContent.getChildAt(_indx).updateRX(daSliderValue);					break;			}		}		public function changeColors():void{			var backColor:uint;			var fontColor:uint;			if(_isBackBlack){				_isBackBlack = false;				SV_Config.BGCOLOR = SV_Config.BGCOLOR2;				SV_Config.FONTCOLOR = SV_Config.FONTCOLOR2;			}else{				_isBackBlack = true;				SV_Config.BGCOLOR = SV_Config.BGCOLOR1;				SV_Config.FONTCOLOR = SV_Config.FONTCOLOR1;			}			for(var i:uint=0;i<_numOfScreens;i++){				_mcContent.getChildAt(i).setColors(SV_Config.BGCOLOR,SV_Config.FONTCOLOR);			}		}				public function showDone(daThing:Object):void{			/*switch(daThing){			case _pageText:								break;						}*/		}			public function hideDone(daThing:Object):void{			/*switch(daThing){			case _pageText:				//_messageMode = false;				break;			}*/		}		public function jumpNav(pageNum):void{			TweenLite.to(_mcContent,.2,{alpha:0,onComplete:setnewindx,onCompleteParams:[pageNum]});		}		private function setnewindx(pageNum):void{			this.screen=pageNum;			_mcContent.x = -_screenW*_indx;			if(_mcContent.getChildAt(_indx)._type =="threeDpage"){				_mcContent.getChildAt(_indx).mLoad();				if(_indx + 1 < _numOfScreens) _mcContent.getChildAt(_indx+1).mLoad();				if(_indx >= 2) _mcContent.getChildAt(_indx-1).mLoad();				if (_lastIndx>0)_mcContent.getChildAt(_lastIndx).mUnload();				if (_lastIndx-1>0) _mcContent.getChildAt(_lastIndx-1).mUnload();				if (_lastIndx+1<_numOfScreens) _mcContent.getChildAt(_lastIndx+1).mUnload();			}			TweenLite.to(_mcContent,.2,{alpha:1,onComplete:navDone});		}		public function navDone(daThing:Object=null):void{			stage.addEventListener(MouseEvent.MOUSE_DOWN,fakeSwipe,false,0,true);			//switch(daThing){			//case _scroller:				if(_mcContent.getChildAt(_indx)._type =="threeDpage"){					_mcContent.getChildAt(_indx).mPlay();					var loadRange:int = 3;					//if (_indx==1) _jumpNav.mShow();					//if (_lastIndx>0)_mcContent.getChildAt(_lastIndx)._jumpNav.disable();					trace("_indx: ",_indx,"  _lastIndx: ",_lastIndx);						if(_indx + 1 <= _numOfScreens-1) _mcContent.getChildAt(_indx+1).mLoad();						if(_indx >= 2) _mcContent.getChildAt(_indx-1).mLoad();						//if(_indx + 2 <= _numOfScreens-1) _mcContent.getChildAt(_indx+2).mLoad();						//if(_indx >= 3) _mcContent.getChildAt(_indx-2).mLoad();					if(_indx>_lastIndx) {						if (_indx >= loadRange+2) _mcContent.getChildAt(_indx-loadRange-1).mUnload();						if (_indx >= loadRange+1) _mcContent.getChildAt(_indx-loadRange).mUnload();						//if(_indx + loadRange <= _numOfScreens-1) _mcContent.getChildAt(_indx+loadRange).mLoad();					}else{						//if(_indx >= loadRange+1) _mcContent.getChildAt(_indx-loadRange).mLoad();						if(_indx + loadRange <= _numOfScreens-1) _mcContent.getChildAt(_indx+loadRange).mUnload();						if(_indx + loadRange+1 <= _numOfScreens-1) _mcContent.getChildAt(_indx+loadRange+1).mUnload();					}				}				if (_indx>0)_mcContent.getChildAt(_indx)._jumpNav.enable();				if(_mcContent.getChildAt(_lastIndx)._type =="threeDpage") {					if(_mcContent.getChildAt(_lastIndx)!=_mcContent.getChildAt(_indx)) _mcContent.getChildAt(_lastIndx).mStop();				}				//break;																//from before newest text in page test				/*if(_mcContent.getChildAt(_indx)._type =="stereopair"){					TweenMax.to(_maskSprite,.7,{alpha:1});					_mcContent.getChildAt(_indx).mPlay();					if(_mcContent.getChildAt(_lastIndx)._type =="stereopair") _mcContent.getChildAt(_lastIndx).mStop();					_sliderGroup.mShow();					_sliderGroup._slider2.resetSlider();					showPageText();					//this.addChild(_infoButton);					//_infoButton.Show();				}else{					TweenMax.to(_maskSprite,.7,{alpha:0});					_sliderGroup.mHide();					hidePageText();				}				break;				*/			//}		}		public function hidePageStuff(daThing:Object):void{			//trace("turned off hidePageStuff");			return;			//_infoButton.hide();			_pageText.hideText();			_pageTextImage.mHide();		}				public function get imageW():int{			return _imageW;		}				public function set screen(indx:int):void{			_lastIndx = _indx;			_indx = indx;			//trace(_indx);		}		public function get screen():int{			return _indx;		}		private function onEveryEnterFrame(e:Event):void 		{			var obj:Object = calcObj();			_scroller.process( obj );		}				private function calcObj():Object		{			var _currentTime:uint = getTimer();			var pastTime:int = _currentTime - _lastTime;			_lastTime = _currentTime;			return { time:pastTime };		}				private function onRemovedFromStage(e:Event):void 		{			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);			removeEventListener(Event.ENTER_FRAME, onEnterFrame);			addEventListener(Event.ADDED_TO_STAGE, init);			_scroller.release();			_scroller = null;			if ( _mcContent.parent )				_mcContent.parent.removeChild( _mcContent );			_mcContent = null;		}				private function onHomeClick(e:MouseEvent):void 		{			_scroller.forceFocusOnPage( _mcContent.mcPageOne );		}				/*private function loadLeft():void{			//trace("_fileList[_counter] == empty",_fileList[_counter] == "", "_counter:",_counter);			if(_fileList[_counter] == ""){				addDoubleTextPage();			}else{				var thePath:String = _stereoPathPrefix+_fileList[_counter].toString()+"_L.jpg";				_bytesLoadedLatch = 0;				//trace(thePath);				_loadLeft.load(new URLRequest(thePath));				_loadLeft.contentLoaderInfo.addEventListener(Event.COMPLETE,loadRight, false, 0 , true);			}		}			private function loadRight(e:Event):void{			_bytesLoaded += _bytesLoadedLatch;			_bytesLoadedLatch = 0;			//_loadLeftBMD = e.target.content.bitmapData;			var thePath:String = _stereoPathPrefix+_fileList[_counter].toString()+"_R.jpg";				//trace(thePath);			_loadRight.load(new URLRequest(thePath));			_loadRight.contentLoaderInfo.addEventListener(Event.COMPLETE,addImage, false, 0 , true);		}*/		/*private function addImage(e:Event):void{			//instead of e.target.content.bitmapData;			var loadLeftBMD:BitmapData = _loadLeft.content.bitmapData;			var loadRightBMD:BitmapData = _loadRight.content.bitmapData;			//trace("loadLeftBMD",loadLeftBMD);			//trace("loadRightBMD",loadRightBMD);			//ThreeDPage(myDaddy:Object, daX:int, daY:int,leftImageBMD:BitmapData,rightImageBMD:BitmapData, margin:Number, imageW:Number)			var mc:ThreeDPage = new ThreeDPage(this,_xOffset,_yOffset,loadLeftBMD,loadRightBMD,_margin,_imageW,_counter);						if (_appMetaData.xmlData.PAGE[_indx] != null) {				var titleText:String = _appMetaData.xmlData.PAGE[_counter].TITLE.toString();				//mc._headingText.mPlay("North Brother Island" + "\n" + "A History in 3D",18, 0, false, false, false, 0);				mc._headingText.mPlay(titleText,SV_Config.TITLEFONTSIZE, 0, false, false, false, 0);				var someText:String = _appMetaData.xmlData.PAGE[_counter].NOTES.toString();				mc._pageText.mPlay(someText,SV_Config.FONTSIZE, 0, false, false, false, 0);								/////add the image if there is one/////				var filename:String = _appMetaData.xmlData.PAGE[_counter].IMAGE.@file.toString();				if(filename != ""){					var theImagePath:String = _stillPathPrefix + filename;						//trace("theImagePath",theImagePath);					mc.loadImage(theImagePath);				}			}						mc.x = _screenW * (_counter);  //_imageW			_mcContent.addChild(mc);			_loadLeft.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadRight);			_loadRight.contentLoaderInfo.removeEventListener(Event.COMPLETE,addImage);			_counter++;			if(_counter<_numOfScreens){				_bytesLoaded += _bytesLoadedLatch;				_bytesLoadedLatch = 0;				loadLeft();			}else{				initPart3();			}		}*/	}	}