class Factory
	def self.new *args, &block
		Class.new do
			args.each { |e| attr_reader e }

			define_method :initialize do |*arguments|
				arguments.each_with_index do |value, index|
					instance_variable_set("@#{args[index]}", value)
				end
			end

			def [](key)
				if (key.kind_of?(Integer))
					self.instance_variable_get(self.instance_variables[key])
				else
					self.send(key)
				end
			end

			yield block if block_given?
		end
	end
end

Customer = Factory.new(:name, :address, :zip) do
	public
	def greet
		"#{@name} say hello!"
	end
end

joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)

puts joe.name
puts joe["name"]
puts joe[:name]
puts joe[0]

puts joe.greet