// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;


contract Erc20 {
     uint256 private _totalSupply;

    string private _tokenname;
    string private _tokensymbol;
    uint256 private decimals = 18;


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
        balances[msg.sender] -= tokenAmount;
        balances[_spender] += tokenAmount;
        
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
    
        balances[_ownerAddress] -= tokenAmount;
        allowances[_ownerAddress][msg.sender] -= tokenAmount;
        balances[_reciever] += tokenAmount;


        emit TransferTokenFrom(_ownerAddress, _reciever, tokenAmount);
        return true;
    }


}
