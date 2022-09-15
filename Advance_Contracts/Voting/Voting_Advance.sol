// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// 6 important points of any voting system
// ------------------------------
// 1. voting must be secret (use ether address)
// 2. one address = one vote
// 3. voters are eligable to vote. (person who deploys the contract dictates who gets to vote
// 4. transparency - rules must be transparent.
// 5. votes must be recorded and counted
// 6. reliable, no frauds.

contract VotingSystem {

    // VARIABLES
    struct vote {
        address voterAddress;
        // yay or nay
        bool choice;
    }

    struct voter {
        string voterName;
        // did the voter voted or not
        bool voted;
    }

    // count the votes
    uint private countResult = 0;
    uint public finalResult= 0;
    uint public totalVoter = 0;
    uint public totalVote = 0;

    // address of ballot
    address public ballotOfficialAddress;
    string public ballotOfficialName;
    string public proposal;

    mapping(uint => vote) private votes;
    mapping(address => voter) public voterRegister;

    // states of ballot
    enum State {
        Created,
        Voting,
        Ended
    }

    State public state;

    // MODIFIERS
    modifier condition(bool _condition){
        require(_condition);
        _;
    }

    modifier onlyOfficial(){
        require(msg.sender == ballotOfficialAddress);
        _;
    }

    modifier inState(State _state){
        require(state == _state);
        _;
    }


    // FUNCTIONS
    constructor(string memory _ballotOfficialName, string memory _proposal){
        ballotOfficialAddress = msg.sender;
        ballotOfficialName = _ballotOfficialName;
        proposal = _proposal;

        state = State.Created;
    }

    // creator of ballot adds voter addresses one by one
    function addVoter(address _voterAddress, string memory _voterName) public inState(State.Created) onlyOfficial {
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoter++;
    }

    // creator starts the ballot
    function startVote() public inState(State.Created) onlyOfficial{
        state = State.Voting;
    }

    // voter chooses, true or false
    function doVote(bool _choice) public inState(State.Voting) returns(bool voted){
        // first check if the voter is in the voter registry && voter hasnt voted yet
        bool found = false;
        if(bytes(voterRegister[msg.sender].voterName).length != 0 && !voterRegister[msg.sender].voted){
            voterRegister[msg.sender].voted = true;
            vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;

            if(_choice){
                // we only count true values (yay)
                countResult++;
            }
            votes[totalVote] = v;
            totalVote++;
            found = true;
        }
        return found;
    }

    function endVote() public inState(State.Voting) onlyOfficial{
        state = State.Ended;
        finalResult = countResult;
    }



}
