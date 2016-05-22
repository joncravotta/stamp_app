var App = React.createClass({
  getInitialState: function() {
    return {
      urlPath: '',
      emailWidth: '600',
      showSlices: false,
      showLoadingIcon: true,
      showCodeBox: false,
      codeBuildResponse: '',
      emailObject: {},
      apiObj: {}
    };
  },

  submitSlices: function() {
    this.setState({showSlices: true});
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

  handleCodeBuildRequest: function() {
    var newApiObj = {};
    newApiObj.emailBody = this.state.emailObject;
    console.log(newApiObj);
    this.setState({showLoadingIcon: true});
    var self = this;
    $.ajax({
      url: '/build/new',
      method: "POST",
      data: newApiObj
    })
    .done(function(returnedJson){
      console.log(returnedJson.responseText);
      console.log('done');
      self.setState({codeBuildResponse: returnedJson});
    })
    .fail(function(returnedJson) {
      self.setState({showLoadingIcon: false});
      self.setState({showCodeBox: true});
      self.setState({codeBuildResponse: returnedJson.responseText});
    });
  },

  setObject: function() {
    console.log(this.state.emailObject);
    this.setState({sent: 1});
    var newApiObj = {};
    newApiObj.emailBody = this.state.emailObject;
    this.setState({apiObj: newApiObj});
  },

  codeEmail: function() {
    this.setObject();
    this.handleCodeBuildRequest();
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

  handleCodeBoxClose: function() {
    this.setState({showCodeBox: false});
  },

  renderLoadingIcon: function() {
    return (
      <div className="overlay-code-box">
        <div className="talk-bubble tri-right round btm-left">
          <div className="talktext">
            <p>Coding your email now!</p>
          </div>
        </div>
      </div>
    );
  },
  renderCodeBox: function() {
    return (
      <div className="overlay-code-box">
        <div className="code-box">
          <p>{this.state.codeBuildResponse}</p>
        </div>
        <div className="primary-button" onClick={this.handleCodeBoxClose}>CLOSE</div>
      </div>
    );
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
        <div className="primary-button margin-top-25px" onClick={this.handleCodeBuildRequest}>CODE</div>
      </div>
    );
  },
          // TODO needs to be named rebuild after the enail has been built
  render: function() {
    var slices;
    var codeBox;
    var loadingIcon;
    var rulerStyle = {
      width: (this.state.emailWidth) + 'px'
    };
    if (this.state.showSlices === true){
      slices = this.renderSlices();
    }
    if (this.state.showLoadingIcon === true){
      loadingIcon = this.renderLoadingIcon();
    }
    if (this.state.showCodeBox === true){
      codeBox = this.renderCodeBox();
    }

    return (
      <div className="app-container">
        <div className="input-fields">
          <form className="app-form-main" encType="multipart/form-data">
            <label className="control-label">Path to images</label>
            <input className="input" type="text" placeholder="http://www.yoursite.com/folder/images/" onChange={this.handleUrlPathChange}/>
            <div className="app-form-main-details">
              <div className="app-form-main-details-group">
                <label className="control-label">Email Width (pixels)</label>
                <input className="input" type="text" placeholder="600" onChange={this.handleEmailWidthChange}/>
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
        <div className="overlay-code-box-container">
          {loadingIcon}
          {codeBox}
        </div>
    </div>
    );
  }
});
