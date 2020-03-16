# For advanced users:
# You can put some quick verification tests here, any method
# that starts with the `test_` will be run when you save this file.

# Here is an example test and game

# To run the test: ./dragonruby mygame --eval tests.rb --no-tick


class Stuff
  attr_accessor :number, :number2, :string1, :array1
  def initialize
    self.number = 1
    self.number2 = 2
    self.string1 = "test string 1"
    
    
  end
end

class MarshalTest
  require "app/marshal.rb"
  attr_gtk

  def tick
    args.state.stuff ||= Stuff.new
  end

  def save_file(obj)
  File.open("savefile.txt", "w") do |f| 
    f.write "#{Marshal.dump(obj)}" 
    
  end
end

def load_file
   Marshal.load('savefile.txt')
end
end

def test_assert args, assert
  game = MarshalTest.new
  game.args = args
  game.tick
  assert.false!  args.state.stuff == 1, "failure: assertion didn't work right"
  puts "test_assert completed successfully"
end

def test_number args, assert
  game = MarshalTest.new
  game.args = args
  game.tick
  game.save_file(game.args.state.stuff)
  t = game.load_file
  assert.true!  args.state.stuff.number == t.number, "failure: the value isn't 1"
  puts "test_number completed"
end

def test_multiple_numbers args, assert
  game = MarshalTest.new
  game.args = args
  game.tick
  game.save_file(game.args.state.stuff)
  t = game.load_file
  assert.true!  args.state.stuff.number == t.number, "failure: the value aren't equal"
  assert.true!  args.state.stuff.number2 == t.number2, "failure: the value aren't equal"
  assert.false!  args.state.stuff.number == t.number2, "failure: the value shouldn't be equal"
  puts "test_multiple_numbers completed"
end

def test_strings args, assert
  game = MarshalTest.new
  game.args = args
  game.tick
  game.save_file(game.args.state.stuff)
  t = game.load_file
  assert.true!  args.state.stuff.string1 == t.string1, "failure: the value don't match"
  puts "test_strings completed"
end

def test_arrays args, assert
  game = MarshalTest.new
  game.args = args
  game.tick
  game.args.state.stuff.array1 = Array.new
  game.args.state.stuff.array1 << 1
  game.args.state.stuff.array1 << 2
  
  game.save_file(game.args.state.stuff)
  t = game.load_file

  assert.true!  args.state.stuff.array1[0] == t.array1[0], "failure: the value don't match"
  assert.true!  args.state.stuff.array1[1] == t.array1[1], "failure: the value don't match"
  assert.false!  args.state.stuff.array1[0] == t.array1[1], "failure: the value should not match"
  puts "test_arrays completed"
end

puts "running tests"
$gtk.reset 100
$gtk.log_level = :off
$gtk.tests.start

