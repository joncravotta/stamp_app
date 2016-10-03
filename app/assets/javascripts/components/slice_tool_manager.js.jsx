var SliceToolManager = React.createClass({
  getInitialState: function() {
    return {
      managerState: 0
    };
  },
  render: function() {
      return (
        <div class="slice-manager-
          container">
          <SliceToolUploader/>
          <SliceToolProgressBar/>
        </div>
      );
    }
});
