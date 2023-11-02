class OrdersView
  def display(orders)
    if orders.any?
      orders.each_with_index do |order, index|
        puts "#{index + 1}.)  #{order.meal.name} - #{order.customer.name} (#{order.customer.address})
        Rider: #{order.employee.username}"
      end
    else
      puts "No orders yet 🍽️"
    end
  end

  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end
end
