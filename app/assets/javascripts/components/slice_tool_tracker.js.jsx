var SliceToolProgressBar = React.createClass({
  getInitialState: function() {
    return {
      trackerState: 0
    };
  },
  render: function() {
      return (
        <div className="slice-tracker-container">
          <div className="status-bar-circle-completed"></div>
          <div className="status-bar-line-completed"></div>
          <div className="status-bar-circle-completed"></div>
          <div className="status-bar-line-completed"></div>
          <div className="status-bar-circle-active-outside"><div className="status-bar-circle-active-inside"></div></div>
          <div className="status-bar-line-completed"></div>
          <div className="status-bar-circle-incomplete"></div>
          <div className="status-bar-line-completed"></div>
          <div className="status-bar-circle-incomplete"></div>
        </div>
      );
    }
});
