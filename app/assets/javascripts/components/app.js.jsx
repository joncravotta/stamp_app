var App = React.createClass({
  getInitialState: function() {
    console.log(this.props.user);
    return {
      urlPath: this.props.user.url_path,
      emailWidth: this.props.user.email_width,
      header: this.props.user.header,
      headerCodeActive: this.props.user.header_active,
      footer: this.props.user.footer,
      footerCodeActive: this.props.user.footer_active,
      showSlices: false,
      showLoadingIcon: false,
      showCodeBox: false,
      codeBuildResponse: '',
      headerCodeBox: false,
      footerCodeBox: false,
      emailObject: {},
      apiObj: {}
    };
  },

  submitSlices: function() {
    if(Object.keys(this.state.emailObject).length === 0) {
      alert("Please upload images first");
    } else {
      this.setState({showSlices: true});
    }
  },

  handleSailthruForm: function() {
    this.setState({submitted: 2});
  },

  handleSubmit: function(e) {
    e.prevenDefault();
  },

  handleFile: function (e) {
    if (this.state.urlPath === "1" ) {
      alert("Please add a url path first.");
    } else {
      var files = e.target.files,
          url = this.state.urlPath,
          emailObjectInt = {},
          //creating email body object
          //each slice gets an obj
          key;
      for (var i = 0; i < files.length; i++) {
        key = 'slice'+ i;
        emailObjectInt[key] = {
          image: this.state.urlPath+files[i].name,
          ahref: "#",
          altTag: "",
        };
      }
      this.setState({emailObject: emailObjectInt});
    }
  },

  handleCodeBuildRequest: function() {
    var newApiObj = {};
    newApiObj.emailBody = this.state.emailObject;
    newApiObj.headerCodeActive = this.state.headerCodeActive;
    newApiObj.header = this.state.header;
    newApiObj.footerCodeActive = this.state.footerCodeActive;
    newApiObj.footer = this.state.footer;
    newApiObj.emailWidth = this.state.emailWidth;
    newApiObj.urlPath = this.state.urlPath;
    console.log(newApiObj);
    this.setState({showLoadingIcon: true});
    var self = this;
    $.ajax({
      url: '/build/new',
      method: "POST",
      dataType: 'text',
      data: newApiObj
    })
    .done(function(returnedJson){
      console.log(returnedJson.responseText);
      console.log(returnedJson);
      self.setState({showLoadingIcon: false});
      self.setState({showCodeBox: true});
      self.setState({codeBuildResponse: returnedJson});
    })
    .fail(function(returnedJson) {
      self.setState({showLoadingIcon: false});
      self.setState({showCodeBox: true});
      self.setState({codeBuildResponse: 'Sorry there was a problem proccessing your request. ERROR: ' + returnedJson.statusText});
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

  handleHeaderChange: function(event) {
    var value = event.target.value;
    this.setState({header: value});
  },

  handleHeaderCodeActive: function(event) {
    var value = event.target.checked;
    this.setState({headerCodeActive: value});
  },

  handleFooterChange: function(event) {
    var value = event.target.value;
    this.setState({footer: value});
  },

  handleFooterCodeActive: function(event) {
    var value = event.target.checked;
    this.setState({footerCodeActive: value});
  },

  handleEmailWidthChange: function(event) {
    var value = event.target.value;
    this.setState({emailWidth: value});
  },

  handleCodeBoxClose: function() {
    this.setState({showCodeBox: false});
  },

  handleFooterBoxOpen: function() {
    this.setState({footerCodeBox: true});
  },

  handeFooterBoxClose: function() {
    this.setState({footerCodeBox: false});
  },

  handleHeaderBoxOpen: function() {
    this.setState({headerCodeBox: true});
  },

  handleHeaderBoxClose: function() {
    this.setState({headerCodeBox: false});
  },

  renderHeaderCodeBox: function() {
    return (
      <div className="overlay-code-box">
          <h1 className="white-title">Header</h1>
          <textarea className="text-box" rows="20" onChange={this.handleHeaderChange} value={this.state.header} />
          <div className="code-box-checkbox">
            <label>Active</label>
            <input type="checkbox" onChange={this.handleHeaderCodeActive} checked={this.state.headerCodeActive}/>
          </div>
          <div className="primary-button" onClick={this.handleHeaderBoxClose}>CLOSE</div>
      </div>
    );
  },

  renderFooterCodeBox: function() {
    return (
      <div className="overlay-code-box">
        <h1 className="white-title">Footer</h1>
        <textarea className="text-box" rows="20" onChange={this.handleFooterChange} value={this.state.footer} />
        <div className="code-box-checkbox">
          <label>Active</label>
          <input type="checkbox" onChange={this.handleFooterCodeActive} checked={this.state.footerCodeActive}/>
        </div>
        <div className="primary-button" onClick={this.handeFooterBoxClose}>CLOSE</div>
      </div>
    );
  },

  renderLoadingIcon: function() {
    return (
      <div className="overlay-code-box">
        <div className="talking-pigeon">
          <img className="pigeon-logo-talking" src={this.props.pigeon_src} />
          <div className="talk-bubble tri-right round btm-left">
            <div className="talktext">
              <p>Our finest piegeons are writing your code</p>
              <img className="loading-icon" src={this.props.loading_icon} />
            </div>
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
    var headerBox;
    var footerBox;
    var footerStatus;
    var headerStatus;
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

    if (this.state.headerCodeBox === true){
      headerBox = this.renderHeaderCodeBox();
    }

    if (this.state.footerCodeBox === true){
      footerBox = this.renderFooterCodeBox();
    }

    if (this.state.headerCodeActive === true){
      headerStatus = <div className="circle-add-button-active" onClick={this.handleHeaderBoxOpen}>✓</div>;
    } else {
    headerStatus = <div className="circle-add-button" onClick={this.handleHeaderBoxOpen}>+</div>;
    }

    if (this.state.footerCodeActive === true){
      footerStatus = <div className="circle-add-button-active" onClick={this.handleFooterBoxOpen}>✓</div>;
    } else {
    footerStatus = <div className="circle-add-button" onClick={this.handleFooterBoxOpen}>+</div>;
    }

    return (
      <div className="app-container">
        <div className="input-fields">
          <form className="app-form-main" encType="multipart/form-data">
            <label className="control-label">Path to images</label>
            <input className="input" type="text" value={this.state.urlPath} onChange={this.handleUrlPathChange}/>
            <div className="app-form-main-header">
              <div className="app-form-checkbox">
                <label>Header</label>
                {headerStatus}
              </div>
              <div className="app-form-checkbox">
                <label>Footer</label>
                {footerStatus}
              </div>
              <div className="app-form-main-details-group">
                <label className="control-label">Email Width (pixels)</label>
                <input className="input" type="text" value={this.state.emailWidth} onChange={this.handleEmailWidthChange}/>
              </div>
              <input type="file" className="margin-top-25px" onChange={this.handleFile} multiple/>
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
          {headerBox}
          {footerBox}
        </div>
    </div>
    );
  }
});
