fs = require 'fs'
students = require './students'

filename = './example.json' ? process.argv[2]
data = JSON.parse(fs.readFileSync(filename))
answer = students.find_valid_groups data
response = JSON.stringify answer
console.log response
