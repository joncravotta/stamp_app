var SliceToolUploader = React.createClass({
  getInitialState: function() {
    return {
      file: '',
      image: '',
      emailName: '',
      imageWidth:0,
      imageHeight:0,
      emailNameValid: false,
      uploadValid: false,
      showEmailError: false,
      showUploadError: false
    };
  },

  handleEmailNameChange: function(event) {
    this.setState({emailName: event.target.value});

    if (event.target.value){
      this.setState({emailNameValid: true});
      this.setState({showEmailError: false});
    } else {
      this.setState({emailNameValid: false});
    }
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
      self.setState({uploadValid: true});
      self.setState({showUploadError: false});
      self.setState({file: file, image: reader.result});
    };
    reader.readAsDataURL(file);
  },

  handleSubmitButton: function() {
    if (this.state.emailNameValid == false) {
      this.setState({showEmailError: true});
    } else {
      this.setState({showEmailError: false});
    }

    if (this.state.uploadValid == false) {
      this.setState({showUploadError: true});
    } else {
      this.setState({showUploadError: false});
    }

    if (this.state.emailNameValid == true && this.state.uploadValid == true) {
      console.log('should be valid');
      this.props.updateUpload(this.state.file, this.state.image, this.state.imageWidth, this.state.imageHeight, this.state.emailName);
      this.props.updateState();
    }
  },

  renderErrorIcon: function() {
    return (<div className="slice-tool-container-inputs-error">✕</div>);
  },

  renderSuccessIcon : function() {
    return (<div className="slice-tool-container-inputs-success">✓</div>);
  },

  render: function() {
    var showEmailErrorIcon;
    var showUploadErrorIcon;

    if (this.state.showEmailError == true) {
      showEmailErrorIcon = this.renderErrorIcon();
    } else {
      showEmailErrorIcon = <span></span>;
    }

    if (this.state.showUploadError == true) {
      showUploadErrorIcon = this.renderErrorIcon();
    } else if (this.state.uploadValid == true) {
      showUploadErrorIcon = this.renderSuccessIcon();
    } else {
      showEmailErrorIcon = <span></span>;
    }

    return(
      <div className="slice-tool-container-inputs">
        <div className="slice-component-container">
          {showEmailErrorIcon}
          <input className="input-lg" placeholder="Email Name" type="text" onChange={this.handleEmailNameChange} />
        </div>
        <div className="slice-component-container">
          {showUploadErrorIcon}
          <span className="subtitle">Upload your email design</span>
          <span className="subtitle">(JPG, JPEG, PNG)</span>
          <label className="fileContainer">
            Upload
            <input type="file" onChange={this.handleFile}/>
          </label>
        </div>
        <div className="dark-button" onClick={this.handleSubmitButton}>Submit</div>
      </div>
    );
  }
});
