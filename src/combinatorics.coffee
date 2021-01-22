combinatorics = module.exports

# Divide `count` items as evenly as possible into `num_groups` groups. Returns
# an array of `num_groups` group sizes that add up to `count`.
combinatorics.even_group_sizes = (count, num_groups) ->
    small_size = Math.floor count / num_groups
    num_large = count % num_groups
    num_small = num_groups - num_large

    return [
        new Array(num_small).fill(small_size)...
        new Array(num_large).fill(small_size + 1)...
    ]

# Yield each possible way to select `r` elements from `array`, ignoring order.
# Each result generated is a pair containing the `r` elements that were picked
# and the `array.length - r` elements that were left out.
combinatorics.combinations = (array, r) ->
    if array.length < r
        # 0 ways to pick more things than there are
        return
    else if r == 0
        # 1 way to pick 0 things
        yield [[], array]
    else if array.length == r
        # 1 way to pick all the things
        yield [array, []]
    else
        # Otherwise, we can consider the first element of the array and choose
        # to either include or exclude it.
        first = array[0]
        rest = array[1..]

        # We can include it, then pick `r - 1` things from the remaining items.
        for [combination, unused] from combinatorics.combinations rest, r - 1
            yield [[first, combination...], unused]

        # Or we can skip it, and keep looking for `r` picks from what's left.
        for [combination, unused] from combinatorics.combinations rest, r
            yield [combination, [first, unused...]]

# Yield all valid divisions of an array into groups, with each group satisfying
# `predicate`. The `sizes` array specifies the number of elements to put in its
# corresponding group.
#
# N.B. this is one function -- rather than separate group generation and
# filtering -- because we want to fail early. If we generate one group and it's
# not valid, there's no point trying to continue filling the rest of the groups
# from the remainder of the array.
combinatorics.valid_groupings = (array, sizes, predicate) ->
    if sizes.length == 0
        # There's only one way to pick 0 groups, and all 0 of them are valid.
        yield []
    else
        # Otherwise we try each combination to fill out the first group, and if
        # that combination is valid we go on trying to fill out the rest.
        size = sizes[0]
        other_sizes = sizes[1..]
        for [combination, other_items] from combinatorics.combinations array, size
            if predicate combination
                for other_groups from combinatorics.valid_groupings other_items, other_sizes, predicate
                    yield [combination, other_groups...]
