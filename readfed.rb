class Fed
    attr_accessor :fedno
    attr_accessor :title
    attr_accessor :author
    attr_accessor :content
    # Constructor
    def initialize()
      @fedno=0
      @title=""
      @author=""
      @content=""
    end
    # Method to print data on one Fed object
    def prt
       puts "Federalist #@fedno\n"
       puts "\n#@title\n"
       puts "\n#@author\n"
       puts "\n#@content\n"
    end
end

#=========================
# Main program
#=========================

# Input will come from file fed.txt
file = File.new("fed.txt", "r")
# List of Fed objects
feds = []
curFed = nil
# Read and process each line
while (line = file.gets)
    line.strip!                 # Remove trailing white space
    words = line.split          # Split into array of words
    if words.length == 0 then   # If nothing in words (i.e. empty line), skip
        next
    end

    # "FEDERALIST No. number" starts a new Fed object
    if words[0] == "FEDERALIST" then
       curFed = Fed.new    # Construct new Fed object
       feds << curFed      # Add it to the array
       curFed.fedno = words[2]
       next
    end

    if (curFed.author != "") && (curFed.fedno != 0) && (curFed.title != "") then
        curFed.content = curFed.content +  line + "\n"
    end

    # INPUT : A line of text from the Federalist
    # OUTPUT: If the name JAY, MADISON, or HAMILTON shows up
    # SOURCE: RegExr.com
    if line.match(/(JAY)|(MADISON)|(HAMILTON)/) then
        curFed.author = line
    end

    if (curFed.fedno != 0) && (curFed.author == "") then
        curFed.title = curFed.title + "\n" + line
    end

    # INPUT : A line of text from the Federalist
    # OUTPUT: If the word PUBLIUS shows up
    # SOURCE: RegExr.com
    if line.match(/(PUBLIUS)/) then
        curFed = nil
    end
end # End of reading

file.close
fileHtml = File.new("fedindex.html", "w+")
fileHtml.puts "<HTML>"
fileHtml.puts "<HEAD><TITLE>Federalist Index</TITLE></HEAD>"
fileHtml.puts "<BODY><H2>Federalist Index</H1><TABLE>"
fileHtml.puts "<tr><th>No.</th><th>Author</th><th>Title</th><th>Pub</th></tr>"
# Apply the prt (print) method to each Fed object in the feds array
feds.each{|f|
    fedHtml = File.new("fedno" + f.fedno + ".html", "w+")
    fedHtml.puts "<HTML>"
    fedHtml.puts "<HEAD><TITLE>Federalist No. " + f.fedno + "</TITLE></HEAD>"
    fedHtml.puts "<H1>Federalist No. " + f.fedno + " </H1>"
    fedHtml.puts "<H2>" + f.title + "</H2>"
    fedHtml.puts "<H3>" + f.author + "</H3>"
    fedHtml.puts "<P>" + f.content + "</P>"
    fedHtml.puts "<BR><P><a href=\"fedindex.html\">Back to main page</a></P>"
    fedHtml.puts "<BODY>"
    fedHtml.puts "</BODY></HTML>"

    fileHtml.puts "<TR>"
    fileHtml.puts "<TD><a href=\"fedno" + f.fedno + ".html\">" + f.fedno + "</a></TD>"
    fileHtml.puts "<TD>" + f.title + "</TD>"
    fileHtml.puts "<TD>" + f.author + "</TD>"
    fileHtml.puts "<TD>" + f.content[40..60] + "...</TD>"
    fileHtml.puts "</TR>"
}
fileHtml.puts "</TABLE></BODY></HTML>"
fileHtml.close
