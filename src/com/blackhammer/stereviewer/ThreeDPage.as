﻿package  com.blackhammer.stereviewer{	//creted this class to try out making a full page with 3D image and text field	import flash.display.*;	import flash.events.Event;	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.net.URLRequest;		import com.greensock.TweenAlign;	import com.greensock.TimelineMax;	import com.greensock.TweenMax;	import com.greensock.easing.*;		public class ThreeDPage extends MovieClip{				public var _myDaddy:Object;		public var _stereoPair:StereoPair;		public var _headingText:TextDisplay;		public var _pageText:TextDisplay;		private var _pageTextImage:Image_Manager;		public var _sliderGroup:SliderGroup;		public var _type:String = "threeDpage";		private var _Config:SV_Config;		private var _loadimage:Loader = new Loader();		private var _myID:uint;				public function ThreeDPage(myDaddy:Object, daX:int, daY:int,leftImageBMD:BitmapData,rightImageBMD:BitmapData, margin:Number, imageW:Number, counter:uint) {			_myDaddy = myDaddy;			_myID = counter;			_Config = SV_Config.getInstance();			var bgcolor = SV_Config.BGCOLOR;						var bSprite:Sprite = new Sprite();			var b = bSprite.graphics;			b.beginFill(bgcolor,1);			b.drawRect(0,0,SV_Config.SCREENW,SV_Config.SCREENH);			addChild(bSprite);						//from the left first the stereo pair			_stereoPair = new StereoPair(this,daX,daY,leftImageBMD,rightImageBMD);			addChild(_stereoPair);			//add the background mask under the text			var gSprite:Sprite = new Sprite();			var g = gSprite.graphics;			g.beginFill(bgcolor,1);			g.drawRect(imageW,0,SV_Config.SCREENW-imageW,SV_Config.SCREENH);			addChild(gSprite);			//add TextDisplay						_headingText = new TextDisplay(this,SV_Config.HEADINGWIDTH,SV_Config.HEADINGHEIGHT,6,true); ///SV_Config.FIELDMARGIN			_headingText.x = imageW + margin;			_headingText.y = margin - 10;			this.addChild(_headingText);						_pageText = new TextDisplay(this,SV_Config.FIELDWIDTH,SV_Config.FIELDHEIGHT,SV_Config.FIELDMARGIN);			_pageText.x = imageW + margin;			_pageText.y = SV_Config.FIELDTOP;			this.addChild(_pageText);						//page numbers			var pageNumber:StaticTextField = new StaticTextField(this,100,30); //parent, fw,fh,margin			pageNumber.mShow("page "+ String(_myID +1) + " of " + _myDaddy._numOfScreens,12,false,false);			pageNumber.x = 925;			pageNumber.y = 748;			addChild(pageNumber);			//put up the name of the file in edit mode			if (SV_Config.EDITMODE){				var filename3D:StaticTextField = new StaticTextField(this,160,30); //parent, fw,fh,margin				filename3D.mShow(_myDaddy._appMetaData.xmlData.PAGE[_myID].FILE,12,false,false);				filename3D.x = 700;				filename3D.y = 748;				addChild(filename3D);			}						//_sliderGroup =  new SliderGroup(this, 684,66,false); //SliderGroup(this, 684,260);			_sliderGroup =  new SliderGroup(this, 684,630,false); //SliderGroup(this, 684,260);			addChild(_sliderGroup);						_pageTextImage = new Image_Manager(this);			this.addChild(_pageTextImage);									this.addEventListener(Event.ADDED_TO_STAGE, onTheStage, false, 0, true);		}				private function onTheStage(e:Event):void{			this.removeEventListener(Event.ADDED_TO_STAGE,onTheStage);					}				public function loadImage(theImagePath:String):void{			_loadimage.load(new URLRequest(theImagePath));			_loadimage.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded, false, 0 , true);					}				private function imageLoaded(e:Event):void{			var loadimageBMD:BitmapData = _loadimage.content.bitmapData;			_loadimage.contentLoaderInfo.removeEventListener(Event.COMPLETE,imageLoaded);			var daX:Number = Number(_myDaddy._appMetaData.xmlData.PAGE[_myID].IMAGE.@imageX.toString());			var daY:Number = Number(_myDaddy._appMetaData.xmlData.PAGE[_myID].IMAGE.@imageY.toString());			_pageTextImage.setNewImage(loadimageBMD, daX, daY);			_pageTextImage.mShow();		}				public function sliderUpdate(daSlider:Slider,daSliderValue:Number):void{			if (_sliderGroup == null) return;			/*trace("daSlider",daSlider);			trace("daSliderValue",daSliderValue);			trace("_sliderGroup",_sliderGroup);			trace("_sliderGroup._slider1",_sliderGroup._slider1);			trace("==",_sliderGroup._slider1 == daSlider);*/			switch(daSlider){				case _sliderGroup._slider1:					//trace(_mcContent.getChildAt(_indx));					_stereoPair.updateFlickerRate(daSliderValue);					break;				case _sliderGroup._slider2:					_stereoPair.updateRX(daSliderValue);					break;			}		}				//send these messages along		//stereoPair		public function mPlay():void{			_stereoPair.mPlay();		}		public function mStop():void{			_stereoPair.mStop();		}		public function updateFlickerRate(newRate:Number):void{			_stereoPair.updateFlickerRate(newRate);		}		public function updateRX(newX:Number):void{			_stereoPair.updateRX(newX);		}		//text fields		public function hideText():void{			_pageText.hideText();		}				public function mHide():void{			_pageText.mHide();		}		public function kill():void{			_stereoPair.kill();			_headingText.kill();			_pageText.kill();		}		//just pass the messages up to myDaddy		public function showDone(that:Object):void{				//_myDaddy.MessageDone(_messageID);				_myDaddy.showDone(this);		}		public function hideDone(that:Object):void{				_myDaddy.hideDone(this);		}		public function revertTextFromXML(daThing:TextDisplay):void{			_pageText.updateText(_myDaddy._appMetaData.xmlData.PAGE[_myID].NOTES);			//_myDaddy.revertTextFromXML();		}		public function revertTextFromFile(daThing:TextDisplay):void{			_myDaddy.revertTextFromFile("");		}		public function saveXMLlocal(daThing:TextDisplay,daText:String):void{			_myDaddy.saveXMLlocal(daText,"");		}		public function saveXMLtoFile(daThing:TextDisplay,daText:String):void{			_myDaddy.saveXMLtoFile(daText,"");		}		public function saveImageCoords(daX:Number,daY:Number):void{			_myDaddy.saveImageCoords(daX,daY);		}	}	}