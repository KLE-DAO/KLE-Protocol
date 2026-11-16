// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: transfer amount exceeds allowance"
            );
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IUniswapV2Pair {
    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function sync() external;
}

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts);
}

contract KLEToken is ERC20, Ownable, ReentrancyGuard {

    uint256 private constant FEE_PRECISION = 10000;   // fee / slippage precision
    uint256 private constant DROP_5PCT = 500;         // 5% drop threshold
    uint256 private constant DROP_10PCT = 1000;       // 10% drop threshold
    uint256 private constant DROP_50PCT = 5000;       // 50% drop threshold
    uint256 private constant SLIPPAGE_16 = 1600;      // 5%~10% band slippage 16%
    uint256 private constant SLIPPAGE_29 = 2900;      // >=10% band slippage 29%
    uint256 private constant SLIPPAGE_99 = 9900;      // >=50% band slippage 99% (max)
    uint256 private constant MAX_SELL_VALUE_USD = 100000 * 1e18;
    address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
    uint256 private constant INITIAL_SELL_FEE = 300;

    enum TransactionType {
        Buy, 
        Sell, 
        AddLiquidity, 
        RemoveLiquidity, 
        NormalTransfer 
    }

    struct FeeDetail {
        uint256 fee;        
        address recipient;  
    }

    IUniswapV2Router02 public uniswapV2Router;
    mapping(address => bool) public ammPairs;
    address public uniswapV2Pair;
    mapping(TransactionType => FeeDetail[]) public feeConfigs;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public blacklist;
    bool public buyingEnabled = false;   
    bool public sellingEnabled = true; 
    address public stakeToken;

    // Auto slippage adjustment: baseline price, toggle
    uint256 public baselinePrice = 1e18;
    bool public slippageAdjustEnabled = true;
    // AMM swap fee (numerator/denominator). Set from pairFeeBps: num = 10000 - bps.
    // BSC testnet: bps=20 (0.2%) | BSC mainnet: bps=25 (0.25%)
    uint256 public pairFeeNumerator;
    uint256 public pairFeeDenominator;

    // Daily session trigger window, in seconds of the UTC day.
    // Hardcoded UTC 00:00 - 00:10.
    uint256 public sessionStart = 0;                     // UTC 00:00
    uint256 public sessionEnd = 10 * 60;                 // UTC 00:10 (exclusive)
    uint256 public lastTriggerAt;                        // block.timestamp of the last trigger
    uint256 public sessionTriggerCount;                  // total triggers so far

    // 24h TWAP baseline: last snapshot of the pair's price1CumulativeLast
    // (quote-per-KLE direction; KLE is enforced token1 in the constructor).
    uint256 private _twapCumLast;
    uint256 private _twapTimeLast;

    event WhitelistModified(address indexed _address, bool _status);
    event BlacklistModified(address indexed _address, bool _status);
    event TradingEnabledUpdated(bool _buyenabled, bool _sellenabled);
    event SlippageAdjusted(uint256 baselinePrice, uint256 currentPrice, uint256 drop, uint256 newFeeRate);
    event SlippageAdjustEnabledUpdated(bool enabled);
    event FeeDetailsUpdated(TransactionType indexed _type, address indexed recipient, uint256 fee);
    event SessionTriggered(address indexed triggerer, uint256 at);

    constructor(
        string memory name,
        string memory symbol,
        address _router,
        address _stakeToken,
        uint256 _pairFeeBps,
        address _removeLiquidityFeeRecipient
    ) payable ERC20(name, symbol) {
        _mint(msg.sender, 21000000 * 1e18);
        uniswapV2Router = IUniswapV2Router02(_router);

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            _stakeToken
        );

        ammPairs[uniswapV2Pair] = true;

        stakeToken = _stakeToken;

        require(
            IUniswapV2Pair(uniswapV2Pair).token1() == address(this),
            "KLE must be token1"
        );

        // Swap fee in basis points: num = 10000 - bps, den = 10000.
        // BSC testnet: bps=20 (0.2%) | BSC mainnet: bps=25 (0.25%)
        require(_pairFeeBps > 0 && _pairFeeBps < 1000, "invalid pair fee bps");
        pairFeeNumerator = FEE_PRECISION - _pairFeeBps;
        pairFeeDenominator = FEE_PRECISION;

        feeConfigs[TransactionType.Sell].push(FeeDetail(INITIAL_SELL_FEE, DEAD));

        // RemoveLiquidity: 100% fee to the configured recipient (deployment
        // argument, filled by the deployer). KLE leaving the pair on a "remove
        // liquidity" classification is fully confiscated — real LP removals
        // lose the KLE leg, and a fake LP removal (direct pair swap with a
        // small quote outflow, the 1-wei trick) delivers nothing to the buyer.
        require(
            _removeLiquidityFeeRecipient != address(0),
            "ZERO_FEE_RECIPIENT"
        );
        feeConfigs[TransactionType.RemoveLiquidity].push(
            FeeDetail(FEE_PRECISION, _removeLiquidityFeeRecipient)
        );
    }

    function modifyWhitelist(address _address, bool _status) external onlyOwner {
        whitelist[_address] = _status;
        emit WhitelistModified(_address, _status);
    }

    function modifyBlacklist(address _address, bool _status) external onlyOwner {
        blacklist[_address] = _status;
        emit BlacklistModified(_address, _status);
    }

    function setTradingEnabled(bool _buyenabled,bool _sellenabled) external onlyOwner {
        buyingEnabled = _buyenabled;
        sellingEnabled = _sellenabled;
        emit TradingEnabledUpdated(_buyenabled, _sellenabled);
    }

    function setSlippageAdjustEnabled(bool _enabled) external onlyOwner {
        slippageAdjustEnabled = _enabled;
        emit SlippageAdjustEnabledUpdated(_enabled);
    }

    /**
     * @dev Adjusts Sell slippage based on the price drop against the baseline.
     * Bands (only ever raised):
     *   drop >= 50%  -> 99%
     *   drop >= 10%  -> 29%
     *   5% <= drop < 10% -> 16%
     *   otherwise unchanged (price up or drop < 5%)
     * 99% is the hard cap. Sell config is overwritten as [DEAD, targetFee].
     *
     * NOTE: `sellAmount` is the net KLE actually sent into the pair for this sell
     * (i.e. amount minus fees). We must project the POST-swap price from the
     * pre-swap reserves + this sell, because pair.swap() (which updates the AMM
     * reserves) runs only AFTER _transfer returns — reading getReserves() here
     * would otherwise return the stale pre-swap price and miss this sell's impact.
     */
    function _adjustSellSlippage(uint256 sellAmount) internal {
        if (!slippageAdjustEnabled || baselinePrice == 0) {
            return;
        }
        uint256 currentPrice = _getProjectedSellPrice(sellAmount);

        // Guarded subtraction: when price rose, drop is 0 and no band is entered
        uint256 drop = baselinePrice > currentPrice
            ? (baselinePrice - currentPrice) * FEE_PRECISION / baselinePrice
            : 0;

        // Current Sell fee (first entry used as comparison baseline)
        uint256 currentFee = feeConfigs[TransactionType.Sell].length > 0
            ? feeConfigs[TransactionType.Sell][0].fee
            : 0;

        uint256 targetFee = currentFee;
        if (drop >= DROP_50PCT) {
            if (currentFee < SLIPPAGE_99) {
                targetFee = SLIPPAGE_99;
            }
        } else if (drop >= DROP_10PCT) {
            if (currentFee < SLIPPAGE_29) {
                targetFee = SLIPPAGE_29;
            }
        } else if (drop >= DROP_5PCT) {
            if (currentFee < SLIPPAGE_16) {
                targetFee = SLIPPAGE_16;
            }
        }

        // Immediate effect: the band this sell reaches is written right away and
        // THIS very sell pays it (original design made the next sell pay it).
        // Rates only ever rise until the daily session reset.
        if (targetFee != currentFee) {
            delete feeConfigs[TransactionType.Sell];
            feeConfigs[TransactionType.Sell].push(FeeDetail(targetFee, DEAD));
            emit FeeDetailsUpdated(TransactionType.Sell, DEAD, targetFee);
        }

        emit SlippageAdjusted(baselinePrice, currentPrice, drop, targetFee);
    }

    /**
     * @dev Projects the pair price AFTER the current sell of `sellAmount` KLE
     * is swapped, using the SAME formula as getTokenPrice so the fee factor
     * cancels in the drop comparison.
     */
    function _getProjectedSellPrice(uint256 sellAmount) internal view returns (uint256) {
        address pair = uniswapV2Pair;
        address quote = stakeToken;
        (uint112 r0, uint112 r1, ) = IUniswapV2Pair(pair).getReserves();
        address t0 = IUniswapV2Pair(pair).token0();
        bool kleIsToken0 = (t0 == address(this));
        uint256 reserveKLE = kleIsToken0 ? uint256(r0) : uint256(r1);
        uint256 reserveQuote = kleIsToken0 ? uint256(r1) : uint256(r0);

        if (reserveKLE == 0 || reserveQuote == 0 || sellAmount == 0) {
            return getTokenPrice(address(this));
        }

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = quote;
        uint256 amountOut = uniswapV2Router.getAmountsOut(sellAmount, path)[1];

        uint256 newReserveKLE = reserveKLE + sellAmount;
        uint256 newReserveQuote = reserveQuote > amountOut ? reserveQuote - amountOut : 0;
        if (newReserveKLE == 0 || newReserveQuote == 0) {
            return getTokenPrice(address(this));
        }
        uint256 feeNum = pairFeeNumerator;
        uint256 feeDen = pairFeeDenominator;
        return (1e18 * feeNum * newReserveQuote) / (newReserveKLE * feeDen + 1e18 * feeNum);
    }
    
    function _applyFees(TransactionType _type, address sender,uint256 amount) internal returns (uint256){
        FeeDetail[] storage details = feeConfigs[_type];
        uint256 totalFeeAmount = 0;
        for (uint i = 0; i < details.length; i++) {
            uint256 feeAmount = amount * details[i].fee / FEE_PRECISION;  
            totalFeeAmount += feeAmount;
            super._transfer(sender, details[i].recipient, feeAmount);  
        }
        return totalFeeAmount;
    }
    
    function _determineType(address sender, address recipient) internal view returns (TransactionType) {
        (bool isAdd, bool isDel) = _isLiquidity(sender, recipient);

        if (ammPairs[recipient]) {
            return isAdd ? TransactionType.AddLiquidity : TransactionType.Sell;
        } else if (ammPairs[sender]) {
            return isDel ? TransactionType.RemoveLiquidity : TransactionType.Buy;
        }
        return TransactionType.NormalTransfer;
    }

    function _isLiquidity(
        address from,
        address to
    ) internal view returns (bool isAdd, bool isDel) {
        address token0 = IUniswapV2Pair(address(uniswapV2Pair)).token0();
        (uint r0, , ) = IUniswapV2Pair(address(uniswapV2Pair)).getReserves();
        uint bal0 = IERC20(token0).balanceOf(address(uniswapV2Pair));
        if (ammPairs[to]) {
            if (token0 != address(this) && bal0 > r0) {
                isAdd = bal0 - r0 > 0;
            }
        }
        if (ammPairs[from]) {
            if (token0 != address(this) && bal0 < r0) {
                isDel = r0 - bal0 > 0;
            }
        }
    }

    // Absolute timestamp where the current window occurrence started
    function _currentWindowStart() internal view returns (uint256) {
        return ((block.timestamp - sessionStart) / 1 days) * 1 days + sessionStart;
    }

    function _sessionDuration() internal view returns (uint256) {
        return sessionEnd - sessionStart;
    }

    // Manual trigger: anyone, once per UTC window-day; fails loudly with a reason
    function triggerSession() external {
        uint256 ws = _currentWindowStart();
        require(block.timestamp - ws < _sessionDuration(), "NOT_IN_WINDOW");
        // Blocked when the last trigger belongs to the same UTC day as this window
        require(lastTriggerAt < (ws / 1 days) * 1 days, "ALREADY_TRIGGERED");
        lastTriggerAt = block.timestamp;
        _onSessionTriggered(msg.sender);
    }

    // Transfer hook: silent by design, never reverts
    function _tryTriggerSession() internal {
        uint256 ws = _currentWindowStart();
        if (block.timestamp - ws >= _sessionDuration()) return;
        if (lastTriggerAt >= (ws / 1 days) * 1 days) return;
        lastTriggerAt = block.timestamp;
        _onSessionTriggered(msg.sender);
    }

    /**
     * @dev Reads the pair's price1CumulativeLast and adds the increment the pair
     * would book at its next _update but has not booked yet. The pair's
     * cumulative is maintained lazily: it only advances when a swap/mint/burn/
     * sync runs, so an idle stretch (e.g. a pump held overnight) stays invisible
     * until the first later trade — which is exactly when the session trigger
     * fires, mid-transfer, before the pair's own _update. We therefore account
     * for the pending increment ourselves, computed from the pair's STORED
     * reserves with the exact same formula the pair uses:
     *   floor(r0 * 2**112 / r1) * timeElapsed
     * Pure view math — nothing is written to the pair, so an in-flight
     * swap/mint/burn is never disturbed. The unchecked uint32 wrap mirrors the
     * pair's "overflow is desired" time arithmetic. If the pool has no token1
     * the pending term is skipped (the pair guards the same way).
     */
    function _readEffectivePrice1Cumulative() internal view returns (uint256) {
        address pair = uniswapV2Pair;
        uint256 cum = IUniswapV2Pair(pair).price1CumulativeLast();
        (uint112 r0, uint112 r1, uint32 tsLast) = IUniswapV2Pair(pair).getReserves();
        uint32 timeElapsed;
        unchecked {
            timeElapsed = uint32(block.timestamp) - tsLast;
        }
        if (timeElapsed > 0 && r1 > 0) {
            cum += (uint256(r0) * (2 ** 112) / uint256(r1)) * timeElapsed;
        }
        return cum;
    }

    function _onSessionTriggered(address triggerer) internal {
        sessionTriggerCount++;

        delete feeConfigs[TransactionType.Sell];
        feeConfigs[TransactionType.Sell].push(FeeDetail(INITIAL_SELL_FEE, DEAD));
        emit FeeDetailsUpdated(TransactionType.Sell, DEAD, INITIAL_SELL_FEE);

        // Baseline refresh via 24h TWAP. KLE is enforced token1 in the constructor,
        // so price1CumulativeLast is the quote-per-KLE direction. The trigger may
        // fire inside _transfer while the pair has no liquidity — never let the
        // session action fail a trade (getTokenPrice reverts on price 0).
        // The effective cumulative includes the increment the pair has not yet
        // booked for the idle stretch since its last _update (lazy bookkeeping).
        uint256 cumNow = _readEffectivePrice1Cumulative();
        if (_twapTimeLast == 0) {
            // First snapshot ever: fall back to the current spot. Trusted during
            // the pre-open period (team-arranged price). Seed by calling
            // triggerSession() manually once after liquidity is added.
            try this.getTokenPrice(address(this)) returns (uint256 price) {
                baselinePrice = price;
            } catch {}
        } else if (cumNow > _twapCumLast) {
            uint256 elapsed = block.timestamp - _twapTimeLast;
            if (elapsed > 0) {
                // avg = (cumNow - cumLast) * 1e18 / (elapsed * 2**112)
                uint256 twap = ((cumNow - _twapCumLast) * 1e18) / (elapsed * (2 ** 112));
                if (twap > 0) {
                    baselinePrice = twap;
                }
                // twap == 0, or cumNow == _twapCumLast (no trades since the last
                // snapshot): keep the old baseline, never write 0.
            }
        }
        _twapCumLast = cumNow;
        _twapTimeLast = block.timestamp;

        emit SessionTriggered(triggerer, block.timestamp);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");
        require(!blacklist[sender] && !blacklist[recipient], "BLACKLISTED");

        // Daily session trigger: ANY transfer counts (owner, normal, DEX trade).
        // Silent by design — never reverts, never breaks a transfer.
        _tryTriggerSession();
        
        if (sender == owner() || recipient == owner()) {
            super._transfer(sender, recipient, amount);
            return;
        }

        TransactionType transferType = _determineType(sender, recipient);

        
        if ((transferType == TransactionType.Buy)  && !whitelist[sender] && !whitelist[recipient]) 
        {
            require(buyingEnabled, "Buying are currently disabled");
        }

        if ((transferType == TransactionType.Sell) && !whitelist[sender] && !whitelist[recipient]) 
        {
            require(sellingEnabled, "Selling are currently disabled");
        }

        if(transferType == TransactionType.NormalTransfer){
            super._transfer(sender, recipient, amount);
            return;
        }

        // Sell: raise the band FIRST so the sell that crosses a band pays it
        // immediately. Drop is measured on the net amount net of the CURRENT
        // fee (same math as before — only the timing changed: the current sell
        // pays the band instead of the next one).
        if (transferType == TransactionType.Sell) {
            uint256 currentFee = feeConfigs[TransactionType.Sell].length > 0
                ? feeConfigs[TransactionType.Sell][0].fee
                : 0;
            uint256 netGuess = amount - (amount * currentFee / FEE_PRECISION);
            _adjustSellSlippage(netGuess);
        }

        uint256 feeAmount = _applyFees(transferType, sender, amount);
        uint256 netAmount = amount - feeAmount;

        if (transferType == TransactionType.Sell) {
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = stakeToken;
            uint256 sellProceeds = uniswapV2Router.getAmountsOut(netAmount, path)[1];
            require(sellProceeds <= MAX_SELL_VALUE_USD, "SELL_EXCEEDS_MAX_VALUE");
        }

        super._transfer(sender, recipient, netAmount);
    }

    function getTokenPrice(address token) public view returns (uint256){
        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = address(stakeToken);
        uint256 tokenPrice = uniswapV2Router.getAmountsOut(1 * (10 ** IERC20Metadata(token).decimals()), path)[1];
        require(tokenPrice > 0, "Token price must be greater than zero");
        return tokenPrice;
    }

    function inSessionWindow() public view returns (bool) {
        return block.timestamp - _currentWindowStart() < _sessionDuration();
    }
}