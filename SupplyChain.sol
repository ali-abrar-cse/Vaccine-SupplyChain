// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

contract distribution{
    
    address addressTime;
    address addressMan;
    bool signIn = false;
    string signedAs;
    uint256[] hRequests;
    uint256[] pRequests;
    uint256 approval;
    uint256 m=0;
    uint256 l=0;
    
    uint256[] totalNo;
    uint256[] compTotalNo;
    
    struct recievedVaccine{
        uint256 rVID;
        uint256 batchNo;
        string rVname;
        uint256 vStorage;
        uint256 rDoseLimit;
        uint256 dTimestamp;
        uint256 rVexpire;
        uint256[] rFeedBack;
        uint256 dVendorID;
        mapping(uint256 => bool) approved;
        mapping(uint256 => bool) delivered;
    }
    
    //Vaccine Reciever Structure
    struct VaccineReciever{
        uint256 hID;
        string hName;
        bytes32 age;
        string photoUrl;
        string profession;
        uint256 NID;
        string hlocation;
        string hPassword;
        bool vaccineTaken;
        string vName;
        uint256 doseNo;
        string vaccinedBy;
        uint256 priority;
        uint256 pAge;
        uint256 phLocation;
        address wallet;
        mapping(uint256 => bool) hSignUp;
        mapping(uint256 => bool) HapprovedMap;
    }
    
    //centralAuthority
    struct authority{
        uint256 aID;
        string aName;
        string aPassword;
        /*string[] first;
        string[] second;
        string[] third;
        string[] fourth;
        string[] fifth;
        string[] sixth;
        string[] seventh;
        string[] eighth;
        string[] ninth;
        string[] tenth;*/
        mapping (uint256 => bool) aSignUp;
    }
    
    //vaccineProvider
    struct vaccineProvider{
        uint256 pID;
        string pName;
        string photoUrl;
        uint256 licenseNo;
        string plocation;
        string pPassword;
        address wallet;
        mapping (uint256 => bool) pSignUp;
        mapping(uint256 => bool) PapprovedMap;
    }
    
    VaccineReciever[] private holders;
    vaccineProvider[] private vProviders;
    authority[] private authorities;
    recievedVaccine[] private rVaccines;
    
    mapping(address => VaccineReciever) private hAdd;
    mapping(address => vaccineProvider) private vpAdd;
    mapping(address => authority) private aAdd;
    
    event holderSignedUp(uint256 _id2);
    event providerSignedUp(uint256 _id3);
    event authoritySignedUp(uint256 _id4);
    event shipmentConfirm(uint256 _id9);
    
    //set Distribution contract's address
    function setContractManufacture(address _addr) external {
        addressMan = _addr;
    }
    
    //set DateTime contract's address
    function setContractDateTime(address _addr) external {
        addressTime = _addr;
    }
    
    //Converting uint256 to bytes32
    function convertBytes(uint256 _age) public pure returns (bytes32) {
        return bytes32(_age);
    }
    
    //Converting bytes32 to uint256
    function convertUint(bytes32 _age) public pure returns (uint256) {
        return uint256(_age);
    }
    
    function hChecker(address addr) public view returns(uint256){
        uint256 h=0;
        
        while(h<holders.length)
        {
            if(hAdd[addr].hSignUp[h] == true)
            {
                break;
            }
            h++;
        }
        
        return(
            h
        );
    }
    
    function rChecker(address addr) public view returns(uint256){
        manufacture v = manufacture(addressMan);
        uint256 r=0;
        
        while(r<v.getResearcherLen())
        {
            if(v.getRsignUp(r,addr) == true)
            {
                break;
            }
            r++;
        }
        
        return(
            r
        );
    }
    
    function mChecker(address addr) public view returns(uint256){
        manufacture v = manufacture(addressMan);
        uint256 s=0;
        
        while(s<v.getManufacturerLen())
        {
            if(v.getMsignUp(s,addr) == true)
            {
                break;
            }
            s++;
        }
        
        return(
            s
        );
    }
    
    function tChecker(address addr) public view returns(uint256){
        manufacture v = manufacture(addressMan);
        uint256 t=0;
        
        while(t<v.getVendorLen())
        {
            if(v.getTsignUp(t,addr) == true)
            {
                break;
            }
            t++;
        }
        
        return(
            t
        );
    }
    
    function aChecker(address addr) public view returns(uint256){
        uint256 a=0;
        
        while(a<authorities.length)
        {
            if(aAdd[addr].aSignUp[a] == true)
            {
                break;
            }
            a++;
        }
        
        return(
            a
        );
    }
    
    function pChecker(address addr) public view returns(uint256){
        uint256 p=0;
        
        while(p<vProviders.length)
        {
            if(vpAdd[addr].pSignUp[p] == true)
            {
                break;
            }
            p++;
        }
        
        return(
            p
        );
    }
    
    //Holder Sign-Up (Goes to the holder interface)
    function hSignUp(string memory _hName, uint256 _age, string memory _photoUrl, string memory _profession, uint256 _nid, string memory _hlocation, string memory _password) public {
        
        manufacture v = manufacture(addressMan);
        
        uint256 h = hChecker(msg.sender);
        uint256 r = rChecker(msg.sender);
        uint256 a = aChecker(msg.sender);
        uint256 p = pChecker(msg.sender);
        //uint256 s = mChecker(msg.sender);
        //uint256 t = tChecker(msg.sender);
        
        require(bytes(_hName).length > 0, "Holder's name must not be kept empty");
        require(convertBytes(_age).length > 0, "Holder's age must not be kept empty");
        //require(bytes(_photoUrl).length > 0, "Holder's photo must not be kept empty");
        //require(bytes(_hlocation).length > 0, "Holder's location must not be kept empty");
        require(hAdd[msg.sender].hSignUp[h] == false, "This Holder account already exists.");
        require(v.getRsignUp(r,msg.sender) == false, "This account belongs to a Researcher.");
        //require(v.getMsignUp(s,msg.sender) == false, "This account belongs to a Manufacturer.");
        //require(v.getTsignUp(t,msg.sender) == false, "This account belongs to a Vendor.");
        require(vpAdd[msg.sender].pSignUp[p] == false, "This account belongs to a Vaccine Provider.");
        require(aAdd[msg.sender].aSignUp[a] == false, "This account belongs to a Authority");

        uint256 id2 = holders.length;

        VaccineReciever memory newHolder = VaccineReciever({
            hID: id2,
            hName: _hName,
            age: convertBytes(_age),
            photoUrl: _photoUrl,
            profession: _profession,
            NID: _nid,
            hlocation: _hlocation,
            hPassword: _password,
            vaccineTaken: false,
            vName: "None",
            doseNo: 0,
            vaccinedBy: "None",
            priority: 0,
            pAge: 1,
            phLocation: 1,
            wallet: msg.sender
        });

        holders.push(newHolder);
        emit holderSignedUp(id2);
        hAdd[msg.sender].hSignUp[id2] = true;
        hRequests.push(id2);
    }
    
    //Vaccine Reciever Feedback (Gooes to Vaccine Reciever interface)
    function holderFeedBack(uint256 _rVID, uint256 _feedbackRating) public {
        uint256 _id2 = hChecker(msg.sender);
        require(_id2 < holders.length && _id2 >= 0, "No Holder found");
        require((_rVID-1) < holders.length && _id2 >= 0, "No Vaccine found");
        require(holders[_id2].vaccineTaken==true, "Please, complete your vaccination before giving a Feedback.");
        
        rVaccines[_rVID-1].rFeedBack.push(_feedbackRating);
    }
    
    //View Vaccine Reciever Feedback (Gooes to Authority interface)
    function getHolderFeedBack(uint256 _rVID) public view returns(uint256[] memory) {
        
        return(
            rVaccines[_rVID-1].rFeedBack
        );
    }
    
    //Holder specifies the attributes which should be publicly visible (Goes to the holder interface)
    /*function holderPermission(uint256 _pAge, uint256 _phLocation) public{
        
        uint256 _id2 = hChecker(msg.sender);
        require(_id2 < holders.length && _id2 >= 0, "No Holder found");
        
        holders[_id2].pAge = _pAge;
        holders[_id2].phLocation = _phLocation;
    }
    
    //Getting the Age permission
    function getAgePermission(uint256 _id2) public view returns (uint256)
    {
        require(_id2 < holders.length && _id2 >= 0, "No Holder found");
        return(
            holders[_id2].pAge
        );
    }
    
    //Getting the Location permission
    function getLocationPermission(uint256 _id2) public view returns (uint256)
    {
        require(_id2 < holders.length && _id2 >= 0, "No Holder found");
        return(
            holders[_id2].phLocation
        );
    }*/
    
    //View Holder Profile (Goes to the holder interface)
    function getHolder(address addr) public view returns(string memory, string memory, uint256, uint256, string memory, string memory)
    {
        uint256 _id2 = hChecker(addr);
        require(_id2 < holders.length && _id2 >= 0, "No Holder found");
        
        return (
            holders[_id2].photoUrl,
            holders[_id2].hName,
            holders[_id2].hID,
            convertUint(holders[_id2].age),
            holders[_id2].hlocation,
            holders[_id2].profession
        );
    }
    
    // View vaccine taken Information (Goes to Holder Interface)
    function getVaccinationInfo(address addr) public view returns(string memory, bool, string memory, uint256, uint256, string memory){
        uint256 _hID = hChecker(addr);
        require(_hID < holders.length && _hID >= 0, "No Holder found");
        
        return(
            holders[_hID].hName,
            holders[_hID].vaccineTaken,
            holders[_hID].vName,
            holders[_hID].doseNo,
            holders[_hID].priority,
            holders[_hID].vaccinedBy
        );
    }
    
    //Verifier verifies holders DHP (Goes to the verifier interface)
    /*function verification(address addr) external view returns(string memory, uint256, string memory, string memory, bool, string memory)
    {
        uint256 _id2 = hChecker(addr);
        require(_id2 < holders.length && _id2 >= 0, "No Holder found");
        string memory perLocation = "Showing location is not permitted..!!!";
        
        uint256 _pAge = getAgePermission(_id2);
        uint256 _phLocation = getLocationPermission(_id2);
        
        
        if(_pAge == 0 && _phLocation == 0)
        {
                
            return(
                holders[_id2].hName,
                0,
                holders[_id2].photoUrl,
                perLocation,
                holders[_id2].vaccineTaken,
                holders[_id2].vaccinedBy
            );
        }
        else if(_pAge == 1 && _phLocation == 0)
        {
            return(
                holders[_id2].hName,
                convertUint(holders[_id2].age),
                holders[_id2].photoUrl,
                perLocation,
                holders[_id2].vaccineTaken,
                holders[_id2].vaccinedBy
            );
        }
        else if(_pAge == 0 && _phLocation == 1)
        {
            return (
                holders[_id2].hName,
                0,
                holders[_id2].photoUrl,
                holders[_id2].hlocation,
                holders[_id2].vaccineTaken,
                holders[_id2].vaccinedBy
            );
        }
        else
        {
            return (
                holders[_id2].hName,
                convertUint(holders[_id2].age),
                holders[_id2].photoUrl,
                holders[_id2].hlocation,
                holders[_id2].vaccineTaken,
                holders[_id2].vaccinedBy
            );
        }
    }*/
    
    //Vaccine Provider Sign-Up (Goes to the Vaccine Provider interface)
    function pSignUp(string memory _pName, string memory _photoUrl, uint256 _licenseNo, string memory _plocation, string memory _password) public {
        
        manufacture v = manufacture(addressMan);
        
        uint256 h = hChecker(msg.sender);
        uint256 r = rChecker(msg.sender);
        uint256 a = aChecker(msg.sender);
        uint256 p = pChecker(msg.sender);
        uint256 s = mChecker(msg.sender);
        uint256 t = tChecker(msg.sender);
        
        require(bytes(_pName).length > 0, "Vaccine provider's name must not be kept empty");
        //require(bytes(_photoUrl).length > 0, "Vaccine provider's photo must not be kept empty");
        //require(bytes(_plocation).length > 0, "Vaccine provider's location must not be kept empty");
        require(vpAdd[msg.sender].pSignUp[p] == false, "This Vaccine Provider account already exists.");
        require(v.getTsignUp(t,msg.sender) == false, "This account belongs to a Vendor.");
        require(v.getMsignUp(s,msg.sender) == false, "This account belongs to a Manufacturer.");
        require(v.getRsignUp(r,msg.sender) == false, "This account belongs to a Researcher.");
        require(hAdd[msg.sender].hSignUp[h] == false, "This account belongs to a Holder.");
        require(aAdd[msg.sender].aSignUp[a] == false, "This account belongs to a Authority");

        uint256 id3 = vProviders.length;
        
        vaccineProvider memory newVprovider = vaccineProvider({
            pID: id3,
            pName: _pName,
            photoUrl: _photoUrl,
            licenseNo: _licenseNo,
            plocation: _plocation,
            pPassword: _password,
            wallet: msg.sender
        });
        
        vProviders.push(newVprovider);
        emit providerSignedUp(id3);
        vpAdd[msg.sender].pSignUp[id3] = true;
        pRequests.push(id3);
    }
    
    //View Vaccine Provider Profile (Goes to the vaccine provider interface)
    /*function getVaccineProvider(address addr) external view returns(string memory, string memory, uint256, uint256, string memory)
    {
        uint256 _id3 = pChecker(addr);
        require(_id3 < vProviders.length && _id3 >= 0, "No Vaccine Provider found");
        require(vpAdd[addr].pSignUp[_id3] == true, "This account does not belongs to you.");
        
        
        return (
            vProviders[_id3].photoUrl,
            vProviders[_id3].pName,
            vProviders[_id3].pID,
            vProviders[_id3].licenseNo,
            vProviders[_id3].plocation
        );
    }*/
    
    //Authority Sign Up (Goes to the Authority interface)
    function aSignUp(string memory _aName, string memory _password) public {
        
        manufacture v = manufacture(addressMan);
        
        uint256 h = hChecker(msg.sender);
        uint256 r = rChecker(msg.sender);
        uint256 a = aChecker(msg.sender);
        uint256 p = pChecker(msg.sender);
        uint256 s = mChecker(msg.sender);
        uint256 t = tChecker(msg.sender);
        
        require(bytes(_aName).length > 0, "Authority's name must not be kept empty");
        require(aAdd[msg.sender].aSignUp[a] == false, "This Authority account already exists.");
        require(v.getMsignUp(s,msg.sender) == false, "This account belongs to a Manufacturer.");
        require(v.getTsignUp(t,msg.sender) == false, "This account belongs to a Vendor.");
        require(v.getRsignUp(r,msg.sender) == false, "This account belongs to a Researcher.");
        require(hAdd[msg.sender].hSignUp[h] == false, "This account belongs to a Holder.");
        require(vpAdd[msg.sender].pSignUp[p] == false, "This account belongs to a Vaccine Provider.");

        uint256 id4 = vProviders.length;
        
        authority memory newAuthority = authority({
            aID: id4,
            aName: _aName,
            aPassword: _password
            /*first: new string[](authorities.length),
            second: new string[](authorities.length),
            third: new string[](authorities.length),
            fourth: new string[](authorities.length),
            fifth: new string[](authorities.length),
            sixth: new string[](authorities.length),
            seventh: new string[](authorities.length),
            eighth: new string[](authorities.length),
            ninth: new string[](authorities.length),
            tenth: new string[](authorities.length)*/
        });
        
        authorities.push(newAuthority);
        emit authoritySignedUp(id4);
        aAdd[msg.sender].aSignUp[id4] = true;
    }
    
    //View Authority Profile (Goes to the authority interface)
    /*function getAuthority(address addr) external view returns(string memory, uint256)
    {
        uint256 _id4 = aChecker(addr);
        require(_id4 < authorities.length && _id4 >= 0, "No Authority found");
        require(aAdd[addr].aSignUp[_id4] == true, "This account does not belongs to you.");
        
        
        return (
            authorities[_id4].aName,
            authorities[_id4].aID
        );
    }*/
    
    //Sign-In (Goes to the general interface)
    function SignIn(uint256 _ID, string memory _password, address addr) public returns (string memory) {
        
        manufacture v = manufacture(addressMan);
        signIn = false;
        
        signedAs="None";
        
        if (hAdd[addr].HapprovedMap[_ID] == true)
        {
            require(keccak256(abi.encodePacked((holders[_ID].hPassword))) == keccak256(abi.encodePacked((_password))), "Incorrect Password...!!!");
            signIn = true;
            signedAs = "holder";
            return
            (
                signedAs
            );
        }
        
        else if (vpAdd[addr].PapprovedMap[_ID] == true)
        {
            require(keccak256(abi.encodePacked((vProviders[_ID].pPassword))) == keccak256(abi.encodePacked((_password))), "Incorrect Password...!!!");
            signIn = true;
            signedAs = "vaccineProvider";
            return
            (
                signedAs
            );
        }
        
        else if (aAdd[addr].aSignUp[_ID] == true)
        {
            require(keccak256(abi.encodePacked((authorities[_ID].aPassword))) == keccak256(abi.encodePacked((_password))), "Incorrect Password...!!!");
            signIn = true;
            signedAs = "authority";
            return
            (
                signedAs
            );
        }
        
        else if (v.getRsignUp(_ID, addr) == true)
        {
            require(keccak256(abi.encodePacked((v.getRpassword(_ID)))) == keccak256(abi.encodePacked((_password))), "Incorrect Password...!!!");
            signIn=true;
            signedAs = "researcher";
            return
            (
                signedAs
            );
        }
        
        else if (v.getMsignUp(_ID, addr) == true)
        {
            require(keccak256(abi.encodePacked((v.getMpassword(_ID)))) == keccak256(abi.encodePacked((_password))), "Incorrect Password...!!!");
            signIn = true;
            signedAs = "manufacture";
            return
            (
                signedAs
            );
        }
        
        else if (v.getTsignUp(_ID, addr) == true)
        {
            require(keccak256(abi.encodePacked((v.getTpassword(_ID)))) == keccak256(abi.encodePacked((_password))), "Incorrect Password...!!!");
            signIn = true;
            signedAs = "vendor";
            return
            (
                signedAs
            );
        }
        
        else
        {
            require(signIn == true, "Sign IN Failed...!!!");
            
            return
            (
                signedAs
            );
            
        }
        
    }
    
    //Profile Verification(Goes to Authority Interface)
    function hDetails() public view returns(string memory, uint256, string memory){
        uint256 id2 = hRequests[m];
        require(id2 < holders.length && id2 >= 0, "No Holder found");
        
        return(
            holders[id2].hName,
            holders[id2].NID,
            holders[id2].profession
        );
    }
    
    //Registration Approval(Goes to Authority Interface)
    function hApproval(uint256 _approval) public{
        uint256 _aID = aChecker(msg.sender);
        require(_aID < authorities.length && _aID >= 0, "No Authority found");
        require(aAdd[msg.sender].aSignUp[_aID] == true, "You are not a authority or this account does not belongs to you.");
        
        uint256 id2 = hRequests[m];
        approval = _approval;
        
        if(approval==0)
        {
            hAdd[holders[id2].wallet].HapprovedMap[id2] = false;
        }
        else if(approval==1)
        {
            hAdd[holders[id2].wallet].HapprovedMap[id2] = true;
        }
        
        m++;
    }
    
    //Profile Verification(Goes to Authority Interface)
    function pDetails() public view returns(string memory, uint256){
        uint256 id4 = pRequests[l];
        require(id4 < vProviders.length && id4 >= 0, "No Vaccine Provider found");
        
        return(
            vProviders[id4].pName,
            vProviders[id4].licenseNo
        );
    }
    
    //Registration Approval(Goes to Authority Interface)
    function pApproval(uint256 _approval) public{
        uint256 _aID = aChecker(msg.sender);
        require(_aID < authorities.length && _aID >= 0, "No Authority found");
        require(aAdd[msg.sender].aSignUp[_aID] == true, "You are not a authority or this account does not belongs to you.");
        
        uint256 id2 = pRequests[l];
        approval = _approval;
        
        if(approval==0)
        {
            vpAdd[vProviders[id2].wallet].PapprovedMap[id2] = false;
        }
        else if(approval==1)
        {
            vpAdd[vProviders[id2].wallet].PapprovedMap[id2] = true;
        }
        
        l++;
    }
    
    function setRvaccine(uint256 _batchNo, string memory _rVname, uint256 _vStorage, uint256 _rDoseLimit, uint256 _dTimestamp, uint256 _rVexpire, uint256 _tID) public{
        
        uint256 id9 = rVaccines.length;
        
        recievedVaccine memory newRvaccines = recievedVaccine({
            rVID: id9+1,
            batchNo: _batchNo,
            rVname: _rVname,
            vStorage: _vStorage,
            rDoseLimit: _rDoseLimit,
            dTimestamp: _dTimestamp,
            rVexpire: _rVexpire,
            rFeedBack: new uint256[](rVaccines.length),
            dVendorID: _tID
        });
        
        rVaccines.push(newRvaccines);
        rVaccines[id9].delivered[id9] = true;
    }
    
    // View Vaccine Info (Goes to all interface)
    function getVaccine(uint256 _vID) public view returns(uint256, string memory, uint256, uint256)
    {
        require(rVaccines[_vID-1].approved[_vID] == true, "This vaccine has no approval.");
        
        return(
            rVaccines[_vID-1].rVID,
            rVaccines[_vID-1].rVname,
            rVaccines[_vID-1].vStorage,
            rVaccines[_vID-1].rDoseLimit
        );
    }
    
    //Set Priority (Goes to the Authority interface)
    function setPriority() public {
        
        uint256 _aID = aChecker(msg.sender);
        require(_aID < authorities.length && _aID >= 0, "No Authority found");
        //require(aAdd[msg.sender].aSignUp[_aID] == true, "You are not a authority or this account does not belongs to you.");
        
        uint256 j=0;
        
        while(j<10){
            totalNo.push(0);
            compTotalNo.push(0);
            j++;
        }
        
        uint256 htotal = holders.length;
        uint256 hid=0;

                //for checking different holders professions
                while (hid<htotal)
                {
                    if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Freedom Fighters"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].first.push(holders[hid].hName);
                        totalNo[0] = totalNo[0] + 1;
                        compTotalNo[0] = compTotalNo[0] + 1;
                        holders[hid].priority = 0;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Covid-19 Doctors"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].second.push(holders[hid].hName);
                        totalNo[1] = totalNo[1] + 1;
                        compTotalNo[1] = compTotalNo[1] + 1;
                        holders[hid].priority = 1;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Nurses"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].third.push(holders[hid].hName);
                        totalNo[2] = totalNo[2] + 1;
                        compTotalNo[2] = compTotalNo[2] + 1;
                        holders[hid].priority = 2;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Frontline Staff"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].fourth.push(holders[hid].hName);
                        totalNo[3] = totalNo[3] + 1;
                        compTotalNo[3] = compTotalNo[3] + 1;
                        holders[hid].priority = 3;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Immune Deficient"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].fifth.push(holders[hid].hName);
                        totalNo[4] = totalNo[4] + 1;
                        compTotalNo[4] = compTotalNo[4] + 1;
                        holders[hid].priority = 4;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Elder age-60-up"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].sixth.push(holders[hid].hName);
                        totalNo[5] = totalNo[5] + 1;
                        compTotalNo[5] = compTotalNo[5] + 1;
                        holders[hid].priority = 5;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Adult long-term-Disease"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].seventh.push(holders[hid].hName);
                        totalNo[6] = totalNo[6] + 1;
                        compTotalNo[6] = compTotalNo[6] + 1;
                        holders[hid].priority = 6;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Education Staff"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].eighth.push(holders[hid].hName);
                        totalNo[7] = totalNo[7] + 1;
                        compTotalNo[7] = compTotalNo[7] + 1;
                        holders[hid].priority = 7;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Public Transport Worker"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].ninth.push(holders[hid].hName);
                        totalNo[8] = totalNo[8] + 1;
                        compTotalNo[8] = compTotalNo[8] + 1;
                        holders[hid].priority = 8;
                    }
                    
                    else if(hAdd[holders[hid].wallet].HapprovedMap[hid] == true && keccak256(abi.encodePacked(("Others"))) == keccak256(abi.encodePacked((holders[hid].profession))))
                    {
                        //authorities[_aID].tenth.push(holders[hid].hName);
                        totalNo[9] = totalNo[9] + 1;
                        compTotalNo[9] = compTotalNo[9] + 1;
                        holders[hid].priority = 9;
                    }
                    
                    hid++;
                }
    }
    
    //View Priority (Goes to the Vaccine Provider interface)
    /*function getPriority1(uint256 _aID) external view returns(string[] memory, string[] memory, string[] memory, string[] memory, string[] memory)
    {
        require(_aID < authorities.length && _aID >= 0, "No authority found");
        
        return (
            authorities[_aID].first,
            authorities[_aID].second,
            authorities[_aID].third,
            authorities[_aID].fourth,
            authorities[_aID].fifth
        );
    }
    
    function getPriority2(uint256 _aID) external view returns(string[] memory, string[] memory, string[] memory, string[] memory, string[] memory)
    {
        require(_aID < authorities.length && _aID >= 0, "No authority found");
        
        return (
            authorities[_aID].sixth,
            authorities[_aID].seventh,
            authorities[_aID].eighth,
            authorities[_aID].ninth,
            authorities[_aID].tenth
        );
    }*/
    
    function deliveryCheck(uint256 _rVID) public view returns(string memory){
        
        manufacture v = manufacture(addressMan);
        
        string memory confirm = "This Batch is not Expired and Ok...";
        string memory reject = "This Batch is Expired or Damaged...";
        
        uint256 _aID = aChecker(msg.sender);
        require(_aID < authorities.length && _aID >= 0, "No Authority found");
        //require(aAdd[msg.sender].aSignUp[_aID] == true, "You are not a authority or this account does not belongs to you.");
        require((_rVID-1) < rVaccines.length && (_rVID-1) >= 0, "No Recieced Vaccine found");
        
        if(rVaccines[_rVID-1].dTimestamp>rVaccines[_rVID-1].rVexpire || v.getGrading(rVaccines[_rVID-1].dVendorID)==1)
        {
            return(reject);
        }
        else if (rVaccines[_rVID-1].dTimestamp<rVaccines[_rVID-1].rVexpire && v.getGrading(rVaccines[_rVID-1].dVendorID)==0)
        {
            return(confirm);
        }
    }
    
    function isExpire(uint256 _rVID, uint256 _year, uint256 _month, uint256 _day) public view returns(uint256){
        DateTime x = DateTime(addressTime);
        
        uint256 timestamp = x.toTimestamp(_year,_month,_day,0,0,0);
        
        if(timestamp>rVaccines[_rVID-1].rVexpire)
        {
            return(0);
        }
        else if (timestamp<rVaccines[_rVID-1].rVexpire)
        {
            return(1);
        }
    }
    
    function dealConfirmation(uint256 _rVID, uint256 _confirmation) public{
        uint256 _aID = aChecker(msg.sender);
        require(_aID < authorities.length && _aID >= 0, "No Authority found");
        //require(aAdd[msg.sender].aSignUp[_aID] == true, "You are not a authority or this account does not belongs to you.");
        require((_rVID-1) < rVaccines.length && (_rVID-1) >= 0, "No Recieced Vaccine found");
        
        if(_confirmation==0)
        {
        rVaccines[_rVID-1].rVID=0;
        rVaccines[_rVID-1].batchNo=0;
        rVaccines[_rVID-1].rVname="None";
        rVaccines[_rVID-1].vStorage=0;
        rVaccines[_rVID-1].rDoseLimit=0;
        rVaccines[_rVID-1].dTimestamp=0;
        rVaccines[_rVID-1].rVexpire=0;
        rVaccines[_rVID-1].approved[_rVID]=false;
        }
        
        else if(_confirmation==1)
        {
            rVaccines[_rVID-1].approved[_rVID]=true;
            emit shipmentConfirm(_rVID-1);
        }
        
    }
    
    //Push Vaccine (Goes to the Vaccine Provider interface)
    function pushVaccine(/*uint256 _aID, */uint256 _vID, uint256 _hID, string memory _vName, uint256 _year, uint256 _month, uint256 _day) public {
        
        uint256 _pID = pChecker(msg.sender);
        require(_pID < vProviders.length && _pID >= 0, "No Vaccine Provider found");
        
        require(_hID < holders.length, "Holder does not exist");
        require((_vID-1) < rVaccines.length, "Vaccine does not exist");
        //require(rVaccines[_vID-1].approved[_vID] == true, "This vaccine has no approval.");
        require(rVaccines[_vID-1].vStorage > 0, "This vaccine is out of stock.");
        require(holders[_hID].doseNo < rVaccines[_vID-1].rDoseLimit, "Vaccination dose is already completed");
        //require(vpAdd[msg.sender].pSignUp[_pID] == true, "You are not a vaccine provider or this account does not belongs to you.");
        require(keccak256(abi.encodePacked((rVaccines[_vID-1].rVname))) == keccak256(abi.encodePacked((_vName))), "This vaccine does not exist.");
        require(isExpire(_vID,_year,_month,_day)==1, "This Vaccine is Expired...!!!!");
        
        uint256 j=0;
        //uint256 i=0;
        //uint256 n=0;
        uint256 k=0;
        
        while (j<10)
        {
            if(totalNo[j]!=0)
            {
                break;
            }
            j++;
        }
        
        if(j<10)
        {
                require(holders[_hID].priority == j, "Vaccination is not completed for the higher priority Holders yet.");

                holders[_hID].vName=_vName;
                rVaccines[_vID-1].vStorage -= 1;
                holders[_hID].doseNo += 1;
                holders[_hID].vaccineTaken=true;
                totalNo[j] -= 1;
        }
            
        else if(j>=10)
        {
            k=0;
            while (k<10) 
            {
                if(compTotalNo[k]!=0)
                {
                    break;
                }
                k++;
            }
        
            if(k<10)
            {
                require(holders[_hID].priority == k, "Vaccination is not completed for the higher priority Holders yet.");

                holders[_hID].vName=_vName;
                rVaccines[_vID-1].vStorage -= 1;
                holders[_hID].doseNo += 1;
                holders[_hID].vaccineTaken=true;
                compTotalNo[k] -= 1;
                
                /*if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 0)
                {
                    uint256 htotal=authorities[_aID].first.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].first[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].first[n] = authorities[_aID].first[authorities[_aID].first.length - 1];
                    delete authorities[_aID].first[authorities[_aID].first.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 1)
                {
                    uint256 htotal=authorities[_aID].second.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].second[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].second[n] = authorities[_aID].second[authorities[_aID].second.length - 1];
                    delete authorities[_aID].second[authorities[_aID].second.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 2)
                {
                    uint256 htotal=authorities[_aID].third.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].third[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].third[n] = authorities[_aID].third[authorities[_aID].third.length - 1];
                    delete authorities[_aID].third[authorities[_aID].third.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 3)
                {
                    uint256 htotal=authorities[_aID].fourth.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].fourth[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].fourth[n] = authorities[_aID].fourth[authorities[_aID].fourth.length - 1];
                    delete authorities[_aID].fourth[authorities[_aID].fourth.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 4)
                {
                    uint256 htotal=authorities[_aID].fifth.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].fifth[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].fifth[n] = authorities[_aID].fifth[authorities[_aID].fifth.length - 1];
                    delete authorities[_aID].fifth[authorities[_aID].fifth.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 5)
                {
                    uint256 htotal=authorities[_aID].sixth.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].sixth[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].sixth[n] = authorities[_aID].sixth[authorities[_aID].sixth.length - 1];
                    delete authorities[_aID].sixth[authorities[_aID].sixth.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 6)
                {
                    uint256 htotal=authorities[_aID].seventh.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].seventh[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].seventh[n] = authorities[_aID].seventh[authorities[_aID].seventh.length - 1];
                    delete authorities[_aID].seventh[authorities[_aID].seventh.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 7)
                {
                    uint256 htotal=authorities[_aID].eighth.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].eighth[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].eighth[n] = authorities[_aID].eighth[authorities[_aID].eighth.length - 1];
                    delete authorities[_aID].eighth[authorities[_aID].eighth.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 8)
                {
                    uint256 htotal=authorities[_aID].ninth.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].ninth[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].ninth[n] = authorities[_aID].ninth[authorities[_aID].ninth.length - 1];
                    delete authorities[_aID].ninth[authorities[_aID].ninth.length - 1];
                }
                
                else if (holders[_hID].doseNo == rVaccines[_vID].rDoseLimit && holders[_hID].priority == 9)
                {
                    uint256 htotal=authorities[_aID].tenth.length;
                    
                    while(i<=htotal)
                    {
                        if(keccak256(abi.encodePacked((authorities[_aID].tenth[i]))) == keccak256(abi.encodePacked((holders[_hID].hName))))
                        {
                            break;
                        }
                        n += 1;
                        i++;
                    }
                    authorities[_aID].tenth[n] = authorities[_aID].tenth[authorities[_aID].tenth.length - 1];
                    delete authorities[_aID].tenth[authorities[_aID].tenth.length - 1];
                }*/
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function getHsignUp(uint256 _id2, address _add) public view returns(bool){
        return (
            hAdd[_add].hSignUp[_id2]
        );
    }
    
    function getVPsignUp(uint256 _id2, address _add) public view returns(bool){
        return (
            vpAdd[_add].pSignUp[_id2]
        );
    }
    
    function getAsignUp(uint256 _id2, address _add) public view returns(bool){
        return (
            aAdd[_add].aSignUp[_id2]
        );
    }
}

contract manufacture{
    
    address addressDist;
    address addressTime;
    
    struct vaccine{
        uint256 vID;
        string vName;
        uint256 doseLimit;
        string tempSign;
        uint256 lowTemperature;
        uint256 highTemperature;
        uint256 humidity;
        string formula;
        uint256 expire;
        mapping (uint256 => bool) approved;
    }
    
    struct manufacturedVaccines{
        uint256 batchNo;
        uint256 vID;
        string vName;
        uint256 quantity;
        uint256 mTimestamp;
        uint256 eTimestamp;
        string[] tracking;
        uint256 currLoc;
        mapping (uint256 => bool) produced;
    }
    
    //Researcher Structure
    struct researcher {
        uint256 rID;
        string rName;
        string qualification;
        string photoUrl;
        string rlocation;
        string rPassword;
        mapping(uint256 => bool) rSignUp;
    }
    
    //Manufacturer Structure
    struct manufacturer{
        uint256 mID;
        string mName;
        string photoUrl;
        uint256 mLicenseNo;
        string mlocation;
        string mPassword;
        uint256 vID;
        mapping(uint256 => bool) mSignUp;
    }
    
    struct vendor{
        uint256 tID;
        string tName;
        uint256 tLicenseNo;
        string photoUrl;
        string transportedBy;
        uint256 vBatch;
        uint256 vQuantity;
        string tempSign;
        uint256 temp;
        uint256 humd;
        string stTempSign;
        uint256 stLowTemp;
        uint256 stHighTemp;
        uint256 stHumd;
        uint256 rtimestamp;
        string source;
        uint256 grading;
        string tPassword;
        mapping(uint256 => bool) tSignUp;
    }
    
    researcher[] private researchers;
    manufacturer[] private manufacturers;
    vendor[] private vendors;
    vaccine[] private vaccines;
    manufacturedVaccines[] private mVaccines;
    
    mapping(address => researcher) private rAdd;
    mapping(address => manufacturer) private mAdd;
    mapping(address => vendor) private tAdd;
    
    event researcherSignedUp(uint256 _id5);
    event manufacturerSignedUp(uint256 _id6);
    event vendorSignedUp(uint256 _id7);
    event vaccineStored(uint256 _id1);
    event vaccineProduced(uint256 _id8);
    
    //set Distribution contract's address
    function setContractDistribution(address _addr) external {
        addressDist = _addr;
    }
    
    //set DateTime contract's address
    function setContractDateTime(address _addr) external {
        addressTime = _addr;
    }
    
    //Vaccine Provider Sign-Up (Goes to the Vaccine Provider interface)
    function rSignUp(string memory _rName, string memory _qualification, string memory _photoUrl, string memory _rlocation, string memory _password) public {
        distribution c = distribution(addressDist);
        uint256 h = c.hChecker(msg.sender);
        uint256 s = c.mChecker(msg.sender);
        uint256 r = c.rChecker(msg.sender);
        uint256 a = c.aChecker(msg.sender);
        uint256 p = c.pChecker(msg.sender);
        uint256 t = c.tChecker(msg.sender);
        
        require(bytes(_rName).length > 0, "Researcher's name must not be kept empty");
        require(bytes(_photoUrl).length > 0, "Researcher's photo must not be kept empty");
        require(bytes(_qualification).length > 0, "Researcher's qualification must not be kept empty");
        require(bytes(_rlocation).length > 0, "Researcher's location must not be kept empty");
        require(rAdd[msg.sender].rSignUp[r] == false, "This Researcher already exists.");
        require(mAdd[msg.sender].mSignUp[s] == false, "This account belongs to a Manufacturer.");
        require(tAdd[msg.sender].tSignUp[t] == false, "This account belongs to a Vendor.");
        require(c.getVPsignUp(p,msg.sender) == false, "This account belongs to a Vaccine Provider");
        require(c.getAsignUp(a,msg.sender) == false, "This account belongs to an Authority.");
        require(c.getHsignUp(h,msg.sender) == false, "This account belongs to a Holder.");

        uint256 id5 = researchers.length;
        
        researcher memory newResearcher = researcher({
            rID: id5,
            rName: _rName,
            qualification: _qualification,
            photoUrl: _photoUrl,
            rlocation: _rlocation,
            rPassword: _password
        });
        
        researchers.push(newResearcher);
        emit researcherSignedUp(id5);
        rAdd[msg.sender].rSignUp[id5] = true;
    }
    
    //View Researcher Profile (Goes to the researcher interface)
    /*function getResearcher(address addr) external view returns(string memory, string memory, uint256, string memory, string memory)
    {
        distribution c = distribution(addressDist);
        
        uint256 _id3 = c.rChecker(addr);
        require(_id3 < researchers.length && _id3 >= 0, "No Researcher found");
        require(rAdd[addr].rSignUp[_id3] == true, "This account does not belongs to you.");
        
        
        return (
            researchers[_id3].photoUrl,
            researchers[_id3].rName,
            researchers[_id3].rID,
            researchers[_id3].qualification,
            researchers[_id3].rlocation
        );
    }*/
    
    //Vaccine Provider Sign-Up (Goes to the Vaccine Provider interface)
    function mSignUp(string memory _mName, string memory _photoUrl, uint256 _mLicenseNo, string memory _mlocation, string memory _password) public {
        distribution c = distribution(addressDist);
        uint256 h = c.hChecker(msg.sender);
        uint256 s = c.mChecker(msg.sender);
        uint256 r = c.rChecker(msg.sender);
        uint256 a = c.aChecker(msg.sender);
        uint256 p = c.pChecker(msg.sender);
        uint256 t = c.tChecker(msg.sender);
        
        require(bytes(_mName).length > 0, "Manufacturer's name must not be kept empty");
        require(bytes(_photoUrl).length > 0, "Manufacturer's photo must not be kept empty");
        require(c.convertBytes(_mLicenseNo).length > 0, "Manufacturer's License Number must not be kept empty");
        require(bytes(_mlocation).length > 0, "Researcher's location must not be kept empty");
        require(mAdd[msg.sender].mSignUp[s] == false, "This Manufacturer already exists.");
        require(rAdd[msg.sender].rSignUp[r] == false, "This account belongs to a Researcher.");
        require(tAdd[msg.sender].tSignUp[t] == false, "This account belongs to a Vendor.");
        require(c.getVPsignUp(p,msg.sender) == false, "This account belongs to a Vaccine Provider");
        require(c.getAsignUp(a,msg.sender) == false, "This account belongs to an Authority.");
        require(c.getHsignUp(h,msg.sender) == false, "This account belongs to a Holder.");

        uint256 id6 = manufacturers.length;
        
        manufacturer memory newManufacturer = manufacturer({
            mID: id6,
            mName: _mName,
            photoUrl: _photoUrl,
            mLicenseNo: _mLicenseNo,
            mlocation: _mlocation,
            mPassword: _password,
            vID: 0
        });
        
        manufacturers.push(newManufacturer);
        emit manufacturerSignedUp(id6);
        mAdd[msg.sender].mSignUp[id6] = true;
    }
    
    //View Manufacturer Profile (Goes to the manufacturer interface)
    /*function getManufacturer(address addr) external view returns(string memory, string memory, uint256, uint256, string memory)
    {
        distribution c = distribution(addressDist);
        
        uint256 _id3 = c.mChecker(addr);
        require(_id3 < manufacturers.length && _id3 >= 0, "No Manufacturer found");
        require(rAdd[addr].rSignUp[_id3] == true, "This account does not belongs to you.");
        
        return (
            manufacturers[_id3].photoUrl,
            manufacturers[_id3].mName,
            manufacturers[_id3].mID,
            manufacturers[_id3].mLicenseNo,
            manufacturers[_id3].mlocation
        );
    }*/
    
    //Vendor Sign-Up (Goes to the Vendor interface)
    function tSignUp(string memory _tName, uint256 _tLicenseNo, string memory _photoUrl, string memory _transportedBy, string memory _password) public {
        distribution c = distribution(addressDist);
        uint256 h = c.hChecker(msg.sender);
        uint256 s = c.mChecker(msg.sender);
        uint256 r = c.rChecker(msg.sender);
        uint256 a = c.aChecker(msg.sender);
        uint256 p = c.pChecker(msg.sender);
        uint256 t = c.tChecker(msg.sender);
        
        require(bytes(_tName).length > 0, "Vendor's name must not be kept empty");
        require(bytes(_photoUrl).length > 0, "Vendor's photo must not be kept empty");
        require(c.convertBytes(_tLicenseNo).length > 0, "Vendor's License Number must not be kept empty");
        require(bytes(_transportedBy).length > 0, "Vendor's Transport Route must not be kept empty");
        require(tAdd[msg.sender].tSignUp[t] == false, "This Vendor already exists.");
        require(mAdd[msg.sender].mSignUp[s] == false, "This account belongs to a Manufacturer.");
        require(rAdd[msg.sender].rSignUp[r] == false, "This account belongs to a Researcher.");
        require(c.getVPsignUp(p,msg.sender) == false, "This account belongs to a Vaccine Provider");
        require(c.getAsignUp(a,msg.sender) == false, "This account belongs to an Authority.");
        require(c.getHsignUp(h,msg.sender) == false, "This account belongs to a Holder.");

        uint256 id7 = vendors.length;
        
        vendor memory newVendor = vendor({
            tID: id7,
            tName: _tName,
            tLicenseNo: _tLicenseNo,
            photoUrl: _photoUrl,
            transportedBy: _transportedBy,
            vBatch: 0,
            vQuantity: 0,
            tempSign: "None",
            temp: 0,
            humd: 0,
            stTempSign: "None",
            stLowTemp: 0,
            stHighTemp: 0,
            stHumd: 0,
            rtimestamp: 0,
            source: "None",
            grading: 0,
            tPassword: _password
        });
        
        vendors.push(newVendor);
        emit vendorSignedUp(id7);
        tAdd[msg.sender].tSignUp[id7] = true;
    }
    
    //View Vendors Profile (Goes to the Vendor interface)
    /*function getVendor(address addr) external view returns(string memory, string memory, uint256, uint256, string memory)
    {
        distribution c = distribution(addressDist);
        
        uint256 _id3 = c.tChecker(addr);
        require(_id3 < vendors.length && _id3 >= 0, "No Vendor found");
        require(tAdd[addr].tSignUp[_id3] == true, "This account does not belongs to you.");
        
        
        return (
            vendors[_id3].photoUrl,
            vendors[_id3].tName,
            vendors[_id3].tID,
            vendors[_id3].tLicenseNo,
            vendors[_id3].transportedBy
        );
    }*/
    
    //View Vendors Profile (Goes to the Vendor interface)
    function getCurrentCondition(uint256 _batchNo) external view returns(uint256, string memory, string memory, uint256, uint256, uint256, string memory)
    {
        require((_batchNo-1) < mVaccines.length && (_batchNo-1) >= 0, "No Vaccine Batch found");
        uint256 _id3 = mVaccines[_batchNo-1].currLoc;
        
        return (
            vendors[_id3].vBatch,
            vendors[_id3].tName,
            vendors[_id3].tempSign,
            vendors[_id3].temp,
            vendors[_id3].humd,
            vendors[_id3].tLicenseNo,
            vendors[_id3].transportedBy
        );
    }
    
    //Vaccine entry (Goes to the Researcher interface)
    function setVaccine(string memory _vName, uint256 _doseLimit, string memory _tempSign, uint256 _lowTemperature, uint256 _highTemperature, uint256 _humidity, string memory _formula, uint256 _expire) public {
        
        distribution c = distribution(addressDist);
        
        uint256 _rID = c.rChecker(msg.sender);
        require(_rID < researchers.length && _rID >= 0, "No Researcher found");
        require(rAdd[msg.sender].rSignUp[_rID] == true, "You are not a researcher or this account does not belongs to you.");
        require(bytes(_vName).length > 0, "Vaccine's name must not be kept empty");
        require(c.convertBytes(_doseLimit).length > 0, "Dose limit must not be kept empty");
        require(bytes(_tempSign).length > 0, "Required temperature sign must not be kept empty");
        require(c.convertBytes(_lowTemperature).length > 0, "Required low temperature must not be kept empty");
        require(c.convertBytes(_highTemperature).length > 0, "Required low temperature must not be kept empty");
        require(c.convertBytes(_humidity).length > 0, "Required humidity must not be kept empty");
        require(bytes(_formula).length > 0, "Vaccine's formula must not be kept empty");
        require(c.convertBytes(_expire).length > 0, "Expiry range must not be kept empty");
        
        uint256 id1 = vaccines.length;
        
        vaccine memory newVaccine = vaccine({
            vID: id1+1,
            vName: _vName,
            doseLimit: _doseLimit,
            tempSign: _tempSign,
            lowTemperature: _lowTemperature,
            highTemperature: _highTemperature,
            humidity: _humidity,
            formula: _formula,
            expire: _expire
        });
        
        vaccines.push(newVaccine);
        emit vaccineStored(id1);
        vaccines[id1].approved[id1] = true;
    }
    
    // View Vaccine Info (Goes to Researcher interface)
    /*function getVaccine(uint256 _vID) public view returns(string memory, uint256, uint256, uint256, string memory, uint256)
    {
        distribution c = distribution(addressDist);
        
        uint256 _rID = c.rChecker(msg.sender);
        require(_rID < researchers.length && _rID >= 0, "No Researcher found");
        require(rAdd[msg.sender].rSignUp[_rID] == true, "You are not a researcher or this account does not belongs to you.");
        require(vaccines[_vID].approved[_vID] == true, "This vaccine has no approval.");
        
        return(
            vaccines[_vID].vName,
            vaccines[_vID].temperature,
            vaccines[_vID].humidity,
            vaccines[_vID].doseLimit,
            vaccines[_vID].formula,
            vaccines[_vID].expire
        );
    }*/
    
    //(Goes to Researcher interface)
    function vaccineHandover(uint256 _mID, uint256 _vID) public{
        distribution c = distribution(addressDist);
        
        uint256 _rID = c.rChecker(msg.sender);
        require(_rID < researchers.length && _rID >= 0, "No Researcher found");
        require(rAdd[msg.sender].rSignUp[_rID] == true, "You are not a researcher or this account does not belongs to you.");
        require(c.convertBytes(_vID).length > 0, "Vaccine ID must not be kept empty");
        require((_vID-1) < vaccines.length && _vID >= 0, "No Vaccine found");
        require(_mID < manufacturers.length && _mID >= 0, "No Manufacturer found");
        
        manufacturers[_mID].vID = _vID;
    }
    
    //(Goes to Manufacturer interface)
    function viewFormula(address addr) public view returns (string memory, uint256, string memory, uint256, uint256, uint256, string memory, uint256){
        distribution c = distribution(addressDist);
        uint256 _id5 = c.mChecker(addr);
        require(_id5 < manufacturers.length && _id5 >= 0, "No Manufacturer found");
        require(mAdd[addr].mSignUp[_id5] == true, "This account does not belongs to you.");
        
        uint256 id1 = manufacturers[_id5].vID;
        
        return(
            vaccines[id1-1].vName,
            vaccines[id1-1].doseLimit,
            vaccines[id1-1].tempSign,
            vaccines[id1-1].lowTemperature,
            vaccines[id1-1].highTemperature,
            vaccines[id1-1].humidity,
            vaccines[id1-1].formula,
            vaccines[id1-1].expire
        );
    }
    
    //(Goes to Manufacturer interface)
    function massProduction(string memory _vName, uint256 _quantity, uint256 _mYear, uint256 _mMonth, uint256 _mDay) public{
        
        distribution c = distribution(addressDist);
        DateTime x = DateTime(addressTime);
        
        uint256 _mID = c.mChecker(msg.sender);
        require(_mID < researchers.length && _mID >= 0, "No Manufacturer found");
        require(mAdd[msg.sender].mSignUp[_mID] == true, "You are not a manufacturer or this account does not belongs to you.");
        require(bytes(_vName).length > 0, "Vaccine's name must not be kept empty");
        require(c.convertBytes(_quantity).length > 0, "Quantity must not be kept empty");
        require(c.convertBytes(_mYear).length > 0 && c.convertBytes(_mMonth).length > 0 && c.convertBytes(_mDay).length > 0, "Manufacturing Details must not be kept empty");
        
        uint256 id8 = mVaccines.length;
        uint256 id1 = manufacturers[_mID].vID;
        uint256 expireYear = vaccines[id1-1].expire + 1970;
        uint256 mTime = x.toTimestamp(_mYear,_mMonth,_mDay, 0, 0, 0);
        uint256 eTime=x.toTimestamp(expireYear, 0, 0, 0, 0, 0);
        
        manufacturedVaccines memory newMvaccine = manufacturedVaccines({
            batchNo: id8+1,
            vID: id1,
            vName: _vName,
            quantity: _quantity,
            tracking: new string[](mVaccines.length),
            currLoc: 0,
            mTimestamp: mTime,
            eTimestamp: eTime+mTime
        });
        
        mVaccines.push(newMvaccine);
        emit vaccineProduced(id8);
        mVaccines[id8].produced[id8] = true;
    }
    
    //(Goes to Manufacturer interface)
    function shipment(uint256 _tID, uint256 _batchNo, uint256 _quantity, uint256 _rYear, uint256 _rMonth, uint256 _rDay) public{
        distribution c = distribution(addressDist);
        DateTime x = DateTime(addressTime);
        
        uint256 _mID = c.mChecker(msg.sender);
        require(_mID < manufacturers.length && _mID >= 0, "No Manufacturer found");
        require(mAdd[msg.sender].mSignUp[_mID] == true, "You are not a manufacturer or this account does not belongs to you.");
        require(_tID < vendors.length && _tID >= 0, "No Vendors found");
        require((_batchNo-1) < mVaccines.length && (_batchNo-1) >= 0, "No Vaccine Batch found");
        require(_quantity <= mVaccines[_batchNo-1].quantity && _quantity > 0, "Out of Stock or Nothing to Supply");
        
        uint256 rTime = x.toTimestamp(_rYear,_rMonth,_rDay, 0, 0, 0);
        uint256 id1 = manufacturers[_mID].vID;
        
        vendors[_tID].vBatch=_batchNo;
        vendors[_tID].vQuantity=_quantity;
        vendors[_tID].stTempSign=vaccines[id1-1].tempSign;
        vendors[_tID].stLowTemp=vaccines[id1-1].lowTemperature;
        vendors[_tID].stHighTemp=vaccines[id1-1].highTemperature;
        vendors[_tID].stHumd=vaccines[id1-1].humidity;
        vendors[_tID].rtimestamp=rTime;
        vendors[_tID].source=manufacturers[_mID].mName;
        mVaccines[_batchNo-1].tracking.push(vendors[_tID].tName);
        mVaccines[_batchNo-1].currLoc=vendors[_tID].tID;
        mVaccines[_batchNo-1].quantity-=_quantity;
        vendors[_tID].grading=0;
    }
    
    //(Goes to Vendors interface)
    function handChanging(uint256 _tID, uint256 _batchNo, uint256 _quantity, uint256 _rYear, uint256 _rMonth, uint256 _rDay) public{
        distribution c = distribution(addressDist);
        DateTime x = DateTime(addressTime);
        
        uint256 id6 = c.tChecker(msg.sender);
        require(id6 < vendors.length && id6 >= 0, "No Vendors found");
        require(tAdd[msg.sender].tSignUp[id6] == true, "You are not a Vendor or this account does not belongs to you.");
        require(_tID < vendors.length && _tID >= 0, "No Vendors found");
        require((_batchNo-1) < mVaccines.length && (_batchNo-1) >= 0, "No Vaccine Batch found");
        require(_quantity <= vendors[id6].vQuantity && _quantity > 0, "Out of Stock or Nothing to Supply");
        
        uint256 rTime = x.toTimestamp(_rYear,_rMonth,_rDay, 0, 0, 0);
        
        vendors[_tID].vBatch=_batchNo;
        vendors[_tID].vQuantity=_quantity;
        vendors[_tID].stTempSign=vendors[id6].stTempSign;
        vendors[_tID].stLowTemp=vendors[id6].stLowTemp;
        vendors[_tID].stHighTemp=vendors[id6].stHighTemp;
        vendors[_tID].stHumd=vendors[id6].stHumd;
        vendors[_tID].rtimestamp=rTime;
        vendors[_tID].source=vendors[id6].tName;
        vendors[_tID].grading=vendors[id6].grading;
        mVaccines[_batchNo-1].tracking.push(vendors[_tID].tName);
        mVaccines[_batchNo-1].currLoc=vendors[_tID].tID;
        
        vendors[id6].vBatch=0;
        vendors[id6].vQuantity=0;
        vendors[id6].stTempSign="None";
        vendors[id6].stLowTemp=0;
        vendors[id6].stHighTemp=0;
        vendors[id6].stHumd=0;
        vendors[id6].rtimestamp=0;
        vendors[id6].source="None";
    }
    
    function conditionCheck(string memory _tempSign, uint256 _temp, uint256 _humd) public{
        distribution c = distribution(addressDist);
        
        uint256 id6 = c.tChecker(msg.sender);
        require(id6 < vendors.length && id6 >= 0, "No Vendors found");
        require(tAdd[msg.sender].tSignUp[id6] == true, "You are not a Vendor or this account does not belongs to you.");
        
        vendors[id6].tempSign=_tempSign;
        vendors[id6].temp=_temp;
        vendors[id6].humd=_humd;
        
        if(_temp<vendors[id6].stHighTemp || _temp>vendors[id6].stLowTemp || _humd<vendors[id6].stHumd || _humd>vendors[id6].stHumd || keccak256(abi.encodePacked((_tempSign))) == keccak256(abi.encodePacked(("Positive"))))
        {
            vendors[id6].grading=1;
        }
    }
    
    function getGrading(uint256 _tID) public view returns(uint256){
        require(_tID < vendors.length && _tID >= 0, "No Vendors found");
        return(
            vendors[_tID].grading
        );
    }
    
    function finalHandOver(uint256 _batchNo, uint256 _vStorage, uint256 _dYear, uint256 _dMonth, uint256 _dDay) public{
        
        distribution c = distribution(addressDist);
        DateTime x = DateTime(addressTime);
        
        uint256 id6 = c.tChecker(msg.sender);
        require(id6 < vendors.length && id6 >= 0, "No Vendors found");
        //require(tAdd[msg.sender].tSignUp[id6] == true, "You are not a Vendor or this account does not belongs to you.");
        require((_batchNo-1) < mVaccines.length && (_batchNo-1) >= 0, "No Vaccine Batch found");
        require(_vStorage <= vendors[id6].vQuantity && _vStorage > 0, "Out of Stock or Nothing to Supply");
        
        uint256 id8 = mVaccines[_batchNo-1].vID;
        string memory _rVname = vaccines[id8-1].vName;
        uint256 _rDoseLimit = vaccines[id8-1].doseLimit;
        uint256 _rVexpire = mVaccines[_batchNo-1].eTimestamp;
        uint256 _dTimestamp = x.toTimestamp(_dYear,_dMonth,_dDay, 0, 0, 0);
        
        c.setRvaccine(_batchNo, _rVname, _vStorage, _rDoseLimit, _dTimestamp, _rVexpire, id6);
        
        vendors[id6].vBatch=0;
        vendors[id6].vQuantity=0;
        vendors[id6].stTempSign="None";
        vendors[id6].stLowTemp=0;
        vendors[id6].stHighTemp=0;
        vendors[id6].stHumd=0;
        vendors[id6].rtimestamp=0;
        vendors[id6].source="None";
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function getRsignUp(uint256 _id2, address _add) public view returns(bool){
        return (
            rAdd[_add].rSignUp[_id2]
        );
    }
    
    function getResearcherLen() public view returns(uint256){
        return (
            researchers.length
        );
    }
    
    function getRpassword(uint256 ID) external view returns(string memory)
    {
        return(
            researchers[ID].rPassword
        );
    }
    
    function getMsignUp(uint256 _id2, address _add) public view returns(bool){
        return (
            mAdd[_add].mSignUp[_id2]
        );
    }
    
    function getManufacturerLen() public view returns(uint256){
        return (
            manufacturers.length
        );
    }
    
    function getMpassword(uint256 ID) external view returns(string memory)
    {
        return(
            manufacturers[ID].mPassword
        );
    }
    
    function getTsignUp(uint256 _id2, address _add) public view returns(bool){
        return (
            tAdd[_add].tSignUp[_id2]
        );
    }
    
    function getVendorLen() public view returns(uint256){
        return (
            vendors.length
        );
    }
    
    function getTpassword(uint256 ID) external view returns(string memory)
    {
        return(
            vendors[ID].tPassword
        );
    }
}

contract DateTime {
        /*
         *  Date and Time utilities for ethereum contracts
         *
         */
        struct _DateTime {
                uint256 year;
                uint256 month;
                uint256 day;
                uint256 hour;
                uint256 minute;
                uint256 second;
                uint256 weekday;
        }

        uint256 constant DAY_IN_SECONDS = 86400;
        uint256 constant YEAR_IN_SECONDS = 31536000;
        uint256 constant LEAP_YEAR_IN_SECONDS = 31622400;

        uint256 constant HOUR_IN_SECONDS = 3600;
        uint256 constant MINUTE_IN_SECONDS = 60;

        uint256 constant ORIGIN_YEAR = 1970;

        function isLeapYear(uint256 year) public pure returns (bool) {
                if (year % 4 != 0) {
                        return false;
                }
                if (year % 100 != 0) {
                        return true;
                }
                if (year % 400 != 0) {
                        return false;
                }
                return true;
        }

        function leapYearsBefore(uint256 year) public pure returns (uint256) {
                year -= 1;
                return year / 4 - year / 100 + year / 400;
        }

        function getDaysInMonth(uint256 month, uint256 year) public pure returns (uint256) {
                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                        return 31;
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11) {
                        return 30;
                }
                else if (isLeapYear(year)) {
                        return 29;
                }
                else {
                        return 28;
                }
        }

        function parseTimestamp(uint timestamp) internal pure returns (_DateTime memory dt) {
                uint256 secondsAccountedFor = 0;
                uint256 buf;
                uint256 i;

                // Year
                dt.year = getYear(timestamp);
                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

                // Month
                uint256 secondsInMonth;
                for (i = 1; i <= 12; i++) {
                        secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
                        if (secondsInMonth + secondsAccountedFor > timestamp) {
                                dt.month = i;
                                break;
                        }
                        secondsAccountedFor += secondsInMonth;
                }

                // Day
                for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.day = i;
                                break;
                        }
                        secondsAccountedFor += DAY_IN_SECONDS;
                }

                // Hour
                dt.hour = getHour(timestamp);

                // Minute
                dt.minute = getMinute(timestamp);

                // Second
                dt.second = getSecond(timestamp);

                // Day of week.
                dt.weekday = getWeekday(timestamp);
        }

        function getYear(uint256 timestamp) public pure returns (uint256) {
                uint256 secondsAccountedFor = 0;
                uint256 year;
                uint256 numLeapYears;

                // Year
                year = uint256(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

                while (secondsAccountedFor > timestamp) {
                        if (isLeapYear(uint256(year - 1))) {
                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                secondsAccountedFor -= YEAR_IN_SECONDS;
                        }
                        year -= 1;
                }
                return year;
        }

        function getMonth(uint256 timestamp) public pure returns (uint256) {
                return parseTimestamp(timestamp).month;
        }

        function getDay(uint256 timestamp) public pure returns (uint256) {
                return parseTimestamp(timestamp).day;
        }

        function getHour(uint256 timestamp) public pure returns (uint256) {
                return uint256((timestamp / 60 / 60) % 24);
        }

        function getMinute(uint256 timestamp) public pure returns (uint256) {
                return uint256((timestamp / 60) % 60);
        }

        function getSecond(uint256 timestamp) public pure returns (uint256) {
                return uint256(timestamp % 60);
        }

        function getWeekday(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
        }

        function toTimestamp1(uint256 year, uint256 month, uint256 day) public pure returns (uint256 timestamp) {
                return toTimestamp(year, month, day, 0, 0, 0);
        }

        function toTimestamp2(uint256 year, uint256 month, uint256 day, uint256 hour) public pure returns (uint256 timestamp) {
                return toTimestamp(year, month, day, hour, 0, 0);
        }

        function toTimestamp3(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute) public pure returns (uint256 timestamp) {
                return toTimestamp(year, month, day, hour, minute, 0);
        }

        function toTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) public pure returns (uint256 timestamp) {
                uint256 i;

                // Year
                for (i = ORIGIN_YEAR; i < year; i++) {
                        if (isLeapYear(i)) {
                                timestamp += LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                timestamp += YEAR_IN_SECONDS;
                        }
                }

                // Month
                uint256[12] memory monthDayCounts;
                monthDayCounts[0] = 31;
                if (isLeapYear(year)) {
                        monthDayCounts[1] = 29;
                }
                else {
                        monthDayCounts[1] = 28;
                }
                monthDayCounts[2] = 31;
                monthDayCounts[3] = 30;
                monthDayCounts[4] = 31;
                monthDayCounts[5] = 30;
                monthDayCounts[6] = 31;
                monthDayCounts[7] = 31;
                monthDayCounts[8] = 30;
                monthDayCounts[9] = 31;
                monthDayCounts[10] = 30;
                monthDayCounts[11] = 31;

                for (i = 1; i < month; i++) {
                        timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
                }

                // Day
                timestamp += DAY_IN_SECONDS * (day - 1);

                // Hour
                timestamp += HOUR_IN_SECONDS * (hour);

                // Minute
                timestamp += MINUTE_IN_SECONDS * (minute);

                // Second
                timestamp += second;

                return timestamp;
        }
}