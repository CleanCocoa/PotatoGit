import Clibgit2

public struct CheckoutStrategy: OptionSet, ExpressibleByNilLiteral {
    public let rawValue: UInt

    // MARK: - Initialization

    public init(nilLiteral: ()) {
        self.rawValue = 0
    }

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public init(_ strategy: git_checkout_strategy_t) {
        self.rawValue = UInt(strategy.rawValue)
    }

    public static var allZeros: CheckoutStrategy {
        return self.init(rawValue: 0)
    }

    public var gitCheckoutStrategy: git_checkout_strategy_t {
        return git_checkout_strategy_t(UInt32(self.rawValue))
    }

    // MARK: - Values

    /// Default is a dry run, no actual updates.
    public static let none = CheckoutStrategy(GIT_CHECKOUT_NONE)

    /// Allow safe updates that cannot overwrite uncommitted data.
    public static let safe = CheckoutStrategy(GIT_CHECKOUT_SAFE)

    /// Allow all updates to force working directory to look like index
    public static let force = CheckoutStrategy(GIT_CHECKOUT_FORCE)

    /// Allow checkout to recreate missing files.
    public static let recreateMissing = CheckoutStrategy(GIT_CHECKOUT_RECREATE_MISSING)

    /// Allow checkout to make safe updates even if conflicts are found.
    public static let allowConflicts = CheckoutStrategy(GIT_CHECKOUT_ALLOW_CONFLICTS)

    /// Remove untracked files not in index (that are not ignored).
    public static let removeUntracked = CheckoutStrategy(GIT_CHECKOUT_REMOVE_UNTRACKED)

    /// Remove ignored files not in index.
    public static let removeIgnored = CheckoutStrategy(GIT_CHECKOUT_REMOVE_IGNORED)

    /// Only update existing files, don't create new ones.
    public static let UpdateOnly = CheckoutStrategy(GIT_CHECKOUT_UPDATE_ONLY)

    /// Normally checkout updates index entries as it goes; this stops that.
    /// Implies `DontWriteIndex`.
    public static let dontUpdateIndex = CheckoutStrategy(GIT_CHECKOUT_DONT_UPDATE_INDEX)

    /// Don't refresh index/config/etc before doing checkout
    public static let noRefresh = CheckoutStrategy(GIT_CHECKOUT_NO_REFRESH)

    /// Allow checkout to skip unmerged files
    public static let skipUnmerged = CheckoutStrategy(GIT_CHECKOUT_SKIP_UNMERGED)

    /// For unmerged files, checkout stage 2 from index
    public static let useOurs = CheckoutStrategy(GIT_CHECKOUT_USE_OURS)

    /// For unmerged files, checkout stage 3 from index
    public static let useTheirs = CheckoutStrategy(GIT_CHECKOUT_USE_THEIRS)

    /// Treat pathspec as simple list of exact match file paths
    public static let disablePathspecMatch = CheckoutStrategy(GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH)

    /// Ignore directories in use, they will be left empty
    public static let skipLockedDirectories = CheckoutStrategy(GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES)

    /// Don't overwrite ignored files that exist in the checkout target
    public static let dontOverwriteIgnored = CheckoutStrategy(GIT_CHECKOUT_DONT_OVERWRITE_IGNORED)

    /// Write normal merge files for conflicts
    public static let conflictStyleMerge = CheckoutStrategy(GIT_CHECKOUT_CONFLICT_STYLE_MERGE)

    /// Include common ancestor data in diff3 format files for conflicts
    public static let conflictStyleDiff3 = CheckoutStrategy(GIT_CHECKOUT_CONFLICT_STYLE_DIFF3)

    /// Don't overwrite existing files or folders
    public static let dontRemoveExisting = CheckoutStrategy(GIT_CHECKOUT_DONT_REMOVE_EXISTING)

    /// Normally checkout writes the index upon completion; this prevents that.
    public static let dontWriteIndex = CheckoutStrategy(GIT_CHECKOUT_DONT_WRITE_INDEX)
}
