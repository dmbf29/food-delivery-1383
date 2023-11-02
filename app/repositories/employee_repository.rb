require "csv"
require_relative "../models/employee"

class EmployeeRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @employees = []
    @next_id = 1
    load_csv if File.exist?(@csv_file)
  end

  def find(id)
    @employees.find { |employee| employee.id == id }
  end

  def find_by_username(username) # argument is string
    # look into the @employees array and return a employee instance that has the given username
    @employees.find { |employee| employee.username == username }
  end

  def all_riders
    @employees.select do |employee|
      employee.rider?
    end
  end

  private

  def save_csv
    CSV.open(@csv_file, "wb") do |csv|
      csv << %w[id name address]
      @employees.each do |employee|
        csv << [employee.id, employee.username, employee.password, employee.role]
      end
    end
  end

  def load_csv
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      row[:id] = row[:id].to_i
      @employees << Employee.new(row)
    end
    @next_id = @employees.last.id + 1 unless @employees.empty?
  end
end
