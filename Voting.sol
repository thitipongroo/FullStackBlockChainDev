//SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.8.17;

contract Voting {
    address officialAddress;
    string[] public candidateList;
    mapping (string => uint256) votesReceived;
    mapping (address => bool) isVoted;
    enum State { Created, Voting, Ended }
    State public state;

    constructor(string[] memory candidateNames){
        officialAddress = msg.sender;
        candidateList = candidateNames;
        state = State.Created;
    }

    modifier onlyOfficial(){
        require(msg.sender == officialAddress, "Only Official");
        _;
    }

    modifier inState(State _state){
        require(state == _state);
        _;
    }

    function startVote() public inState(State.Created) onlyOfficial {
        state = State.Voting;
    }

    function endVote() public inState(State.Voting) onlyOfficial {
        state = State.Ended;
    }

    function candidateCount() public view returns (uint256) {
        return candidateList.length;
    }

    function voteForCandidate(string memory candidate) public inState(State.Voting){
        require(isVoted[msg.sender] == false, "Already Voted");
        isVoted[msg.sender] = true;
        votesReceived[candidate] += 1;
    }

    function totalVotesFor(string memory candidate) public inState(State.Ended) view returns (uint256){
        return votesReceived[candidate];
    }
}
