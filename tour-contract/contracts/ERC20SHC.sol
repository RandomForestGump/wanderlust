//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.2 <=0.6.0;


interface IERC20 {


    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferSHC(address owner, address buyer, uint numTokens) external returns (bool);

    function approveMod(address sender,address delegate, uint numTokens) external  returns (bool) ;

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


contract ERC20SHC is IERC20 {

    string public constant name = "ShutterCoin";
    string public constant symbol = "SHC";
    uint8 public constant decimals = 2;  
   
    address ERCowner; //#1
    

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 totalSupply_;

    using SafeMath for uint256;


   constructor() public {  
	totalSupply_ = 10000000;
	balances[msg.sender] = totalSupply_;
	ERCowner = msg.sender; 
    }  

    function totalSupply() public view virtual override returns (uint256) {
	return totalSupply_;
    }
    
    function balanceOf(address tokenOwner) public  view  virtual override returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public  virtual override  returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public  virtual override  returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public  virtual override  view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public virtual override  returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);
    
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
    
    //#3
    function close() public { 
        require(msg.sender == ERCowner);
        selfdestruct(msg.sender); 
     }

function transferSHC(address owner, address buyer, uint numTokens) public  virtual override returns (bool) {
        require(numTokens <= balances[owner]);    
        balances[owner] = balances[owner].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    
    }
 function approveMod(address sender,address delegate, uint numTokens) public  virtual override returns (bool) {
        allowed[sender][delegate] = numTokens;
        emit Approval(sender, delegate, numTokens);
        return true;
    }




 
}

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