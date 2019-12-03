pragma solidity ^0.5.0;

contract Property{

    string public name = "PropertyToken";
    string public symbol = "RST";

    uint256 public tokenSupply;
    uint public propertyValue;
    address payable public ownerAddress;

    mapping(address => uint256) public balance;

    constructor(address payable _owner, uint _value, uint256 _supply) public {
        require(_value > 0, "property value has to be greater than 0");
        require(_supply > 0, "token supply has to be greater than 0");

        propertyValue = _value;
        tokenSupply = _supply;
        ownerAddress = _owner;

        balance[ownerAddress] = tokenSupply; //passando todos os tokens para o proprietario inicial do imovel



    }



    function buyTokens(address _buyer, uint256 _amount) public
    payable
        returns (bool)
    {   
        require(_amount > 0, "_amount has to be greater than 0");
        ownerAddress.transfer(getTokenPrice() * _amount);
        balance[_buyer] += _amount;
        balance[ownerAddress] -= _amount;

        return true;
    }

    function sellTokens(address payable _seller, uint256 _amount) public
    payable
        returns (bool)
    {   
        require(_amount > 0, "_amount has to be greater than 0");
        _seller.transfer(getTokenPrice() * _amount);
        balance[ownerAddress] += _amount;
        balance[_seller] -= _amount;

        return true;
    }


    function getTokenPrice() public view returns (uint256){
        return propertyValue/tokenSupply;
    }

    function getBalance(address x) public view returns (uint256){
        return balance[x];
    }
    



}