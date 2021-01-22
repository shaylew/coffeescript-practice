combinatorics = require './combinatorics'

students = module.exports

# Check that at most one student in the group is noisy.
students.not_too_noisy = (group) -> 
    noisy = group.filter (student) -> student.noisy
    return noisy.length <= 2

# Check that at least one student in the group understands the material.
students.someone_understands = (group) ->
    return group.some (student) -> student.understands

# Check that no student in the group fights with any other student in the group.
students.no_fighting_pairs = (group) ->
    for student in group
        conflict = group.some (other) -> student.fights_with.includes(other.name)
        if conflict then return false
    return true

# Check that a group of students meets all our criteria.
students.group_is_valid = (group) ->
    return (students.not_too_noisy(group) &&
            students.someone_understands(group) &&
            students.no_fighting_pairs(group))

# Find a set of valid groups for the given students. Returns either an array of
# arrays containing the names of students in each group, or an object containing
# an error message in its `.error` key.
students.find_valid_groups = (json) ->
    num_groups = json.groups
    people = json.students

    group_sizes = combinatorics.even_group_sizes people.length, num_groups

    for groups from combinatorics.valid_groupings people, group_sizes, students.group_is_valid
        return ((student.name for student in group) for group in groups)
    return {
        error: "UNPOSSIBLE"
    }
