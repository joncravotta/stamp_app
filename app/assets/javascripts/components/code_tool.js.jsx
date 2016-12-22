var CodeTool = React.createClass({
  getInitialState: function() {
    return {
      emailWidth: this.props.emailWidth,
      header: this.props.user.header,
      headerCodeActive: this.props.user.header_active,
      footer: this.props.user.footer,
      footerCodeActive: this.props.user.footer_active,
      urls: this.props.urls,
      showLoadingIcon: false,
      showCodeBox: false,
      codeBuildResponse: '',
      headerCodeBox: false,
      footerCodeBox: false,
      emailObject: {},
      apiObj: {}
    };
  },

  componentDidMount: function() {
    this.handleUrls();
  },
  // TODO Should change to handle urls, no need to access file
  handleUrls: function() {
    console.log('setting up urls')
    var  emailObjectInt = {};
    for (var i = 0; i < this.state.urls.length; i++) {
      var key = 'slice'+ i;
      emailObjectInt[key] = {
        image: this.state.urls[i],
        ahref: "#",
        altTag: "",
      };
    }
    this.setState({emailObject: emailObjectInt});
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
      self.props.updateState();
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
          <h1 className="dark-title margin-top-25px">Header</h1>
          <textarea className="text-box" rows="20" onChange={this.handleHeaderChange} value={this.state.header} />
          <div className="code-box-checkbox">
            <label>Active</label>
            <input type="checkbox" onChange={this.handleHeaderCodeActive} checked={this.state.headerCodeActive}/>
          </div>
          <div className="dark-button margin-top-25px" onClick={this.handleHeaderBoxClose}>CLOSE</div>
      </div>
    );
  },

  renderFooterCodeBox: function() {
    return (
      <div className="overlay-code-box">
        <h1 className="dark-title">Footer</h1>
        <textarea className="text-box" rows="20" onChange={this.handleFooterChange} value={this.state.footer} />
        <div className="code-box-checkbox">
          <label>Active</label>
          <input type="checkbox" onChange={this.handleFooterCodeActive} checked={this.state.footerCodeActive}/>
        </div>
        <div className="dark-button margin-top-25px" onClick={this.handeFooterBoxClose}>CLOSE</div>
      </div>
    );
  },

  renderLoadingIcon: function() {
    return (
      <LoadingScreenOverlay/>
    );
  },

  renderCodeBox: function() {
    return (
      <div className="overlay-code-box">
        <div className="code-box">
          {this.state.codeBuildResponse}
        </div>
        <div className="dark-button margin-top-25px" onClick={this.handleCodeBoxClose}>CLOSE</div>
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
      return <CodeToolSlice key={key} id={key} altTag={item.altTag} ahref={item.ahref} imageUrl={item.image} updateAhrefState={ahrefState} updateAltTagState={altTagState}/>;
    });
    return (

      <div className="slices-container">
        {slicesLoop}
      </div>
    );
  },
          // TODO needs to be named rebuild after the enail has been built
  render: function() {
    var slices = this.renderSlices();
    var codeBox;
    var loadingIcon;
    var headerBox;
    var footerBox;
    var footerStatus;
    var headerStatus;
    var rulerStyle = {
      width: (this.state.emailWidth) + 'px'
    };

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
      <div className="slice-tool-container">
        <div className="slice-tool-left-rail">
          <div className="slice-tool-left-rail-button-container">
            <div className="app-form-checkbox">
              <label>Header</label>
              {headerStatus}
            </div>
            <div className="app-form-checkbox">
              <label>Footer</label>
              {footerStatus}
            </div>
            <div className="white-dark-border-button slice-tool-button" onClick={this.handleCodeBuildRequest}>Code</div>
          </div>
        </div>
        <div className="slice-tool-right-email-container">
          <div className="email-slices" style={rulerStyle}>
            {slices}
          </div>
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
