require_relative "../views/orders_view"
require_relative "../views/employees_view"
require_relative "../models/order"

class OrdersController
  def initialize(meal_repository, customer_repository, employee_repository, order_repository)
    @meal_repository = meal_repository
    @customer_repository = customer_repository
    @employee_repository = employee_repository
    @order_repository = order_repository
    @orders_view = OrdersView.new
    @meals_view = MealsView.new
    @customers_view = CustomersView.new
    @employees_view = EmployeesView.new
  end

  def list_undelivered_orders
    # get all the undelivered order from order repository
    orders = @order_repository.undelivered_orders
    # give the orders to the orders view to display
    @orders_view.display(orders)
  end

  def add
    # get all the meals from meal repository
    meals = @meal_repository.all
    # tell the view to display the meals
    @meals_view.display(meals)
    # ask the user which index meal
    index = @meals_view.ask_user_for('number').to_i - 1
    # we need to get the instance of the meal from the number
    meal = meals[index]

    # get all the meals from customer repository
    customers = @customer_repository.all
    # tell the view to display the customers
    @customers_view.display(customers)
    # ask the user which index customer
    index = @customers_view.ask_user_for('number').to_i - 1
    # we need to get the instance of the customer from the number
    customer = customers[index]

    # get all the meals from customer repository
    employees = @employee_repository.all_riders
    # tell the view to display the employees
    @employees_view.display(employees)
    # ask the user which index employee
    index = @employees_view.ask_user_for('number').to_i - 1
    # we need to get the instance of the employee from the number
    employee = employees[index]

    # create our instance of a order
    order = Order.new(meal: meal, customer: customer, employee: employee)
    # give the instance to the repository
    @order_repository.create(order)
  end

  def list_my_undelivered_orders(employee)
    # we need to get MY orders from the repo
    orders = @order_repository.my_undelivered_order(employee)
    # give them to the view
    @orders_view.display(orders)
  end

  def mark_as_delivered(employee)
    # we need all of my orders
    orders = @order_repository.my_undelivered_order(employee)
    # display those orders
    @orders_view.display(orders)
    # ask the user which number
    index = @orders_view.ask_user_for('number').to_i - 1
    # get the instance with that number
    order = orders[index]
    # mark it as delivered
    @order_repository.mark_as_delivered(order)
    # save
  end
end
