class Regular
  def price(rental)
    ((rental.days_rented * 1.5) - 1).clamp(2..)
  end

  def frequent_renter_points(rental)
    1
  end
end

class NewRelease
  def price(rental)
    rental.days_rented * 3
  end

  def frequent_renter_points(rental)
    rental.days_rented > 1 ? 2 : 1
  end
end

class Childrens
  def price(rental)
    ((rental.days_rented * 1.5) - 3).clamp(1.5..)
  end

  def frequent_renter_points(rental)
    1
  end
end

class Movie < Struct.new(:title, :price_code)
  REGULAR = Regular.new
  NEW_RELEASE = NewRelease.new
  CHILDRENS = Childrens.new

  delegate :price, :frequent_renter_points, to: :price_code
end

class Rental < Struct.new(:movie, :days_rented)
  delegate :title, to: :movie

  def price
    movie.price(self)
  end

  def frequent_renter_points
    movie.frequent_renter_points(self)
  end
end

class CustomerStatement < Struct.new(:customer)
  delegate :rentals, to: :customer
  delegate :name, to: :customer, prefix: true

  def total_amount
    rentals.sum(&:price)
  end

  def frequent_renter_points
    rentals.sum(&:frequent_renter_points)
  end
end

class CustomerStatementFormatter < SimpleDelegator
  def display_statement
    [
      "Rental Record for #{customer_name}",
      "",
      rentals.map(&method(:format_rental)),
      line("", "-----"),
      line("Total", price(total_amount)),
      "",
      "You earned #{frequent_renter_points} frequent renter points",
    ].join("\n")
  end

  private

  def format_rental(rental)
    line(rental.title, price(rental.price))
  end

  def price(price)
    format("%5.2f", price)
  end

  def line(left, right)
    format("  %-30s  %s", left, right)
  end
end

class Customer < Struct.new(:name, :rentals)
  def initialize(name)
    super(name, [])
  end

  def add_rental(arg)
    rentals << arg
  end

  def statement
    CustomerStatementFormatter.new(CustomerStatement.new(self)).display_statement
  end
end
