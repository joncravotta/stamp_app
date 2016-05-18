var App = React.createClass({
  getInitialState: function() {
    return {
      submitted: 0,
      urlPath: '',
      emailWidth: '600',
      emailObject: {}
    };
  },

  submitSlices: function() {
    this.setState({submitted: 1});
  },

  handleSailthruForm: function() {
    this.setState({submitted: 2});
  },

  handleSubmit: function(e) {
    e.prevenDefault();
  },

  handleFile: function (e) {
    var files = e.target.files,
        url = this.state.urlPath,
        emailObjectInt = {},
        //creating email body object
        //each slice gets an obj
        key;
    for (var i = 0; i < files.length; i++) {
      key = 'slice'+ i;
      emailObjectInt[key] = {
        image: url+files[i].name,
        ahref: "#",
        altTag: "",
      };
    }
    this.setState({emailObject: emailObjectInt});
  },

  handleSliceAltTagUpdate: function(key, value) {
    var emailObjectNew = this.state.emailObject;
    emailObjectNew[key].altTag = value;
    this.setState({emailObject: emailObjectNew});
  },

  handleSliceAhrefUpdate: function(key, value) {
    var emailObjectNew = this.state.emailObject;
    emailObjectNew[key].ahref = value;
    this.setState({emailObject: emailObjectNew});
  },

  handleUrlPathChange: function(event) {
    var value = event.target.value;
    this.setState({urlPath: value});
  },

  handleEmailWidthChange: function(event) {
    var value = event.target.value;
    this.setState({emailWidth: value});
  },

  renderSlices: function() {
    var mapObj = this.state.emailObject,
        item,
        ahrefState = this.handleSliceAhrefUpdate,
        altTagState = this.handleSliceAltTagUpdate;
    var slicesLoop = Object.keys(mapObj).map(function (key) {
      item = mapObj[key];
      return <AppSlice key={key} id={key} altTag={item.altTag} ahref={item.ahref} imageUrl={item.image} updateAhrefState={ahrefState} updateAltTagState={altTagState}/>;
    });
    return (
      <div className="slices-container">
        {slicesLoop}
        <div className="submit-btn centered-submit-btn margin-top-26px" onClick={this.handleSailthruForm}>CODE</div>
      </div>
    );
  },
          // TODO needs to be named rebuild after the enail has been built
  render: function() {
    var slices;
    var rulerStyle = {
      width: (this.state.emailWidth) + 'px'
    };
    if (this.state.submitted == 1){
      slices = this.renderSlices();
    }
    return (
      <div className="app-container">
        <div className="input-fields">
          <form className="app-form-main" encType="multipart/form-data">
            <label className="control-label">Path to images</label>
            <input type="text" placeholder="http://www.yoursite.com/folder/images/" onChange={this.handleUrlPathChange}/>
            <div className="app-form-main-details">
              <div className="app-form-main-details-group">
                <label className="control-label">Email Width (pixels)</label>
                <input type="text" placeholder="600" onChange={this.handleEmailWidthChange}/>
              </div>
              <input type="file" onChange={this.handleFile} multiple/>
            </div>
          </form>
          <div className="primary-button" onClick={this.submitSlices}>BUILD</div>
        </div>
        <div className="width-ruler" style={rulerStyle}>
        {this.state.emailWidth} px
        </div>
        <div className="email-slices" style={rulerStyle}>
          {slices}
        </div>
    </div>
    );
  }
});
