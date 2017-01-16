var SliceToolManager = React.createClass({
  getInitialState: function() {
    return {
      managerState: this.props.manager_state,
      trackerState: this.props.tracker_state,
      user: this.props.user,
      emailImageFile: "",
      emailImage:"",
      emailHeight:0,
      emailWidth:this.props.email_width,
      emailName: this.props.email_name,
      returnedUrls: this.props.returned_urls,
      templateId: this.props.template_id
    };
  },

  updateManagerState: function() {
    var newState = this.state.managerState + 1;
    this.setState({managerState: newState});
    this.setState({trackerState: newState});
  },

  updateManagerStateWithUrls: function(urls) {
    this.setState({returnedUrls: urls});
    var newState = this.state.managerState + 1;
    this.setState({managerState: newState});
    this.setState({trackerState: newState});
  },

  updateTrackerState: function() {
    var newState = this.state.trackerState + 1;
    this.setState({trackerState: newState});
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

  updateTemplateId: function(templateId) {
    this.setState({
      templateId: templateId
    })
  },

  handleOrderState: function() {
    switch (this.state.managerState) {
      case 0:
        return (<SliceToolUploader updateUpload={this.propUpdateUpload} updateState={this.updateManagerState}/>);
      case 1:
        return (<SliceTool updateTemplateId={this.updateTemplateId} userId={this.state.user.id} updateState={this.updateManagerStateWithUrls} file={this.state.emailImageFile} image={this.state.emailImage} imageWidth={this.state.emailWidth} imageHeight={this.state.emailHeight} emailName={this.state.emailName}/>);
      case 2:
        return (<CodeTool templateId={this.state.templateId} user={this.state.user} urls={this.state.returnedUrls} emailWidth={this.state.emailWidth} updateState={this.updateTrackerState} name={this.state.emailName} />);
      default:
        break;
    }
  },
  render: function() {
      return (
        <div className="slice-manager-container">
          <SliceToolProgressBar trackerState={this.state.trackerState}/>
          {this.handleOrderState()}
        </div>
      );
    }
});
