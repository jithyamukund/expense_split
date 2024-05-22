# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

split_types = [{ type_name: 'equal', description: 'split equally' },
               { type_name: 'exact amounts', description: 'specify exactly how much each person owes' },
               { type_name: 'percentage', description: 'enter percentage split' },
               { type_name: 'shares', description: 'split by shares' },
               { type_name: 'adjustment', description: 'split by adjustment' }]

split_types.each do |type|
  SplitType.find_or_create_by(type)
end
