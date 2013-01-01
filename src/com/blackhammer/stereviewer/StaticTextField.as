﻿package com.blackhammer.stereviewer {		//being used for text label on slidegroup///		import flash.display.*;	import flash.geom.*;	import flash.media.*;	import flash.events.*;	import flash.text.*;	import fl.motion.*;	import com.blackhammer.util.BHUtils;	import com.greensock.*;		public class StaticTextField extends Sprite{				private var _myDaddy:Object;		private var _gSprite:Sprite = new Sprite();		private var _g:Graphics;		private var _fieldW:Number;		private var _fieldH:Number;		private var _margin:int = 20;		public var _displayField:TextField  = new TextField();		private var _format:TextFormat = new TextFormat("Gotham_book");				public function StaticTextField(myDaddy:Object, fw:Number,fh:Number, margin:Number=0) {			_myDaddy = myDaddy;			_fieldW = fw;			_fieldH = fh;			_margin = margin;			_g = _gSprite.graphics;			_displayField.multiline = _displayField.wordWrap = true;			_displayField.autoSize = TextFieldAutoSize.CENTER;			_displayField.type = TextFieldType.DYNAMIC;			_displayField.selectable =false;			_displayField.antiAliasType = flash.text.AntiAliasType.ADVANCED;			///use border for placement testing			//_displayField.border = true;			//_displayField.borderColor = 0x990000;						var customFont:Font = new font_Gotham_book();  			_format.font = customFont.fontName;			//_format.bold = true;            _format.color = 0x000000;            _format.size = 24;            _format.underline = false;			_format.align = TextFormatAlign.LEFT;            _displayField.defaultTextFormat = _format;			_displayField.text = ".";			_displayField.embedFonts = true;			_gSprite.addChild(_displayField);			//_displayField.rotation = 10; //for testing			//this.visible = false;			//this.alpha = 0.0;			//this.transform.matrix = new Matrix(1, 0, 0, 1,  -_fieldW,  -_fieldH);			//not centering			//this.setRegistrationPoint(this.width >> 1, this.height >> 1, false);			this.addEventListener(Event.ADDED_TO_STAGE, onTheStage, false, 0, true);		}				private function onTheStage(e:Event):void{			this.removeEventListener(Event.ADDED_TO_STAGE, onTheStage);			//this.alpha = 0.0;			//not centering			//this.x = (stage.stageWidth)/2;			//this.y = (stage.stageHeight)/2;		}				public function mShow(daText:String, fontSize:Number, isbold:Boolean = false, hasBacking:Boolean = false):void{			if (hasBacking){ 				SetUpStuff();				var textH = _displayField.height;				var textW = _displayField.width;				_displayField.x = (_fieldW - textW)/2 				_displayField.y = _margin; //(_fieldH - textH)/2			}			_format.size = fontSize;			_format.bold = isbold;			_displayField.text = daText;			_displayField.setTextFormat(_format); //added insted of using default			addChild(_gSprite);					}				private function SetUpStuff():void{			_g.clear();			_g.beginFill(0x333333,0.90);			_g.drawRoundRect(0,0,_fieldW,_fieldH,10);			//if putting it over a backing then the margin is used to show backing around the field			//and the field is smaller			_displayField.width = _fieldW -2*_margin;			_displayField.height = _fieldH - 2*_margin;			//not centering			//_gSprite.transform.matrix = new Matrix(1, 0, 0, 1, -_fieldW/2, -_fieldH/2);			//addChild(_gSprite);			//_displayField.alpha = 0			//_displayField.transform.matrix = new Matrix(1, 0, 0, 1, -(_displayField.width)/2, -(_displayField.height)/2);			}	}	}