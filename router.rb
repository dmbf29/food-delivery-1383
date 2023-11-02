class Router
  def initialize(meals_controller, customers_controller, sessions_controller, orders_controller)
    @meals_controller = meals_controller
    @customers_controller = customers_controller
    @sessions_controller = sessions_controller
    @orders_controller = orders_controller
    @running = true
  end

  def run
    while @running
      @current_user = @sessions_controller.login
      while @current_user
        if @current_user.manager?
          # if the current user is a manager print manager menu
          print_manager_menu
          choice = gets.chomp.to_i
          print `clear`
          route_manager_action(choice)
        else
          # if the current user is a rider print rider menu
          print_rider_menu
          choice = gets.chomp.to_i
          print `clear`
          route_rider_action(choice)
        end
      end
    end
  end

  private

  def print_manager_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. Add new meal"
    puts "2. List all meals"
    puts "3. Add new customer"
    puts "4. List all customers"
    puts "5. Add new order"
    puts "6. List all undelivered orders"
    puts "7. logout"
    puts "8. exit"
    print "> "
  end

  def print_rider_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. List all MY undelivered orders"
    puts "2. Mark an order as delivered"
    puts "7. Logout"
    puts "8. Exit"
    print "> "
  end

  def route_rider_action(choice)
    case choice
    when 1 then @orders_controller.list_my_undelivered_orders(@current_user)
    when 2 then @orders_controller.mark_as_delivered(@current_user)
    when 7 then logout!
    when 8 then stop!
    else puts "Try again..."
    end
  end

  def route_manager_action(choice)
    case choice
    when 1 then @meals_controller.add
    when 2 then @meals_controller.list
    when 3 then @customers_controller.add
    when 4 then @customers_controller.list
    when 5 then @orders_controller.add
    when 6 then @orders_controller.list_undelivered_orders
    when 7 then logout!
    when 8 then stop!
    else puts "Try again..."
    end
  end

  def logout!
    @current_user = nil
  end

  def stop!
    logout!
    @running = false
  end
end
