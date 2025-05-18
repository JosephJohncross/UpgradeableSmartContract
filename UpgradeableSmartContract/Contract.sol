// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;


/**
    @title Implementation contract - version 1
    @notice This contracts contains the implementation logic for the smart contract
*/
contract ImpementationContractV1 {
    uint256 public num;

    /**
        @notice Set the value of the internal variable - could act as the initializer or whatever, since a constructor in the implementation code is always considered unsafe
        @param _num value of which should be set
    */
    function setValue (uint256 _num) virtual external {
        num =_num;    
    }

    /**
        @notice Return the value of the state variable num
        @return Value of the state variable num
    */
    function getValue() external  view returns (uint256){
        return num;
    }
}



/**
    @title Implementation contract - version 2
    @notice This contracts contains the implementation logic for the smart contract
*/
contract ImplementationContractV2 is ImpementationContractV1{

    /** Changes the implementation logic for this function, inerited from the parent contract */
    function setValue (uint256 _num) override  external {
        num = _num ** 2;
    }
}




/**
    @title Abstract contract to proxy another contract
    @notice This contarct acts as a proxy, all storage and balance for the refrenced implementation contract
*/
contract ProxyContract {
    address public implementationAddress;
    address public admin;
     
   /**
        @notice Constructor
        @param _implementationAddress Address of the implementation contract
    */
    constructor(address _implementationAddress) {
         implementationAddress = _implementationAddress;
         admin = msg.sender;
     }
     
     
   /**
       @notice Admin can set implementation contract address
       @param _newImplementationAddress Address of the new Implementaion Contract
    */
    function upgrade (address _newImplementationAddress) external  {
        require(msg.sender == admin, "Only admin can call this function");
        implementationAddress = _newImplementationAddress;
    }
    
    /**
        @notice Fallback function to delegates the execution to implementation contract   
    */
    fallback() external {
        if (msg.sender == admin) {
            revert("Admin cannot interact with logic contract directly");
        }

        (bool success, ) = implementationAddress.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }
}