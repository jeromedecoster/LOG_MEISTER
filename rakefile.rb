require 'hpricot'
require 'xml'
require 'fileutils'

task :clean_report do
  
  if ENV['file'].nil?
    puts "environment var 'file' required"
    exit 1
  end
  
  elems = get_def ENV['file']
  
  ids = []
  elems.each{ |e| ids << e[:id] }
  ids.sort!
  
  save_def ENV['file'], ids
  
end

task :finalize_report do
  
  if ENV['file'].nil?
    puts "environment var 'file' required"
    exit 1
  end
  
  if ENV['clean'].nil?
    puts "environment var 'clean' required"
    exit 1
  end
  
  if ENV['report'].nil?
    puts "environment var 'report' required"
    exit 1
  end
  
  #puts "file:#{ENV['file']}"
  #puts "clean:#{ENV['clean']}"
  #puts "report:#{ENV['report']}"
  
  if ENV['clean'] == 'true'
    elems = get_def ENV['file']
    
    ids = []
    elems.each{ |e| ids << e[:id] if e[:id][0] != '_' && e[:id][0] != 95 }
    ids.sort!
    
    save_def ENV['file'], ids
  end
  
  if ENV['report'] != ''
    FileUtils.mv ENV['file'], ENV['report']
  else
    FileUtils.rm ENV['file']
  end
  
  FileUtils.rm ["#{ENV['file']}.ref", "#{ENV['file']}.inc", "#{ENV['file']}.exc"]
  
end

task :split_report do
  
  if ENV['file'].nil?
    puts "environment var 'file' required"
    exit 1
  end
  
  #puts "file:#{ENV['file']}"
  
  elems = get_def ENV['file']
  
  inc = []
  exc = []
  elems.each do |e|
    if e[:id][0] != '_' && e[:id][0] != 95
      inc << e[:id]
    else
      exc << e[:id]
    end
  end
  
  inc.sort!
  exc.sort!
  
  FileUtils.cp ENV['file'], "#{ENV['file']}.ref"
  save_def "#{ENV['file']}.inc", inc
  save_def "#{ENV['file']}.exc", exc  
  
end


def get_def(file)
  
  # ouvrir le fichier de cette maniere force Hpricot
  # a fermer les noeuds <dep /> generes par mxmlc pour 
  # les rendre valide XHTML. Ce qui permet d'effectuer
  # la recherche via XPath
  doc = open(ENV['file']) { |f| Hpricot.XML(f) }
  
  elems = doc.search('//def')
  
end


def save_def(file, array)
  
  xml = XML::Document.new
  xml.root = XML::Node.new 'datas'
  
  array.each do |i|
    node = XML::Node.new 'def'
    XML::Attr.new node, 'id', i
    xml.root << node
  end
  
  xml.save(file, :indent => true, :encoding => XML::Encoding::UTF_8)
  
end

__END__

Windows
=======
01 - Install latest Ruby version: http://rubyinstaller.org/downloads/ (C:\Ruby192)
02 - Add Ruby/bin in PATH
03 - Download development kit: http://rubyinstaller.org/downloads/
04 - Create folder (C:\Ruby192\devkit) and extract DevKit here. (No space, no special char)
05 - Run "ruby dk.rb init"
06 - Run "ruby dk.rb install"
07 - Run "gem list"
08 - Run "gem install hpricot" to install hpricot: http://rubygems.org/gems/hpricot
09 - Run "gem install libxml-ruby" to install libxml: http://rubygems.org/gems/libxml-ruby
10 - Run "gem list"
11 - If, when run the rake file, error with libxml like:
	"can't find libxml2-2.dll" or "no such file to load -- libxml_ruby" then:
	Locate "libxml2-2.dll" and "libiconv-2.dll"
	(...\lib\ruby\gems\1.9.1\gems\libxml-ruby-2.0.6-x86-mingw32\lib\libs)
    Paste the 2 dll in the bin ruby folder (C:\Ruby192\bin)




