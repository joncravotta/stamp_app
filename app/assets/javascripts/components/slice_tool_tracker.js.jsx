var SliceToolProgressBar = React.createClass({
  getInitialState: function() {
    return {
      statusState: 0
    };
  },

  componentWillReceiveProps: function() {
    this.setState({statusState: this.props.trackerState + 1});
  },

  showStatus: function() {
    var statusItems = [];
    var statusMaxCount = 3;
    var x = 0;
    for (var i = 0; i <= statusMaxCount; i++) {
      if (i < this.state.statusState){
        statusItems.push(<div key={i} className="status-bar-circle-completed"></div>);
      } else if (this.state.statusState == statusMaxCount) {
        statusItems.push(<div key={i} className="status-bar-circle-completed"></div>);
      } else if (i == this.state.statusState) {
        statusItems.push(<div key={i} className="status-bar-circle-active-outside"></div>);
      }  else {
        statusItems.push(<div key={i} className="status-bar-circle-incomplete"></div>);
      }
      if (i != statusMaxCount){
        if (i < this.state.statusState) {
          statusItems.push(<div className="status-bar-line-completed"></div>);
        } else {
          statusItems.push(<div className="status-bar-line-incomplete"></div>);
        }

      }
    }
    return(<div className="slice-tracker-container">{statusItems}</div>);
  },
  render: function() {
      return (
        <div className="slice-tracker-container">
          {this.showStatus()}
        </div>
      );
    }
});
