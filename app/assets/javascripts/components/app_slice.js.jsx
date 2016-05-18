var AppSlice = React.createClass({
  getInitialState: function() {
    return {
      poppedUp: false,
      hasChanged: false
    };
  },

  activatePopup: function() {
    this.setState({poppedUp: true});
    this.setState({hasChanged: true});
  },

  deactivatePopup: function() {
    this.setState({poppedUp: false});
  },

  handleAhrefChange: function(event) {
    var value = event.target.value;
    this.props.updateAhrefState(this.props.id, value);
  },

  handleAltTagChange: function(event) {
    var value = event.target.value;
    this.props.updateAltTagState(this.props.id, value);
  },
  // TODO This can be done without the if else statment
  renderDisplay: function() {
    if (this.state.hasChanged){
      return (
        <img onClick={this.activatePopup} key={this.props.key} altTag={this.props.altTag} ahref={this.props.ahref} src={this.props.imageUrl} className="has-changed-border" />
      );
    }
    else {
      return (
        <img onClick={this.activatePopup} key={this.props.key} altTag={this.props.altTag} ahref={this.props.ahref} src={this.props.imageUrl} />
      );
    }
  },

  render: function() {
    if (this.state.poppedUp) {
      return (
        <div className="overlay">
          <div className="left-side-form">
            <label className="control-label">Link</label>
            <input type="text" value={this.props.ahref} onChange={this.handleAhrefChange} />
            <label className="control-label padding-top-20px">Alt</label>
            <textarea type="text" value={this.props.altTag} key={this.props.key} onChange={this.handleAltTagChange} rows="4" cols="50" />
            <div className="submit-btn" onClick={this.deactivatePopup}>DONE</div>
          </div>
          <img src={this.props.imageUrl} />
        </div>
      );
    }
    else {
      return this.renderDisplay();
    }
  }
});
