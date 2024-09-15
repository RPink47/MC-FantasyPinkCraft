def self.compare_mods(mods_doc, mods2)
  mod_list_doc = Array.new(mods_doc)
  mod_list2 = mods2.map { |e| e.split(".jar")[0]}
  mod_list_doc.delete_if do |mod|
    idx = mod_list2.index(mod)
    if idx then
      mod_list2.delete_at idx
      true
    end
  end
  return mod_list_doc, mod_list2
end

def self.nice_mod(mods)
  return "None!" if mods.length == 0
  if mods.length < 4 then 
    return mods.join("; ")
  else
    return "\n\t" + mods.join(";\n\t")
  end
end

mods_folder = Dir.entries("server-mods")[2..-1]
server_mods_folder = Dir.entries("instalations/mods")[2..-1]
mods_doc = File.open("mods.md")
mods_doc_contents = mods_doc.read.split(/\n(## [\w\/ \-]+)/).map { |e| e.split(/\n/)}
mods_doc.close
# pp mods_doc_contents
# pp mods_doc_contents.index {|e| e[0] == "## Mod list"}
mod_list = mods_doc_contents[(mods_doc_contents.index {|e| e[0] == "## Mod list"})+1]
  .select { |e| e.match(/^- \[?\w+\]?/)}
  .map { |e| e[2..-1].split(/ *\(/)[0].gsub(/\[([\w\/ \.\-]+)\]/,'\\1') }

out = compare_mods(mod_list, mods_folder)
out2 = compare_mods(mod_list, server_mods_folder)

puts "\n\n"
#pp out2[1]
puts "Documented not used mods: " + nice_mod(out[0].union(out2[0]))
puts "Client mods: " + nice_mod(out[1])
puts "Server mods: " + nice_mod(out2[1])