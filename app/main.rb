require "app/marshal.rb"
require "app/stuff.rb"

def tick args
  args.outputs.labels << [ 580, 500, 'Hello World!' ]
  args.outputs.labels << [ 475, 150, '(Consider reading README.txt now.)' ]
  $gtk.args.state.stuff ||= Stuff.new

end


def save_file
  File.open("savefile.txt", "w") do |f| 
    f.write "#{Marshal.dump($gtk.args.state.stuff)}" 
    
  end
end

def load_file
  $gtk.args.state.second_stuff = Marshal.load('savefile.txt')
end