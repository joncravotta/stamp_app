var LoadingScreenOverlay = React.createClass({
  render: function() {
    return (
      <div className="loading-overlay-container">
          <span className="loading-overlay-cta">{this.props.loadingCta}</span>
          <div id="pictureframe">
            <div id="bird">
              <div id="body2"></div>
              <div id="body1"></div>
              <div id="wing-l"></div>
              <div id="wing-r"></div>
            </div>
            <div id="shadow"></div>
        </div>
      </div>
    );
  }
});
