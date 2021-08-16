for n in 1..3001 do
  File.open("trash_#{n.to_s.rjust(4, "0")}", "w") do |file|
    file.write("ignorable content")
  end
end

