package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	import com.bit101.components.*;
	
	/**
	 * Example.as
	 * DragSlider component for Minimalcomps example
	 * Author: Vladimir Nayata
	 */
	
	[SWF(width="660", height="260", backgroundColor="0x282828", frameRate="30")]
	public class Example extends Sprite {
		private const WIDTH:int = 660;
		private const HEIGHT:int = 260;
				
		private var translateXSlider:DragSlider;
		private var translateYSlider:DragSlider;
		private var scaleXSlider:DragSlider;
		private var scaleYSlider:DragSlider;
		
		private var step:int = 1;
		private var gridSnap:PushButton;

		private var tile:Sprite;

		
		public function Example() {
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			init();
		}
		
		protected function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;
			stage.focus = stage;

			Style.setStyle(Style.DARK);
			Style.BUTTON_FACE = 0x505050;
			Style.BUTTON_DOWN = 0x444444;
			Style.DROPSHADOW = 0x1d1d1d;
			Style.PANEL = 0x505050;
			
			tile = new Sprite();
			tile.x = WIDTH * 0.5 - 80; 
			tile.y = HEIGHT * 0.5; 
			tile.graphics.lineStyle(2, 0x0592f8);
			tile.graphics.beginFill(0x0592f8, 0.5);
			tile.graphics.drawRect(-38/2, -38/2, 38, 38);
			tile.graphics.endFill();
			tile.graphics.beginFill(0x0592f8, 1.0);
			tile.graphics.drawRect(-2, -2, 4, 4);
			tile.graphics.endFill();
			stage.addChild(tile);

			var editPanel:Sprite = new Sprite();
			editPanel.x = WIDTH - 160; 
			editPanel.y = 70;
			stage.addChild(editPanel);
			
			var editLabel:Label = new Label(editPanel, 0, -25, "Properties:");
			editLabel.textField.defaultTextFormat = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT);
		
			translateXSlider = new DragSlider(editPanel, 0, 0, step, "position x", translateXChange);
			translateYSlider = new DragSlider(editPanel, 0, 20, step, "position y", translateYChange);
			
			scaleXSlider = new DragSlider(editPanel, 0, 50, step, "width", scaleXChange);
			scaleYSlider = new DragSlider(editPanel, 0, 70, step, "height", scaleYChange);
			
			translateXSlider.value = tile.x;
			translateYSlider.value = tile.y;
			scaleXSlider.value = tile.width;
			scaleYSlider.value = tile.height;
			
			gridSnap = new PushButton(editPanel, 0, 110, "Snap: 1x", tileStep);
			gridSnap.setSize(90, 20);
			gridSnap.tag = 1;
		}
		
		private function translateXChange(event:Event):void {
			if (!tile) return;
			tile.x = translateXSlider.value;
		}
		
		private function translateYChange(event:Event):void {
			if (!tile) return;
			tile.y = translateYSlider.value;
		}

		private function scaleXChange(event:Event):void {
			if (!tile) return;
			
			var limit:int = 10;
			if(scaleXSlider.value < limit) {
				scaleXSlider.value = limit;
			}
			
			tile.width = scaleXSlider.value;
			redrawTile();
		}
		
		private function scaleYChange(event:Event):void {
			if (!tile) return;
			
			var limit:int = 10;
			if(scaleYSlider.value < limit) {
				scaleYSlider.value = limit;
			}
			
			tile.height = scaleYSlider.value;
			redrawTile();
		}

		private function tileStep(event:Event):void {
			if (gridSnap.tag == 1) {
				gridSnap.label = "Snap: 5x";
				gridSnap.tag = 2;
				step = 5; 
			}
			else if (gridSnap.tag == 2) {
				gridSnap.label = "Snap: 20x";
				gridSnap.tag = 3;
				step = 20; 
			}
			else if (gridSnap.tag == 3) {
				gridSnap.label = "Snap: 1x";
				gridSnap.tag = 1;
				step = 1; 
			}
			
			translateXSlider.step = step;
			translateYSlider.step = step;
			scaleXSlider.step = step;
			scaleYSlider.step = step;
		}
		
		private function redrawTile():void {
			var tw:Number = tile.width;
			var th:Number = tile.height;
				
			tile.graphics.clear();
			tile.graphics.lineStyle(2, 0x0592f8);
			tile.graphics.beginFill(0x0592f8, 0.5);
			tile.graphics.drawRect(-tw/2, -th/2, tw, th);
			tile.graphics.endFill();
			tile.graphics.beginFill(0x0592f8, 1.0);
			tile.graphics.drawRect(-2, -2, 4, 4);
			tile.graphics.endFill();
			
			tile.width = scaleXSlider.value;
			tile.height = scaleYSlider.value;
		}
	}
}
