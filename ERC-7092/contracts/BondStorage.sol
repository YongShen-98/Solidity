// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.18;

contract BondStorage {
    /*
        isin：这是一个字符串，表示国际证券识别码（ISIN），是一种用于唯一标识证券的国际标准编码。
        name：也是一个字符串，表示债券的名称，通常是一个人类可读的描述性名称，以便人们识别和理解债券。
        symbol：同样是一个字符串，表示债券的符号或简称，通常是一个短字符串，用于在交易所或市场上唯一标识债券。
        currency：这是一个以太坊地址（address），表示债券的货币，可能是以太币（Ether）或其他代币。
        currencyOfCoupon：同样是一个以太坊地址，表示债券的票息支付货币，可能与债券本身的货币不同。\
        decimals：这是一个8位无符号整数（uint8），表示债券的小数位数，用于对债券面额和票息率进行精确度控制。
        denomination：这是一个256位无符号整数（uint256），表示债券的面额，即债券的标面价值。
        issueVolume：这是一个256位无符号整数，表示债券的发行数量，通常以债券单位（面额）为单位。
        couponRate：这是一个256位无符号整数，表示债券的票息率，即债券每年支付的利息率。
        couponType：这是一个256位无符号整数，表示债券的票息类型，可能表示不同的票息计算方式。
        couponFrequency：这是一个256位无符号整数，表示债券的票息支付频率，通常以年为单位。
        issueDate：这是一个256位无符号整数，表示债券的发行日期，以Unix时间戳格式表示。
        maturityDate：这是一个256位无符号整数，表示债券的到期日，以Unix时间戳格式表示。
        dayCountBasis：这是一个256位无符号整数，表示债券的计息基准，用于确定票息计算的时间间隔。
    */
    struct Bond {
        string isin;             //国际证券识别码（ISIN）
        string name;             //债券的名称
        string symbol;           //债券的符号或简称
        address currency;        //债券的币种，本金的货币的合同地址
        address currencyOfCoupon;//债券的票息支付货币
        uint8 decimals;          //债券的小数位数
        uint256 denomination;    //债券的面额
        uint256 issueVolume;     //债券的发行数量
        uint256 couponRate;      //债券的票息率
        uint256 couponType;      //债券的票息类型
        uint256 couponFrequency; //债券的票息支付频率
        uint256 issueDate;       //债券的发行日期
        uint256 maturityDate;    //债券的到期日
        uint256 dayCountBasis;   //债券的计息基准，用于计算利息的基准方法
    }

    /**
    发行方 
        name: 发行者的名称或名字。
        email:发行者的电子邮件地址。
        country: 发行者所在的国家。
        headquarters: 发行者的总部地址。
        issuerType: 发行者的类型或性质。
        creditRating: 发行者的信用评级，表示其信用质量的等级。
        carbonCredit（无符号整数类型 uint256）：发行者的碳信用额度或碳排放权。
        issuerAddress（地址类型 address）：发行者的以太坊地址 
    */
    struct Issuer {
        string name;            //发行者的名称或名字
        string email;           //发行者的电子邮件地址
        string country;         //发行者所在的国家
        string headquarters;    //发行者的总部地址
        string issuerType;      //发行者的类型或性质
        string creditRating;    //发行者的信用评级
        //uint256 carbonCredit; //发行者的碳信用额度或碳排放权
        address issuerAddress;  //发行者的以太坊地址
    }

    struct IssueData {
        address investor;
        uint256 principal;
    }

    /**
    UNREGISTERED：  这个常量表示债券的状态为未注册。
                    这通常是债券的初始状态，表示债券还未在系统中注册或创建。
    SUBMITTED：     这个常量表示债券的状态为已提交。
                    这可能表示债券发行者已经提交了必要的文件或信息，以便注册或发行债券，但债券尚未正式发行。
    ISSUED：        这个常量表示债券的状态为已发行。一旦债券发行成功，并且投资者开始持有债券，债券的状态通常会变为已发行。
    REDEEMED：      这个常量表示债券的状态为已赎回。当债券到期或在其他条件下被赎回时，债券的状态可能会变为已赎回。
                    赎回意味着债券发行者已经支付了债券的本金和利息，债券不再存在。
    */
    enum BondStatus {UNREGISTERED, SUBMITTED, ISSUED, REDEEMED}

    mapping(string => Bond) internal _bond;
    mapping(string => Issuer) internal _issuer;
    mapping(address => uint256) internal _principals;
    mapping(address => mapping(address => uint256)) internal _approvals;

    string internal bondISIN;
    string internal _countryOfIssuance;

    BondStatus internal _bondStatus;
    IssueData[] internal _listOfInvestors;

    address internal _bondManager;

    modifier onlyBondManager {
        require(msg.sender == _bondManager, "BondStorage: ONLY_BOND_MANAGER");
        _;
    }

    event BondIssued(IssueData[] _issueData, Bond _bond);
    event BondRedeemed();

    function bondStatus() external view returns(BondStatus) {
        return _bondStatus;
    }

    function listOfInvestors() external view returns(IssueData[] memory) {
        return _listOfInvestors;
    }

    function bondInfo() public view returns(Bond memory) {
        return _bond[bondISIN];
    }

    function issuerInfo() public view returns(Issuer memory) {
        return _issuer[bondISIN];
    }
}