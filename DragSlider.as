/**
 * DragSlider.as
 * DragSlider component for Minimalcomps
 * version 1.0
 */
 
package {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.bit101.components.*;
	
	[Event(name="change", type="flash.events.Event")]
	
    public class DragSlider extends Component {
		public static var GRIP:String = "IIIIIIII";
		public static var GRIP_STILE:uint = 0xBBBBBB;
		
		protected var _back:Sprite;
		protected var _face:Sprite;
		protected var _toggle:Label;
		
		protected var _handle:PushButton;
		protected var _minusBtn:PushButton;
        protected var _plusBtn:PushButton;
		
		protected var _value:Number = 0;
		protected var _step:Number = 1;
		
		protected var _labelText:String;
		
		protected var _label:Label;
		protected var _valueLabel:Label;

		protected var _oldValue:Number = 0;
		protected var _startDragValue:Number = 0;

		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this DragSlider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param step The step value of this component.
		 * @param label The string to use as the label for this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function DragSlider(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, step:Number = 1, label:String = "", defaultHandler:Function = null) {
			_labelText = label;
			_step = step;
			
			super(parent, xpos, ypos);
			
			if(defaultHandler != null) {
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		// Initializes the component.
		override protected function init():void {
			super.init();
			setSize(90, 16);
		}
		
		// Creates and adds the child display objects of this component.
		override protected function addChildren():void {
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			_back.mouseEnabled = false;
			addChild(_back);
			
			_face = new Sprite();
			_face.buttonMode = true;
			_face.useHandCursor = true;
			_face.filters = [getShadow(1)];
			_face.x = 1;
			_face.y = 1;
			addChild(_face);
			
			_face.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			
			_toggle = new Label();
			addChild(_toggle);
			
			_label = new Label(this, 0, 0, _labelText);
			_valueLabel = new Label(this, 0, 0, _value.toString());

			_minusBtn = new PushButton(this, 0, 0, "-");
			_minusBtn.addEventListener(MouseEvent.CLICK, onMinus);
			_minusBtn.setSize(_height, _height);
			
			_plusBtn = new PushButton(this, 0, 0, "+");
			_plusBtn.addEventListener(MouseEvent.CLICK, onPlus);
			_plusBtn.setSize(_height, _height);
		}

		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		// Draws the visual ui of the component.
		override public function draw():void {
			super.draw();
			
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(_minusBtn.width, 0, _width - _plusBtn.width - _plusBtn.width, _height);
			_back.graphics.endFill();
			
			_face.graphics.clear();
			_face.graphics.beginFill(Style.BUTTON_FACE);
			_face.graphics.drawRect(_minusBtn.width, 0, _width - _plusBtn.width - _plusBtn.width - 2, _height - 2);
			_face.graphics.endFill();
			
			_toggle.text = GRIP;
			_toggle.autoSize = true;
			_toggle.draw();
			if(_toggle.width > _width - 4) {
				_toggle.autoSize = false;
				_toggle.width = _width - 4;
			}
			else {
				_toggle.autoSize = true;
			}
			_toggle.draw();
			_toggle.move(_width / 2 - _toggle.width / 2, _height / 2 - _toggle.height / 2);
			
			_toggle.textField.defaultTextFormat = new TextFormat(Style.fontName, Style.fontSize, GRIP_STILE);
			

			_plusBtn.x = _width - _plusBtn.width;
			
			_label.draw();
			_label.move(-_label.width - 5, _height / 2 - _label.height / 2);
			
			_valueLabel.draw();
			_valueLabel.move(_width + 5, _height / 2 - _valueLabel.height / 2);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		override public function setSize(w:Number, h:Number):void {
			_minusBtn.setSize(h, h);
        	_plusBtn.setSize(h, h);
			super.setSize(w, h);
		}
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		// Called when the minus button is pressed. Decrements the value by the step amount.
		protected function onMinus(event:MouseEvent):void {
			_value -= _step;
			_valueLabel.text = _value.toString();
				
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		// Called when the plus button is pressed. Increments the value by the step amount.
		protected function onPlus(event:MouseEvent):void {
			_value += _step;
			_valueLabel.text = _value.toString();
				
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}

		// Internal mouseDown handler. Starts dragging the handle.
		protected function onDrag(event:MouseEvent):void {
			_face.filters = [getShadow(1, true)];
			
			_startDragValue = stage.mouseX;
			_oldValue = _value;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
		}
		
		// Internal mouseUp handler. Stops dragging the handle.
		protected function onDrop(event:MouseEvent):void {
			_face.filters = [getShadow(1, false)];
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
		}
		
		// Internal mouseMove handler for when the handle is being moved.
		protected function onSlide(event:MouseEvent):void {
			var _newValue:Number = _oldValue + (stage.mouseX - _startDragValue);
			_value = Math.round(_newValue / _step) * _step;
			
			_valueLabel.text = _value.toString();

			if(_value != _oldValue) {
				dispatchEvent(new Event(Event.CHANGE));
			}
		}


		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		// Sets / gets the current value of this slider.
		public function set value(v:Number):void {
			_value = v;
			_valueLabel.text = _value.toString();
		}
		
		public function get value():Number {
			return _value;
		}
		
		// Gets / sets the step value of this slider. Must be positive.
		public function set step(value:Number):void {
			if(value <= 0) {
				throw new Error("DragSlider step must be positive.");
			}
			_step = value;
		}
		
		public function get step():Number {
			return _step;
		}

	}
}
