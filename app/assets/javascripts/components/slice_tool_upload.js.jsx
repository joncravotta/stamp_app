var SliceToolUploader = React.createClass({
  getInitialState: function() {
    return {
      file: '',
      imageWidth:0,
      imageHeight:0
    };
  },

  handleFile: function (event) {
    event.preventDefault();
    var reader = new FileReader();
    var file = event.target.files[0];
    var self = this;
    var height;
    var width;
    var image;
    var imgFile;

    reader.onload = function(){
      var img = new Image();
      img.onload = function() {
        height = img.width
        width = img.height;
      };
      img.src = reader.result;
      imgFile = file;
      image = reader.result;
    };
    this.props.updateUpload(imgFile, image, width, height);
    reader.readAsDataURL(file);
  },

  render: function() {
    return(
      <div className="slice-tool-container">
        <input type="file" onChange={this.handleFile} />
      </div>
    );
  }
});
