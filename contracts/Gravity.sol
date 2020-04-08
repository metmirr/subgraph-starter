pragma solidity ^0.4.0;


contract GravatarRegistry {
    event NewGravatar(
        uint256 id,
        address owner,
        string displayName,
        string imageUrl
    );
    event UpdatedGravatar(
        uint256 id,
        address owner,
        string displayName,
        string imageUrl
    );
    event NextID(uint256 id, string description);

    struct Gravatar {
        address owner;
        string displayName;
        string imageUrl;
    }

    Gravatar[] public gravatars;

    mapping(uint256 => address) public gravatarToOwner;
    mapping(address => uint256) public ownerToGravatar;
    uint256 public nextId = 0;

    function createGravatar(string _displayName, string _imageUrl) public {
        require(ownerToGravatar[msg.sender] == 0);
        uint256 id = gravatars.push(
            Gravatar(msg.sender, _displayName, _imageUrl)
        ) - 1;

        gravatarToOwner[id] = msg.sender;
        ownerToGravatar[msg.sender] = id;
        nextId = id + 1;
        emit NextID(nextId, "A new Gravatar created, next ID is");

        emit NewGravatar(id, msg.sender, _displayName, _imageUrl);
    }

    function getNextId() external returns (uint256) {
        emit NextID(nextId, "Get next id");
        return nextId;
    }

    function getGravatar(address owner) public view returns (string, string) {
        uint256 id = ownerToGravatar[owner];
        return (gravatars[id].displayName, gravatars[id].imageUrl);
    }

    function updateGravatarName(string _displayName) public {
        require(ownerToGravatar[msg.sender] != 0);
        require(msg.sender == gravatars[ownerToGravatar[msg.sender]].owner);

        uint256 id = ownerToGravatar[msg.sender];

        gravatars[id].displayName = _displayName;
        emit UpdatedGravatar(
            id,
            msg.sender,
            _displayName,
            gravatars[id].imageUrl
        );
    }

    function updateGravatarImage(string _imageUrl) public {
        require(ownerToGravatar[msg.sender] != 0);
        require(msg.sender == gravatars[ownerToGravatar[msg.sender]].owner);

        uint256 id = ownerToGravatar[msg.sender];

        gravatars[id].imageUrl = _imageUrl;
        emit UpdatedGravatar(
            id,
            msg.sender,
            gravatars[id].displayName,
            _imageUrl
        );
    }

    // the gravatar at position 0 of gravatars[]
    // is fake
    // it's a mythical gravatar
    // that doesn't really exist
    // dani will invoke this function once when this contract is deployed
    // but then no more
    function setMythicalGravatar() public {
        require(msg.sender == 0x8d3e809Fbd258083a5Ba004a527159Da535c8abA);
        gravatars.push(Gravatar(0x0, " ", " "));
    }
}
