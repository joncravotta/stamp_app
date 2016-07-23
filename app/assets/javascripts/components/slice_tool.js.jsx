var SliceTool = React.createClass({
  getInitialState: function() {
    return {
      clickType: "horizontal",
      data: [],
      file: '',
      image: '',
      imageWidth:0,
      imageHeight:0
    };
  },

  handleFile: function (event) {
    event.preventDefault();
    var reader = new FileReader();
    var file = event.target.files[0];
    var self = this;

    reader.onload = function(){
      var img = new Image();
      img.onload = function() {
        self.setState({imageWidth: img.width});
        self.setState({imageHeight: img.height});
    };
    img.src = reader.result;
      self.setState({file: file, image: reader.result});
    };


    reader.readAsDataURL(file);
    console.log(this.state.image);
  },

  handleCanvasClick: function(ev) {
    var canvas = document.getElementById("canvas");
    var div = $(ev.target);
    var rect = canvas.getBoundingClientRect();

    var offset = div.offset();
    var x = ev.clientX - rect.left;
    var y = ev.clientY - rect.top;


    $('.coords').text('x: ' + x + ', y: ' + y);
    this.addData(x, y);
  },

  handleClickType: function(ev) {
    if (ev.target.id == "vertical"){
      this.setState({clickType: "vertical"});
    } else {
      this.setState({clickType: "horizontal"});
    }
  },

  handleReset: function() {
    var canvas = document.getElementById("canvas");
    var context = canvas.getContext("2d");
    // Clears the canvas
    canvas.width = canvas.width;
    var newData = this.state.data;
    newData.length = 0;
    this.setState({data: newData});
  },

  handleUndo: function() {
    var newData = this.state.data;
    newData.pop();
    var canvas = document.getElementById("canvas");
    var context = canvas.getContext("2d");
    for (var x = 0; x < newData.length; x++){
      if (newData[x].clickType == "vertical"){
        var closestEndY = canvas.height;
        for (var y = 0; y < newData.length; y++){
          if (newData[y].clickType == "horizontal" && newData[y].endY < closestEndY && newData[y].endY > newData[x].startY){
            closestEndY = newData[y].endY;
          }
        }
        newData[x].endY = closestEndY;
      }
    }
    this.setState({data: newData});
    this.drawRect();
  },

  addData: function(x, y) {
    var canvas = document.getElementById("canvas");
    console.log(canvas);
    var context = canvas.getContext("2d");
    var obj = {};
    var newData = this.state.data;
    if (this.state.clickType == "horizontal") {
      this.configXCoords(y);
      obj.clickType = "horizontal";
      obj.startX = 0;
      obj.startY = y;
      obj.endX = this.state.imageWidth;
      obj.endY = y;
      newData.push(obj);
    } else {
      var yCoords = this.findYCoords(y);
      obj.clickType = "vertical";
      obj.startX = x;
      obj.startY = yCoords[0];
      obj.endX = x;
      obj.endY = yCoords[1];
      newData.push(obj);
    }
    this.setState({data: newData});
    this.drawRect();
  },

  drawRect: function() {
    var canvas = document.getElementById("canvas");
    var context = canvas.getContext("2d");
    canvas.width = canvas.width;
    var data = this.state.data;

    for (var x = 0; x < data.length; x++){
      context.moveTo(data[x].startX, data[x].startY);
      context.lineTo(data[x].endX, data[x].endY);
      context.stroke();
    }
  },

  findYCoords: function(y) {
    var canvas = document.getElementById("canvas");
    var context = canvas.getContext("2d");
    var startY = 0;
    var endY = this.state.imageHeight;
    var data = this.state.data;

    for (var x = 0; x < data.length; x++){
      if (data[x].startY < y && data[x].startY > startY){
        startY = data[x].startY;
      }
      if (data[x].endY > y && data[x].endY < endY){
        endY = data[x].endY;
      }
    }
    return [startY, endY];
  },

  configXCoords: function(y) {
    var canvas = document.getElementById("canvas");
    var context = canvas.getContext("2d");
    var newData = this.state.data;

    for (var x = 0; x < newData.length; x++){
      if (newData[x].startY < y && newData[x].endY > y){
        newData[x].endY = y;
      }
    }
    this.setState({data: newData});
  },

  render: function() {
    canvasStyle = {
      backgroundImage: 'url(' + this.state.image + ')'
    };
    console.log(this.state.data);
      return (
        <div className="slice-tool-container">
          <input type="file" onChange={this.handleFile} />
          <canvas id="canvas" height={this.state.imageHeight} width={this.state.imageWidth} onClick={this.handleCanvasClick} style={canvasStyle}></canvas>
          <span className='coords'></span>
          <span className='clickType'>{this.state.clickType}</span>
          <button className="button" id="horizontal" onClick={this.handleClickType}>Horizontal</button>
          <button className="button" id="vertical" onClick={this.handleClickType}>Vertical</button>
          <button className="reset" onClick={this.handleReset}>Reset</button>
          <button className="undo" onClick={this.handleUndo}>Undo</button>
        </div>
      );
    }
});
