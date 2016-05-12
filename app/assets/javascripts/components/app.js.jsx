var App = React.createClass({
  getInitialState: function() {
    return {
      imagePath: '',
      emailWidth: '',
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
        url = 'https://cdn.rtrcdn.com/sites/default/files/sailthru/campaigns/' + this.state.yearSelector + '/' + this.state.monthSelector + '/',
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

  handleSliceAltTagState: function(key, value) {
    var emailObjectNew = this.state.emailObject;
    emailObjectNew[key].altTag = value;
    this.setState({emailObject: emailObjectNew});
  },

  handleSliceAhrefState: function(key, value) {
    var emailObjectNew = this.state.emailObject;
    emailObjectNew[key].ahref = value;
    this.setState({emailObject: emailObjectNew});
  },
/*
  renderSlices: function() {
    var mapObj = this.state.emailObject,
        item,
        ahrefState = this.handleSliceAhrefState,
        altTagState = this.handleSliceAltTagState;
    var slicesLoop = Object.keys(mapObj).map(function (key) {
      item = mapObj[key];
      return <ImageSlice key={key} id={key} altTag={item.altTag} ahref={item.ahref} imageUrl={item.image} updateAhrefState={ahrefState} updateAltTagState={altTagState}/>;
    });
    return (
      <div className="slices-container">
        {slicesLoop}
        <div className="submit-btn centered-submit-btn margin-top-26px" onClick={this.handleSailthruForm}>SUBMIT CHANGES</div>
      </div>
    );
  },
*/
  render: function() {
    if (this.state.submitted == 1) {
      return this.renderSlices();
    }
    else if (this.state.submitted == 2) {
      return (
        <SailthruForm emailObject={this.state.emailObject} month={this.state.monthSelector} year={this.state.yearSelector} day={this.state.dayInput}/>
      );
    }
    else {
      return (
        <div className="input-fields">
          <form className="file-input-btn" encType="multipart/form-data">
            <input type="file" onChange={this.handleFile} multiple/>
          </form>
          <div className="submit-btn" onClick={this.submitSlices}>SUBMIT</div>
        </div>
      );
    }
  }
});
