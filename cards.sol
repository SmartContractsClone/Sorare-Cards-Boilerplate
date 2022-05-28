// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IIPLData {

    function getClub(uint8 clubId) external view 
        returns (
            uint8 id,
            string memory name,
            string memory city
        );
    
    function getPlayer(uint playerId) external view
        returns (
            uint id,
            string memory name,
            string memory country,
            uint16 byear,
            uint8 bmonth,
            uint8 bdate
        );  

    function checkPlayerexists(uint _id) external view returns(bool);
    function checkClubexists(uint8 _id) external view returns(bool);

}


contract ModeratorAccess is Ownable {

    address private _moderator;

    event ModeratorChanged(address indexed previousModerator, address indexed newModerator);

    function setModerator(address _newModerator) public onlyOwner returns(bool) {
        require(_newModerator!= address(0),"ModeratorAccess: New Moderator is the Zero address");
        emit ModeratorChanged(_moderator, _newModerator);
        _moderator = _newModerator;
        return true;
    }

    modifier onlyModerator() {
        require(Moderator() == _msgSender(), "ModeratorAccess: caller is not the Moderator");
        _;
    }

    function Moderator() public view virtual returns (address) {
        return _moderator;
    }

}

contract IPLCards is ERC721URIStorage, ModeratorAccess,IIPLData {
    using SafeMath for uint256;

    struct Card {

        uint256 cardId;
        string cardType;
        uint16 season;
        uint playerId;
        uint8 clubId;
        string metadata;
        
    }

    IIPLData private IPLData;

    uint internal totalCards;

    mapping (uint => Card) internal cards;    

    constructor(address _moderator,address IPLDataAddress) ERC721("IPLCards", "IPLC")  {
        require(IPLDataAddress != address(0),"IPLData address is required");
        require(_moderator != address(0),"Moderator address is required");

        IPLData = IIPLData(IPLDataAddress);
        setModerator(_moderator);
    }

    function checkPlayerexists(uint _id) public view returns(bool) {
        return(IPLData.checkPlayerexists(_id));
    }

    function checkClubexists(uint8 _id) public view returns(bool) {
        return(IPLData.checkClubexists(_id));
    }

    function mintCards(Card[] memory _cards) public {

        for (uint i = 0; i < _cards.length; ++i) {

            require(checkPlayerexists(_cards[i].playerId),"IPLCards player does not exist");
            require(checkClubexists(_cards[i].clubId),"IPLCards club does not exist");

            totalCards = totalCards.add(1);
            _cards[i].cardId = totalCards;
            cards[totalCards] = _cards[i];

            _mint(Moderator(), totalCards);
            _setTokenURI(totalCards, _cards[i].metadata);
        }
        
    }

    function getPlayer(uint _id) public view returns (
            uint id,
            string memory name,
            string memory country,
            uint16 byear,
            uint8 bmonth,
            uint8 bdate
        )

        {
            (id,name, country,byear,bmonth,bdate) = IPLData.getPlayer(_id);
        }

    function getClub(uint8 _id) public view returns (
            uint8 id,
            string memory name,
            string memory city
        )

        {
            (id,name, city) = IPLData.getClub(_id);
        }


    function getCard(uint _id)
        public        
        view
        returns (
            uint256 cardId,
            string memory cardType,
            uint16 season,
            uint playerId,
            uint8 clubId,
            string memory metadata
            )
    {
        require(checkCardexists(_id), "IPLCards: Card with that token ID does not exists");
        (cardId,cardType, season,playerId,clubId,metadata) = (cards[_id].cardId,cards[_id].cardType,cards[_id].season,cards[_id].playerId,cards[_id].clubId,cards[_id].metadata);
    }

    function totalSupply() public view returns (uint) {
        return totalCards;
    }

    function checkCardexists(uint _id) public view returns(bool) {
        if(cards[_id].cardId == 0){
            return false;
        }
        return true;
    }

}
