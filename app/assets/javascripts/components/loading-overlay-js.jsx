var LoadingScreenOverlay = React.createClass({
  render: function() {
    return (
      <div className="loading-overlay-container">
        <div className="loading-overlay-blur"></div>
        <div className="loading-overlay">
          <div className="sk-three-bounce">
            <div className="sk-child sk-bounce1"></div>
            <div className="sk-child sk-bounce2"></div>
            <div className="sk-child sk-bounce3"></div>
          </div>
        </div>
      </div>
    );
  }
});
