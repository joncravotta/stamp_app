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
        return (<SliceToolUploader updateUpload={this.propUpdateUpload}/>);
      default:
        break;
    }
  },
  render: function() {
      return (
        <div class="slice-manager-
          container">
          <SliceToolProgressBar/>
          {this.handleOrderState()}
        </div>
      );
    }
});
