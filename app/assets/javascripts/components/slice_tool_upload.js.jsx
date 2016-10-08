var SliceToolUploader = React.createClass({
  getInitialState: function() {
    return {
      file: '',
      image: '',
      imageWidth:0,
      imageHeight:0
    };
  },

  updateUpload: function() {
    this.props.updateUpload(this.state.file, this.state.image, this.state.imageWidth, this.state.imageHeight);
    this.props.updateState();
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
  },

  render: function() {
    return(
      <div className="slice-tool-container">
        <input type="file" onChange={this.handleFile} />
        <div className="primary-button" onClick={this.updateUpload}>SLICE</div>
      </div>
    );
  }
});
