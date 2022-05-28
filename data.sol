// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

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

contract IPLData is ModeratorAccess {

    using SafeMath for uint256;

    uint8 public totalClubs;
    uint public totalPlayers;

    struct Club {

        uint8 id;
        string name;
        string city;
        
    }

    struct Player {

        uint id;
        string name;
        string country;
        uint16 byear;
        uint8 bmonth;
        uint8 bdate;
        
    }

    mapping (uint8 => Club) internal clubs;
    mapping (uint => Player) internal players;

    constructor(address _moderator) {
        require(_moderator != address(0),"Moderator address is required");
        setModerator(_moderator);
    }

    function createClubs(Club[] memory _clubs) public onlyModerator{
                
        for (uint8 i = 0; i < _clubs.length; ++i) {
            totalClubs = totalClubs + 1;
            _clubs[i].id = totalClubs;
            clubs[totalClubs] = _clubs[i];
        }        

    }

    function createPlayers(Player[] memory _players) public onlyModerator{
                
        for (uint i = 0; i < _players.length; ++i) {
            totalPlayers = totalPlayers.add(1);
            _players[i].id = totalPlayers;
            players[totalPlayers] = _players[i];
        }        

    }

    function getClub(uint8 clubId)
        public        
        view
        returns (
            uint8 id,
            string memory name,
            string memory city
            )
    {
        require(checkClubexists(clubId), "IPLData: Club with that token ID does not exists");
        (id,name, city) = (clubs[clubId].id,clubs[clubId].name,clubs[clubId].city);
    }

    function getPlayer(uint playerId)
        public        
        view
        returns (
            uint id,
            string memory name,
            string memory country,
            uint16 byear,
            uint8 bmonth,
            uint8 bdate
            )
    {
        require(checkPlayerexists(playerId), "IPLData: Player with that token ID does not exists");
        (id,name, country,byear,bmonth,bdate) = (players[playerId].id,players[playerId].name,players[playerId].country,players[playerId].byear,players[playerId].bmonth,players[playerId].bdate);
    }

    function checkPlayerexists(uint _id) public view returns(bool) {
        if(players[_id].id == 0){
            return false;
        }
        return true;
    }

    function checkClubexists(uint8 _id) public view returns(bool) {
        if(clubs[_id].id == 0){
            return false;
        }
        return true;
    }


}
