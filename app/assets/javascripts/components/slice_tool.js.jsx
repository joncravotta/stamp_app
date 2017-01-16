var SliceTool = React.createClass({
  getInitialState: function() {
    return {
      clickType: "horizontal",
      data: [],
      file: this.props.file,
      image: this.props.image,
      imageWidth: this.props.imageWidth,
      imageHeight: this.props.imageHeight,
      emailName: this.props.emailName,
      returnedUrls: [],
      makingRequest: false
    };
  },

  handleCanvasClick: function(ev) {
    var canvas = document.getElementById("canvas");
    var div = $(ev.target);
    var rect = canvas.getBoundingClientRect();

    var offset = div.offset();
    var x = ev.clientX - rect.left;
    var y = ev.clientY - rect.top;
    this.addData(x, y);
  },

  handleClickType: function(ev) {
    if (ev.target.id == "vertical"){
      this.setState({clickType: "vertical"});
    } else {
      this.setState({clickType: "horizontal"});
    }
  },

  handleSlicePost: function() {
    var self = this;
    var dataObj = {};
    dataObj.slice_data = this.state.data;
    dataObj.imageWidth = this.state.imageWidth;
    dataObj.imageHeight = this.state.imageHeight;
    dataObj.image = this.state.image;
    dataObj.emailName = this.state.emailName;
    dataObj.userId = this.props.userId;
    this.setState({makingRequest: true});
    $.ajax({
      url: '/slice/new',
      method: "POST",
      dataType: 'json',
      data: dataObj
    })
    .done(function(returnedJson){
      if (returnedJson.urls.length > 0) {
        self.props.updateState(returnedJson.urls);
        self.props.updateTemplateId(returnedJson.template_id);
      } else {
        // TODO: load error screen
        console.log("there was a problem");
      }
    })
    .fail(function(returnedJson) {
      console.log("failed");
    });
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
    var horizontal_class;
    var vertical_class;
    var showLoadingOverlay;

    if (this.state.clickType == "horizontal") {
      horizontal_class = "dark-button slice-tool-button";
      vertical_class = "white-button slice-tool-button";
    } else {
      horizontal_class = "white-button slice-tool-button";
      vertical_class = "dark-button slice-tool-button";
    }

    if (this.state.makingRequest == true) {
      showLoadingOverlay = <LoadingScreenOverlay/>;
    } else {
      showLoadingOverlay = '';
    }

    console.log(this.state.data);
      return (
        <div className="slice-tool-container">
          {showLoadingOverlay}

          <div className="slice-tool-left-rail">
            <div className="slice-tool-left-rail-button-container">
              <div className={horizontal_class} id="horizontal" onClick={this.handleClickType}>Horizontal</div>
              <div className={vertical_class} id="vertical" onClick={this.handleClickType}>Vertical</div>
              <div className="slice-tool-small-button-container">
                <div className="slice-tool-small-button" onClick={this.handleReset}>Reset</div>
                <div className="slice-tool-small-button" onClick={this.handleUndo}>Undo</div>
              </div>
              <div className="white-dark-border-button slice-tool-button" onClick={this.handleSlicePost}>Submit to server</div>
            </div>
          </div>

          <div className="slice-tool-right-email-container">
            <canvas id="canvas" height={this.state.imageHeight} width={this.state.imageWidth} onClick={this.handleCanvasClick} style={canvasStyle}></canvas>
          </div>

        </div>
      );
    }
});
