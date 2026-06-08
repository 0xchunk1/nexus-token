// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title Nexus Token (NXS)
 * @notice Mint 1000 NXS for $0.50 USD in BNB. BNB auto-forwarded to treasury.
 */
contract NexusToken is ERC20, Ownable, ReentrancyGuard {
    // ============ STATE ============

    uint256 public mintPrice;
    uint256 public constant TOKENS_PER_MINT = 1000 * 1e18;
    uint256 public maxSupply;
    bool public mintActive;
    uint256 public totalCollected;
    mapping(address => uint256) public mintCount;

    /// @notice Maximum mints per wallet (anti-whale, fair distribution)
    uint256 public constant MAX_MINTS_PER_WALLET = 3;

    /// @notice Wallet where BNB is forwarded on every mint
    address public treasury;

    // ============ EVENTS ============

    event Minted(address indexed buyer, uint256 amount, uint256 pricePaid);
    event MintPriceUpdated(uint256 oldPrice, uint256 newPrice);
    event MintToggled(bool active);
    event MaxSupplyUpdated(uint256 oldSupply, uint256 newSupply);
    event TreasuryUpdated(address oldTreasury, address newTreasury);
    event Withdrawn(address indexed to, uint256 amount);

    // ============ CONSTRUCTOR ============

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _mintPrice,
        uint256 _maxSupply,
        address _treasury
    ) ERC20(_name, _symbol) Ownable(msg.sender) {
        require(_mintPrice > 0, "Mint price must be > 0");
        require(_maxSupply >= TOKENS_PER_MINT, "Max supply too low");
        require(_treasury != address(0), "Treasury cannot be zero");

        mintPrice = _mintPrice;
        maxSupply = _maxSupply;
        treasury = _treasury;
        mintActive = true;
    }

    // ============ MINT ============

    /**
     * @notice Mint 1000 NXS. BNB langsung dikirim ke treasury.
     */
    function mint() external payable nonReentrant {
        require(mintActive, "Minting is paused");
        require(msg.value == mintPrice, "Incorrect payment amount");
        require(
            mintCount[msg.sender] < MAX_MINTS_PER_WALLET,
            "Max 3 mints per wallet"
        );
        require(
            totalSupply() + TOKENS_PER_MINT <= maxSupply,
            "Max supply reached"
        );

        totalCollected += msg.value;
        mintCount[msg.sender]++;
        _mint(msg.sender, TOKENS_PER_MINT);

        // Forward BNB langsung ke treasury
        (bool sent, ) = treasury.call{value: msg.value}("");
        require(sent, "Treasury transfer failed");

        emit Minted(msg.sender, TOKENS_PER_MINT, msg.value);
    }

    /**
     * @notice Batch mint N x 1000 NXS. BNB langsung ke treasury.
     */
    function batchMint(uint256 times) external payable nonReentrant {
        require(mintActive, "Minting is paused");
        require(times > 0, "Times must be > 0");
        require(
            mintCount[msg.sender] + times <= MAX_MINTS_PER_WALLET,
            "Max 3 mints per wallet"
        );

        uint256 totalCost = mintPrice * times;
        uint256 totalTokens = TOKENS_PER_MINT * times;

        require(msg.value == totalCost, "Incorrect payment amount");
        require(totalSupply() + totalTokens <= maxSupply, "Max supply reached");

        totalCollected += msg.value;
        mintCount[msg.sender] += times;
        _mint(msg.sender, totalTokens);

        // Forward BNB langsung ke treasury
        (bool sent, ) = treasury.call{value: msg.value}("");
        require(sent, "Treasury transfer failed");

        emit Minted(msg.sender, totalTokens, msg.value);
    }

    // ============ OWNER ============

    function setMintPrice(uint256 _newPrice) external onlyOwner {
        require(_newPrice > 0, "Price must be > 0");
        emit MintPriceUpdated(mintPrice, _newPrice);
        mintPrice = _newPrice;
    }

    function toggleMint() external onlyOwner {
        mintActive = !mintActive;
        emit MintToggled(mintActive);
    }

    function setMaxSupply(uint256 _newMax) external onlyOwner {
        require(_newMax >= totalSupply(), "Below current supply");
        emit MaxSupplyUpdated(maxSupply, _newMax);
        maxSupply = _newMax;
    }

    /**
     * @notice Ganti treasury address (wallet penerima BNB)
     */
    function setTreasury(address _newTreasury) external onlyOwner {
        require(_newTreasury != address(0), "Cannot be zero address");
        emit TreasuryUpdated(treasury, _newTreasury);
        treasury = _newTreasury;
    }

    /**
     * @notice Tarik BNB yang tersangkut di kontrak (stray funds / edge-case)
     */
    function withdrawStuck() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No BNB stuck");

        (bool success, ) = treasury.call{value: balance}("");
        require(success, "Withdraw failed");

        emit Withdrawn(treasury, balance);
    }

    // ============ VIEW ============

    function remainingSupply() external view returns (uint256) {
        if (totalSupply() >= maxSupply) return 0;
        return maxSupply - totalSupply();
    }

    function mintsRemaining() external view returns (uint256) {
        if (totalSupply() >= maxSupply) return 0;
        return (maxSupply - totalSupply()) / TOKENS_PER_MINT;
    }

    // Prevent accidental BNB sends
    receive() external payable {
        revert("Use mint() to send BNB");
    }
}
