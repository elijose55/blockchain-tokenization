pragma solidity ^0.5.0;

contract Property{
	address[16] public adopters;

	

	string public name = "PropertyToken";
	string public symbol = "RST";
	uint8 public decimals = 3;
	uint public INITIAL_SUPPLY = 1000;

	uint256 public tokenSupply;
	uint public propertyValue;
	address payable public ownerAddress;
	uint256 public tokenPrice;

	mapping(address => uint256) balance;
	address[] internal tokenOwners;

	constructor(address payable _owner, uint _value, uint256 _supply) public {

		//_mint(_owner, _supply);  //passando todos os tokens para o proprietario inicial do imovel
		require(_value > 0, "property value has to be greater than 0");
		require(_supply > 0, "token supply has to be greater than 0");

		

		propertyValue = _value;
		tokenSupply = _supply;
		ownerAddress = _owner;

		balance[ownerAddress] = tokenSupply; //passando todos os tokens para o proprietario inicial do imovel



	}


    function transferTokens(address payable _seller, address _buyer, uint256 _amount) public
        returns (bool)
    {	

        //(bool hasToken, uint256 i) = hasToken(_seller);
        //_transfer(_seller, _buyer, _amount);
        require(_amount > 0);
        require(balance[_seller] >= _amount);
        


        _seller.transfer(getTokenPrice() * _amount);
        balance[_buyer] += _amount;
        balance[_seller] -= _amount;


        return true;
    }

    function buyTokens(address _buyer, uint256 _amount) public
    payable
        returns (bool)
    {	

        //(bool hasToken, uint256 i) = hasToken(_seller);
        //_transfer(_seller, _buyer, _amount);
        //require(balance[ownerAddress] >= _amount);
        //ownerAddress.transfer(getTokenPrice() * _amount);
        uint256 x = 1;
        ownerAddress.transfer(getTokenPrice() * _amount);
        balance[_buyer] += _amount;
        balance[ownerAddress] -= _amount;

        return true;
    }

    function sellTokens(address payable _seller, uint256 _amount) public
        returns (bool)
    {	

        //(bool hasToken, uint256 i) = hasToken(_seller);
        //_transfer(_seller, _buyer, _amount);
        require(balance[_seller] >= _amount);
        _seller.transfer(getTokenPrice() * _amount);
        balance[ownerAddress] += _amount;
        balance[_seller] -= _amount;

        return true;
    }


    function getTokenPrice() public view returns (uint256){
        return propertyValue/tokenSupply;
    }

    function hasToken(address _address)
        public
        view
        returns(bool, uint256)
    {
        for (uint256 i = 0; i < tokenOwners.length; i += 1){
            if (_address == tokenOwners[i]) return (true, i);
        }
        return (false, 0);
    }

    function addTokenOwner(address _address)
        public
    {
        (bool _hasToken, ) = hasToken(_address);
        if (!_hasToken) tokenOwners.push(_address);
    }

	// Adopting a pet
	function adopt(uint petId) public returns (uint) {
		require(petId >= 0 && petId <= 15);
		adopters[petId] = msg.sender;
		return petId;
	}

	// Retrieving the adopters
	function getAdopters() public view returns (address[16] memory) {
		return adopters;
	}

}