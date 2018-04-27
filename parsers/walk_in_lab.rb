module Parser
  module WalkInLab
    def self.parse(file)
      reader = PDF::Reader.new(file)
      results = []
      reader.pages.each do |page|
        lines = page.text.split("\n")
        parse_test_list_now = false
        tests_ordered = []
        test_date = nil

        # Extract list of tests, and test date
        lines.each do |line|
          line.strip!
          next if line.length == 0
          # If the flag is set, extract the tests ordered
          if parse_test_list_now
            tests_ordered = line.split(';')
            tests_ordered.each {|test| test.strip!}
            parse_test_list_now = false
          end
          # When we find the `Ordered Items` text, the next line will have the list of tests ordered
          if line.match(/Ordered Items/)
            parse_test_list_now = true
          end
          # Match test data
          if line.match?(/Date collected/)
            match_result = line.match('Date collected:\s+(\d+/\d+/\d+)')
            test_date = match_result[1]
          end
        end

        # Extract test results
        Struct.new("TestResults", :name, :lab, :result, :range, :unit, :test_date)
        lines.each do |line|
          line.strip!
          next if line.length == 0
          if line.start_with?(*tests_ordered)
            # Clean up the test results data
            fields = line.split("    ")
            fields.each {|field| field.strip!}
            fields.reject! {|field| field.length == 0 || field == 'High'}
            p fields
            p line
            # If we finally end up with 4 fields, it means we matched the correct line
            if fields.length == 5
              result = Struct::TestResults.new(fields[0], "Walk In Lab", fields[1], fields[3], fields[4], test_date).to_h.to_json
              results << result
            end
          end
        end
      end
      results
    end
  end
end