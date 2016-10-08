var SliceToolManager = React.createClass({
  getInitialState: function() {
    return {
      managerState: 0,
      emailImageFile: "",
      emailImage:"",
      emailHeight:0,
      emailWidth:0
    };
  },

  updateManagerState: function() {
    var newState = this.state.managerState + 1;
    this.setState({managerState: newState});
  },

  propUpdateUpload: function(file, image, width, height) {
    this.setState({
      emailImageFile: file,
      emailImage: image,
      emailWidth: width,
      emailHeight: height
    })
  },
  handleOrderState: function() {
    switch (this.state.managerState) {
      case 0:
        return (<SliceToolUploader updateUpload={this.propUpdateUpload} updateState={this.updateManagerState}/>);
      case 1:
          return (<SliceTool file={this.state.emailImageFile} image={this.state.emailImage} imageWidth={this.state.emailWidth} imageHeight={this.state.emailHeight}/>);
      default:
        break;
    }
  },
  render: function() {
    console.log(this.state.emailWidth);
      return (
        <div className="slice-manager-container">
          <SliceToolProgressBar/>
          {this.handleOrderState()}
        </div>
      );
    }
});
