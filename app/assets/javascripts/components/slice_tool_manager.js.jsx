var SliceToolManager = React.createClass({
  getInitialState: function() {
    return {
      managerState: 0,
      user: this.props.user,
      emailImageFile: "",
      emailImage:"",
      emailHeight:0,
      emailWidth:0,
      emailName: '',
      returnedUrls: []
    };
  },

  updateManagerState: function() {
    var newState = this.state.managerState + 1;
    this.setState({managerState: newState});
  },

  updateManagerStateWithUrls: function(urls) {
    this.setState({returnedUrls: urls});
    var newState = this.state.managerState + 1;
    this.setState({managerState: newState});
  },

  propUpdateUpload: function(file, image, width, height, emailName) {
    this.setState({
      emailImageFile: file,
      emailImage: image,
      emailWidth: width,
      emailHeight: height,
      emailName: emailName
    })
  },

  handleOrderState: function() {
    switch (this.state.managerState) {
      case 0:
        return (<SliceToolUploader updateUpload={this.propUpdateUpload} updateState={this.updateManagerState}/>);
      case 1:
        return (<SliceTool updateState={this.updateManagerStateWithUrls} file={this.state.emailImageFile} image={this.state.emailImage} imageWidth={this.state.emailWidth} imageHeight={this.state.emailHeight}/>);
      case 2:
        return (<CodeTool urls={this.state.urls} user={this.state.user} urls={this.state.returnedUrls} emailWidth={this.state.emailWidth}/>);
      default:
        break;
    }
  },
  render: function() {
      return (
        <div className="slice-manager-container">
          <SliceToolProgressBar/>
          {this.handleOrderState()}
        </div>
      );
    }
});
