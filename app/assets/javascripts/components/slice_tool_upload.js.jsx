var SliceToolUploader = React.createClass({
  getInitialState: function() {
    return {
      file: '',
      image: '',
      emailName: '',
      imageWidth:0,
      imageHeight:0
    };
  },

  updateUpload: function() {
    this.props.updateUpload(this.state.file, this.state.image, this.state.imageWidth, this.state.imageHeight);
    this.props.updateState();
  },

  handleEmailNameChange: function(event) {
    this.setState({emailName: event});
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
        <div className="slice-component-container">
          <input className="input-lg" placeholder="Email Name" type="text" onChange={this.handleEmailNameChange} />
        </div>
        <div className="slice-component-container">
          <span className="subtitle">Upload your email design</span>
          <span className="subtitle">and lets get slicin'</span>
          <label className="fileContainer">
            Upload
            <input type="file" onChange={this.handleFile}/>
          </label>
        </div>
      </div>
    );
  }
});
