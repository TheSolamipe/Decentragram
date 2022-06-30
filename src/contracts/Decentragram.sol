pragma solidity ^0.5.0;

contract Decentragram {
    string public name = "Decentragram";

    // Store Images
    uint256 public imageCount = 0;
    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    // Create Posts
    function uploadImage(string memory _imgHash, string memory _description)
        public
    {
        //make sure the image hash exists
        require(bytes(_imgHash).length > 0);

        //make sure the image description exists
        require(bytes(_description).length > 0);

        //make sure the Uploader address exists
        require(msg.sender != address(0x0));

        //Increment image id
        imageCount++;

        // Add Image to contract
        images[imageCount] = Image(
            imageCount,
            _imgHash,
            _description,
            0,
            msg.sender
        );

        //Trigger an event
        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
    }

    // Tip Images
    function tipImageOwner(uint256 _id) public payable {
        //Make sure the id is valid
        require(_id > 0 && _id <= imageCount);

        // fetch the Image
        Image memory _image = images[_id];

        // Fetch the author
        address payable _author = _image.author;

        // Pay the author by sending them ether
        address(_author).transfer(msg.value);

        // Increment the tip amount
        _image.tipAmount = _image.tipAmount + msg.value;

        // Update Image
        images[_id] = _image;

        // Trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
