// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

library SafeMath { 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

contract Erc20 {
     uint256 private _totalSupply;

    string private _tokenname;
    string private _tokensymbol;
    uint256 private decimals = 18;

    using SafeMath for uint256;

    mapping(address => uint256) public  balances;
    mapping(address => mapping (address => uint256)) public allowances;

    event ApprovalToken(address indexed tokenOwner, address indexed spender, uint256 tokenAmount);
    event TransferTokenFrom(address indexed from, address indexed to, uint256 tokenAmount);
    event TransferToken(address indexed  from, address indexed  spender, uint256 tokenAmount);


    constructor(string memory _name, string memory _symbol) {
        _tokenname = _name;
        balances[msg.sender] = 100 * 10 ** decimals;
        _tokensymbol = _symbol;
    }

    function symbol() public view returns (string memory) {
        return _tokensymbol;
    }

    function name() public view returns (string memory) {
        return _tokenname;
    }

    function balanceOf(address ownerAddress) public view returns (uint) {
       return balances[ownerAddress];
    }

    
    function transfer(address _spender, uint256 tokenAmount) public returns (bool) {
        require(_spender != address(0), "Invalid address");
        require(tokenAmount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] = balances[msg.sender].sub(tokenAmount);
        balances[_spender] = balances[_spender].add(tokenAmount);
        
        emit TransferToken(msg.sender, _spender, tokenAmount);
        return true;
    }

    function approve(address _spender, uint256 _tokenAmount) public returns (bool) {
        require(_spender != address(0), "Invalid address");
        allowances[msg.sender][_spender] = _tokenAmount;
        emit ApprovalToken(msg.sender, _spender, _tokenAmount);
        return true;
    }

    function transferFrom(address _ownerAddress, address _reciever, uint tokenAmount) public returns (bool) {
        require(tokenAmount <= balances[_ownerAddress], "Insufficient Amount");    
        require(tokenAmount <= allowances[_ownerAddress][msg.sender], "Insucfficient allowance");
    
        balances[_ownerAddress] = balances[_ownerAddress].sub(tokenAmount);
        allowances[_ownerAddress][msg.sender] = allowances[_ownerAddress][msg.sender].sub(tokenAmount);
        balances[_reciever] = balances[_reciever].add(tokenAmount);


        emit TransferTokenFrom(_ownerAddress, _reciever, tokenAmount);
        return true;
    }


}
