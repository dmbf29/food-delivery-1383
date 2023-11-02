require "csv"
require_relative "../models/order"

class OrderRepository
  def initialize(csv_file, meal_repository, customer_repository, employee_repository)
    @csv_file = csv_file
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @orders = []
    @next_id = 1
    load_csv if File.exist?(@csv_file)
  end

  def create(order)
    order.id = @next_id
    @orders << order
    @next_id += 1
    save_csv
  end

  def undelivered_orders
    @orders.reject do |order|
      order.delivered?
    end
  end

  def my_undelivered_order(employee)
    undelivered_orders.select do |order|
      order.employee == employee
    end
  end

  def find(id)
    @orders.find { |order| order.id == id }
  end

  def mark_as_delivered(order)
    order.deliver!
    save_csv
  end

  private

  def save_csv
    CSV.open(@csv_file, "wb") do |csv|
      csv << %w[id delivered meal_id customer_id employee_id]
      @orders.each do |order|
        # we have to dumb the instance down for the CSV
        csv << [order.id, order.delivered?, order.meal.id, order.customer.id, order.employee.id]
      end
    end
  end

  def load_csv
    CSV.foreach(@csv_file, headers: :first_row, header_converters: :symbol) do |row|
      # Change any non-string data from the CSV, into the correct data type before we create the instance
      row[:id] = row[:id].to_i
      row[:delivered] = row[:delivered] == "true"
      row[:meal_id] = row[:meal_id].to_i
      row[:meal] = @meal_repository.find(row[:meal_id])
      row[:customer_id] = row[:customer_id].to_i
      row[:customer] = @customer_repository.find(row[:customer_id])
      row[:employee_id] = row[:employee_id].to_i
      row[:employee] = @employee_repository.find(row[:employee_id])
      order = Order.new(row)
      @orders << order
    end
    @next_id = @orders.last.id + 1 unless @orders.empty?
  end
end
