require "app/marshal.rb"
require "app/stuff.rb"

def tick args
  $gtk.args.state.stuff ||= Stuff.new

end


def save_file
  File.open("savefile.txt", "w") do |f| 
    f.write "#{Marshal.dump($gtk.args.state.stuff)}" 
    
  end
end

def load_file
  $gtk.args.state.second_stuff = Marshal.load(File.read('savefile.txt'))
end

