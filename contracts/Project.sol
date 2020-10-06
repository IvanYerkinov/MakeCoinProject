pragma solidity ^0.6.0;

//SPDX-License-Identifier: UNLICENSED

import "./SafeMath.sol";


contract Gratitude {

    using SafeMath for uint256;

    struct GradToken
    {
    string message;
    address creator;
    }

    GradToken[] public tokens;
    mapping (uint256 => address) public gradToOwner;
    mapping (address => uint256) ownerGradCount;
    mapping (address => uint256) ownerGradMade;

    function _createGrad(string memory _message) internal {
        tokens.push(GradToken(_message, msg.sender));
        uint256 id = tokens.length;
        id = id.sub(1);
        gradToOwner[id] = msg.sender;
        ownerGradMade[msg.sender] = ownerGradMade[msg.sender].add(1);
    }

    function sendGrad(address _from, address _to, uint256 _id) internal
    {
        require(msg.sender == gradToOwner[_id]);
        require(msg.sender == tokens[_id].creator);

        gradToOwner[_id] = _to;
        ownerGradCount[_to] = ownerGradCount[_to].add(1);
    }

    function transferGrad(address _to, uint256 _id) public
    {
        sendGrad(msg.sender, _to, _id);
    }

    function getLatestId() public view returns(uint256)
    {
        return tokens.length - 1;
    }

    function resendGrad(uint256 _id, address _from, address _to, string memory _newmessage) public
    {
        require(_from == gradToOwner[_id]);
        require(_from != tokens[_id].creator);

        GradToken memory grdtoken = tokens[_id];
        grdtoken.message = _newmessage;

        gradToOwner[_id] = _to;
        ownerGradCount[_to] = ownerGradCount[_to].add(1);
        ownerGradCount[_from] = ownerGradCount[_from].sub(1);
    }

    function getOwnerOfGrad(uint256 _id) public view returns(address)
    {
        return gradToOwner[_id];
    }

    function makeGrad(string memory message) public
    {
        require(ownerGradMade[msg.sender] <= ownerGradCount[msg.sender]);
        _createGrad(message);
    }

}
