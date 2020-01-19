pragma solidity 0.5.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GrantsDAO {

  struct Proposal {
    bool active;
    uint256 amount;
  }

  uint256 public counter = 1;
  IERC20 public SNX;

  mapping(uint256 => Proposal) public proposals;
  mapping(address => bool) public teamSigners;
  mapping(address => bool) public communitySigners;

  event NewProposal(uint256 amount);

  constructor(
    address _snx,
    address[] memory _teamSigners,
    address[] memory _communitySigners
  ) public {
    for (uint i = 0; i < _teamSigners.length; i++) {
      teamSigners[_teamSigners[i]] = true;
    }
    for (uint i = 0; i < _communitySigners.length; i++) {
      communitySigners[_communitySigners[i]] = true;
    }

    SNX = IERC20(_snx);
  }

  function createProposal(uint256 _amount) external onlyProposer() {
    require(_amount <= SNX.balanceOf(address(this)), "Invalid funds on DAO");
    proposals[counter] = Proposal(false, _amount);
    counter++;
    emit NewProposal(_amount);
  }

  modifier onlyProposer() {
    require(
      teamSigners[msg.sender] ||
      communitySigners[msg.sender],
      "Not proposer"
    );
    _;
  }
}
